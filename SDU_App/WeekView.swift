//
//  WeekView.swift
//  SDU App
//
//  Created by Nurkhat on 15.09.2024.
//

import SwiftUI

// Вью для выбора недель
struct WeekSelectorView: View {
    @Binding var currentWeek: Int

    var body: some View {
        VStack {
            // Горизонтальный стек с номерами недель
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(1...15, id: \.self) { week in
                        WeekNumberView(week: week, isCurrentWeek: week == currentWeek)
                            .onTapGesture {
                                currentWeek = week
                            }
                    }
                }
                .padding()
            }

            // Отображение даты только для выбранной недели
            
            Text(weekDates(for: currentWeek))
                .font(.title3)
                .foregroundColor(.blue)
            
                
        }
        
        .onAppear {
            // Определяем текущую неделю при появлении экрана
            currentWeek = getCurrentWeek()
        }
    }

    // Функция для расчета диапазона дат для каждой недели
    func weekDates(for week: Int) -> String {
        let calendar = Calendar.current

        // Начало семестра (например, 1 сентября)
        let semesterStartDate = calendar.date(from: DateComponents(year: 2024, month: 9, day: 2))!

        // Рассчитываем дату начала недели
        if let weekStartDate = calendar.date(byAdding: .weekOfYear, value: week - 1, to: semesterStartDate) {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM"

            let weekEndDate = calendar.date(byAdding: .day, value: 6, to: weekStartDate)!
            return "\(formatter.string(from: weekStartDate)) - \(formatter.string(from: weekEndDate))"
        }

        return ""
    }
    
    // Функция для вычисления текущей недели на основе текущей даты устройства
        func getCurrentWeek() -> Int {
            let calendar = Calendar.current
            let today = Date()

            // Начало семестра (например, 2 сентября)
            let semesterStartDate = calendar.date(from: DateComponents(year: 2024, month: 9, day: 2))!

            // Рассчитываем количество недель между началом семестра и текущей датой
            let components = calendar.dateComponents([.weekOfYear], from: semesterStartDate, to: today)
            let weekNumber = (components.weekOfYear ?? 1) + 1

            // Ограничиваем результат в пределах от 1 до 15
            return min(max(weekNumber, 1), 15)
        }
}

// Вью для номера недели с выделением текущей недели
struct WeekNumberView: View {
    var week: Int
    var isCurrentWeek: Bool

    var body: some View {
        Text("\(week)")
            .font(.title3)
            .frame(width: 40, height: 40) // Устанавливаем фиксированные размеры
            .background(isCurrentWeek ? Color.blue : Color.gray.opacity(0.2))
            .cornerRadius(17)
            .foregroundColor(isCurrentWeek ? .white : .primary)
            /*.overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(isCurrentWeek ? Color.blue : Color.primary.opacity(0), lineWidth: 1)
            )*/
            .multilineTextAlignment(.center) // Выровнять текст по центру
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

#Preview {
    WeekSelectorView(currentWeek: .constant(1))
}
