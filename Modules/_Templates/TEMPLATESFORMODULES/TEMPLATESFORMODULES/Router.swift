//
//  Router.swift
//  <MODULE_NAME>
//
//  Created by <USER_NAME> on <DATE>.
//  Copyright © <YEAR> Yandex. All rights reserved.
//

import UIKit
import NetworkLayer

public protocol RouterDelegate: AnyObject {
    func didRequestShowError(with message: String)
}

public final class Router {
    internal enum CustomError: CustomStringConvertible {
        case error

        var description: String {
            switch self {
            case .error:
                return "Request.error.message".localizedString()
            }
        }
    }
    
    private let buttonAvailability: Bool
    
    private let networkPerformer: NetworkPerformer
    
    private weak var analytics: Analytics?
    public weak var delegate: RouterDelegate?
    
    private var root: (controller: UIViewController, presenter: Presenter)? // clear after close screen
    
    public convenience init(buttonAvailability: Bool,
                            httpClient: HTTPClientProtocol,
                            analytics: Analytics? = nil) {
        
        self.init(buttonAvailability: buttonAvailability,
                  networkPerformer: DefaultNetworkPerformer(httpClient: httpClient),
                  analytics: analytics)
    }
    
    public init(buttonAvailability: Bool,
                networkPerformer: NetworkPerformer,
                analytics: Analytics?) {
        self.buttonAvailability = buttonAvailability
        
        self.networkPerformer = networkPerformer
        self.analytics = analytics
    }
    
    public func open() -> UIViewController {
        let render = Render()
        let presenter = Presenter(buttonAvailability: self.buttonAvailability,
                                  render: render,
                                  networkPerformer: self.networkPerformer,
                                  router: self,
                                  analytics: self.analytics)
        
        presenter.start()
        
        self.root = (render, presenter)
        return render
    }
}

extension Router: Routing {
    func showError(error: CustomError) {
        self.delegate?.didRequestShowError(with: error.description)
    }
}
