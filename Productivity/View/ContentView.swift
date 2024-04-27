//
//  ContentView.swift
//  Productivity
//
//  Created by Trenton Lyke on 4/27/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TodoListView(tasks: [Task.dummyParentTask])
    }
}

#Preview {
    ContentView()
}
