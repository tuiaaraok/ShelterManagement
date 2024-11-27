//
//  AnimalsViewModel.swift
//  ShelterManagement
//
//  Created by Karen Khachatryan on 28.11.24.
//

import Foundation

class AnimalsViewModel {
    static let shared = AnimalsViewModel()
    @Published var animals: [AnimalModel] = []
    private init() {}
    
    func fetchData() {
        CoreDataManager.shared.fetchAnimals { [weak self] animals, _ in
            guard let self = self else { return }
            self.animals = animals
        }
    }
    
    func remove(id: UUID, completion: @escaping (Error?) -> Void) {
        CoreDataManager.shared.removeAnimal(by: id, completion: completion)
    }
}
