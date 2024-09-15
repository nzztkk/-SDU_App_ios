//
//  ViewBox.swift
//  SDU_App
//
//  Created by Nurkhat on 11.09.2024.
//

import Foundation
import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            TabView {
                SchedulePage()
                    .tabItem {
                        Label("Schedule", systemImage: "graduationcap.fill")
                    }

                CoursesPage()
                    .tabItem {
                        Label("Courses", systemImage: "square.and.pencil")
                    }
                
                DeadlinesPage()
                    .tabItem {
                        Label("Deadlines", systemImage: "flame.fill")
                    }
            }
            .navigationBarTitle("Расписание", displayMode: .inline)
            .toolbar {
                // Добавляем кнопку справа
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        print("Кнопка нажата")
                    }) {
                        Image(systemName: "calendar")
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
