//
//  MedicalFormViewModel.swift
//  ShelterManagement
//
//  Created by Karen Khachatryan on 28.11.24.
//

import Foundation

class MedicalFormViewModel {
    static let shared = MedicalFormViewModel()
    @Published var medical = MedicalModel(id: UUID())
    @Published var animal: AnimalModel?
    @Published var animals: [AnimalModel] = []
    private init() {}
    
    func save(completion: @escaping (Error?) -> Void) {
        CoreDataManager.shared.saveMedical(medicalModel: medical, completion: completion)
    }
    
    func fetchData() {
        CoreDataManager.shared.fetchAnimals { [weak self] animals, _ in
            guard let self = self else { return }
            self.animals = animals
        }
    }
    
    func fetchAnimal(by id: UUID) {
        CoreDataManager.shared.fetchAnimal(by: id) { [weak self] animal, _ in
            guard let self = self else { return }
            self.animal = animal
        }
    }
    
    func clear() {
        medical = MedicalModel(id: UUID())
        animal = nil
    }
}
