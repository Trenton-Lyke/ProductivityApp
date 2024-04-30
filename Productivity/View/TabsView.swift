//
//  TabsView.swift
//  Productivity
//
//  Created by Trenton Lyke on 4/29/24.
//

import SwiftUI

struct TabsView: View {
    var body: some View {
        TabView {
            Group{
                CoursesView()
                    .tabItem {
                        Label("", systemImage: "person.3.fill")
                    }
                AssignmentsView()
                    .tabItem {
                        Label("", systemImage: "folder.fill")
                    }
                TimerView()
                    .tabItem {
                        Label("", systemImage: "timer")
                    }
                AccountView(isTemporaryAuth: false)
                    .tabItem {
                        Label("", systemImage: "person.crop.circle.fill")
                    }
            }
            .toolbarBackground(.pink, for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarColorScheme(.dark, for: .tabBar)
            
        }
        
    }
}

#Preview {
    TabsView()
}
