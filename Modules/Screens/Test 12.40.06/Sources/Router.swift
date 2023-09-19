//
//  Router.swift
//  TEMPLATESFORMODULES
//
//  Created by Danil Lyskin on 09.10.2022.
//

import UIKit

public protocol RouterDelegate {
    
}

public final class Router {
    
    private var root: (controller: UIViewController, presenter: Presenter)? // clear after close screen
    
    public func open() -> UIViewController {
        let controller = ViewController()
        let presenter = Presenter(render: controller)
        
        presenter.router = self
        
        self.root = (controller, presenter)
        return controller
    }
}

extension Router: Routing {}
