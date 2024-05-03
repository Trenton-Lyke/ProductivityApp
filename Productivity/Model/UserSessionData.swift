//
//  UserSessionData.swift
//  Productivity
//
//  Created by Trenton Lyke on 5/2/24.
//

import Foundation

struct UserSessionData: Codable, Hashable {
    let session: SessionData
    let user: User
    let position: Int
}
