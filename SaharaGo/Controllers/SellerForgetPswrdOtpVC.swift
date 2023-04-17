//
//  SellerForgetPswrdOtpVC.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 13/10/22.
//

import UIKit

class SellerForgetPswrdOtpVC: UIViewController {

    @IBOutlet weak var confirmPasswordTxt: UITextField!
    @IBOutlet weak var otptxt: UITextField!
    @IBOutlet weak var newPasswordTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitAction(_ sender: Any) {
        
        if self.otptxt.text!.isEmpty {
            self.view.makeToast("Please Enter OTP.")
            return
        } else if self.newPasswordTxt.text!.isEmpty {
            self.view.makeToast("Please Enter New Password.")
            return
        } else if self.confirmPasswordTxt.text!.isEmpty {
            self.view.makeToast("Please Enter Confirm Password.")
            return
        }  else if !isPasswordValid(self.newPasswordTxt.text!) {
//            showCustomMessageAlertWithTitle(message: "Password must be atleast of 8 characters, 1 alphabet and 1 special character.", title: "Weak Password !")
            showCustomMessageAlertWithTitle(message: "Password must be atleast of 8 characters, 1 Uppercase alphabet , 1 Lowercase Alphabet and 1 special character.", title: "Weak Password !")
            self.newPasswordTxt.tintColor = .red
            self.confirmPasswordTxt.text = ""
            self.newPasswordTxt.becomeFirstResponder()
            return
        } else if self.confirmPasswordTxt.text! != self.newPasswordTxt.text! {
            self.view.makeToast("Passwords not matched.")
            return
        }
        
        self.forgotPswrdOtpVerifyAPI()
    }
    
    func forgotPswrdOtpVerifyAPI() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:Any] = [ "otpId": UserDefaults.standard.object(forKey: USER_DEFAULTS_KEYS.VENDOR_SIGNUP_OTP_ID)!,"otp":self.otptxt.text!,"password":self.newPasswordTxt.text!]
                        
            ServerClass.sharedInstance.putRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.VENDOR_FORGOT_PASSWORD_OTP_VERIFY, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                
                if success == "true"
                {
//                    UIAlertController.showInfoAlertWithTitle("Message", message: json["message"].stringValue, buttonTitle: "Okay")
                    self.showOkAlertWithHandler(json["message"].stringValue) {
                        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
                            self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
                    }
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
    

}
