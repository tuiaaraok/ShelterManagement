//
//  FeedManagementViewController.swift
//  ShelterManagement
//
//  Created by Karen Khachatryan on 28.11.24.
//

import UIKit
import Combine

class FeedManagementViewController: UIViewController {

    @IBOutlet weak var feedsTableView: UITableView!
    private let viewModel = FeedManagementViewModel.shared
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        subscribe()
        viewModel.fetchData()
    }
    
    func setupUI() {
        setNaviagtionBackButton()
        feedsTableView.register(UINib(nibName: "FeedTableViewCell", bundle: nil), forCellReuseIdentifier: "FeedTableViewCell")
        feedsTableView.delegate = self
        feedsTableView.dataSource = self
    }
    
    func subscribe() {
        viewModel.$feeds
            .receive(on: DispatchQueue.main)
            .sink { [weak self] feeds in
                guard let self = self else { return }
                self.feedsTableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    @IBAction func clickedAdd(_ sender: BaseButton) {
        let feedFormVC = FeedFormViewController(nibName: "FeedFormViewController", bundle: nil)
        feedFormVC.completion = { [weak self] in
            if let self = self {
                self.viewModel.fetchData()
            }
        }
        self.navigationController?.pushViewController(feedFormVC, animated: true)
    }
}

extension FeedManagementViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.feeds.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedTableViewCell", for: indexPath) as! FeedTableViewCell
        cell.configure(feed: viewModel.feeds[indexPath.section])
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        UIView()
    }
}

extension FeedManagementViewController: FeedTableViewCellDelegate {
    func increment(id: UUID) {
        viewModel.increment(id: id) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.showErrorAlert(message: error.localizedDescription)
            } else {
                self.viewModel.fetchData()
            }
        }
    }
    
    func decrement(id: UUID) {
        viewModel.decrement(id: id) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.showErrorAlert(message: error.localizedDescription)
            } else {
                self.viewModel.fetchData()
            }
        }
    }
}
