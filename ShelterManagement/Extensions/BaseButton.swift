//
//  BaseButton.swift
//  Party
//
//  Created by Karen Khachatryan on 15.10.24.
//

import UIKit

class BaseButton: UIButton {
    
    override var isEnabled: Bool {
        didSet {
            self.backgroundColor = isEnabled ? self.backgroundColor?.withAlphaComponent(1) : self.backgroundColor?.withAlphaComponent(0.5)
        }
    }
    
    override var isSelected: Bool {
        didSet {
//            self.backgroundColor = isSelected ? .baseGreen : .grayBlue
        }
    }
    
    func commonInit() {
        self.titleLabel?.font = .regular(size: 26)
        self.setTitleColor(.background, for: .normal)
        self.backgroundColor = .baseOrange
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = 8
        self.addShadow()
        let attributes: [NSAttributedString.Key: Any] = [
            .strokeColor: UIColor.black,
            .foregroundColor: UIColor.background,
            .strokeWidth: -4
        ]
        let attributedText = NSAttributedString(string: self.titleLabel?.text ?? "", attributes: attributes)
        self.setAttributedTitle(attributedText, for: .normal)

    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
}
