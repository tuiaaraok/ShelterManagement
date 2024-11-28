//
//  FeedFormViewController.swift
//  ShelterManagement
//
//  Created by Karen Khachatryan on 28.11.24.
//

import UIKit
import Combine
import DropDown

class FeedFormViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var titleLabels: [UILabel]!
    @IBOutlet weak var typeButton: UIButton!
    @IBOutlet weak var quantityTextField: NumberTextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: BaseButton!
    @IBOutlet weak var dropDownImageView: UIImageView!
    private let dropDown = DropDown()
    private let viewModel = FeedFormViewModel.shared
    private var cancellables: Set<AnyCancellable> = []
    var completion: (() -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDropDown()
        subscribe()
    }
    
    override func viewDidLayoutSubviews() {
        dropDown.width = typeButton.bounds.width
        dropDown.bottomOffset = CGPoint(x: typeButton.frame.minX, y: typeButton.frame.maxY + 2)
    }
    
    func setupUI() {
        self.navigationItem.hidesBackButton = true
        let attributes: [NSAttributedString.Key: Any] = [.strokeColor: UIColor.black, .foregroundColor: UIColor.background, .strokeWidth: -4, .font: UIFont.regular(size: 26) ?? .systemFont(ofSize: 26)
        ]
        let attributedText = NSAttributedString(string: "Add a delivery", attributes: attributes)
        self.titleLabel.attributedText = attributedText
        titleLabels.forEach({ $0.font = .regular(size: 18) })
        typeButton.titleLabel?.font = .regular(size: 18)
        typeButton.layer.cornerRadius = 8
        typeButton.layer.borderWidth = 2
        typeButton.layer.borderColor = UIColor.black.cgColor
        cancelButton.titleLabel?.font = .regular(size: 18)
        cancelButton.layer.cornerRadius = 8
        cancelButton.layer.borderWidth = 2
        cancelButton.layer.borderColor = UIColor.black.cgColor
        let cancelAttributes: [NSAttributedString.Key: Any] = [.strokeColor: UIColor.black, .foregroundColor: UIColor.baseOrange, .strokeWidth: -4, .font: UIFont.regular(size: 18) ?? .systemFont(ofSize: 18)
        ]
        let attributedCancel = NSAttributedString(string: "Cancel", attributes: cancelAttributes)
        cancelButton.setAttributedTitle(attributedCancel, for: .normal)
        cancelButton.addShadow()
        quantityTextField.baseDelegate = self
    }
    
    func setupDropDown() {
        let data: [String] = FeedType.allCases.map { $0.rawValue }
        dropDown.backgroundColor = .white
        dropDown.layer.cornerRadius = 16
        dropDown.dataSource = data
        dropDown.anchorView = view
        dropDown.direction = .bottom
        DropDown.appearance().textColor = .black
        DropDown.appearance().textFont = .regular(size: 18) ?? .boldSystemFont(ofSize: 18)
        dropDown.addShadow()
        
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let self = self else { return }
            self.viewModel.feedModel.type = item
            self.dropDownImageView.isHighlighted = false
        }
        
        dropDown.cancelAction = { [weak self] in
            guard let self = self else { return }
            self.dropDownImageView.isHighlighted = false
        }
    }
    
    func subscribe() {
        viewModel.$feedModel
            .receive(on: DispatchQueue.main)
            .sink { [weak self] feed in
                guard let self = self else { return }
                self.saveButton.isEnabled = (feed.quantity != nil && feed.type.checkValidation())
                self.typeButton.setTitle(feed.type, for: .normal)
            }
            .store(in: &cancellables)
    }
    
    @IBAction func handleTapGesture(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func chooseAnimalType(_ sender: UIButton) {
        dropDown.show()
        dropDownImageView.isHighlighted = !dropDown.isHidden
    }
    
    @IBAction func clickedCancel(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickedSave(_ sender: BaseButton) {
        viewModel.save { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.showErrorAlert(message: error.localizedDescription)
            } else {
                self.completion?()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    deinit {
        viewModel.clear()
    }
}

extension FeedFormViewController: NumberTextFielddDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        viewModel.feedModel.quantity = quantityTextField.formatNumber()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
         
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
         
    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let allowedCharacters = CharacterSet.decimalDigits
//        let characterSet = CharacterSet(charactersIn: string)
//        return allowedCharacters.isSuperset(of: characterSet)
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
}

enum FeedType: String, CaseIterable {
    case dry = "dry food"
    case canned = "canned food"
}
