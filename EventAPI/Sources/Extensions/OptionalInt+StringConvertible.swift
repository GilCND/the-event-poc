//
//  File.swift
//  
//
//  Created by Felipe Gil on 2023-10-20.
//

import Foundation

extension Optional where Wrapped == Int {
    var asStringOrEmpty: String {
        switch self {
        case .some(let value):
            return "\(value)/"
        case .none:
            return ""
        }
    }
}
