//
//  User.swift
//  shaka
//
//  Created by 박원빈 on 2022/07/27.
//

import Foundation

struct User: Codable {
    let uuid: String
    let firebaseUid: String
    let nickname: String?
    let email: String?
}
