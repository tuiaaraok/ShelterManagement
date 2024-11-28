//
//  ViewController.swift
//  Party
//
//  Created by Karen Khachatryan on 15.10.24.
//

import UIKit

extension UIViewController {
    
    func setNaviagtionBackButton() {
        let backButton = UIButton(type: .custom)
        backButton.setImage(.backIcon, for: .normal)
        backButton.addTarget(self, action: #selector(clickedBack), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    func setNaviagtionInfoButton() {
        let infoButton = UIButton(type: .custom)
        infoButton.setImage(.info, for: .normal)
        infoButton.addTarget(self, action: #selector(clickedInfo), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: infoButton)
    }
    
    @objc func clickedInfo() {
        self.pushViewController(SettingsViewController.self)
    }
    
    @objc func clickedBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleTap() {
        self.view.endEditing(true)
    }
    
    func pushViewController<T: UIViewController>(_ viewControllerType: T.Type, animated: Bool = true) {
        let nibName = String(describing: viewControllerType)
        let viewController = T(nibName: nibName, bundle: nil)
        self.navigationController?.pushViewController(viewController, animated: animated)
    }
    
    func showErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.view // Your source view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        present(alertController, animated: true, completion: nil)
    }
}

