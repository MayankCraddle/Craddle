//
//  CatProductsCollCell.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 30/08/22.
//

import UIKit

class CatProductsCollCell: UICollectionViewCell {
    
    @IBOutlet weak var cellQuantityLbl: UILabel!
    @IBOutlet weak var cellImg: UIImageView!
    @IBOutlet weak var cellPriceLbl: UILabel!
    @IBOutlet weak var cellLbl: UILabel!
    @IBOutlet weak var decreaseCountBtn: UIButton!
    @IBOutlet weak var increaseCountBtn: UIButton!
    
    @IBOutlet weak var quantityView: UIView!
    @IBOutlet weak var cartView: UIView!
    
    var onClickIncreaseCountClosure: changeProductCountClosure?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    @IBAction func decreamentAction(_ sender: UIButton) {
//        self.onClickIncreaseCountClosure?(decreaseCountBtn.tag, -1)
    }
    
    @IBAction func increamentAction(_ sender: UIButton) {
//        self.onClickIncreaseCountClosure?(increaseCountBtn.tag, 1)
    }
    
    
}
