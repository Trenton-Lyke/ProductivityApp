//
//  User.swift
//  Productivity
//
//  Created by Trenton Lyke on 4/29/24.
//

import Foundation

struct User: Codable, Hashable {
    let id: Int
    let name: String
    let courses: [Course]
}
