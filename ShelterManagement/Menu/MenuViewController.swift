//
//  MenuViewController.swift
//  ShelterManagement
//
//  Created by Karen Khachatryan on 27.11.24.
//

import UIKit

class MenuViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNaviagtionInfoButton()
        self.navigationItem.hidesBackButton = true
    }
    
    @IBAction func clickedAnimalAccounting(_ sender: BaseButton) {
        self.pushViewController(AnimalAccountingViewController.self)
    }
    
    @IBAction func clickedFeedManagment(_ sender: BaseButton) {
    }
    @IBAction func clickedMedicalCare(_ sender: BaseButton) {
    }
}
