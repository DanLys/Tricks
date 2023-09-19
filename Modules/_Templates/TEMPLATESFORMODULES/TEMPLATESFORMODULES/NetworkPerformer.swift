//
//  NetworkPerformer.swift
//  <MODULE_NAME>
//
//  Created by <USER_NAME> on <DATE>.
//  Copyright © <YEAR> Yandex. All rights reserved.
//

import Foundation
import NetworkLayer
import Utils
import Combine

public protocol NetworkPerformer {
    func request(completion: @escaping (Result<String>) -> Void)
}

internal final class DefaultNetworkPerformer: NetworkPerformer {
    
    private var cancellables: Set<AnyCancellable> = .empty
    
    let httpClient: HTTPClientProtocol
    
    internal init(httpClient: HTTPClientProtocol) {
        self.httpClient = httpClient
    }
    
    func request(completion: @escaping (Result<String>) -> Void) {
        self.httpClient.runRequest(TempRequest(), responseType: TempResponse.self)
            .receiveOnMainQueue()
            .sink(receiveResult: completion)
            .store(in: &self.cancellables)
    }
}
