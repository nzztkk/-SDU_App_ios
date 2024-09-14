//
//  screen_schedule.swift
//  SDU_App
//
//  Created by Nurkhat on 10.09.2024.
//

import Foundation
import SwiftUI



struct Course {
    var day: String
    var time: String
    var title: String
    var location: String
    var type: String
    var professor: String
}



extension String {
    var lc: String {
        return NSLocalizedString(self, tableName: "courses_details", bundle: .main, value: "", comment: "")
    }
    
    var weeks: String {
        return NSLocalizedString(self, tableName: "Localizable", bundle: .main, value: "", comment: "")
    }
}

struct SchedulePage: View {
    @State private var expandedDays: Set<String> = [] // Хранение информации о развернутых днях

    let courses: [Course]

    init() {
    

        // Инициализируем курсы, группируя их по дням недели
        courses = SchedulePage.generateCourses()
    }

    static func generateCourses() -> [Course] {
        var allCourses: [Course] = []

        // Функция для создания курсов для конкретного дня
        func coursesForDay(_ dayKey: String, _ courseData: [(timeStartKey: String, timeEndKey: String, titleKey: String, locationKey: String, typeKey: String, professorKey: String)]) {
            let day = dayKey.weeks
            let dayCourses = courseData.map { data in
                Course(
                    day: day,
                    time: data.timeStartKey.lc + " - " + data.timeEndKey.lc,
                    title: data.titleKey.lc,
                    location: data.locationKey.lc,
                    type: data.typeKey.lc,
                    professor: data.professorKey.lc
                )
            }
            allCourses.append(contentsOf: dayCourses)
        }

        // Курсы для каждого дня
        coursesForDay("day_mon", [
            (timeStartKey: "ct_1_start", timeEndKey: "ct_1_end", titleKey: "c_name_mde_151", locationKey: "cr_a1", typeKey: "Лекция", professorKey: "c_teacher_name_mde_151"),
            (timeStartKey: "ct_3_start", timeEndKey: "ct_3_end", titleKey: "c_name_css_410", locationKey: "cr_a2", typeKey: "Лекция", professorKey: "c_teacher_name_css_410"),
            (timeStartKey: "ct_4_start", timeEndKey: "ct_4_end", titleKey: "c_name_css_410", locationKey: "cr_a2", typeKey: "Лекция", professorKey: "c_teacher_name_css_410"),
            (timeStartKey: "ct_8_start", timeEndKey: "ct_8_end", titleKey: "c_name_css_410", locationKey: "cr_a3", typeKey: "Практика", professorKey: "c_teacher_name_css_410")
        ])

        coursesForDay("day_tues", [
            (timeStartKey: "ct_9_start", timeEndKey: "ct_9_end", titleKey: "c_name_css_312", locationKey: "cr_e1", typeKey: "Лекция", professorKey: "c_teacher_name_css_312_l")
        ])

        coursesForDay("day_wednes", [
            (timeStartKey: "ct_8_start", timeEndKey: "ct_8_end", titleKey: "c_name_inf_405", locationKey: "cr_a1", typeKey: "Лекция", professorKey: "c_teacher_name_inf_405"),
            (timeStartKey: "ct_9_start", timeEndKey: "ct_9_end", titleKey: "c_name_inf_405", locationKey: "cr_a1", typeKey: "Лекция", professorKey: "c_teacher_name_inf_405"),
            (timeStartKey: "ct_10_start", timeEndKey: "ct_10_end", titleKey: "c_name_inf_405", locationKey: "cr_a1", typeKey: "Лекция", professorKey: "c_teacher_name_inf_405")
        ])

        coursesForDay("day_thurs", [
            (timeStartKey: "ct_5_start", timeEndKey: "ct_5_end", titleKey: "c_name_inf_228", locationKey: "cr_b2", typeKey: "Лекция", professorKey: "c_teacher_name_inf_228"),
            (timeStartKey: "ct_6_start", timeEndKey: "ct_6_end", titleKey: "c_name_inf_228", locationKey: "cr_b2", typeKey: "Лекция", professorKey: "c_teacher_name_inf_228")
        ])

        coursesForDay("day_fri", [
            (timeStartKey: "ct_1_start", timeEndKey: "ct_1_end", titleKey: "c_name_css_312", locationKey: "cr_f1", typeKey: "Практика", professorKey: "c_teacher_name_css_312_p"),
            (timeStartKey: "ct_2_start", timeEndKey: "ct_2_end", titleKey: "c_name_css_312", locationKey: "cr_f1", typeKey: "Практика", professorKey: "c_teacher_name_css_312_p"),
            (timeStartKey: "ct_3_start", timeEndKey: "ct_3_end", titleKey: "c_name_inf_228", locationKey: "cr_g1", typeKey: "Практика", professorKey: "c_teacher_name_inf_228")
        ])

        coursesForDay("day_satur", [
            (timeStartKey: "ct_1_start", timeEndKey: "ct_1_end", titleKey: "c_name_css_319", locationKey: "cr_d1", typeKey: "Лекция", professorKey: "c_teacher_name_css_319"),
            (timeStartKey: "ct_2_start", timeEndKey: "ct_2_end", titleKey: "c_name_css_319", locationKey: "cr_d1", typeKey: "Лекция", professorKey: "c_teacher_name_css_319"),
            (timeStartKey: "ct_7_start", timeEndKey: "ct_7_end", titleKey: "c_name_css_319", locationKey: "cr_d1", typeKey: "Практика", professorKey: "c_teacher_name_css_319")
        ])

        return allCourses
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ForEach(filteredDaysOfWeek(), id: \.self) { day in
                    let coursesForDay = courses.filter { $0.day == day }
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
        .navigationTitle("Расписание".lc)
    }

    // Определение дня недели и отображение расписания, начиная с текущего дня
    func filteredDaysOfWeek() -> [String] {
        let today = currentWeekday()
        let days = daysOfWeek()
        if let todayIndex = days.firstIndex(of: today) {
            let startWeek = days[todayIndex...]
            let remainingWeek = days[..<todayIndex]
            return Array(startWeek + remainingWeek)
        }
        return days
    }

    // Получение дня недели на основе текущей даты
    func currentWeekday() -> String {
        let calendar = Calendar.current
        let date = Date()
        let weekdayIndex = calendar.component(.weekday, from: date) // День недели как число (1-7)
        let days = daysOfWeek()
        let index = (weekdayIndex + 5) % 7 // Приводим к диапазону 0-6
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

    // Изменить состояние развернутости дня
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
            Button(action: toggleExpanded) {
                HStack {
                    Text(day)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.blue)
                }
                .padding(.vertical, 8)
            }

            if isExpanded {
                ForEach(courses, id: \.time) { course in
                    CourseItem(course: course)
                        .transition(.opacity.combined(with: .slide))
                }
            }
        }
    }
}

struct CourseItem: View {
    var course: Course

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(course.time)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Spacer()
                Text(course.type)
                    .font(.subheadline)
                    .foregroundColor(course.type == "Лекция".lc ? .blue : .green)
            }
            Text(course.title)
                .font(.body)
                .foregroundColor(.primary)
            Text(course.professor)
                .font(.footnote)
                .foregroundColor(.secondary)
            Text(course.location)
                .font(.footnote)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}




#Preview {
    SchedulePage()
}
