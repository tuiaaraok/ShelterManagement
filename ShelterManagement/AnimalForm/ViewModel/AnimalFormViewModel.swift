//
//  AnimalFormViewModel.swift
//  ShelterManagement
//
//  Created by Karen Khachatryan on 27.11.24.
//

import Foundation

class AnimalFormViewModel {
    static let shared = AnimalFormViewModel()
    @Published var animalModel = AnimalModel(id: UUID())
    private init() {}
    
    func save(completion: @escaping (Error?) -> Void) {
        CoreDataManager.shared.saveAnimal(animalModel: animalModel, completion: completion)
    }
    
    func clear() {
        animalModel = AnimalModel(id: UUID())
    }
}
