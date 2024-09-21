//
//  SDU_AppApp.swift
//  SDU_App
//
//  Created by Nurkhat on 30.08.2024.
//

import SwiftUI
import FirebaseCore

@main
struct SDU_App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    // Запрашиваем разрешение на уведомления
                    NotificationManager.shared.requestNotificationPermission()
                    
                    // Очищаем все старые уведомления
                    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                    
                    // Получаем расписание и устанавливаем уведомления
                    let schedule = ScheduleManager.shared.getCourses()
                    NotificationManager.shared.setupNotifications(for: schedule)
                }
        }
    }
}

// AppDelegate для обработки уведомлений
class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if #available(iOS 14.0, *) {
            completionHandler([.banner, .sound, .list])
        } else {
            completionHandler([.alert, .sound])
        }
    }
}


    
    
    
    
