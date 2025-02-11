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
            // Название курса
            Text(course.courseName)
                .font(.title)
                .bold()
                .lineLimit(3)
                .minimumScaleFactor(0.7)
                .frame(maxWidth: .infinity, alignment: .leading)

            // Время начала
            HStack {
                Image(systemName: "clock")
                    .foregroundColor(.gray)
                Text(":  \(course.timeStart) - \(course.timeEnd)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            // Группа
            HStack {
                Image(systemName: "book")
                    .foregroundColor(.gray)
                Text(":  \(course.group)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            // Преподаватель
            HStack {
                Image(systemName: "person.fill")
                    .foregroundColor(.gray)
                Text(":  \(course.professor)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            // Аудитория
            HStack {
                Image(systemName: "door.left.hand.closed")
                    .foregroundColor(.gray)
                Text(":  \(course.classroom)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            // Онлайн-ссылка
            if let onlineLink = course.onlineLink {
                HStack {
                    Image(systemName: "link")
                        .foregroundColor(.gray)
                    Text(": ")
                        .foregroundColor(.gray)
                    Link("online_lesson_link".lc, destination: URL(string: onlineLink)!)
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
            }

            Spacer()
        }
        .padding()
        .navigationTitle("lesson_info_p".syswords)
    }
}
