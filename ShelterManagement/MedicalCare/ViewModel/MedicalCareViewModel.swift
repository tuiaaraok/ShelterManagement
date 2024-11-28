//
//  MedicalCareViewModel.swift
//  ShelterManagement
//
//  Created by Karen Khachatryan on 28.11.24.
//

import Foundation

class MedicalCareViewModel {
    static let shared = MedicalCareViewModel()
    @Published var medicals: [MedicalModel] = []
    private init() {}
    
    func fetchData() {
        CoreDataManager.shared.fetchMedicals { [weak self] medicals, _ in
            guard let self = self else { return }
            self.medicals = medicals
        }
    }
    
    func remove(id: UUID, completion: @escaping (Error?) -> Void) {
        CoreDataManager.shared.removeMedical(by: id, completion: completion)
    }
}
