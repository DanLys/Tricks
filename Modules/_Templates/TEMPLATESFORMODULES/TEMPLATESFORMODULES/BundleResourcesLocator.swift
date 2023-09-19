//
//  BundleResourcesLocator.swift
//  <MODULE_NAME>
//
//  Created by <USER_NAME> on <DATE>.
//  Copyright © <YEAR> Yandex. All rights reserved.
//

import Foundation
import Utils

internal extension Bundle {
    static let module = Bundle.resourceBundle(named: "<MODULE_NAME>Resources", caller: Bundle(for: BundleLocator.self))
}

private class BundleLocator {}
