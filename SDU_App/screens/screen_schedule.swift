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
        
        /*
         "type_lecture" = "Лекция";
         "type_practice" = "Практика";
         "type_lab_work" = "Лаб. работа";
         */
        
        //Временные костыли в виде фиксированных курсов

        // Курсы для каждого дня
        coursesForDay("day_mon", [
            (timeStartKey: "ct_1_start", timeEndKey: "ct_1_end", titleKey: "c_name_mde_151", locationKey: "(Virtual Room 96) VR 96", typeKey: "type_lecture", professorKey: "c_teacher_name_mde_151"),
            (timeStartKey: "ct_3_start", timeEndKey: "ct_3_end", titleKey: "c_name_css_410", locationKey: "(Virtual Room 53) VR 53", typeKey: "type_lecture", professorKey: "c_teacher_name_css_410"),
            (timeStartKey: "ct_4_start", timeEndKey: "ct_4_end", titleKey: "c_name_css_410", locationKey: "(Virtual Room 53) VR 53", typeKey: "type_lecture", professorKey: "c_teacher_name_css_410"),
            (timeStartKey: "ct_8_start", timeEndKey: "ct_8_end", titleKey: "c_name_css_410", locationKey: "(Virtual Room 1) VR 1", typeKey: "type_practice", professorKey: "c_teacher_name_css_410")
        ])

        coursesForDay("day_tues", [
            (timeStartKey: "ct_9_start", timeEndKey: "ct_9_end", titleKey: "c_name_css_312", locationKey: "(L.T. D2) E221", typeKey: "type_lecture", professorKey: "c_teacher_name_css_312_l")
        ])

        coursesForDay("day_wednes", [
            (timeStartKey: "ct_8_start", timeEndKey: "ct_8_end", titleKey: "c_name_inf_405", locationKey: "(Virtual Room 2) VR 2", typeKey: "type_lecture", professorKey: "c_teacher_name_inf_405"),
            (timeStartKey: "ct_9_start", timeEndKey: "ct_9_end", titleKey: "c_name_inf_405", locationKey: "(Virtual Room 2) VR 2", typeKey: "type_lecture", professorKey: "c_teacher_name_inf_405"),
            (timeStartKey: "ct_10_start", timeEndKey: "ct_10_end", titleKey: "c_name_inf_405", locationKey: "(Virtual Room 2) VR 2", typeKey: "type_lecture", professorKey: "c_teacher_name_inf_405")
        ])

        coursesForDay("day_thurs", [
            (timeStartKey: "ct_5_start", timeEndKey: "ct_5_end", titleKey: "c_name_inf_228", locationKey: "(SDU Life 202) SL 1", typeKey: "type_lecture", professorKey: "c_teacher_name_inf_228"),
            (timeStartKey: "ct_6_start", timeEndKey: "ct_6_end", titleKey: "c_name_inf_228", locationKey: "(SDU Life 202) SL 1", typeKey: "type_lecture", professorKey: "c_teacher_name_inf_228")
        ])

        coursesForDay("day_fri", [
            (timeStartKey: "ct_1_start", timeEndKey: "ct_1_end", titleKey: "c_name_css_312", locationKey: "(ENG 103) F103", typeKey: "type_practice", professorKey: "c_teacher_name_css_312_p"),
            (timeStartKey: "ct_2_start", timeEndKey: "ct_2_end", titleKey: "c_name_css_312", locationKey: "(ENG 103) F103", typeKey: "type_practice", professorKey: "c_teacher_name_css_312_p"),
            (timeStartKey: "ct_3_start", timeEndKey: "ct_3_end", titleKey: "c_name_inf_228", locationKey: "(LAB-ECO1) G108", typeKey: "type_practice", professorKey: "c_teacher_name_inf_228")
        ])

        coursesForDay("day_satur", [
            (timeStartKey: "ct_1_start", timeEndKey: "ct_1_end", titleKey: "c_name_css_319", locationKey: "(Virtual Room 33) VR 33", typeKey: "type_lecture", professorKey: "c_teacher_name_css_319"),
            (timeStartKey: "ct_2_start", timeEndKey: "ct_2_end", titleKey: "c_name_css_319", locationKey: "(Virtual Room 33) VR 33", typeKey: "type_lecture", professorKey: "c_teacher_name_css_319"),
            (timeStartKey: "ct_7_start", timeEndKey: "ct_7_end", titleKey: "c_name_css_319", locationKey: "(Virtual Room 33) VR 33", typeKey: "type_practice", professorKey: "c_teacher_name_css_319")
        ])
        
        //test day
        /*
       coursesForDay("day_sun", [
            (timeStartKey: "test_time1", timeEndKey: "ct_1_end", titleKey: "c_name_css_319", locationKey: "cr_d1", typeKey: "Лекция", professorKey: "c_teacher_name_css_319"),
            
            
        ])
        
        coursesForDay("day_tues", [
             (timeStartKey: "test_time1", timeEndKey: "ct_1_end", titleKey: "c_name_css_319", locationKey: "cr_d1", typeKey: "Лекция", professorKey: "c_teacher_name_css_319"),
             
             
         ])*/

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
        .navigationTitle("schedule_p".syswords)
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
            // Кнопка для сворачивания/разворачивания секции
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

            // Список курсов, если секция развернута
            if isExpanded {
                ForEach(Array(courses.enumerated()), id: \.element.time) { index, course in
                    // Вызов CourseItem с номером курса (index + 1)
                    CourseItem(course: course, number: index + 1)
                        .transition(.opacity.combined(with: .slide))
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
    var number: Int // Порядковый номер курса

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Горизонтальный контейнер с порядковым номером, временем и типом занятия
            HStack {
                // Порядковый номер прижат к левой стенке с фоном, который исходит из левой стены
                Text("\(number)")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .frame(width: 45, height: 25)
                    .background(Color(hex: "5F7ADB"))
                    .cornerRadius(10, corners: [.topRight, .bottomRight]) // Округление только справа
                    .padding(.leading, -40)
                
                // Тип занятия (лекция или практика)
                Text(course.type.lc)
                    .font(.subheadline)
                    .bold()
                    //.frame(width: 110, height: 25)
                    //.background(Color(hex: "5F7ADB"))
                    .foregroundColor(getCourseTypeColor(type: course.type))
                    .cornerRadius(10, corners: [.topRight, .bottomRight]) // Округление только справа
                    
                
                Spacer()
                
                // Время занятия
                Text(course.time)
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 8)
            
            // Основная информация о курсе
            VStack(alignment: .leading, spacing: 4) {
                Text(course.title)
                    .font(.body)
                    .foregroundColor(.primary)
                
                // Аудитория и преподаватель
                HStack {
                    Image(systemName: "door.left.hand.closed")
                        .foregroundColor(.gray)
                    Text(": \(course.location)")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    Spacer()
                }
                
                HStack {
                    Image(systemName: "person.fill")
                        .foregroundColor(.gray)
                    Text(": \(course.professor)")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    Spacer()
                }
            }
        }
        .padding(.horizontal)
        
        // Горизонтальная линия в качестве разделителя
        Divider()
    }
}




#Preview {
    SchedulePage()
}
