//
//  ViewBox.swift
//  SDU_App
//
//  Created by Nurkhat on 11.09.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var currentWeek: Int = 1 // Текущая неделя

    var body: some View {
        TabView {
            // Экран с расписанием
            NavigationView {
                VStack {
                    // Добавляем отдельный компонент для выбора недель
                    WeekSelectorView(currentWeek: $currentWeek)
                    
                    // Основной экран с расписанием
                    SchedulePage()
                        .padding(.top, 10)
                }
                .navigationBarTitle("schedule_p".syswords, displayMode: .inline) // Надпись Расписание сверху
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            print("Кнопка нажата")
                        }) {
                            Image(systemName: "calendar")
                        }
                    }
                }
            }
            .tabItem {
                Label("schedule_p".syswords, systemImage: "graduationcap.fill")
            }

            // Страница курсов
            NavigationView {
                CoursesPage()
                    .navigationBarTitle("courses_p".syswords, displayMode: .inline)
            }
            .tabItem {
                Label("courses_p".syswords, systemImage: "square.and.pencil")
            }

            // Страница дедлайнов
            NavigationView {
                DeadlinesPage()
                    .navigationBarTitle("deadlines_p".syswords, displayMode: .inline)
            }
            .tabItem {
                Label("deadlines_p".syswords, systemImage: "flame.fill")
            }
        }
        
    }

    
}

#Preview {
    ContentView()
}
