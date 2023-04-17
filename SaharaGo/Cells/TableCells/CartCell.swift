//
//  CartCell.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 03/08/22.
//

import UIKit

typealias changeProductCountClosure = ((_ index: Int?, _ changeBy: Int?) -> Void)
typealias moveToWishlistClosure = ((_ index: Int?) -> Void)

class CartCell: UITableViewCell {

    @IBOutlet weak var cellRemoveBtn: UIButton!
    @IBOutlet weak var wishlistBtn: UIButton!
    @IBOutlet weak var cellProductCountLbl: UILabel!
    @IBOutlet weak var increaseCountBtn: UIButton!
    @IBOutlet weak var decreaseCountBtn: UIButton!
    @IBOutlet weak var cellPriceLbl: UILabel!
    @IBOutlet weak var cellVendorLbl: UILabel!
    @IBOutlet weak var cellProductLbl: UILabel!
    @IBOutlet weak var cellImg: UIImageView!
    @IBOutlet weak var cellPeicesLbl: UILabel!
    
    var onClickIncreaseCountClosure: changeProductCountClosure?
    var onClickMoveToWishlistClosure: moveToWishlistClosure?
    var onClickRemoveFromCartClosure: moveToWishlistClosure?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    @IBAction func increaseCountAction(_ sender: UIButton) {
        self.onClickIncreaseCountClosure?(increaseCountBtn.tag, 1)
    }
    
    @IBAction func decreaseCountAction(_ sender: UIButton) {
        self.onClickIncreaseCountClosure?(decreaseCountBtn.tag, -1)
    }
    
    @IBAction func wishlistAction(_ sender: UIButton) {
        self.onClickMoveToWishlistClosure?(wishlistBtn.tag)
    }
    
    @IBAction func removeItemAction(_ sender: UIButton) {
        self.onClickRemoveFromCartClosure?(cellRemoveBtn.tag)
    }
    
    
    public func setCartData(_ info: cartProductListStruct) {
        
        self.cellProductLbl.text = info.name
        self.cellPriceLbl.text = "₦\(info.discountedPrice)"
        self.cellVendorLbl.text = info.shortDescription
        self.cellPeicesLbl.text = "No. of Pieces: \(info.noOfPieces)"
        let imgArr = info.imagesArr
        if imgArr!.count > 0 {
            self.cellImg.sd_setImage(with: URL(string: FILE_BASE_URL + "/\(imgArr![0])"), placeholderImage: UIImage(named: "loading"))
        }
        
        self.cellProductCountLbl.text = info.quantity
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
