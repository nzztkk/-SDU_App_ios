//
//  screen_deadlines.swift
//  SDU_App
//
//  Created by Nurkhat on 11.09.2024.
//

import Foundation
import SwiftUI

struct Deadline: Identifiable, Codable { // Добавляем протокол Codable
    let id = UUID()
    var courseTitle: String
    var type: String
    var professor: String
    var location: String
    var time: String
    var isCompleted: Bool
    var isPriority: Int // Используем Int для приоритета
}

extension String {
    func toDate(withFormat format: String = "dd MMM yyyy, HH:mm") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "ru_RU")
        return dateFormatter.date(from: self)
    }
    
    func toDate() -> Date? {
        return self.toDate(withFormat: "dd MMM yyyy, HH:mm") // Подключаем функцию преобразования
    }
}

struct DeadlinesPage: View {
    @State private var deadlines: [Deadline] = []
    @State private var completedDeadlines: [Deadline] = []
    @State private var selectedTab: Int = 0
    @State private var showingAddDeadlineForm = false
    @State private var showingEditDeadlineForm = false
    @State private var selectedDeadline: Deadline?

    var body: some View {
        VStack {
            Picker("", selection: $selectedTab) {
                Text("Активные").tag(0)
                Text("Завершённые").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            ScrollView {
                VStack(spacing: 10) {
                    if selectedTab == 0 {
                        let activeDeadlines = deadlines.filter { !$0.isCompleted }
                        if activeDeadlines.isEmpty {
                            EmptyStateView(text: "Нет активных дедлайнов")
                        } else {
                            ForEach(activeDeadlines.enumerated().map { ($0.offset, $0.element) }, id: \.1.id) { index, deadline in
                                DeadlineItem(deadline: deadline, number: index + 1)
                                    .contextMenu {
                                        Button(action: {
                                            selectedDeadline = deadline
                                            showingEditDeadlineForm = true
                                        }) {
                                            Text("Редактировать")
                                        }

                                        Button(role: .destructive) {
                                            deleteDeadline(deadline)
                                        } label: {
                                            Text("Удалить")
                                        }
                                    }
                            }
                        }
                    } else {
                        if completedDeadlines.isEmpty {
                            EmptyStateView(text: "Нет завершённых дедлайнов")
                        } else {
                            ForEach(completedDeadlines) { deadline in
                                DeadlineItem(deadline: deadline)
                            }
                        }
                    }

                    if selectedTab == 0 {
                        Button(action: {
                            showingAddDeadlineForm = true
                        }) {
                            Image(systemName: "plus")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(20)
                                .shadow(radius: 4)
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddDeadlineForm) {
            AddDeadlineForm(deadlines: $deadlines, isEditing: false)
        }
        .sheet(isPresented: $showingEditDeadlineForm) {
            if let deadline = selectedDeadline {
                AddDeadlineForm(deadlines: $deadlines, deadlineToEdit: deadline, isEditing: true)
            }
        }
        .navigationTitle("Задачи и дедлайны")
        .gesture(DragGesture().onEnded { value in
            if value.translation.width < -100 {
                selectedTab = 1
            } else if value.translation.width > 100 {
                selectedTab = 0
            }
        })
        .onAppear {
            loadDeadlines()
            moveExpiredDeadlinesToArchive()
            saveDeadlines()
        }
    }

    func moveExpiredDeadlinesToArchive() {
        let currentDate = Date()
        
        // Фильтруем дедлайны, которые просрочены более чем на 30 дней
        let expiredDeadlines = deadlines.filter { deadline in
            if let deadlineDate = deadline.time.toDate() {
                return !deadline.isCompleted && deadlineDate < currentDate.addingTimeInterval(-30 * 24 * 60 * 60) // 30 дней
            }
            return false
        }
        
        // Добавляем просроченные дедлайны в архив
        for deadline in expiredDeadlines {
            if !completedDeadlines.contains(where: { $0.id == deadline.id }) {
                completedDeadlines.append(deadline)
            }
        }
        
        // Удаляем просроченные дедлайны из активного списка
        deadlines.removeAll { deadline in
            if let deadlineDate = deadline.time.toDate() {
                return !deadline.isCompleted && deadlineDate < currentDate.addingTimeInterval(-30 * 24 * 60 * 60)
            }
            return false
        }
    }

    // Сохранение дедлайнов в UserDefaults
    func saveDeadlines() {
        if let encoded = try? JSONEncoder().encode(deadlines) {
            UserDefaults.standard.set(encoded, forKey: "deadlines")
        }
        
        if let encoded = try? JSONEncoder().encode(completedDeadlines) {
            UserDefaults.standard.set(encoded, forKey: "completedDeadlines")
        }
    }

    // В методе loadDeadlines
    func loadDeadlines() {
        if let data = UserDefaults.standard.data(forKey: "deadlines"),
           let decoded = try? JSONDecoder().decode([Deadline].self, from: data) {
            deadlines = decoded
        }

        if let data = UserDefaults.standard.data(forKey: "completedDeadlines"),
           let decoded = try? JSONDecoder().decode([Deadline].self, from: data) {
            completedDeadlines = decoded
        }

        removeExpiredDeadlinesFromCache() // Добавляем очистку просроченных дедлайнов при загрузке
    }

    // Удаление просроченных дедлайнов через 21 день
    func removeExpiredDeadlinesFromCache() {
        let currentDate = Date()
        
        // Проверяем завершённые дедлайны на срок хранения в 21 день
        completedDeadlines.removeAll { deadline in
            if let deadlineDate = deadline.time.toDate() {
                return deadlineDate.addingTimeInterval(21 * 24 * 60 * 60) < currentDate
            }
            return false
        }
        
        // Сохраняем обновлённые данные в UserDefaults
        saveDeadlines()
    }

    // В методе deleteDeadline
    func deleteDeadline(_ deadline: Deadline) {
        if let index = deadlines.firstIndex(where: { $0.id == deadline.id }) {
            deadlines.remove(at: index)
            saveDeadlines() // Сохраняем изменения после удаления
        }

        // Если дедлайн был в завершённых, удаляем его оттуда
        if let index = completedDeadlines.firstIndex(where: { $0.id == deadline.id }) {
            completedDeadlines.remove(at: index)
            saveDeadlines()
        }
    }
}

struct AddDeadlineForm: View {
    @Binding var deadlines: [Deadline]
    var deadlineToEdit: Deadline?
    var isEditing: Bool

    @State private var course: String = ""
    @State private var task: String = ""
    @State private var deadlineDate: Date = Date()
    @State private var priority: Double = 0 // Значение от 0 до 2

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Информация о дедлайне")) {
                    TextField("Название предмета", text: $course)
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.words)
                    
                    TextField("Задача", text: $task)
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.sentences)
                    
                    DatePicker("Дата дедлайна", selection: $deadlineDate, in: Date()..., displayedComponents: [.date, .hourAndMinute])
                    
                    VStack {
                        Text("Приоритет: \(priorityLevelText(for: Int(priority)))")
                            .font(.subheadline)
                            .foregroundColor(.primary)

                        Slider(value: $priority, in: 0...2, step: 1) {
                            Text("Приоритет")
                        }
                        .padding()
                        .accentColor(.primary)

                        GeometryReader { geometry in
                            HStack {
                                Circle()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(priority == 0 ? .green : .gray)
                                    .position(x: geometry.size.width * 0.05, y: geometry.size.height / 2)

                                Spacer()

                                Circle()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(priority == 1 ? .yellow : .gray)
                                    .position(x: geometry.size.width * 0.15, y: geometry.size.height / 2)

                                Spacer()

                                Circle()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(priority == 2 ? .red : .gray)
                                    .position(x: geometry.size.width * 0.25, y: geometry.size.height / 2)
                            }
                            .padding(.horizontal)
                        }
                        .frame(height: 40)
                    }
                }

                Button(action: {
                    if isEditing, let editDeadline = deadlineToEdit {
                        if let index = deadlines.firstIndex(where: { $0.id == editDeadline.id }) {
                            deadlines[index] = Deadline(
                                courseTitle: course,
                                type: task,
                                professor: "",
                                location: "",
                                time: deadlineDate.formatted(),
                                isCompleted: false,
                                isPriority: Int(priority)
                            )
                        }
                    } else {
                        let newDeadline = Deadline(
                            courseTitle: course,
                            type: task,
                            professor: "",
                            location: "",
                            time: deadlineDate.formatted(),
                            isCompleted: false,
                            isPriority: Int(priority)
                        )
                        deadlines.append(newDeadline)
                    }
                    dismissForm()
                }) {
                    Text("Сохранить")
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .disabled(course.isEmpty || task.isEmpty || deadlineDate < Date())
            }
            .onAppear {
                if isEditing, let editDeadline = deadlineToEdit {
                    course = editDeadline.courseTitle
                    task = editDeadline.type
                    deadlineDate = editDeadline.time.toDate() ?? Date()
                    priority = Double(editDeadline.isPriority)
                }
            }
            .navigationTitle(isEditing ? "Изменить дедлайн" : "Новый дедлайн")
            .navigationBarItems(leading: Button("Отменить") {
                dismissForm()
            }
            .foregroundColor(.gray))
        }
    }

