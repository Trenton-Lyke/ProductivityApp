//
//  ErrorText.swift
//  Productivity
//
//  Created by Trenton Lyke on 4/29/24.
//

import SwiftUI

struct ErrorText: View {
    var error: String
    @Binding var showError: Bool
    
    
    var body: some View {
        createErrorDisplay()
    }
    
    @ViewBuilder
    private func createErrorDisplay() -> some View {
        if showError {
            Text(error)
                .italic()
                .foregroundStyle(.red)
        } else {
            EmptyView()
        }
    }
}

