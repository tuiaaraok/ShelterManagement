//
//  MedicalTableViewCell.swift
//  ShelterManagement
//
//  Created by Karen Khachatryan on 28.11.24.
//

import UIKit

class MedicalTableViewCell: UITableViewCell {
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        bgView.layer.cornerRadius = 8
        bgView.layer.borderWidth = 2
        bgView.layer.borderColor = UIColor.black.cgColor
        nameLabel.font = .regular(size: 18)
        photoImageView.layer.cornerRadius = 17
        photoImageView.layer.borderWidth = 2
        photoImageView.layer.borderColor = UIColor.black.cgColor
        photoImageView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(medical: MedicalModel) {
        nameLabel.text = "\(medical.animal?.name ?? ""), \(medical.animal?.type ?? ""), \(medical.procedureType ?? ""), \(medical.visitDate?.toString() ?? Date().toString())"
    }
}
