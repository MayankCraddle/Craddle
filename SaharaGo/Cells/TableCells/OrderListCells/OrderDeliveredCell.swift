//
//  OrderDeliveredCell.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 07/11/22.
//

import UIKit
import Cosmos

class OrderDeliveredCell: UITableViewCell {

    @IBOutlet weak var cellImg: UIImageView!
    @IBOutlet weak var cellLbl: UILabel!
    @IBOutlet weak var cellStatusLbl: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var cellDateLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
