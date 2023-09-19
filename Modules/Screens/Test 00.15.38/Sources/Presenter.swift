//
//  Presenter.swift
//  TEMPLATESFORMODULES
//
//  Created by Danil Lyskin on 08.10.2022.
//

import Foundation

internal protocol PresentingProtocol {
    func render(props: Props)
}

internal class Presenter {
    let rendering: PresentingProtocol
    
    init(rendering: PresentingProtocol) {
        self.rendering = rendering
    }
    
    func rerender() {
        self.render()
    }
    
    func render() {
        self.rendering.render(props: self.buildProps())
    }
    
    func buildProps() -> Props {
        Props()
    }
}
