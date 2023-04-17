//
//  VariantCollCell.swift
//  SaharaGo
//
//  Created by Ritesh Sinha on 05/12/22.
//

import UIKit

class VariantCollCell: UICollectionViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var cellActualPriceLbl: UILabel!
    @IBOutlet weak var cellDiscountPriceLbl: UILabel!
    @IBOutlet weak var cellDiscountLbl: UILabel!
    @IBOutlet weak var cellHeadingLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
