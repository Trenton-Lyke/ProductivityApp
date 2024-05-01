//
//  BorderedNumberField.swift
//  Productivity
//
//  Created by Trenton Lyke on 5/1/24.
//

import SwiftUI

struct BorderedNumberField: View {
    var title: String
    var placeholder: String
    @Binding var value: Int
    var disabled: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title).font(.headline)
            TextField(placeholder, value: $value, format: .number).padding(10).addBorder(disabled ? .gray : .black, cornerRadius: 15).disabled(disabled)
        }.foregroundColor(disabled ? .gray : .black)
    }
    
}

