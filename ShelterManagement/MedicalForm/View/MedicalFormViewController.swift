//
//  MedicalFormViewController.swift
//  ShelterManagement
//
//  Created by Karen Khachatryan on 28.11.24.
//

import UIKit
import Combine
import DropDown

class MedicalFormViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var titleLabels: [UILabel]!
    @IBOutlet weak var typeButton: UIButton!
    @IBOutlet weak var visiteDateTextField: BaseTextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: BaseButton!
    @IBOutlet weak var typeDropDownImageView: UIImageView!
    @IBOutlet weak var animalButton: UIButton!
    @IBOutlet weak var animalDropDownImageView: UIImageView!
    private let typeDropDown = DropDown()
    private let animalsDropDown = DropDown()
    private let datePicker = UIDatePicker()
    private let viewModel = MedicalFormViewModel.shared
    private var cancellables: Set<AnyCancellable> = []
    var completion: (() -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDropDown()
        subscribe()
        viewModel.fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        typeDropDown.width = typeButton.bounds.width
        typeDropDown.bottomOffset = CGPoint(x: typeButton.frame.minX, y: typeButton.frame.maxY + 2)
        animalsDropDown.width = animalButton.bounds.width
        animalsDropDown.bottomOffset = CGPoint(x: animalButton.frame.minX, y: animalButton.frame.maxY + 2)
    }
    
    func setupUI() {
        self.navigationItem.hidesBackButton = true
        let attributes: [NSAttributedString.Key: Any] = [.strokeColor: UIColor.black, .foregroundColor: UIColor.background, .strokeWidth: -4, .font: UIFont.regular(size: 26) ?? .systemFont(ofSize: 26)
        ]
        let attributedText = NSAttributedString(string: "Schedule an inspection", attributes: attributes)
        self.titleLabel.attributedText = attributedText
        titleLabels.forEach({ $0.font = .regular(size: 18) })
        typeButton.titleLabel?.font = .regular(size: 18)
        typeButton.layer.cornerRadius = 8
        typeButton.layer.borderWidth = 2
        typeButton.layer.borderColor = UIColor.black.cgColor
        animalButton.titleLabel?.font = .regular(size: 18)
        animalButton.layer.cornerRadius = 8
        animalButton.layer.borderWidth = 2
        animalButton.layer.borderColor = UIColor.black.cgColor
        cancelButton.titleLabel?.font = .regular(size: 18)
        cancelButton.layer.cornerRadius = 8
        cancelButton.layer.borderWidth = 2
        cancelButton.layer.borderColor = UIColor.black.cgColor
        let cancelAttributes: [NSAttributedString.Key: Any] = [.strokeColor: UIColor.black, .foregroundColor: UIColor.baseOrange, .strokeWidth: -4, .font: UIFont.regular(size: 18) ?? .systemFont(ofSize: 18)
        ]
        let attributedCancel = NSAttributedString(string: "Cancel", attributes: cancelAttributes)
        cancelButton.setAttributedTitle(attributedCancel, for: .normal)
        cancelButton.addShadow()
        datePicker.locale = NSLocale.current
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        visiteDateTextField.inputView = datePicker
    }
    
    func setupDropDown() {
        let data: [String] = ProcedureType.allCases.map { $0.rawValue }
        typeDropDown.backgroundColor = .white
        typeDropDown.layer.cornerRadius = 16
        typeDropDown.dataSource = data
        typeDropDown.anchorView = view
        typeDropDown.direction = .bottom
        DropDown.appearance().textColor = .black
        DropDown.appearance().textFont = .regular(size: 18) ?? .boldSystemFont(ofSize: 18)
        typeDropDown.addShadow()
        
        typeDropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let self = self else { return }
            self.viewModel.medical.procedureType = item
            self.typeDropDownImageView.isHighlighted = false
        }
        
        typeDropDown.cancelAction = { [weak self] in
            guard let self = self else { return }
            self.typeDropDownImageView.isHighlighted = false
        }
        
        animalsDropDown.backgroundColor = .white
        animalsDropDown.layer.cornerRadius = 16
        animalsDropDown.anchorView = view
        animalsDropDown.direction = .bottom
        animalsDropDown.addShadow()
        
        animalsDropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let self = self else { return }
            self.viewModel.medical.animalID = viewModel.animals[index].id
            self.animalButton.setTitle(item, for: .normal)
            self.animalDropDownImageView.isHighlighted = false
        }
        
        animalsDropDown.cancelAction = { [weak self] in
            guard let self = self else { return }
            self.animalDropDownImageView.isHighlighted = false
        }
    }
    
    func subscribe() {
        viewModel.$medical
            .receive(on: DispatchQueue.main)
            .sink { [weak self] medical in
                guard let self = self else { return }
                self.saveButton.isEnabled = (medical.animalID != nil && medical.procedureType.checkValidation() && medical.visitDate != nil)
                self.typeButton.setTitle(medical.procedureType, for: .normal)
                self.visiteDateTextField.text = medical.visitDate?.toString()
            }
            .store(in: &cancellables)
        
        viewModel.$animals
            .receive(on: DispatchQueue.main)
            .sink { [weak self] animals in
                guard let self = self else { return }
                self.animalsDropDown.dataSource = animals.map({ $0.name ?? ""})
            }
            .store(in: &cancellables)
        
        viewModel.$animal
            .receive(on: DispatchQueue.main)
            .sink { [weak self] animal in
                guard let self = self else { return }
                self.animalButton.setTitle(animal?.name, for: .normal)
            }
            .store(in: &cancellables)
    }
    
    @objc func datePickerValueChanged() {
        viewModel.medical.visitDate = datePicker.date
    }
    
    @IBAction func handleTapGesture(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func chooseAnimal(_ sender: UIButton) {
        animalsDropDown.show()
        animalDropDownImageView.isHighlighted = !animalsDropDown.isHidden
    }
    
    @IBAction func chooseProcedureType(_ sender: UIButton) {
        typeDropDown.show()
        typeDropDownImageView.isHighlighted = !typeDropDown.isHidden
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

enum ProcedureType: String, CaseIterable {
    case inspection = "inspection"
    case grooming = "grooming"
    case deworming = "deworming"
    case vaccination = "Vaccination"
    case treatment = "treatment"
    case castration = "Castration"
    case other = "other"
}