    func priorityLevelText(for priority: Int) -> String {
        switch priority {
        case 0:
            return "Низкий"
        case 1:
            return "Средний"
        case 2:
            return "Высокий"
        default:
            return "Не задан"
        }
    }

    func dismissForm() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
}

struct DeadlineItem: View {
    var deadline: Deadline
    var number: Int?

    var body: some View {
        VStack(alignment: .leading) {
            if let number = number {
                Text("\(number). \(deadline.courseTitle)")
                    .font(.headline)
                    .foregroundColor(.primary)
            } else {
                Text(deadline.courseTitle)
                    .font(.headline)
                    .foregroundColor(.primary)
            }

            Text(deadline.type)
                .font(.body)
                .foregroundColor(.primary)

            HStack {
                Text(deadline.time)
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Spacer()

                // Отображение значка приоритета
                switch deadline.isPriority {
                case 0:
                    Circle()
                        .frame(width: 10, height: 10)
                        .foregroundColor(.green)
                case 1:
                    Circle()
                        .frame(width: 10, height: 10)
                        .foregroundColor(.yellow)
                case 2:
                    Circle()
                        .frame(width: 10, height: 10)
                        .foregroundColor(.red)
                default:
                    EmptyView()
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
        .padding(.horizontal)
    }
}

struct EmptyStateView: View {
    let text: String

    var body: some View {
        VStack {
            Text(text)
                .font(.headline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding()

            Spacer()
        }
    }
}

#Preview {
    DeadlinesPage()
}
