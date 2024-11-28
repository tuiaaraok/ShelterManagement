//
//  MedicalModel.swift
//  ShelterManagement
//
//  Created by Karen Khachatryan on 28.11.24.
//

import Foundation

struct MedicalModel {
    var id: UUID
    var animal: AnimalModel?
    var procedureType: String?
    var visitDate: Date?
}
