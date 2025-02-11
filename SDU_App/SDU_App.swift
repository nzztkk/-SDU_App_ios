import SwiftUI
import FirebaseCore
import FirebaseFirestore

@main
struct SDU_App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    
    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
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
            } else {
                ScreenLogin()
            }
        }
    }
}

// AppDelegate для обработки уведомлений
class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // MARK: Firebase initialization
        FirebaseApp.configure()
        let db = Firestore.firestore()
        
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
