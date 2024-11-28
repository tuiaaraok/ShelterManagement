//
//  MedicalCareViewController.swift
//  ShelterManagement
//
//  Created by Karen Khachatryan on 28.11.24.
//

import UIKit
import Combine

class MedicalCareViewController: UIViewController {
    
    @IBOutlet weak var medicalsTableView: UITableView!
    private let viewModel = MedicalCareViewModel.shared
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        subscribe()
        viewModel.fetchData()
    }
    
    func setupUI() {
        setNaviagtionBackButton()
        medicalsTableView.register(UINib(nibName: "MedicalTableViewCell", bundle: nil), forCellReuseIdentifier: "MedicalTableViewCell")
        medicalsTableView.delegate = self
        medicalsTableView.dataSource = self
    }
    
    func subscribe() {
        viewModel.$medicals
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.medicalsTableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    func openMedicalForm() {
        let medicalFormVC = MedicalFormViewController(nibName: "MedicalFormViewController", bundle: nil)
        medicalFormVC.completion = { [weak self] in
            if let self = self {
                self.viewModel.fetchData()
            }
        }
        self.navigationController?.pushViewController(medicalFormVC, animated: true)
    }
    
    @IBAction func clickedAdd(_ sender: BaseButton) {
        openMedicalForm()
    }
}

extension MedicalCareViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.medicals.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MedicalTableViewCell", for: indexPath) as! MedicalTableViewCell
        cell.configure(medical: viewModel.medicals[indexPath.section])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        UIView()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "") { [weak self] (action, view, handler) in
            guard let self = self else { return }
            self.viewModel.remove(id: self.viewModel.medicals[indexPath.section].id) { [weak self] error in
                guard let self = self else { return }
                if let error = error {
                    self.showErrorAlert(message: error.localizedDescription)
                } else {
                    self.viewModel.medicals.remove(at: indexPath.section)
                    handler(true)
                }
            }
        }
        
        let editAction = UIContextualAction(style: .normal, title: "") { [weak self] (action, view, handler) in
            guard let self = self else { return }
            MedicalFormViewModel.shared.medical = self.viewModel.medicals[indexPath.section]
            self.openMedicalForm()
        }
        deleteAction.backgroundColor = .background
        deleteAction.image = UIImage.removeIcon
        editAction.backgroundColor = .background
        editAction.image = .edit
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
