//
//  SettingsViewController.swift
//  ShelterManagement
//
//  Created by Karen Khachatryan on 28.11.24.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet var sectionButtons: [BaseButton]!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNaviagtionBackButton()
        sectionButtons.forEach({ $0.titleLabel?.font = .regular(size: 26) })
    }
    
    @IBAction func clickedContactUs(_ sender: UIButton) {
    }
    @IBAction func clickedPrivacyPolicy(_ sender: UIButton) {
    }
    @IBAction func clickedRateUs(_ sender: UIButton) {
    }
}
