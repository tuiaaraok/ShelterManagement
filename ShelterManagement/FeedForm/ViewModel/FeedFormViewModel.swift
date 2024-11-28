//
//  FeedFormViewModel.swift
//  ShelterManagement
//
//  Created by Karen Khachatryan on 28.11.24.
//

import Foundation

class FeedFormViewModel {
    static let shared = FeedFormViewModel()
    @Published var feedModel = FeedModel(id: UUID())
    private init() {}
    
    func save(completion: @escaping (Error?) -> Void) {
        CoreDataManager.shared.saveFeed(feedModel: feedModel, completion: completion)
    }
    
    func clear() {
        feedModel = FeedModel(id: UUID())
    }
}
