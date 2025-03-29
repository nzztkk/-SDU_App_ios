import Foundation
import FirebaseFirestore

class DatabaseManager {
    
    static let shared = DatabaseManager()
    private let db = Firestore.firestore()
    private var cachedSchedule: [[String: Any]]?
    private var lastFetchTime: Date?
    
    private init() {}
    
    // MARK: - Fetch Schedule with Caching
    
    /// Fetch schedule with caching mechanism
    func fetchSchedule(forceRefresh: Bool = false, completion: @escaping (Result<[[String: Any]], Error>) -> Void) {
        // Проверяем, есть ли кешированные данные и не истек ли их срок действия
        if let cachedSchedule = cachedSchedule, let lastFetchTime = lastFetchTime, !forceRefresh {
            let timeSinceLastFetch = Date().timeIntervalSince(lastFetchTime)
            if timeSinceLastFetch < 3600 { // 1 час
                completion(.success(cachedSchedule))
                return
            }
        }
        
        // Если кеша нет или он устарел — загружаем из Firestore
        db.collection("schedule").getDocuments { [weak self] (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot {
                let schedule = snapshot.documents.map { $0.data() }
                self?.cachedSchedule = schedule
                self?.lastFetchTime = Date()
                completion(.success(schedule))
            }
        }
    }
    
    // Очистка кеша (если надо)
    func clearCache() {
        cachedSchedule = nil
        lastFetchTime = nil
    }
}
