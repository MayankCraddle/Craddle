//
//  commentsTableCell.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 01/11/22.
//

import UIKit

class commentsTableCell: UITableViewCell {

    @IBOutlet weak var cellSubLbl: UILabel!
    @IBOutlet weak var cellMainLbl: UILabel!
    @IBOutlet weak var cellImg: UIImageView!
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
