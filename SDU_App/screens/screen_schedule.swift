//
//  screen_schedule.swift
//  SDU_App
//
//  Created by Nurkhat on 10.09.2024.
//

import Foundation
import SwiftUI

struct Course: Identifiable, Hashable {
    let id = UUID()
    var day: String
    var time: String
    var title: String
    var location: String
    var type: String
    var professor: String
    var onlineLink: String?

    init(data: [String: Any]) {
        self.day = data["day"] as? String ?? ""
        self.time = "\(data["timeStart"] as? String ?? "") - \(data["timeEnd"] as? String ?? "")"
        self.title = data["title"] as? String ?? ""
        self.location = data["location"] as? String ?? ""
        self.type = data["type"] as? String ?? ""
        self.professor = data["professor"] as? String ?? ""
        self.onlineLink = data["onlineLink"] as? String
    }
}

struct SchedulePage: View {
    @State private var expandedDays: Set<String> = []
    @ObservedObject var dbConnection = DatabaseConnection()  // Использование DatabaseConnection
    @State private var isLoading = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ForEach(filteredDaysOfWeek(), id: \.self) { day in
                    let coursesForDay = dbConnection.courses.filter { $0.day == day }
                    if !coursesForDay.isEmpty {
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
            .padding()
        }
        .refreshable {
            isLoading = true
            Task {
                await dbConnection.getCoursesData()
                DispatchQueue.main.async {
                    isLoading = false
                }
            }
        }
        .navigationTitle("schedule_p".syswords)
        .overlay(alignment: .center) {
            if dbConnection.isLoading {  // Используем isLoading, определенное в DatabaseConnection
                ProgressView()
            }
        }
        .onAppear {
            Task {
                await dbConnection.getCoursesData()
                DispatchQueue.main.async {
                    isLoading = false
                }
            }
        }
        .onChange(of: dbConnection.isLoading) { newValue in
            isLoading = newValue  // Привязка состояния isLoading
        }
    }

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

    func currentWeekday() -> String {
        let calendar = Calendar.current
        let date = Date()
        let weekdayIndex = calendar.component(.weekday, from: date)
        let days = daysOfWeek()
        let index = (weekdayIndex + 5) % 7
        return days[index]
    }

    func daysOfWeek() -> [String] {
        return [
            "day_mon".weeks,
            "day_tues".weeks,
            "day_wednes".weeks,
            "day_thurs".weeks,
            "day_fri".weeks,
            "day_satur".weeks,
            "day_sun".weeks
        ]
    }

    func toggleDayExpansion(day: String) {
        if expandedDays.contains(day) {
            expandedDays.remove(day)
        } else {
            expandedDays.insert(day)
        }
    }
}

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

func getCourseTypeColor(type: String) -> Color {
    switch type {
    case "type_lecture".lc:
        return .orange
    case "type_practice".lc:
        return .green
    case "type_lab_work".lc:
        return .gray
    default:
        return .gray
    }
}

struct CourseItem: View {
    var course: Course
    var number: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center) {
                Text("\(number)")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .frame(width: 45, height: 25)
                    .background(Color(hex: "5F7ADB"))
                    .cornerRadius(10, corners: [.topRight, .bottomRight])
                    .padding(.leading, -40)

                Text(course.type.lc)
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(getCourseTypeColor(type: course.type))

                Spacer()

                Text(course.time)
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            VStack(alignment: .leading, spacing: 4) {
                Text(course.title)
                    .font(.body)
                    .foregroundColor(.primary)
                    .lineLimit(nil)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)

                HStack(alignment: .center) {
                    Image(systemName: "door.left.hand.closed")
                        .foregroundColor(.gray)
                    Text(": \(course.location)")
                        .font(.footnote)
                        .foregroundColor(.gray)

                    Spacer()
                }

                HStack(alignment: .center) {
                    Image(systemName: "person.fill")
                        .foregroundColor(.gray)
                    Text(": \(course.professor)")
                        .font(.footnote)
                        .foregroundColor(.gray)

                    Spacer()
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal)

        Divider()
            .background(.primary)
    }
}

#Preview {
    SchedulePage()
}
