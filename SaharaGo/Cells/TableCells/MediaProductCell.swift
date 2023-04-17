//
//  MediaProductCell.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 01/03/23.
//

import UIKit
import Cosmos

class MediaProductCell: UITableViewCell {
    
    @IBOutlet weak var cellBuyBtn: UIButton!
    @IBOutlet weak var cellImg: UIImageView!
    @IBOutlet weak var cellPriceLbl: UILabel!
    @IBOutlet weak var cellRatingView: CosmosView!
    @IBOutlet weak var cellNameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
