//
//  UserSessionData.swift
//  Productivity
//
//  Created by Trenton Lyke on 5/2/24.
//

import Foundation

struct SessionData: Codable, Hashable {
    let sessionToken: String
    let sessionExpiration: Date
    let updateToken: String
}
