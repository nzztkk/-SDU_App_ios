import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore

class DatabaseConnection: ObservableObject {
    @Published var courses: [Course] = []
    @Published var isLoading: Bool = false  // Добавлено свойство isLoading
    
    var db: Firestore!

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
        DispatchQueue.main.async {
            self.isLoading = true  // Устанавливаем isLoading в true на главном потоке
        }
        do {
            let querySnapshot = try await db.collection("Courses_code&name(rus)").getDocuments()
            for document in querySnapshot.documents {
                print("\(document.documentID) => \(document.data())")
                // Можно добавить код для обработки данных из документа, например:
                // self.courses.append(Course(data: document.data())) или что-то подобное
            }
            DispatchQueue.main.async {
                self.isLoading = false  // После загрузки устанавливаем isLoading в false на главном потоке
            }
        } catch {
            print("Error getting documents: \(error)")
            DispatchQueue.main.async {
                self.isLoading = false  // Если ошибка, тоже выключаем загрузку на главном потоке
            }
        }
    }
}
