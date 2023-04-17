//
//  ForgotPasswordOTPVC.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 08/08/22.
//

import UIKit
import SkyFloatingLabelTextField

class ForgotPasswordOTPVC: UIViewController {

    @IBOutlet weak var resendBtn: UIButton!
    @IBOutlet weak var timerLbl: UILabel!
    @IBOutlet weak var otpTxt: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTxt: SkyFloatingLabelTextField!
    @IBOutlet weak var confirmPswrdTxt: SkyFloatingLabelTextField!
    
    var seconds = 30
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.seconds -= 1
            if self.seconds == 0 {
                self.timerLbl.isHidden = true
                self.resendBtn.titleLabel?.textColor = UIColor.black
                self.resendBtn.isUserInteractionEnabled = true
                timer.invalidate()
            } else {
                self.timerLbl.isHidden = false
                self.resendBtn.titleLabel?.textColor = UIColor.lightGray
                self.resendBtn.isUserInteractionEnabled = false
                self.timerLbl.text = "Seconds remaining \(self.seconds)"
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func resetAction(_ sender: Any) {
        
        if self.otpTxt.text!.isEmpty {
            self.view.makeToast("Please Enter OTP.")
            return
        } else if self.passwordTxt.text!.isEmpty {
            self.view.makeToast("Please Enter New Password.")
            return
        } else if self.confirmPswrdTxt.text!.isEmpty {
            self.view.makeToast("Please Enter Confirm Password.")
            return
        } else if self.passwordTxt.text!.count < 7 || self.passwordTxt.text!.count > 16 {
            self.view.makeToast("Password should have 7 to 16 characters.")
            return
        } else if self.confirmPswrdTxt.text! != self.passwordTxt.text! {
            self.view.makeToast("Passwords not matched.")
            return
        } else if !isPasswordValid(self.passwordTxt.text!) {
//            showCustomMessageAlertWithTitle(message: "Password must be atleast of 8 characters, 1 alphabet and 1 special character.", title: "Weak Password !")
            showCustomMessageAlertWithTitle(message: "Password must be atleast of 8 characters, 1 Uppercase alphabet , 1 Lowercase Alphabet and 1 special character.", title: "Weak Password !")
            self.passwordTxt.tintColor = .red
            self.passwordTxt.selectedLineColor = .red
            self.passwordTxt.selectedTitleColor = .red
            self.confirmPswrdTxt.text = ""
            self.passwordTxt.becomeFirstResponder()
            return
        }
        
        self.forgotPswrdOtpVerifyAPI()
    }
    
    func resendOtp() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
        let param:[String:Any] = [ "otpId": UserDefaults.standard.object(forKey: USER_DEFAULTS_KEYS.VENDOR_SIGNUP_OTP_ID)!]
            ServerClass.sharedInstance.postRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.USER_RESEND_OTP, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    
                    UserDefaults.standard.setValue(json["otpId"].stringValue, forKey: USER_DEFAULTS_KEYS.VENDOR_SIGNUP_OTP_ID)
                    var secondss = 30
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                        secondss -= 1
                        if secondss == 0 {
                            self.timerLbl.isHidden = true
                            self.resendBtn.titleLabel?.textColor = UIColor.black
                            self.resendBtn.isUserInteractionEnabled = true
                            timer.invalidate()
                        } else {
                            self.timerLbl.isHidden = false
                            self.resendBtn.titleLabel?.textColor = UIColor.lightGray
                            self.resendBtn.isUserInteractionEnabled = false
                            self.timerLbl.text = "Seconds remaining \(secondss)"
                        }
                    }
                    
                    self.view.makeToast("Otp sent successfully.")
                
                    

//                    APP_DELEGATE.showBuyerHomeTab(self)
                }
                else {
                    UIAlertController.showInfoAlertWithTitle("Message", message: json["message"].stringValue, buttonTitle: "Okay")
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
    
    func forgotPswrdOtpVerifyAPI() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:Any] = [ "otpId": UserDefaults.standard.object(forKey: USER_DEFAULTS_KEYS.VENDOR_SIGNUP_OTP_ID)!,"otp":self.otpTxt.text!,"password":self.passwordTxt.text!]
                        
            ServerClass.sharedInstance.putRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.USER_FORGOT_PASSWORD_OTP_VERIFY, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                
                if success == "true"
                {
                    self.view.makeToast(json["message"].stringValue)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
                        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
                    }
                }
                else {
                    UIAlertController.showInfoAlertWithTitle("Message", message: json["message"].stringValue, buttonTitle: "Okay")
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
    
    @IBAction func onClickResend(_ sender: UIButton) {
        self.resendOtp()
    }
    
    
}
