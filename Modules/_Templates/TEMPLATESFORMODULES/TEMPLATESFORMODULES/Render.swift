//
//  Render.swift
//  <MODULE_NAME>
//
//  Created by <USER_NAME> on <DATE>.
//  Copyright © <YEAR> Yandex. All rights reserved.
//

import UIKit
import Utils
import Styler
import UtilsUI

internal final class Render: UIViewController {
    private enum Constants {
        static let spacing: CGFloat = 10
    }
    
    private var props: Props?
    
    private let label = UILabel.createEmptyLabel().forAutolayout().applying {
        $0.textColor = .black
        $0.textAlignment = .left
        $0.numberOfLines = 0
    }
    
    private let button = UIButton.createButton().forAutolayout().applying {
        $0.setTitle("Tap".localizedString(), for: .normal)
    }
    
    internal override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
    }
    
    internal override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if previousTraitCollection?.preferredContentSizeCategory != self.traitCollection.preferredContentSizeCategory {
            // Изменение соотношения сторон, нужно перелэяутить
        }
        
        if self.traitCollection.preferredContentSizeCategory.isAccessibilityCategory {
            // Нужно оптимизировать интерфейс для людей с ограничениями
        }
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        
        [self.label, self.button].forEach { self.view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            self.label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.label.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 200),
            
            self.button.centerXAnchor.constraint(equalTo: self.label.centerXAnchor),
            self.button.topAnchor.constraint(equalTo: self.label.bottomAnchor, constant: Constants.spacing)
        ])
        
        self.button.addTarget(self, action: #selector(tap), for: .touchUpInside)
    }
    
    @objc private func tap() {
        self.props?.buttonTap()
    }
}

extension Render: Rendering {
    func render(props: Props) {
        let oldProps = self.props
        
        self.props = props
        
        self.button.isEnabled = props.buttonAvailability
        
        self.accessibilityLabel = props.title
        self.accessibilityValue = props.description
        
        self.label.text = props.title
        
        if let oldProps,
           oldProps.title != props.title
            || oldProps.description != props.description {
            UIAccessibility.post(notification: .layoutChanged, argument: self)
        }
    }
}

private extension UILabel {
    static func createEmptyLabel() -> UILabel {
        let label = UILabel()
        label.adjustsFontForContentSizeCategory = true
        label.minimumScaleFactor = 0.5
        return label
    }
}

private extension UIButton {
    static func createButton() -> UIButton {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .medium14px
        button.backgroundColor = .systemGray4
        button.layer.cornerRadius = 8
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
}
