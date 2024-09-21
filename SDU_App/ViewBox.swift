//
//  ViewBox.swift
//  SDU_App
//
//  Created by Nurkhat on 11.09.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var currentWeek: Int = 1 // Текущая неделя
    @State private var isWeekSelectorVisible: Bool = true // Контроль видимости панели с неделями

    var body: some View {
        TabView {
            // Экран с расписанием
            NavigationView {
                VStack(spacing: 0) {
                    // Панель с неделями и датой
                    if isWeekSelectorVisible {
                        WeekSelectorView(currentWeek: $currentWeek)
                            .zIndex(1) // Поднимаем над остальными элементами
                            .transition(.move(edge: .top))
                            .animation(.easeInOut(duration: 0.3), value: isWeekSelectorVisible) // Анимация скрытия
                    }
                    
                    // Основной экран с расписанием
                    ScrollView {
                        SchedulePage()
                            .padding(.top, 10)
                            .background(GeometryReader { proxy in
                                Color.clear
                                    .onChange(of: proxy.frame(in: .global).minY) { newValue in
                                        withAnimation {
                                            // Если пользователь прокручивает вверх - показываем панель, вниз - скрываем
                                            isWeekSelectorVisible = newValue > 0
                                        }
                                    }
                            })
                    }
                }
                .navigationBarTitle("schedule_p".syswords, displayMode: .inline) // Надпись Расписание сверху
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            print("Кнопка нажата")
                        }) {
                            Image(systemName: "person.crop.circle")
                                
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
