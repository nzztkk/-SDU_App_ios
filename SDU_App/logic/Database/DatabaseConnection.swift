import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore

class DatabaseConnection: ObservableObject {
    @Published var courses: [Course] = []
    @Published var isLoading: Bool = false  // Добавлено свойство isLoading
    
    var db: Firestore!

    // Убираем override и super.init(), инициализатор больше не нужен для ObservableObject
    init() {
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        db.settings = settings
    }

    func setupCache() {
        db.collection("Courses_code&name(rus)").addSnapshotListener(includeMetadataChanges: true) { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error retrieving snapshot: \(error!)")
                return
            }

            for diff in snapshot.documentChanges {
                if diff.type == .added {
                    print("New document: \(diff.document.data())")
                } else if diff.type == .modified {
                    print("Modified document: \(diff.document.data())")
                } else if diff.type == .removed {
                    print("Removed document: \(diff.document.data())")
                }
            }

            let source = snapshot.metadata.isFromCache ? "local cache" : "server"
            print("Metadata: Data fetched from \(source)")
        }
    }

    func getCoursesData() async {
        isLoading = true  // Устанавливаем isLoading в true
        do {
            let querySnapshot = try await db.collection("Courses_code&name(rus)").getDocuments()
            for document in querySnapshot.documents {
                print("\(document.documentID) => \(document.data())")
            }
            isLoading = false  // После загрузки устанавливаем isLoading в false
        } catch {
            print("Error getting documents: \(error)")
            isLoading = false  // Если ошибка, тоже выключаем загрузку
        }
    }
}
