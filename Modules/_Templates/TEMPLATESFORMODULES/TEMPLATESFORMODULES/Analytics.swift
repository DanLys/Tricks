//
//  Analytics.swift
//  <MODULE_NAME>
//
//  Created by <USER_NAME> on <DATE>.
//  Copyright © <YEAR> Yandex. All rights reserved.
//

public protocol Analytics: AnyObject {
    func logEvent(_ event: Event, parameters: [String: Any])
}

public enum Event: String {
    case event
}
