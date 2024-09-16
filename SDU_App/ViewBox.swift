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
        .onAppear {
            // Определяем текущую неделю при появлении экрана
            currentWeek = getCurrentWeek()
        }
    }

    // Определение текущей недели на основе сегодняшней даты
    func getCurrentWeek() -> Int {
        let calendar = Calendar.current
        let today = Date()
        
        // Начало семестра (например, 1 сентября)
        let semesterStartDate = calendar.date(from: DateComponents(year: 2024, month: 9, day: 1))!
        
        let components = calendar.dateComponents([.weekOfYear], from: semesterStartDate, to: today)
        let weekNumber = components.weekOfYear ?? 1
        
        return min(max(weekNumber, 1), 15) // Убедимся, что результат в пределах от 1 до 15
    }
}

#Preview {
    ContentView()
}
