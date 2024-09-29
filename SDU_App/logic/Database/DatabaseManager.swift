//
//  DatabaseManager.swift
//  SDU App
//
//  Created by Nurkhat on 20.09.2024.
//

import FirebaseFirestore
import SwiftUI

class DatabaseManager {
    static let shared = DatabaseManager()
    private let db = Firestore.firestore()

    private init() {}

    struct Course: Codable, Identifiable {
        let id = UUID()
        let courseCode: String
        let courseName: String
        let professor: String
        let day: String
        let time: String
        let location: String?
        let onlineLink: String?
    }

    // Fetch courses data with locale support
    func fetchCourses(locale: String) async throws -> [Course] {
        let snapshot = try await db.collection("Courses_code&name(\(locale))").getDocuments()
        let courses = snapshot.documents.compactMap { document -> Course? in
            let data = document.data()
            return Course(
                courseCode: data["course_code"] as? String ?? "",
                courseName: data["course_name"] as? String ?? "",
                professor: data["professor"] as? String ?? "",
                day: data["day"] as? String ?? "",
                time: data["time"] as? String ?? "",
                location: data["location"] as? String,
                onlineLink: data["online_link"] as? String
            )
        }
        return courses
    }
    
    func fetchTeachers(locale: String) async throws -> [String] {
        let snapshot = try await db.collection("teachers_\(locale)").getDocuments()
        return snapshot.documents.compactMap { $0.data()["name"] as? String }
    }

    func fetchLessonStartTimes() async throws -> [String] {
        let snapshot = try await db.collection("lessons_start_time").getDocuments()
        return snapshot.documents.compactMap { $0.data()["start_time"] as? String }
    }

    func fetchLessonEndTimes() async throws -> [String] {
        let snapshot = try await db.collection("lessons_end_time").getDocuments()
        return snapshot.documents.compactMap { $0.data()["end_time"] as? String }
    }
}
