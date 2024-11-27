//
//  AnimalTableViewCell.swift
//  ShelterManagement
//
//  Created by Karen Khachatryan on 27.11.24.
//

import UIKit

class AnimalTableViewCell: UITableViewCell {

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
    
    func configure(animal: AnimalModel) {
        nameLabel.text = "\(animal.name ?? ""), \(animal.type ?? ""), \(animal.age ?? 0) years old"
        photoImageView.image = (animal.type == AnimalType.dog.rawValue) ? .dog : .cat
    }
    
}
