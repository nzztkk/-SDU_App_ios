//
//  DatabaseManager.swift
//  SDU App
//
//  Created by Nurkhat on 20.09.2024.
//


import Foundation
import FirebaseFirestore
//import FirebaseFirestoreSwift

class DatabaseManager {
    
    static let shared = DatabaseManager()
    private let db = Firestore.firestore()
    
    private init() {}
    
    // MARK: - Add Data
    
    /// Add a new document to the Firestore collection
    func addUser(userID: String, firstName: String, lastName: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let userData: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName
        ]
        
        db.collection("users").document(userID).setData(userData) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // MARK: - Fetch Data
    
    /// Fetch a single user's data from Firestore
    func fetchUser(userID: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        let userRef = db.collection("users").document(userID)
        
        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if let data = document.data() {
                    completion(.success(data))
                }
            } else if let error = error {
                completion(.failure(error))
            } else {
                completion(.failure(NSError(domain: "Firestore", code: 404, userInfo: [NSLocalizedDescriptionKey: "Document does not exist"])))
            }
        }
    }
    
    // MARK: - Update Data
    
    /// Update user's data in Firestore
    func updateUser(userID: String, updatedData: [String: Any], completion: @escaping (Result<Void, Error>) -> Void) {
        let userRef = db.collection("users").document(userID)
        
        userRef.updateData(updatedData) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // MARK: - Delete Data
    
    /// Delete a user from Firestore
    func deleteUser(userID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let userRef = db.collection("users").document(userID)
        
        userRef.delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // MARK: - Fetch All Users
    
    /// Fetch all users in the "users" collection
    func fetchAllUsers(completion: @escaping (Result<[[String: Any]], Error>) -> Void) {
        db.collection("users").getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot {
                let users = snapshot.documents.map { $0.data() }
                completion(.success(users))
            }
        }
    }
}
