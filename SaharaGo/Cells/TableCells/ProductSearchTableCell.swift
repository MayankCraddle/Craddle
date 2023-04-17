//
//  ProductSearchTableCell.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 27/09/22.
//

import UIKit
import Cosmos

class ProductSearchTableCell: UITableViewCell {

    @IBOutlet weak var cellWishlistBtn: UIButton!
    @IBOutlet weak var cellActualPriceLbl: UILabel!
    @IBOutlet weak var cellDiscountPriceLbl: UILabel!
    @IBOutlet weak var cellDescLbl: UILabel!
    @IBOutlet weak var cellRatingView: CosmosView!
    @IBOutlet weak var cellProductLbl: UILabel!
    @IBOutlet weak var cellImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
