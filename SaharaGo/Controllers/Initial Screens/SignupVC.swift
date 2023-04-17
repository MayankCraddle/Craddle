//
//  SignupVC.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 05/08/22.
//

import UIKit
import TransitionButton
import SkyFloatingLabelTextField
import CountryPickerView

class SignupVC: UIViewController {

    @IBOutlet weak var txtCountryCode: UITextField!
    @IBOutlet weak var firstNameTxt: SkyFloatingLabelTextField!
    @IBOutlet weak var lastNameTxt: SkyFloatingLabelTextField!
    @IBOutlet weak var emailIdTxt: SkyFloatingLabelTextField!
    @IBOutlet weak var countryTxt: SkyFloatingLabelTextField!
    @IBOutlet weak var citytxt: SkyFloatingLabelTextField!
    @IBOutlet weak var phoneTxt: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTxt: SkyFloatingLabelTextField!
    @IBOutlet weak var confirmPaswordTxt: SkyFloatingLabelTextField!
    @IBOutlet weak var referredByTxt: SkyFloatingLabelTextField!
    
    var metaDataDic: NSMutableDictionary = NSMutableDictionary()
    var countryPickerView: CountryPickerView?
    var isFrom = ""
    var referredBy = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        AnalyticsUtil.instance.trackEvent(AnalyticsEvents.kUserLoggedOut)
        self.navigationController?.isNavigationBarHidden = false
        txtCountryCode.delegate = self
        configCountryCodePicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.passwordTxt.delegate = self
    }
    
    func configCountryCodePicker(){
        self.countryPickerView = CountryPickerView()
        self.countryPickerView?.delegate = self
        self.countryPickerView?.dataSource = self
        
        let locale = Locale.current
        let code = ((locale as NSLocale).object(forKey: NSLocale.Key.countryCode) as! String?)!
        self.countryPickerView?.setCountryByCode(code)
    }
    
    
    @IBAction func onClickSignIn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
//        let verifyOtpVC = DIConfigurator.shared.getVerifyOTPVC()
//        verifyOtpVC.mail = self.emailIdTxt.text!
//        self.navigationController?.pushViewController(verifyOtpVC, animated: true)
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        
        if self.firstNameTxt.text!.isEmpty {
            self.view.makeToast("Please Enter First Name.")
            return
        } else if self.lastNameTxt.text!.isEmpty {
            self.view.makeToast("Please Enter Last Name.")
            return
        } else if self.phoneTxt.text!.isEmpty {
            self.view.makeToast("Please Enter Phone No.")
            return
        } else if self.phoneTxt.text!.count > 10 {
            self.view.makeToast("Please Enter valid Phone No.")
            return
        } else if self.emailIdTxt.text!.isEmpty {
            self.view.makeToast("Please Enter Email.")
            return
        } else if !self.emailIdTxt.text!.isValidEmail() {
            self.view.makeToast("Please enter Valid Email.")
            return
        } else if self.countryTxt.text!.isEmpty {
            self.view.makeToast("Please Enter Country.")
            return
        } else if self.passwordTxt.text!.isEmpty {
            self.view.makeToast("Please Enter Password.")
            return
        } else if !isPasswordValid(self.passwordTxt.text!) {
            showCustomMessageAlertWithTitle(message: "Password must be atleast of 8 characters, 1 Uppercase alphabet , 1 Lowercase Alphabet and 1 special character.", title: "Weak Password !")

            self.passwordTxt.tintColor = .red
            self.passwordTxt.selectedLineColor = .red
            self.passwordTxt.selectedTitleColor = .red
            self.confirmPaswordTxt.text = ""
            self.passwordTxt.becomeFirstResponder()
            return
        } else if self.confirmPaswordTxt.text!.isEmpty {
            self.view.makeToast("Please Confirm your Password")
            return
        } else if self.confirmPaswordTxt.text! != self.passwordTxt.text! {
            self.view.makeToast("Passwords not matched.")
            return
        }  else if !self.referredByTxt.text!.isEmpty {
            if !self.referredByTxt.text!.isValidEmail() {
                self.view.makeToast("Please enter valid email of Referred by.")
                return
            }
        }

        metaDataDic.setValue(self.firstNameTxt.text!, forKey: "firstName")
        metaDataDic.setValue(self.lastNameTxt.text!, forKey: "lastName")
        country = self.countryTxt.text!
        
        self.signupApiCall()
    }
    
    func signupApiCall() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            if let objFcmKey = UserDefaults.standard.object(forKey: "fcm_key") as? String
            {
                fcmKey = objFcmKey
            }
            else
            {
                fcmKey = "abcdef"
            }
            
            
            let param:[String:Any] = [ "emailMobile": self.emailIdTxt.text!,"password":self.passwordTxt.text!,"country":self.countryTxt.text!, "fcmKey": fcmKey,"metaData":self.metaDataDic, "referredBy": self.referredByTxt.text ?? ""]
            ServerClass.sharedInstance.postRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.USER_SIGNUP, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    //save data in userdefault..
                    UserDefaults.standard.setValue(json["otpId"].stringValue, forKey: USER_DEFAULTS_KEYS.VENDOR_SIGNUP_OTP_ID)
                    
                    let verifyOtpVC = DIConfigurator.shared.getVerifyOTPVC()
                    verifyOtpVC.mail = self.emailIdTxt.text!
                    self.navigationController?.pushViewController(verifyOtpVC, animated: true)
                    
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
    
    @IBAction func countryAction(_ sender: UIButton) {

        self.isFrom = "Country"
        self.countryPickerView?.showCountriesList(from: self)
    }
    
    @IBAction func tapViewPass(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        sender.tintColor = sender.isSelected ? UIColor(red: 0/255.0, green: 125/255.0, blue: 67/255.0, alpha: 1.0) : UIColor.lightGray
        if sender.tag == 101 {
            self.passwordTxt.isSecureTextEntry = !sender.isSelected
        } else {
            self.confirmPaswordTxt.isSecureTextEntry = !sender.isSelected
        }
        
    }
    
}

extension SignupVC: ChooseCountryDelegate{
    func onSelectCountry(country: Select_Country_List_Struct, isFrom: String) {

    }
}

extension SignupVC: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.passwordTxt && self.passwordTxt.text!.isEmpty {
            self.passwordTxt.selectedLineColor = .black
            self.passwordTxt.selectedTitleColor = .black
            self.passwordTxt.tintColor = .black
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == txtCountryCode{
            self.countryPickerView?.showCountriesList(from: self)
            self.isFrom = "Phone"
            return false
        }
        return true
    }
}

//MARK:- CountryPickerDelegate
extension SignupVC: CountryPickerViewDelegate, CountryPickerViewDataSource{
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        if self.isFrom == "Phone" {
            txtCountryCode.text = country.phoneCode
        } else if self.isFrom == "Country" {
            countryTxt.text = country.name
        }
    }
    
    func navigationTitle(in countryPickerView: CountryPickerView) -> String? {
        return "Select your country"
    }
    
}
