//
//  MediaCategoryCell.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 05/09/22.
//

import UIKit

class MediaCategoryCell: UICollectionViewCell {
    
    @IBOutlet weak var cellImg: UIImageView!
    @IBOutlet weak var cellViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var cellView: MyCustomView!
    @IBOutlet weak var cellLbl: UILabel!
    
    var mediaCategoriesObj = mediaCategoryListStruct()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        if mediaCategoriesObj.isSelected {
//            self.cellViewTopConstraint.constant = 0
//        } else {
//            self.cellViewTopConstraint.constant = 5
//        }
        
        if mediaCategoriesObj.isSelected {
            self.cellView.backgroundColor = UIColor(red: 251/255.0, green: 144/255.0, blue: 0/255.0, alpha: 1.0)
        } else {
            let countryColorStr = UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.COUNTRY_COLOR_CODE) as! String
            let rgba = countryColorStr.slice(from: "(", to: ")")
            let myStringArr = rgba!.components(separatedBy: ",")
            //        layer.cornerRadius = 6
            
            self.cellView.backgroundColor = UIColor(red: CGFloat((myStringArr[0] as NSString).doubleValue/255.0), green: CGFloat((myStringArr[1] as NSString).doubleValue/255.0), blue: CGFloat((myStringArr[2] as NSString).doubleValue/255.0), alpha: CGFloat((myStringArr[3] as NSString).doubleValue))
        }
        
        self.cellView.roundCorners(corners: [.topLeft, .topRight], cornerRadius: 10)
    }
    
}
