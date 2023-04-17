//
//  ChangePasswordVC.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 25/08/22.
//

import UIKit
import SkyFloatingLabelTextField

class ChangePasswordVC: UIViewController {

    @IBOutlet weak var currentPasswordTxt: SkyFloatingLabelTextField!
    @IBOutlet weak var newpasswordTxt: SkyFloatingLabelTextField!
    @IBOutlet weak var confirmPasswordtxt: SkyFloatingLabelTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickReset(_ sender: UIButton) {
        if self.currentPasswordTxt.text!.isEmpty {
            self.view.makeToast("Please Enter Current Password.")
            return
        } else if self.newpasswordTxt.text!.isEmpty {
            self.view.makeToast("Please Enter New Password.")
            return
        } else if !isPasswordValid(self.newpasswordTxt.text!) {
//            showCustomMessageAlertWithTitle(message: "Password must be atleast of 8 characters, 1 alphabet and 1 special character.", title: "Weak Password !")
            showCustomMessageAlertWithTitle(message: "Password must be atleast of 8 characters, 1 Uppercase alphabet , 1 Lowercase Alphabet and 1 special character.", title: "Weak Password !")
            self.newpasswordTxt.tintColor = .red
            self.newpasswordTxt.selectedLineColor = .red
            self.newpasswordTxt.selectedTitleColor = .red
            self.confirmPasswordtxt.text = ""
            self.newpasswordTxt.becomeFirstResponder()
            return
        } else if self.confirmPasswordtxt.text!.isEmpty {
            self.view.makeToast("Please Confirm your Password")
            return
        } else if self.confirmPasswordtxt.text! != self.newpasswordTxt.text! {
            self.view.makeToast("Passwords not matched.")
            return
        }
        
        self.changePasswordAPI()
    }
    
    func changePasswordAPI() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
        let param:[String:Any] = [ "oldPassword": self.currentPasswordTxt.text!, "newPassword": self.newpasswordTxt.text!]
            
            ServerClass.sharedInstance.putRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.USER_CHANGE_PASSWORD, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                
                if success == "true"
                {
                    
                    self.view.makeToast(json["message"].stringValue)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.navigationController?.popViewController(animated: true)
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

}
