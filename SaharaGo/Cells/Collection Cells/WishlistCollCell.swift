//
//  WishlistCollCell.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 22/07/22.
//

import UIKit
import SkeletonView

class WishlistCollCell: UICollectionViewCell {
    
    @IBOutlet weak var cellPriceLbl: UILabel!
    @IBOutlet weak var cellLbl: UILabel!
    @IBOutlet weak var cellImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        cellBtnLbl.maskToBounds = false
//        cellBtnLbl.layer.borderWidth = 1
//        cellBtnLbl.layer.borderColor = UIColor.black.cgColor
        
        cellImg.clipsToBounds = true
        cellImg.layer.cornerRadius = 6
    }
    
}
