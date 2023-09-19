//
//  Presenter.swift
//  <MODULE_NAME>
//
//  Created by <USER_NAME> on <DATE>.
//  Copyright © <YEAR> Yandex. All rights reserved.
//

import Foundation
import Utils

internal protocol Rendering {
    func render(props: Props)
}

internal protocol Routing: AnyObject {
    func showError(error: Router.CustomError)
}

internal final class Presenter {
    private let watcher = LifetimeWatcher<Presenter>()
    
    private let render: Rendering
    private let networkPerformer: NetworkPerformer
    
    private let buttonAvailability: Bool
    
    private weak var router: Routing?
    private weak var analytics: Analytics?
    
    init(buttonAvailability: Bool,
         render: Rendering,
         networkPerformer: NetworkPerformer,
         router: Routing,
         analytics: Analytics?) {
        self.buttonAvailability = buttonAvailability
        
        self.render = render
        self.networkPerformer = networkPerformer
        self.router = router
        self.analytics = analytics
    }
    
    internal func rerender() {
        self.render.render(props: self.buildProps())
    }
    
    internal func start() {
        self.rerender()
    }
    
    private func buildProps() -> Props {
        Props(title: "title".localizedString(),
              description: "description".localizedString(),
              buttonAvailability: self.buttonAvailability,
              buttonTap: Command(action: { [weak self] in
                  self?.networkPerformer.request { result in
                      guard let self else { return }
                        
                      result.onValue { str in
                          self.analytics?.logEvent(.event, parameters: ["ans": str])
                      }
                        
                      result.onError { _ in
                          self.router?.showError(error: .error)
                      }
                  }
              }))
    }
}
