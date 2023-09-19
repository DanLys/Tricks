//
//  TempRequest.swift
//  <MODULE_NAME>
//
//  Created by <USER_NAME> on <DATE>.
//  Copyright © <YEAR> Yandex. All rights reserved.
//

import Foundation
import NetworkLayer

@objc(YOTempRequest)
internal final class TempRequest: YODataRequest {
    internal override init() {
        // do nothing
    }

    override func parameters() -> [AnyHashable: Any]? {
        return .empty
    }

    override func targetPath() -> String {
        return ""
    }

    override func apiVersion() -> YOAPIVersion {
        return .V2
    }

    override func shouldJsonifyBody() -> Bool {
        return true
    }

    internal override func copy(with zone: NSZone? = nil) -> Any {
        let copy = Self()
        self.copyProperties(to: copy)
        return copy
    }

    internal override func isEqual(_ object: Any?) -> Bool {
        guard object is TempRequest else {
            return false
        }

        return super.isEqual(object)
    }

    internal override var hash: Int {
        var hasher = Hasher()
        hasher.combine(super.hash)
        return hasher.finalize()
    }

    internal override var description: String {
        var description = ""
        var superDescription = super.description
        if superDescription.last == ">" {
            superDescription.removeLast()
            description = "\(superDescription), \(description)>"
        } else {
            description = "<\(type(of: self)) : \(description)>"
        }
        return description
    }
}
