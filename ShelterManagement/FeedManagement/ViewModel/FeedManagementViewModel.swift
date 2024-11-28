//
//  FeedManagementViewModel.swift
//  ShelterManagement
//
//  Created by Karen Khachatryan on 28.11.24.
//

import Foundation

class FeedManagementViewModel {
    static let shared = FeedManagementViewModel()
    @Published var feeds: [FeedModel] = []
    private init() {}
    
    func fetchData() {
        CoreDataManager.shared.fetchFeeds { [weak self] feeds, _ in
            guard let self = self else { return }
            self.feeds = feeds
        }
    }
    
    func increment(id: UUID, completion: @escaping (Error?) -> Void) {
        CoreDataManager.shared.updateFeedQuantity(id: id, delta: 1, completion: completion)
    }

    func decrement(id: UUID, completion: @escaping (Error?) -> Void) {
        CoreDataManager.shared.updateFeedQuantity(id: id, delta: -1, completion: completion)
    }
    
    func clear() {
        feeds = []
    }
}
