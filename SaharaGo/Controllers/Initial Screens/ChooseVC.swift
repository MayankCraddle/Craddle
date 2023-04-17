//
//  ChooseVC.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 12/10/22.
//

import UIKit

class ChooseVC: UIViewController {

    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var vendorImg: UIImageView!
    @IBOutlet weak var userBg: UIView!
    @IBOutlet weak var vendorBg: UIView!
    
    var userSelection = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func onClickNext(_ sender: Any) {
        if userSelection == "User" {
            let productsVC = DIConfigurator.shared.getLoginVC()
            self.navigationController?.pushViewController(productsVC, animated: true)
        } else {
            let sellerLoginVC = DIConfigurator.shared.getSellerLoginVC()
            self.navigationController?.pushViewController(sellerLoginVC, animated: true)
        }
        
    }
    
    @IBAction func onClickUserSelection(_ sender: UIButton) {
        if sender.tag == 101 {
            userSelection = "User"
            self.userBg.backgroundColor = UIColor(red: 0.0/255.0, green: 125.0/255.0, blue: 67.0/255.0, alpha: 1.0)
            self.vendorBg.backgroundColor = UIColor.white
            self.userImg.image = UIImage.init(named: "loginuser_h")
            self.vendorImg.image = UIImage.init(named: "loginvendor")
        } else {
            userSelection = "Vendor"
            self.vendorBg.backgroundColor = UIColor(red: 0.0/255.0, green: 125.0/255.0, blue: 67.0/255.0, alpha: 1.0)
            self.userBg.backgroundColor = UIColor.white
            self.userImg.image = UIImage.init(named: "loginuser")
            self.vendorImg.image = UIImage.init(named: "loginvendor_h")
        }
    }
    
    

}
