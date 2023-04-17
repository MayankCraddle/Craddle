//
//  VendorSearchTableCell.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 27/09/22.
//

import UIKit
import Cosmos

class VendorSearchTableCell: UITableViewCell {

    @IBOutlet weak var cellRating: CosmosView!
    @IBOutlet weak var cellWishlistBtn: UIButton!
    @IBOutlet weak var cellAddressLbl: UILabel!
    @IBOutlet weak var cellVendorLbl: UILabel!
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
