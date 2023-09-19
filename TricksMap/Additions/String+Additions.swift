//
//  String+Additions.swift
//  FA&Investment
//
//  Created by Danil Lyskin on 27.03.2023.
//

import Foundation

public extension String {
    var localized: String {
        NSLocalizedString(self, comment: self)
    }
    
    init(array: Array<Any>, with separator: String) {
        var result = ""
        
        array.forEach {
            result += "\($0)" + separator
        }
        result.removeLast(separator.count)
        
        self = result
    }
}
