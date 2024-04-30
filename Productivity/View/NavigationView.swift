//
//  NavigationView.swift
//  Productivity
//
//  Created by Trenton Lyke on 4/29/24.
//

import SwiftUI

struct NavigationView<Content: View>: View {
    let title: String
    let content: Content
        
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    
    var body: some View {
        NavigationStack {
            VStack{
                content
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(
                .pink,
                for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Text(title).font(.title)
                    }
                    .padding(20)
                }
            }
            .background(Color(red: 243 / 255, green: 242 / 255, blue: 247 / 255, opacity: 1.0))
        }
        
    }
}

#Preview {
    NavigationView(title: "Title"){
        Text("Content")
    }
}
