//
//  OrderDetailPriceCell.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 07/11/22.
//

import UIKit

class OrderDetailPriceCell: UITableViewCell {

    @IBOutlet weak var cellPaymentModeLbl: UILabel!
    @IBOutlet weak var CellTotalPriceLbl: UILabel!
    @IBOutlet weak var cellDiscountLbl: UILabel!
    @IBOutlet weak var cellDeliveryLbl: UILabel!
    @IBOutlet weak var cellItemTotalLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
