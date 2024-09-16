//
//  SDU_AppApp.swift
//  SDU_App
//
//  Created by Nurkhat on 30.08.2024.
//

import SwiftUI
import UserNotifications
import FirebaseCore


class Delegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}



@main
struct SDU_App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    // Запрашиваем разрешение на уведомления
                    requestNotificationPermission()
                    
                    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                    
                    
                    // Полное расписание курсов
                    let schedule = [
                        CourseNtfy(
                            day:"day_mon".weeks,
                            startTime: "ct_1_start".lc,
                            name: "c_name_mde_151".lc,
                            location: "cr_a1".lc
                        ),
                        CourseNtfy(
                            day:"day_mon".weeks,
                            startTime: "ct_3_start".lc,
                            name: "c_name_css_410".lc,
                            location: "cr_a2".lc
                        ),
                        CourseNtfy(
                            day:"day_mon".weeks,
                            startTime: "ct_4_start".lc,
                            name: "c_name_css_410".lc,
                            location: "cr_a2".lc
                        ),
                        CourseNtfy(
                            day:"day_mon".weeks,
                            startTime: "ct_8_start".lc,
                            name: "c_name_css_410".lc,
                            location: "cr_a3".lc
                        ),
                        CourseNtfy(
                            day:"day_tues".weeks,
                            startTime: "ct_9_start".lc,
                            name: "c_name_css_312".lc,
                            location: "cr_e1".lc
                        ),
                        CourseNtfy(
                            day:"day_wednes".weeks,
                            startTime: "ct_8_start".lc,
                            name: "c_name_inf_405".lc,
                            location: "cr_a1".lc
                        ),
                        CourseNtfy(
                            day:"day_wednes".weeks,
                            startTime: "ct_9_start".lc,
                            name: "c_name_inf_405".lc,
                            location: "cr_a1".lc
                        ),
                        CourseNtfy(
                            day:"day_wednes".weeks,
                            startTime: "ct_10_start".lc,
                            name: "c_name_inf_405".lc,
                            location: "cr_a1".lc
                        ),
                        CourseNtfy(
                            day:"day_thurs".weeks,
                            startTime: "ct_5_start".lc,
                            name: "c_name_inf_228".lc,
                            location: "cr_b2".lc
                        ),
                        CourseNtfy(
                            day:"day_thurs".weeks,
                            startTime: "ct_6_start".lc,
                            name: "c_name_inf_228".lc,
                            location: "cr_b2".lc
                        ),
                        CourseNtfy(
                            day:"day_fri".weeks,
                            startTime: "ct_1_start".lc,
                            name: "c_name_css_312".lc,
                            location: "cr_f1".lc
                        ),
                        CourseNtfy(
                            day:"day_fri".weeks,
                            startTime: "ct_2_start".lc,
                            name: "c_name_css_312".lc,
                            location: "cr_f1".lc
                        ),
                        CourseNtfy(
                            day:"day_fri".weeks,
                            startTime: "ct_3_start".lc,
                            name: "c_name_inf_228".lc,
                            location: "cr_g1".lc
                        ),
                        CourseNtfy(
                            day:"day_satur".weeks,
                            startTime: "ct_1_start".lc,
                            name: "c_name_css_319".lc,
                            location: "cr_d1".lc
                        ),
                        CourseNtfy(
                            day:"day_satur".weeks,
                            startTime: "ct_2_start".lc,
                            name: "c_name_css_319".lc,
                            location: "cr_d1".lc
                        ),
                        CourseNtfy(
                            day:"day_satur".weeks,
                            startTime: "ct_7_start".lc,
                            name: "c_name_css_319".lc,
                            location: "cr_d1".lc
                        )
                        
                        //testnotify
                       /*
                        CourseNtfy(
                            day:"day_sun".weeks,
                            startTime: "test_time1".lc,
                            name: "c_name_css_319".lc,
                            location: "cr_d1".lc
                        ),
                        CourseNtfy(
                            day:"day_tues".weeks,
                            startTime: "test_time1".lc,
                            name: "c_name_css_319".lc,
                            location: "cr_d1".lc
                        )*/
                        
                    ]
                    
                    
                    
                    setupNotifications(for: schedule)
                    
                   
                }
        }
    }
    
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
    
    /*
     
     "day_mon" = "Понедельник";
     "day_tues" = "Вторник";
     "day_wednes" = "Среда";
     "day_thurs" = "Четверг";
     "day_fri" = "Пятница";
     "day_satur" = "Суббота";
     "day_sun" = "Воскресенье";
     */
    
    // Получение дня недели на основе текущей даты
    func currentWeekday() -> String {
        let date = Date()
        let calendar = Calendar.current
        let weekdayIndex = calendar.component(.weekday, from: date) // День недели как число (1-7)

        // Массив дней недели, начиная с воскресенья (индекс 1)
        let daysOfWeek = ["day_sun".weeks, "day_mon".weeks, "day_tues".weeks, "day_wednes".weeks, "day_thurs".weeks, "day_fri".weeks, "day_satur".weeks]

        // Поскольку weekdayIndex в календаре Gregorian начинается с 1 (воскресенье), вычитаем 1 для корректного индекса массива
        return daysOfWeek[weekdayIndex - 1] // Возвращаем название дня
    }
        
        // Функция для планирования уведомления за 15 минут до начала курса
        func scheduleNotification(for course: CourseNtfy, at date: Date) {
            let content = UNMutableNotificationContent()
            content.title = course.name
            content.body = "Начало в \(course.startTime) в кабинете \(course.location)"
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
        func getDateFromTime(time: String) -> Date? {
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
    }
    
    // Структура курса
    struct CourseNtfy {
        let day: String
        let startTime: String
        let name: String
        let location: String
    }
    
    // AppDelegate для обработки уведомлений
    class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
            UNUserNotificationCenter.current().delegate = self
            return true
        }
        
        func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            // Для iOS 14 и выше
            if #available(iOS 14.0, *) {
                completionHandler([.banner, .sound, .list])
            } else {
                // Для более ранних версий iOS
                completionHandler([.alert, .sound])
            }
        }
    }

