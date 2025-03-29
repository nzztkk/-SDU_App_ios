import Foundation
import SwiftUI

// ✅ Модель данных с корректными полями
struct Course: Identifiable, Decodable {
    let id = UUID()
    let timeStart: String
    let timeEnd: String
    let day: String
    let courseCode: String
    let courseName: String
    let credits: String
    let group: String
    let professor: String
    let classroom: String
    
    private enum CodingKeys: String, CodingKey {
        case timeStart = "time_start"
        case timeEnd = "time_end"
        case day
        case courseCode = "course_code"
        case courseName = "course_name"
        case credits
        case group
        case professor
        case classroom
    }
}

struct SchedulePage: View {
    @ObservedObject var dbConnection = DatabaseConnection.shared
    
    @State private var expandedDays: Set<String> = []
    @State private var isLoading = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if dbConnection.isLoading {
                    ForEach(0..<5, id: \.self) { _ in
                        ShimmerRow()
                    }
                } else {
                    let groupedCourses = Dictionary(grouping: dbConnection.courses, by: { $0.day })
                    let sortedDays = sortDays(Set(groupedCourses.keys))

                    ForEach(sortedDays, id: \.self) { day in
                        if let coursesForDay = groupedCourses[day], !coursesForDay.isEmpty {
                            DaySection(
                                day: day,
                                courses: coursesForDay,
                                isExpanded: expandedDays.contains(day),
                                toggleExpanded: { toggleDayExpansion(day: day) }
                            )
                            .animation(.easeInOut(duration: 0.3), value: expandedDays)
                        }
                    }
                }
            }
            .padding()
        }
        .refreshable {
            Task {
                await dbConnection.getCoursesData()
            }
        }
        .navigationTitle("Расписание")
        .overlay {
            if dbConnection.isLoading {
                ProgressView()
            }
        }
        .onAppear {
            Task {
                await dbConnection.configureSupabase()
                await dbConnection.getCoursesData()
            }
        }
        .onChange(of: dbConnection.isLoading) { newValue in
            isLoading = newValue
        }
    }
    
    // ✅ Сортировка по дням недели (по порядку)
    func sortDays(_ days: Set<String>) -> [String] {
        let daysOrder = ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]
        return days.sorted { daysOrder.firstIndex(of: $0) ?? 7 < daysOrder.firstIndex(of: $1) ?? 7 }
    }
    
    func toggleDayExpansion(day: String) {
        if expandedDays.contains(day) {
            expandedDays.remove(day)
        } else {
            expandedDays.insert(day)
        }
    }
}

// ✅ Отображение секции по дням
struct DaySection: View {
    var day: String
    var courses: [Course]
    var isExpanded: Bool
    var toggleExpanded: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.5)) {
                    toggleExpanded()
                }
            }) {
                HStack {
                    Text(day)
                        .font(.title3)
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up.circle.fill" : "chevron.down.circle.fill")
                        .foregroundColor(.blue)
                }
                .padding(.vertical, 8)
            }
            
            if isExpanded {
                ForEach(Array(courses.enumerated()), id: \.element.id) { index, course in
                    NavigationLink(destination: LessonInfoPage(course: course)) {
                        CourseItem(course: course, number: index + 1)
                    }
                }
            }
        }
    }
}

// ✅ Отображение карточки курса
struct CourseItem: View {
    var course: Course
    var number: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("\(number)")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .frame(width: 45, height: 25)
                    .background(Color(hex: "5F7ADB"))
                    .cornerRadius(10)
                    .padding(.leading, -40)
                
                Text("\(course.timeStart) - \(course.timeEnd)")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.gray)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(course.courseName)
                    .font(.body)
                    .foregroundColor(.primary)
                
                HStack {
                    Image(systemName: "door.left.hand.closed")
                        .foregroundColor(.gray)
                    Text(": \(course.classroom)")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                
                HStack {
                    Image(systemName: "person.fill")
                        .foregroundColor(.gray)
                    Text(": \(course.professor)")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal)
        }
        
        Divider()
            .background(Color.primary)
    }
}

// ✅ Пример страницы для урока
struct LessonInfo: View {
    var course: Course
    
    var body: some View {
        Text("Подробности занятия \(course.courseName)")
    }
}

#Preview {
    SchedulePage()
}
