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
    var professor: String // Добавляем поле для имени преподавателя
}

struct SchedulePage: View {
    @State private var expandedDays: Set<String> = [] // Хранение информации о развернутых днях
    
    let courses: [Course] = [
        Course(day: "Понедельник", time: "08:30 - 09:20", title: "Модуль социально-политических знаний (Политология)", location: "VR Room 96", type: "Лекция", professor: "Еркебұлан Ақбердиев"),
        Course(day: "Понедельник", time: "10:30 - 11:20", title: "Методы исследования и инструменты", location: "VR Room 53", type: "Лекция", professor: "Жуманияз Маматнабиев"),
        Course(day: "Понедельник", time: "11:30 - 12:20", title: "Методы исследования и инструменты", location: "VR Room 53", type: "Лекция", professor: "Жуманияз Маматнабиев"),
        Course(day: "Понедельник", time: "15:30 - 16:20", title: "Методы исследования и инструменты", location: "VR Room 1", type: "Практика", professor: "Жуманияз Маматнабиев"),
        
        Course(day: "Вторник", time: "16:30 - 17:20", title: "Компьютерные сети 1", location: "E221", type: "Лекция", professor: "Бауыржан Берліқожа"),
        
        Course(day: "Среда", time: "15:30 - 16:20", title: "Саморазвитие в области компьютерных наук", location: "VR 2", type: "Лекция", professor: "Алина Беделханова"),
        Course(day: "Среда", time: "16:30 - 17:20", title: "Саморазвитие в области компьютерных наук", location: "VR 2", type: "Лекция", professor: "Алина Беделханова"),
        Course(day: "Среда", time: "17:30 - 18:20", title: "Саморазвитие в области компьютерных наук", location: "VR 2", type: "Лекция", professor: "Алина Беделханова"),
        
        Course(day: "Четверг", time: "12:30 - 13:20", title: "UX/UI дизайн", location: "SL 1 (Stud Life 202)", type: "Лекция", professor: "Али Байгеленов"),
        Course(day: "Четверг", time: "13:30 - 14:20", title: "UX/UI дизайн", location: "SL 1 (Stud Life 202)", type: "Лекция", professor: "Али Байгеленов"),
        
        Course(day: "Пятница", time: "8:30 - 9:20", title: "Компьютерные сети 1", location: "F103", type: "Практика", professor: "Нұрбол Молдабай"),
        Course(day: "Пятница", time: "9:30 - 10:20", title: "Компьютерные сети 1", location: "F103", type: "Практика", professor: "Нұрбол Молдабай"),
        Course(day: "Пятница", time: "10:30 - 11:20", title: "UX/UI дизайн", location: "G108", type: "Практика", professor: "Али Байгеленов"),
        
        Course(day: "Суббота", time: "8:30 - 9:20", title: "Тестирование и валидация программного обеспечения", location: "VR 33", type: "Лекция", professor: "Назым Тұрысбек"),
        Course(day: "Суббота", time: "9:30 - 10:20", title: "Тестирование и валидация программного обеспечения", location: "VR 33", type: "Лекция", professor: "Назым Тұрысбек"),
        Course(day: "Суббота", time: "14:30 - 15:20", title: "Тестирование и валидация программного обеспечения", location: "VR 33", type: "Практика", professor: "Назым Тұрысбек"),
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ForEach(filteredDaysOfWeek(), id: \.self) { day in
                    DaySection(
                        day: day,
                        courses: courses.filter { $0.day == day },
                        isExpanded: expandedDays.contains(day),
                        toggleExpanded: { toggleDayExpansion(day: day) }
                    )
                    .animation(.easeInOut(duration: 0.3)) // Плавная анимация при разворачивании
                }
            }
            .padding()
        }
        .navigationTitle("Расписание")
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
        let weekdayIndex = calendar.component(.weekday, from: date) // День недели как число
        let days = daysOfWeek()
        return days[(weekdayIndex - 2) % 7] // Корректируем для правильного отображения в нашем массиве
    }
    
    // Дни недели
    func daysOfWeek() -> [String] {
        return ["Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота"]
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
                        .foregroundColor(.primary) // Используем адаптивный цвет
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.blue)
                }
                .padding(.vertical, 8)
            }
            
            if isExpanded {
                ForEach(courses, id: \.time) { course in
                    CourseItem(course: course)
                        .transition(.opacity.combined(with: .slide)) // Плавный переход для элементов
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
                Text(course.type) // Добавляем тип занятия (лекция или практика)
                    .font(.subheadline)
                    .foregroundColor(course.type == "Лекция" ? .blue : .green)
            }
            Text(course.title)
                .font(.body)
                .foregroundColor(.primary) // Используем адаптивный цвет для темы
            Text(course.professor) // Добавляем преподавателя
                .font(.footnote)
                .foregroundColor(.secondary) // Вторичный цвет для текста
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
