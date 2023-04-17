//
//  LocalProductsCollCell.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 26/07/22.
//

import UIKit

class LocalProductsCollCell: UICollectionViewCell {

    @IBOutlet weak var cellImg: UIImageView!
    @IBOutlet weak var cellProductLbl: UILabel!
    @IBOutlet weak var cellPriceLbl: UILabel!
    @IBOutlet weak var cellAddToCartBtn: MyCustomButton!
    @IBOutlet weak var cellWishlistBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
