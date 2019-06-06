//
//  InfoReturn.swift
//  BarPass
//
//  Created by Bruno Lopes on 30/05/19.
//  Copyright © 2019 Bruno Lopes. All rights reserved.
//

import Foundation

struct InfoReturn: Codable {
    let data: UserCodable?
    let erro: Bool?
    let message, messageEx: String?
}
