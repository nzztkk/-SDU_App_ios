//
//  NotificationManager.swift
//  SDU App
//
//  Created by Nurkhat on 19.09.2024.
//


import Foundation
import UserNotifications

// Структура курса
struct CourseNtfy {
    let day: String
    let startTime: String
    let name: String
    let location: String
}

class NotificationManager {
    
    
    
    static let shared = NotificationManager() // Singleton для использования в любом месте приложения
    
    private init() {}
    
    // Запрос разрешения на отправку уведомлений
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Разрешение на уведомления получено")
            } else {
                print("Разрешение на уведомления отклонено")
            }
        }
    }
    
    // Настройка уведомлений только для сегодняшних курсов
    func setupNotifications(for courses: [CourseNtfy]) {
        let today = currentWeekday()
        let todayCourses = courses.filter { $0.day == today }
        
        for course in todayCourses {
            if let courseTime = getDateFromTime(time: course.startTime) {
                scheduleNotification(for: course, at: courseTime)
            }
        }
    }
    
    // Функция для планирования уведомления за 15 минут до начала курса
    private func scheduleNotification(for course: CourseNtfy, at date: Date) {
        let content = UNMutableNotificationContent()
        content.title = course.name
        let startTimeLocalized = String(format: NSLocalizedString("ntfy_start_time".syswords, comment: ""), course.startTime)
        let locationLocalized = String(format: NSLocalizedString("ntfy_location".syswords, comment: ""), course.location)

        content.body = "\(startTimeLocalized) \(locationLocalized)"
        content.sound = .default
        
        let triggerDate = Calendar.current.date(byAdding: .minute, value: -15, to: date)!
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: triggerDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        // Уникальный идентификатор для каждого курса
        let requestIdentifier = "\(course.name)_\(course.startTime)"
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Ошибка при создании уведомления: \(error.localizedDescription)")
            }
        }
    }
    
    // Преобразуем строку времени ("08:30") в объект Date
    private func getDateFromTime(time: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        let today = Date()
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: today)
        let timeComponents = time.split(separator: ":")
        if let hour = Int(timeComponents[0]), let minute = Int(timeComponents[1]) {
            components.hour = hour
            components.minute = minute
        }
        
        return calendar.date(from: components)
    }
    
    // Получение дня недели на основе текущей даты
    private func currentWeekday() -> String {
        let date = Date()
        let calendar = Calendar.current
        let weekdayIndex = calendar.component(.weekday, from: date) // День недели как число (1-7)

        // Массив дней недели, начиная с воскресенья (индекс 1)
        let daysOfWeek = ["day_sun".weeks, "day_mon".weeks, "day_tues".weeks, "day_wednes".weeks, "day_thurs".weeks, "day_fri".weeks, "day_satur".weeks]

        return daysOfWeek[weekdayIndex - 1] // Возвращаем название дня
    }
}
