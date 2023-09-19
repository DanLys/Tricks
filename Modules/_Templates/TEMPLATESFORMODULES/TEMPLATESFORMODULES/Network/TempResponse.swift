//
//  TempResponse.swift
//  <MODULE_NAME>
//
//  Created by <USER_NAME> on <DATE>.
//  Copyright © <YEAR> Yandex. All rights reserved.
//

import Foundation
import NetworkLayer

@objc(YOTempResponse)
internal final class TempResponse: NSObject, YODataResponse, YOResponseWithResult {
    internal let responseResult: String

    init?(data: Data) {
        do {
            let response = try JSONDecoder().decode(ResponseDTO.self, from: data)
            
            self.responseResult = response.result
        } catch {
            return nil
        }
    }
}

private struct ResponseDTO: Codable {
    enum CodingKeys: String, CodingKey {
        case result
    }

    fileprivate let result: String
}
