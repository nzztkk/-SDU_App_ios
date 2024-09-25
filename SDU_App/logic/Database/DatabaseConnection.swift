//
//  DatabaseConnection.swift
//  SDU App
//
//  Created by Nurkhat on 22.09.2024.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore


class DatabaseConnection: UIViewController {
    
    var db: Firestore!

      override func viewDidLoad() {
        super.viewDidLoad()

        // [START setup]
        let settings = FirestoreSettings()

        Firestore.firestore().settings = settings

          
        let db = Firestore.firestore()
        db.settings = settings
          
        // MARK: Cahce setup
          
        settings.cacheSettings = MemoryCacheSettings(garbageCollectorSettings: MemoryLRUGCSettings())
        settings.cacheSettings = PersistentCacheSettings(sizeBytes: 100 * 1024 * 1024 as NSNumber)
      }
    
    func setupCache(){
        
        // Listen to metadata updates to receive a server snapshot even if
        // the data is the same as the cached data.
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
    
    private func setupFirestore() async{
        
//        let courseCode = db.collection("").document("")
//
//        do {
//          // Force the SDK to fetch the document from the cache. Could also specify
//          // FirestoreSource.server or FirestoreSource.default.
//          let document = try await courseCode.getDocument(source: .cache)
//          if document.exists {
//            let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
//            print("Cached document data: \(dataDescription)")
//          } else {
//            print("Document does not exist in cache")
//          }
//        } catch {
//          print("Error getting document: \(error)")
//        }
        
        
        do {
          let querySnapshot = try await db.collection("Courses_code&name(rus)").getDocuments()
          for document in querySnapshot.documents {
            print("\(document.documentID) => \(document.data())")
          }
        } catch {
          print("Error getting documents(rus): \(error)")
        }
        
        do {
          let querySnapshot = try await db.collection("Courses_code&name(eng)").getDocuments()
          for document in querySnapshot.documents {
            print("\(document.documentID) => \(document.data())")
          }
        } catch {
          print("Error getting documents(eng): \(error)")
        }
        
        do {
          let querySnapshot = try await db.collection("Courses_code&name(kaz)").getDocuments()
          for document in querySnapshot.documents {
            print("\(document.documentID) => \(document.data())")
          }
        } catch {
          print("Error getting documents(kaz): \(error)")
        }


    }

        
    }
    
    
    
    
    

