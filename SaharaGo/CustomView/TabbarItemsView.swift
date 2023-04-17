//
//  TabbarItemsView.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 14/11/22.
//

import UIKit

protocol SelectTabDelegate {
    func onSelectTab(tabIndex: Int)
}

class TabbarItemsView: UIView {
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var view5: UIView!
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label5: UILabel!
    
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var image4: UIImageView!
    @IBOutlet weak var image5: UIImageView!

    
    @IBOutlet weak var imgSelected: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var consImgSelected: NSLayoutConstraint!
    
    var instance: TabbarVC?
    var delegate: SelectTabDelegate?
    
    
    func configView() {
//        view3.alpha = 0
        imgSelected.image = UIImage(named: "family_memories_selected_tabbar")
        self.addShadowWithRadiusAndColor(radius: 5, color: UIColor.lightGray)
        instance?.selectedIndex = 2
        
        var fontSize:CGFloat = 9
        
        if UIDevice.deviceType_Below_X{
            fontSize = 9
        }else{
            fontSize = 10
        }
        
        label1.font = UIFont(name: label1.font.familyName, size: fontSize)
        label2.font = UIFont(name: label2.font.familyName, size: fontSize)
        label3.font = UIFont(name: label3.font.familyName, size: fontSize)
        label4.font = UIFont(name: label4.font.familyName, size: fontSize)
        label5.font = UIFont(name: label5.font.familyName, size: fontSize)
        
        self.allItemsVisible()
//        label3.textColor = UIColor.green
        image3.alpha = 0
        
//        view1.subviews.forEach { (vie) in
//            if let lbl = vie as? UILabel{
//                lbl.font = UIFont(name: lbl.font.familyName, size: fontSize)
//            }
//        }
//        view2.subviews.forEach { (vie) in
//            if let lbl = vie as? UILabel{
//                lbl.font = UIFont(name: lbl.font.familyName, size: fontSize)
//            }
//        }
//        view3.subviews.forEach { (vie) in
//            if let lbl = vie as? UILabel{
//                lbl.font = UIFont(name: lbl.font.familyName, size: fontSize)
//            }
//        }
//        view4.subviews.forEach { (vie) in
//            if let lbl = vie as? UILabel{
//                lbl.font = UIFont(name: lbl.font.familyName, size: fontSize)
//            }
//        }
//        view5.subviews.forEach { (vie) in
//            if let lbl = vie as? UILabel{
//                lbl.font = UIFont(name: lbl.font.familyName, size: fontSize)
//            }
//        }
        
    }
    
    @IBAction func tapButtons(_ sender: UIButton) {
//        imgSelected.image = nil
//        self.instance?.selectedIndex = sender.tag
//        self.allItemsVisible()
//
//        let widthS = (stackView.bounds.width/5)
//
//        if sender.tag == 0{
//            //image1.alpha = 0
//            label1.textColor = UIColor.green
//            //image1.image = UIImage(named: "Home_select")
//            image1.tintColor = UIColor.green
//
//
//        }else if sender.tag == 1{
//            //image2.alpha = 0
//            label2.textColor = UIColor.green
////            imgSelected.image = UIImage(named: "travel_fam_selected_tabbar")
//            image2.tintColor = UIColor.green
//
//        }else if sender.tag == 2{
//            //image3.alpha = 0
//            label3.textColor = UIColor.green
////            imgSelected.image = UIImage(named: "family_memories_selected_tabbar")
//            image3.tintColor = UIColor.green
//
//        }else if sender.tag == 3{
//            //image4.alpha = 0
//            label4.textColor = UIColor.green
////            imgSelected.image = UIImage(named: "dadi_ki_rasoi_selected_tabbar")
//            image4.tintColor = UIColor.green
//
//        }else if sender.tag == 4{
//            //image5.alpha = 0
//            label5.textColor = UIColor.green
////            imgSelected.image = UIImage(named: "dadi_ki_kahani_selected_tabbar")
//            image5.tintColor = UIColor.green
//
//        }
//        delegate?.onSelectTab(tabIndex: sender.tag)
       /*
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [.curveEaseInOut]) {
            
            var frameB = self.imgSelected.frame
            frameB.origin.x = widthS * CGFloat(sender.tag) + (widthS/4)
            self.imgSelected.frame = frameB
            
        } completion: { (status) in
            
        }
        */
    }
    
    private func allItemsVisible() {
        image1.alpha = 1
        image2.alpha = 1
        image3.alpha = 1
        image4.alpha = 1
        image5.alpha = 1
        
        label1.textColor = UIColor.gray
        label2.textColor = UIColor.gray
        label3.textColor = UIColor.gray
        label4.textColor = UIColor.gray
        label5.textColor = UIColor.gray
        
    }
    
    
}
