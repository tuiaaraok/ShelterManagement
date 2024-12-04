//
//  SettingsViewController.swift
//  ShelterManagement
//
//  Created by Karen Khachatryan on 28.11.24.
//

import UIKit
import MessageUI

class SettingsViewController: UIViewController {
    
    @IBOutlet var sectionButtons: [BaseButton]!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNaviagtionBackButton()
        sectionButtons.forEach({ $0.titleLabel?.font = .regular(size: 26) })
    }
    
    @IBAction func clickedContactUs(_ sender: UIButton) {
        if MFMailComposeViewController.canSendMail() {
            let mailComposeVC = MFMailComposeViewController()
            mailComposeVC.mailComposeDelegate = self
            mailComposeVC.setToRecipients(["surbekbabun@outlook.com"])
            present(mailComposeVC, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(
                title: "Mail Not Available",
                message: "Please configure a Mail account in your settings.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
    
    @IBAction func clickedPrivacyPolicy(_ sender: UIButton) {
        let privacyVC = PrivacyViewController()
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(privacyVC, animated: true)
        self.hidesBottomBarWhenPushed = false
    }
    
    @IBAction func clickedRateUs(_ sender: UIButton) {
        let appID = "6738995312"
        if let url = URL(string: "https://apps.apple.com/app/id\(appID)?action=write-review") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                print("Unable to open App Store URL")
            }
        }
    }
}

extension SettingsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
