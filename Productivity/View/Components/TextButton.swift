//
//  SimpleButton.swift
//  Productivity
//
//  Created by Trenton Lyke on 4/29/24.
//

import SwiftUI

struct TextButton: View {
    let title: String
    let foregroundColor: Color
    let backgroundColor: Color
    let action: () -> Void
    
    
    var body: some View {
        Button(action: action) {
            createButtonLabel(title: title, foregroundColor: foregroundColor, backgroundColor: backgroundColor)
        }
        
    }
    
    @ViewBuilder
    private func createButtonLabel(title: String, foregroundColor: Color, backgroundColor: Color)  -> some View {
        Text(title).font(.title2)
            .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
            .frame(minWidth: 0, maxWidth: .infinity)
            .foregroundColor(foregroundColor)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

#Preview {
    TextButton(title: "test", foregroundColor: .white, backgroundColor: .red) {
        
    }
}
