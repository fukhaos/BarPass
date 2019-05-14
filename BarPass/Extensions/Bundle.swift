//
//  Bundle.swift
//  guroo
//
//  Created by Bruno Lopes de Mello on 09/05/19.
//  Copyright © 2019 Bruno Lopes de Mello. All rights reserved.
//

import Foundation

extension Bundle {
    
    static func loadView<T>(fromNib name: String, withType type: T.Type) -> T {
        if let view = Bundle.main.loadNibNamed(name, owner: nil, options: nil)?.first as? T {
            return view
        }
        
        fatalError("Could not load view with type " + String(describing: type))
    }
}
