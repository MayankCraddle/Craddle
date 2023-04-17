//
//  AddressCell.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 05/09/22.
//

import UIKit

class AddressCell: UITableViewCell {

    @IBOutlet weak var defaultImg: UIImageView!
    @IBOutlet weak var cellSubTitleLbl: UILabel!
    @IBOutlet weak var cellTitleLbl: UILabel!
    @IBOutlet weak var addressTypeLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
