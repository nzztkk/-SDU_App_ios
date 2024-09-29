//
//  screen_schedule.swift
//  SDU_App
//
//  Created by Nurkhat on 10.09.2024.
//

import SwiftUI


struct CourseData {
    var courseCode: String
    var day: String
    var timeStart: String
    var timeEnd: String
    var title: String
    var location: String
    var type: String
    var professor: String
    var onlineLink: String?
}


struct SchedulePage: View {
    @ObservedObject var dbConnection = DatabaseConnection()
    @State private var expandedDays: Set<String> = []
    @State private var selectedCourse: CourseData? = nil
    @State private var isShowingDetails = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ForEach(filteredDaysOfWeek(), id: \.self) { day in
                    let coursesForDay = dbConnection.courses
                        .filter { $0.day == day }
                        .map { course in
                            CourseData(
                                courseCode: course.courseCode,
                                day: course.day,
                                timeStart: course.timeStart,
                                timeEnd: course.timeEnd,
                                title: course.title,
                                location: course.location,
                                type: course.type,
                                professor: course.professor,
                                onlineLink: course.onlineLink
                            )
                        }
                    
                    if !coursesForDay.isEmpty {
                        DaySection(
                            day: day,
                            courses: coursesForDay,
                            isExpanded: expandedDays.contains(day),
                            toggleExpanded: { toggleDayExpansion(day: day) },
                            onSelectCourse: { course in
                                self.selectedCourse = course
                                self.isShowingDetails = true
                            }
                        )
                        .animation(.easeInOut(duration: 0.3), value: expandedDays)
                    }
                }
            }
            .padding()
        }
        .refreshable {
            Task {
                await fetchCourses()
            }
        }
        .navigationTitle("Schedule")
        .overlay(alignment: .center) {
            if dbConnection.isLoading {
                ProgressView()
            }
        }
        .onAppear {
            Task {
                await fetchCourses()
            }
        }
        // Модальное окно с информацией о курсе
        .sheet(item: $selectedCourse) { course in
            LessonDetailView(course: course)
        }
    }

    // Фильтрация дней недели
    func filteredDaysOfWeek() -> [String] {
        let allDays = Set(dbConnection.courses.map { $0.day })
        let today = currentWeekday()
        let days = daysOfWeek()

        if let todayIndex = days.firstIndex(of: today) {
            let startWeek = days[todayIndex...]
            let remainingWeek = days[..<todayIndex]
            return Array(startWeek + remainingWeek).filter { allDays.contains($0) }
        }
        return days.filter { allDays.contains($0) }
    }

    // Получение текущего дня
    func currentWeekday() -> String {
        let calendar = Calendar.current
        let date = Date()
        let weekdayIndex = calendar.component(.weekday, from: date)
        let days = daysOfWeek()
        let index = (weekdayIndex + 5) % 7
        return days[index]
    }

    // Получение списка дней недели
    func daysOfWeek() -> [String] {
        return ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    }

    // Переключение раскрытия дня
    func toggleDayExpansion(day: String) {
        if expandedDays.contains(day) {
            expandedDays.remove(day)
        } else {
            expandedDays.insert(day)
        }
    }

    // Асинхронное получение курсов из базы данных
    func fetchCourses() async {
        await dbConnection.getCoursesData()
    }
}

struct DaySection: View {
    let day: String
    let courses: [CourseData]
    let isExpanded: Bool
    let toggleExpanded: () -> Void
    let onSelectCourse: (CourseData) -> Void

    var body: some View {
        VStack(spacing: 10) {
            // Заголовок дня
            Button(action: {
                toggleExpanded()
            }) {
                HStack {
                    Text(day)
                        .font(.title2)
                        .bold()
                        .padding(.leading, 16)
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .padding(.trailing, 16)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
            .padding(.horizontal)

            if isExpanded {
                ForEach(courses) { course in
                    Button(action: {
                        onSelectCourse(course)
                    }) {
                        CourseCard(course: course)
                    }
                    .buttonStyle(PlainButtonStyle()) // Убираем стиль кнопки, чтобы не было выделения
                }
            }
        }
        .padding(.vertical, 8)
    }
}

struct CourseCard: View {
    var course: CourseData

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(course.title)
                .font(.headline)
                .foregroundColor(.black)

            HStack {
                Text("Time: \(course.timeStart) - \(course.timeEnd)")
                Spacer()
                Text(course.type)
                    .foregroundColor(typeColor(course.type))
                    .fontWeight(.bold)
                    .padding(6)
                    .background(typeColor(course.type).opacity(0.2))
                    .cornerRadius(8)
            }
            .font(.subheadline)
            .foregroundColor(.gray)

            Text("Professor: \(course.professor)")
                .font(.subheadline)
                .foregroundColor(.gray)

            Text("Location: \(course.location)")
                .font(.subheadline)
                .foregroundColor(.gray)

            Divider()
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .padding(.horizontal, 16)
    }

    // Функция для определения цвета типа курса
    func typeColor(_ type: String) -> Color {
        switch type {
        case "Lecture":
            return Color.blue
        case "Lab":
            return Color.green
        case "Seminar":
            return Color.orange
        default:
            return Color.gray
        }
    }
}

struct LessonDetailView: View {
    var course: CourseData

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(course.title)
                .font(.largeTitle)
                .bold()

            Text("Course Code: \(course.courseCode)")
            Text("Day: \(course.day)")
            Text("Time: \(course.timeStart) - \(course.timeEnd)")
            Text("Professor: \(course.professor)")
            Text("Location: \(course.location)")
            Text("Type: \(course.type)")

            if let onlineLink = course.onlineLink {
                Link("Join Online", destination: URL(string: onlineLink)!)
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Course Details")
    }
}
