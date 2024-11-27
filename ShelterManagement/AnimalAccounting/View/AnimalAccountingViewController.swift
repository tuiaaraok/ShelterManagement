//
//  AnimalAccountingViewController.swift
//  ShelterManagement
//
//  Created by Karen Khachatryan on 27.11.24.
//

import UIKit
import Combine

class AnimalAccountingViewController: UIViewController {

    @IBOutlet weak var animalsTableView: UITableView!
    private let viewModel = AnimalsViewModel.shared
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        subscribe()
        viewModel.fetchData()
    }
    
    func setupUI() {
        setNaviagtionBackButton()
        animalsTableView.register(UINib(nibName: "AnimalTableViewCell", bundle: nil), forCellReuseIdentifier: "AnimalTableViewCell")
        animalsTableView.delegate = self
        animalsTableView.dataSource = self
    }
    
    func subscribe() {
        viewModel.$animals
            .receive(on: DispatchQueue.main)
            .sink { [weak self] animals in
                guard let self = self else { return }
                self.animalsTableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    func openAnimalFormVC() {
        let animalFormVC = AnimalFormViewController(nibName: "AnimalFormViewController", bundle: nil)
        animalFormVC.completion = { [weak self] in
            if let self = self {
                self.viewModel.fetchData()
            }
        }
        self.navigationController?.pushViewController(animalFormVC, animated: true)
    }
    
    @IBAction func clickedAdd(_ sender: BaseButton) {
        openAnimalFormVC()
    }
}

extension AnimalAccountingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.animals.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnimalTableViewCell", for: indexPath) as! AnimalTableViewCell
        cell.configure(animal: viewModel.animals[indexPath.section])
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
            self.viewModel.remove(id: self.viewModel.animals[indexPath.section].id) { [weak self] error in
                guard let self = self else { return }
                if let error = error {
                    self.showErrorAlert(message: error.localizedDescription)
                } else {
                    self.viewModel.animals.remove(at: indexPath.section)
                    handler(true)
                }
            }
        }
        
        let editAction = UIContextualAction(style: .normal, title: "") { [weak self] (action, view, handler) in
            guard let self = self else { return }
            AnimalFormViewModel.shared.animalModel = self.viewModel.animals[indexPath.section]
            self.openAnimalFormVC()
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
