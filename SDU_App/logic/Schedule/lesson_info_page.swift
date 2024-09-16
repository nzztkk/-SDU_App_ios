//
//  lesson_info_page.swift
//  SDU App
//
//  Created by Nurkhat on 17.09.2024.
//

import Foundation
import SwiftUI

struct LessonInfoPage: View {
    var course: Course // Передаем объект курса

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            // Используем свойства напрямую из объекта course
            Text(course.title)
                .font(.title)
                .bold()
                .lineLimit(3) // Ограничиваем текст заголовка 3 строками
                .minimumScaleFactor(0.7) // Минимальный масштаб шрифта до 70% от исходного
                .frame(maxWidth: .infinity, alignment: .leading) // Тянем текст на всю ширину

            HStack {
                Image(systemName: "clock")
                    .foregroundColor(.gray)
                Text(" :  \(course.time)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            HStack {
                Image(systemName: "book")
                    .foregroundColor(.gray)
                Text(":  \(course.type.lc)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            HStack {
                Image(systemName: "person.fill")
                    .foregroundColor(.gray)
                Text(" :  \(course.professor)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            HStack {
                Image(systemName: "door.left.hand.closed")
                    .foregroundColor(.gray)
                Text(" :  \(course.location)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            // Отображаем скрытую ссылку под текстом "Ссылка на урок", если она существует
            if let onlineLink = course.onlineLink {
                HStack {
                    Image(systemName: "link")
                        .foregroundColor(.gray)
                    Text(": ")
                        .foregroundStyle(.gray)
                    Link("Ссылка на урок", destination: URL(string: onlineLink)!)
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Информация о паре")
    }
}
