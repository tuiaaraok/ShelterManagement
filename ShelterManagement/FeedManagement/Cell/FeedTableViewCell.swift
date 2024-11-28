//
//  FeedTableViewCell.swift
//  ShelterManagement
//
//  Created by Karen Khachatryan on 28.11.24.
//

import UIKit

protocol FeedTableViewCellDelegate: AnyObject {
    func increment(id: UUID)
    func decrement(id: UUID)
}

class FeedTableViewCell: UITableViewCell {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    weak delegate: FeedTableViewCellDelegate?
    private var id: UUID?
    
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
    
    override func prepareForReuse() {
        id = nil
    }
    
    func configure(feed: FeedModel) {
        id = feed.id
        nameLabel.text = "\(feed.type ?? "") \(feed.quantity?.formattedToString() ?? "")kg"
        photoImageView.image = (feed.type == FeedType.dry.rawValue) ? .dryFood : .cannedFood
    }
    
    @IBAction func clickedMinus(_ sender: UIButton) {
        if let id = id {
            delegate?.decrement(id: id)
        }
    }
    
    @IBAction func clickedPlus(_ sender: UIButton) {
        if let id = id {
            delegate?.increment(id: id)
        }
    }
}
