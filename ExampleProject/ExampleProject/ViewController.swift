//
//  ViewController.swift
//  ExampleProject
//
//  Created by Piotr Gawlowski on 01/06/2017.
//  Copyright © 2017 Piotr Gawlowski. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func test(_ sender: UIButton) {
        print(sender.titleLabel?.text)
    }

}

