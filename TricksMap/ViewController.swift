//
//  ViewController.swift
//  TricksMap
//
//  Created by Danil Lyskin on 07.10.2022.
//

import UIKit

class ViewController: UIViewController {

    let button = AnimationPatternButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.button.backgroundColor = true
            ? UIColor(patternImage: image)
            : .red
        // Do any additional setup after loading the view.
    }


}

