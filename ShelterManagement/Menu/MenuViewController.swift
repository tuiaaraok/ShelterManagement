//
//  MenuViewController.swift
//  ShelterManagement
//
//  Created by Karen Khachatryan on 27.11.24.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var accountingButton: BaseButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNaviagtionInfoButton()
        self.navigationItem.hidesBackButton = true
    }
}
