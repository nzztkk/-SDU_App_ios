//
//  DatabaseConnection.swift
//  SDU App
//
//  Created by Nurkhat on 22.09.2024.
//

import Foundation
import Firebase
import FirebaseFirestore

class DatabaseConnection: ObservableObject {
    @Published var courses: [Course] = []
    @Published var isLoading = false

    private var db: Firestore

    init() {
        self.db = Firestore.firestore()
    }

    // Асинхронная функция для получения курсов из Firestore
    func getCoursesData() async {
        isLoading = true
        do {
            let querySnapshot = try await db.collection("Courses").getDocuments()
            DispatchQueue.main.async {
                self.courses = querySnapshot.documents.map { document in
                    let id = document.documentID // Use the Firestore document ID as the stable ID

                    return CourseData(
                        id: id,
                        courseCode: document["courseCode"] as? String ?? "",
                        day: document["day"] as? String ?? "",
                        timeStart: document["timeStart"] as? String ?? "",
                        timeEnd: document["timeEnd"] as? String ?? "",
                        title: document["title"] as? String ?? "",
                        location: document["location"] as? String ?? "",
                        type: document["type"] as? String ?? "",
                        professor: document["professor"] as? String ?? "",
                        onlineLink: document["onlineLink"] as? String
                    )
                }
            }
        } catch {
            print("Ошибка при получении данных: \(error)")
        }
        isLoading = false
    }
}
