//
//  ViewController.swift
//  autoBuild
//
//  Created by IrvingHuang on 2019/8/26.
//  Copyright © 2019 Irving Huang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tryGoogle()
    }


    func tryGoogle() {
        _ = WebAuthenticationSession.init(url: URL(string: "https://www.google.com")!, callbackURLScheme: nil) { (url, error ) in
            print(url as Any)
            print(error as Any)
        }
    }
    
}

