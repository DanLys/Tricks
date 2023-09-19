//
//  PresenterTests.swift
//  <MODULE_NAME>
//
//  Created by <USER_NAME> on <DATE>.
//  Copyright © <YEAR> Yandex. All rights reserved.
//

import Foundation
import XCTest
import TestUtils
import NetworkLayer
@testable import <MODULE_NAME>

internal final class PresenterTests: XCTestCase {
    private var presenter: Presenter!
    private var router: MockRouter!
    private var render: MockRender!
    private var networkPerformer: MockNetworkPerformer!
    private var analytics: MockAnalytics!
    
    internal override func setUp() {
        super.setUp()
        
        self.router = MockRouter()
        self.networkPerformer = MockNetworkPerformer()
        self.render = MockRender()
        self.analytics = MockAnalytics()
        
        self.presenter = Presenter(buttonAvailability: true,
                                   render: self.render,
                                   networkPerformer: self.networkPerformer,
                                   router: self.router,
                                   analytics: self.analytics)
    }
    
    func testButtonTapWithError() {
        self.presenter?.start()
        XCTAssertNotNil(self.render.props)
        
        self.render.props?.buttonTap()
        XCTAssertEqual(self.router.error, .error)
    }
    
    func testDealocating() {
        self.presenter?.start()
        
        self.validateDeallocation(keyPath: \.presenter)
        self.validateDeallocation(keyPath: \.networkPerformer)
        self.validateDeallocation(keyPath: \.render)
        self.validateDeallocation(keyPath: \.router)
        self.validateDeallocation(keyPath: \.analytics)
    }
}

private final class MockRouter: Routing {
    var error: Router.CustomError?
    
    func showError(error: Router.CustomError) {
        self.error = .error
    }
}
    
private final class MockNetworkPerformer: NetworkPerformer {
    enum MockNetworkError: Error {
        case error
    }
    
    func request(completion: @escaping (Result<String>) -> Void) {
        completion(.failure(MockNetworkError.error))
    }
}

private final class MockRender: Rendering {
    var props: Props?
    
    func render(props: Props) {
        self.props = props
    }
}

private final class MockAnalytics: Analytics {
    func logEvent(_ event: Event, parameters: [String: Any]) {
        print(event, " ", parameters)
    }
}
