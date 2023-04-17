//
//  ContentCollCell.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 17/08/22.
//

import UIKit

class ContentCollCell: UICollectionViewCell {
    
    @IBOutlet weak var labelView: UIView!
    @IBOutlet weak var cellLbl: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.labelView.bounds
        gradientLayer.masksToBounds = true
        gradientLayer.colors = [UIColor.black.withAlphaComponent(1.0).cgColor, UIColor.black.withAlphaComponent(0.0).cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        self.labelView.layer.addSublayer(gradientLayer)
        
    }
    
}
