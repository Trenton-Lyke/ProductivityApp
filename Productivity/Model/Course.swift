//
//  Course.swift
//  Productivity
//
//  Created by Trenton Lyke on 4/29/24.
//

import Foundation

struct Course: Codable, Hashable {
    let id: Int
    let name: String
    let description: String
    let assignments: [Assignment]
}
