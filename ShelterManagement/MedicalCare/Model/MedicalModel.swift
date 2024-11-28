//
//  MedicalModel.swift
//  ShelterManagement
//
//  Created by Karen Khachatryan on 28.11.24.
//

import Foundation

struct MedicalModel {
    var id: UUID
    var animalID: UUID?
    var procedureType: String?
    var visitDate: Date?
    var animal: AnimalModel?
}
