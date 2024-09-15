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
    }

    // Функция для расчета диапазона дат для каждой недели
    func weekDates(for week: Int) -> String {
        let calendar = Calendar.current

        // Начало семестра (например, 1 сентября)
        let semesterStartDate = calendar.date(from: DateComponents(year: 2024, month: 9, day: 1))!

        // Рассчитываем дату начала недели
        if let weekStartDate = calendar.date(byAdding: .weekOfYear, value: week - 1, to: semesterStartDate) {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM"

            let weekEndDate = calendar.date(byAdding: .day, value: 6, to: weekStartDate)!
            return "\(formatter.string(from: weekStartDate)) - \(formatter.string(from: weekEndDate))"
        }

        return ""
    }
}

// Вью для номера недели с выделением текущей недели
struct WeekNumberView: View {
    var week: Int
    var isCurrentWeek: Bool

    var body: some View {
        Text("\(week)")
            .font(.headline)
            .frame(width: 40, height: 40) // Устанавливаем фиксированные размеры
            .background(isCurrentWeek ? Color.blue : Color.gray.opacity(0.2))
            .cornerRadius(10)
            .foregroundColor(isCurrentWeek ? .white : .black)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isCurrentWeek ? Color.blue : Color.gray, lineWidth: 2)
            )
            .multilineTextAlignment(.center) // Выровнять текст по центру
    }
}

#Preview {
    WeekSelectorView(currentWeek: .constant(1))
}
