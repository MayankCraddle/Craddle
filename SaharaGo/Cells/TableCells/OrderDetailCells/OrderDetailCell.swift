//
//  OrderDetailCell.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 07/11/22.
//

import UIKit
import Cosmos

class OrderDetailCell: UITableViewCell {

    @IBOutlet weak var orderIdLbl: UILabel!
    @IBOutlet weak var cellPriceLbl: UILabel!
    @IBOutlet weak var cellSellerLbl: UILabel!
    @IBOutlet weak var cellQuantityLbl: UILabel!
    @IBOutlet weak var cellProductLbl: UILabel!
    @IBOutlet weak var cellImg: UIImageView!
    
    
    @IBOutlet weak var orderConfirmedBackView: UIView!
    @IBOutlet weak var orderConfirmedDotLbl: UILabel!
    @IBOutlet weak var orderConfirmedTrackLbl: UILabel!
    @IBOutlet weak var orderConfirmedStatusLbl: UILabel!
    @IBOutlet weak var orderConfirmedStatusDesLbl: UILabel!
    
    @IBOutlet weak var orderPackedBackView: UIView!
    @IBOutlet weak var orderPackedDotLbl: UILabel!
    @IBOutlet weak var orderPackedTrackLbl: UILabel!
    @IBOutlet weak var orderPackedStatusLbl: UILabel!
    @IBOutlet weak var orderPackedStatusDesLbl: UILabel!
    
    @IBOutlet weak var orderShippedBackView: UIView!
    @IBOutlet weak var orderShippedDotLbl: UILabel!
    @IBOutlet weak var orderShippedTrackLbl: UILabel!
    @IBOutlet weak var orderShippedStatusLbl: UILabel!
    @IBOutlet weak var orderShippedStatusDesLbl: UILabel!
    
    @IBOutlet weak var orderDeliveredBackView: UIView!
    @IBOutlet weak var orderDeliveredDotLbl: UILabel!
    @IBOutlet weak var orderDeliveredTrackLbl: UILabel!
    @IBOutlet weak var orderDeliveredStatusLbl: UILabel!
    @IBOutlet weak var orderDeliveredStatusDesLbl: UILabel!
    
    @IBOutlet weak var ratingStackView: UIView!
    @IBOutlet weak var writeReviewStackView: UIView!
    @IBOutlet weak var writeReviewBtn: UIButton!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var cancelOrderStackView: UIView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
