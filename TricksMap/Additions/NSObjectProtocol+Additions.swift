//
//  NSObjectProtocol+Additions.swift
//  FA&Investment
//
//  Created by Danil Lyskin on 27.03.2023.
//

import Foundation

public extension NSObjectProtocol {
    @inlinable
    @inline(__always)
    @discardableResult
    func applying(_ function: (Self) -> Void) -> Self {
        function(self)
        return self
    }
}
