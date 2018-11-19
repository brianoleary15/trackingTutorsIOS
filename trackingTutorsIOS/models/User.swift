//
//  User.swift
//  trackingTutorsIOS
//
//  Created by Brian Thomas O'Leary on 11/18/18.
//  Copyright © 2018 Brian Thomas O'Leary. All rights reserved.
//

import UIKit

struct User: Codable {
    var id: String
    var email: String
    var firstName: String
    var lastName: String
    var isBeingTutored: String
    var team: String
}
