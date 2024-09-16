//
//  lesson_info_page.swift
//  SDU App
//
//  Created by Nurkhat on 17.09.2024.
//

import Foundation
import SwiftUI

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
        .navigationTitle("lesson_info_p".syswords)
    }
}


