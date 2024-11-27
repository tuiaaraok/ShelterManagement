//
//  ViewController.swift
//  ShelterManagement
//
//  Created by Karen Khachatryan on 27.11.24.
//

import UIKit

class RootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.pushViewController(MenuViewController.self)
    }
}

