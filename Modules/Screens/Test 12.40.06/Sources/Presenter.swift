//
//  Presenter.swift
//  TEMPLATESFORMODULES
//
//  Created by Danil Lyskin on 08.10.2022.
//

import Foundation

internal protocol Rendering {
    func render(props: Props)
}

internal protocol Routing: AnyObject {}

internal class Presenter {
    private let render: Rendering
    weak var router: Routing?
    
    init(render: Rendering) {
        self.render = render
    }
    
    func rerender() {
        self.render.render(props: buildProps())
    }
    
    func start() {
        self.rerender()
    }
    
    private func buildProps() -> Props {
        Props()
    }
}
