//
//  UIView+Additions.swift
//  FA&Investment
//
//  Created by Danil Lyskin on 06.04.2023.
//

import UIKit
import Foundation

internal extension UIView {
    
    @discardableResult
    func forAutolayot() -> Self {
        self.translatesAutoresizingMaskIntoConstraints = false
        return self
    }
    
    func constrainAround(in view: UIView, constant: CGFloat) -> [NSLayoutConstraint] {
        var result = [NSLayoutConstraint]()
        
        result += [self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: constant)]
        result += [self.topAnchor.constraint(equalTo: view.topAnchor, constant: constant)]
        result += [self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -constant)]
        result += [self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -constant)]
        
        return result
    }
}
