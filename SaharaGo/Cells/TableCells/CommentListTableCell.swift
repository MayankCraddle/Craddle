//
//  CommentListTableCell.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 22/09/22.
//

import UIKit

class CommentListTableCell: UITableViewCell {

    @IBOutlet weak var cellCommentLbl: UILabel!
    @IBOutlet weak var cellDateLbl: UILabel!
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
