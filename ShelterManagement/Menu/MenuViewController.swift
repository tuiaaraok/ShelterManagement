//
//  MenuViewController.swift
//  ShelterManagement
//
//  Created by Karen Khachatryan on 27.11.24.
//

import UIKit

class MenuViewController: UIViewController {
    
    @IBOutlet var sectionButtons: [BaseButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNaviagtionInfoButton()
        self.navigationItem.hidesBackButton = true
        sectionButtons.forEach({ $0.titleLabel?.font = .regular(size: 26) })
    }
    
    @IBAction func clickedAnimalAccounting(_ sender: BaseButton) {
        self.pushViewController(AnimalAccountingViewController.self)
    }
    
    @IBAction func clickedFeedManagment(_ sender: BaseButton) {
        self.pushViewController(FeedManagementViewController.self)
    }
    
    @IBAction func clickedMedicalCare(_ sender: BaseButton) {
        self.pushViewController(MedicalCareViewController.self)
    }
}
