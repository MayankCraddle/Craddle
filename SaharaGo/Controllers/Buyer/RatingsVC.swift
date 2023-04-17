//
//  RatingsVC.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 16/11/22.
//

import UIKit
import Cosmos

class RatingsVC: UIViewController {

    @IBOutlet weak var titleTxt: UITextField!
    @IBOutlet var ratingView: CosmosView!
    @IBOutlet var reviewTxtview: UITextView!
    
    var rating = 0.00
    var orderInfo = current_order_Address_main_struct()
    var toId: String = ""
    var orderId: String = ""
    var isFrom: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ratingView.settings.fillMode = .precise
        ratingView.rating = self.rating
        
        ratingView.didFinishTouchingCosmos = { rating in
            
            self.rating = rating
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true

    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func notNowAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func subitAction(_ sender: Any) {

        if self.rating == 0.00 {
            self.view.makeToast("Please give Star rating as per your experience.")
            return
        } else if titleTxt.text! == "" {
            self.view.makeToast("Please enter Subject.")
            return
        }
        
        self.giveRatingApiCall()
    }
    

    func giveRatingApiCall() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:Any] = [ "fromId": UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.USER_ID) as! String,"toId":self.toId,"rating":self.rating, "review": self.reviewTxtview.text!, "title": titleTxt.text!, "orderId": self.orderId]
            print(param)
            ServerClass.sharedInstance.postRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.USER_GIVE_RATING, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    //save data in userdefault..
                    self.view.makeToast(json["message"].stringValue)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        if self.isFrom == "Orders" {
                            let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
                                self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
                        } else {
                            self.navigationController?.popViewController(animated: true)
                        }
                        
                    }
                    
                }
                else {
                    self.view.makeToast("\(json["message"].stringValue)")
                    // UIAlertController.showInfoAlertWithTitle("Message", message: json["message"].stringValue, buttonTitle: "Okay")
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


}
