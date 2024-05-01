//
//  ToggleField.swift
//  Productivity
//
//  Created by Trenton Lyke on 5/1/24.
//

import SwiftUI

struct ToggleField: View {
    let title: String
    @Binding var isOn: Bool
    
    var body: some View {
        Toggle(title, isOn: $isOn)
                    .toggleStyle(CheckToggleStyle())
    }
}

struct CheckToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack{
            configuration.label.font(.headline)
            Button {
                configuration.isOn.toggle()
            } label: {
                
                    Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                        .foregroundStyle(configuration.isOn ? Color.accentColor : .secondary)
                        .accessibility(label: Text(configuration.isOn ? "Checked" : "Unchecked"))
                        .imageScale(.large)
                    
            }
            .buttonStyle(.plain)
            Spacer()
        }
    }
}

