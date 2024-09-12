//
//  ViewBox.swift
//  SDU_App
//
//  Created by Nurkhat on 11.09.2024.
//

import Foundation
import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            
            
            
            SchedulePage()
                .tabItem {
                    Label("Schedule", systemImage: "graduationcap.fill")
                }

            CoursesPage()
                .tabItem {
                    Label("Courses", systemImage: "square.and.pencil")
                }
            
            DeadlinesPage()
                .tabItem {
                    Label("Deadlines", systemImage: "flame.fill")
                }
            
        }
    }
}



#Preview {
    ContentView()
}


