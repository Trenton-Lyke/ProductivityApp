//
//  Timer.swift
//  Productivity
//
//  Created by Trenton Lyke on 5/2/24.
//

import Foundation

struct TimerData: Codable, Hashable {
    let id: Int
    let elapsed_time: Int
    let hours: Int
    let minutes: Int
    let seconds: Int
    let date: Date
}
