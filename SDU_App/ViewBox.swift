import SwiftUI

struct ContentView: View {
    @State private var currentWeek: Int = 1 // Текущая неделя
    @State private var isWeekSelectorVisible: Bool = true // Контроль видимости панели с неделями
    @State private var selectedTab: Int = 0 // Текущая выбранная вкладка
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Экран с расписанием
            NavigationView {
                VStack(spacing: 0) {
                    if isWeekSelectorVisible {
                        WeekSelectorView(currentWeek: $currentWeek)
                            .zIndex(1)
                            .transition(.move(edge: .top))
                            .animation(.easeInOut(duration: 0.3), value: isWeekSelectorVisible)
                    }
                    
                    ScrollView {
                        SchedulePage()
                            .padding(.top, 10)
                            .background(GeometryReader { proxy in
                                Color.clear
                                    .onChange(of: proxy.frame(in: .global).minY) { newValue in
                                        withAnimation {
                                            isWeekSelectorVisible = newValue > 0
                                        }
                                    }
                            })
                    }
                }
                .navigationBarTitle("schedule_p".syswords, displayMode: .inline)
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
                if let image = UIImage(named: selectedTab == 0 ? "schedule-fill" : "schedule-outline") {
                    Image(uiImage: image)
                } else {
                    Image(systemName: "calendar")
                }
                Text("schedule_p".syswords)
            }
            .tag(0)
            
            // Страница курсов
            NavigationView {
                CoursesPage()
                    .navigationBarTitle("courses_p".syswords, displayMode: .inline)
            }
            .tabItem {
                if let image = UIImage(named: selectedTab == 1 ? "courses-fill" : "courses-outline") {
                    Image(uiImage: image)
                } else {
                    Image(systemName: "book")
                }
                Text("courses_p".syswords)
            }
            .tag(1)
            
            // Страница дедлайнов
            NavigationView {
                DeadlinesPage()
                    .navigationBarTitle("deadlines_p".syswords, displayMode: .inline)
            }
            .tabItem {
                if let image = UIImage(named: selectedTab == 2 ? "deadlines-fill" : "deadlines-outline") {
                    Image(uiImage: image)
                } else {
                    Image(systemName: "flame")
                }
                Text("deadlines_p".syswords)
            }
            .tag(2)
        }
        .animation(.easeInOut(duration: 0.3), value: selectedTab)
    }
}

#Preview {
    ContentView()
}
