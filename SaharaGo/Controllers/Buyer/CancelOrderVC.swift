//
//  CancelOrderVC.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 19/12/22.
//

import UIKit

class CancelOrderVC: UIViewController {

    @IBOutlet weak var productPriceLbl: UILabel!
    @IBOutlet weak var productSellerLbl: UILabel!
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var productImg: UIImageView!
    
    @IBOutlet weak var radioImg1: UIImageView!
    @IBOutlet weak var radioImg2: UIImageView!
    @IBOutlet weak var radioImg3: UIImageView!
    @IBOutlet weak var radioImg4: UIImageView!
    @IBOutlet weak var radioImg5: UIImageView!
    @IBOutlet weak var radioImg6: UIImageView!
    
    @IBOutlet weak var commentsTxtView: UITextView!
    
    var orderDetail = current_order_Address_main_struct()
    var reason = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.productNameLbl.text = self.orderDetail.cartMetaData[0].name
        self.productSellerLbl.text = "Seller: \(self.orderDetail.vendorName)"
        if self.orderDetail.cartMetaData[0].metaData.images.count > 0 {
            self.productImg.sd_setImage(with: URL(string: FILE_BASE_URL + "/\( self.orderDetail.cartMetaData[0].metaData.images[0])"), placeholderImage: UIImage(named: "loading"))
        }
        self.productPriceLbl.text = "₦ \(self.orderDetail.cartMetaData[0].discountedPrice)"
        self.uncheckAllRadioBtns()
    }
    
    @IBAction func ReasonActionBtn(_ sender: UIButton) {
        self.uncheckAllRadioBtns()
        if sender.tag == 101 {
            radioImg1.image = UIImage.init(named: "check-radio")
            reason = "I want to change address for the order"
        } else if sender.tag == 102 {
            radioImg2.image = UIImage.init(named: "check-radio")
            reason = "I have purchased the product elsewhere"
        } else if sender.tag == 103 {
            radioImg3.image = UIImage.init(named: "check-radio")
            reason = "I have changed my mind"
        } else if sender.tag == 104 {
            radioImg4.image = UIImage.init(named: "check-radio")
            reason = "I want to change my phone number"
        } else if sender.tag == 105 {
            radioImg5.image = UIImage.init(named: "check-radio")
            reason = "Expected delivery time is very long"
        } else {
            radioImg6.image = UIImage.init(named: "check-radio")
            reason = "Others"
        }
    }
    
    func uncheckAllRadioBtns() {
        radioImg1.image = UIImage.init(named: "uncheck-radio")
        radioImg2.image = UIImage.init(named: "uncheck-radio")
        radioImg3.image = UIImage.init(named: "uncheck-radio")
        radioImg4.image = UIImage.init(named: "uncheck-radio")
        radioImg5.image = UIImage.init(named: "uncheck-radio")
        radioImg6.image = UIImage.init(named: "uncheck-radio")
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func cancelOrderAPI() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)

            let param:[String:Any] = [ "orderId": self.orderDetail.orderId,"reason":reason, "comment": self.commentsTxtView.text!]
            ServerClass.sharedInstance.postRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.CANCEL_ORDER, successBlock: { (json) in
                print(json)
                AnalyticsUtil.instance.trackEvent(AnalyticsEvents.kCancelledOrder)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
                        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
                }
                else {
                    self.view.makeToast("\(json["message"].stringValue)")
                    //UIAlertController.showInfoAlertWithTitle("Message", message: json["message"].stringValue, buttonTitle: "Okay")
                }
            }, errorBlock: { (NSError) in
                UIAlertController.showInfoAlertWithTitle("Alert", message: kUnexpectedErrorAlertString, buttonTitle: "Okay")
                hideAllProgressOnView(appDelegateInstance.window!)
            })

        }else{
            hideAllProgressOnView(appDelegateInstance.window!)
            UIAlertController.showInfoAlertWithTitle("Alert", message: "Please Check internet connection", buttonTitle: "Okay")
        }
    }
    
    
    @IBAction func submitAction(_ sender: Any) {
        if reason == "" {
            self.view.makeToast("Please select your reason.")
            return
        } else if self.commentsTxtView.text!.isEmpty {
            self.view.makeToast("Please type your comment.")
            return
        }
        
        self.cancelOrderAPI()
    }
    
}
