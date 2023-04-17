//
//  ReviewsCell.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 23/10/22.
//

import UIKit
import Cosmos

class ReviewsCell: UITableViewCell {

    @IBOutlet weak var cellSubLbl: UILabel!
    @IBOutlet weak var cellMainLbl: UILabel!
    @IBOutlet weak var cellRating: CosmosView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
