//
//  BorderedTextArea.swift
//  Productivity
//
//  Created by Trenton Lyke on 4/29/24.
//

import SwiftUI

struct BorderedTextEditor: View {
    var title: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title).font(.headline)
            TextEditor(text: $text).padding(10).addBorder(.black, cornerRadius: 15).scrollContentBackground(.hidden).background(Color(red: 243 / 255, green: 242 / 255, blue: 247 / 255, opacity: 1.0))
        }
    }
}

