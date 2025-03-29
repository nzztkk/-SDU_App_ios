import Foundation
import SwiftUI
import Supabase

@MainActor
class DatabaseConnection: ObservableObject {
    @Published var courses: [Course] = []
    @Published var isLoading: Bool = false
    
    // ✅ Синглтон
    static let shared = DatabaseConnection()
    
    private var supabase: SupabaseClient?
    private var isConfigured = false

    // ✅ Закрытый init чтобы класс нельзя было создать извне
    private init() {}
    
    // ✅ Конфигурируем Supabase один раз
    func configureSupabase() async {
        guard !isConfigured else { return } // Не конфигурируем повторно
        
        do {
            if let config = loadSupabaseConfig() {
                guard let url = URL(string: config.url) else {
                    print("❌ Ошибка: Некорректный URL Supabase.")
                    return
                }
                
                supabase = SupabaseClient(supabaseURL: url, supabaseKey: config.key)
                isConfigured = true
                print("✅ Supabase инициализирован успешно.")
            } else {
                print("❌ Ошибка: Не удалось загрузить конфиг Supabase.")
            }
        } catch {
            print("❌ Ошибка при конфигурации Supabase: \(error)")
        }
    }
    
    // ✅ Получаем конфиг из Secrets.plist
    private func loadSupabaseConfig() -> (url: String, key: String)? {
        guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist") else {
            print("❌ Файл Secrets.plist не найден.")
            return nil
        }

        guard let dict = NSDictionary(contentsOfFile: path) as? [String: Any] else {
            print("❌ Не удалось считать данные из Secrets.plist.")
            return nil
        }

        guard let url = dict["SUPABASE_URL"] as? String,
              let key = dict["SUPABASE_KEY"] as? String else {
            print("❌ Не удалось получить URL или KEY из Secrets.plist.")
            return nil
        }

        print("🔐 Загружены конфиги Supabase")
        return (url, key)
    }

    // ✅ Получаем расписание из Supabase Storage
    func getCoursesData() async {
        guard let supabase = supabase else {
            print("❌ Supabase клиент не инициализирован")
            return
        }
        
        if isLoading { return } // ✅ Предотвращаем множественные запросы

        isLoading = true
        
        do {
            let files = try await supabase.storage
                .from("schedules-data")
                .list(path: "Schedule")
            
            var loadedCourses: [Course] = []
            
            for file in files {
                print("📂 Найден файл: \(file.name)")
                
                let fileData = try await supabase.storage
                    .from("schedules-data")
                    .download(path: "Schedule/\(file.name)")
                
                if let course = parseCourseData(fileData) {
                    loadedCourses.append(contentsOf: course)
                }
            }
            
            self.courses = loadedCourses
            print("✅ Загружено курсов: \(loadedCourses.count)")
            
        } catch {
            print("❌ Ошибка при загрузке данных: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
    
    // ✅ Парсинг JSON-файла
    private func parseCourseData(_ data: Data) -> [Course]? {
        do {
            let decoder = JSONDecoder()
            let courses = try decoder.decode([Course].self, from: data)
            return courses
        } catch {
            print("❌ Ошибка при парсинге JSON: \(error)")
            return nil
        }
    }
}
