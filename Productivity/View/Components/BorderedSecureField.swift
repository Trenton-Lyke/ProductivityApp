//
//  BorderedSecureField.swift
//  Productivity
//
//  Created by Trenton Lyke on 4/29/24.
//

import SwiftUI

struct BorderedSecureField: View {
    var title: String
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title).font(.headline)
            SecureField(placeholder, text: $text).padding(10).addBorder(.black, cornerRadius: 15)
        }
    }
}
