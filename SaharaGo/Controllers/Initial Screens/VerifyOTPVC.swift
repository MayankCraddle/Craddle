//
//  VerifyOTPVC.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 05/08/22.
//

import UIKit
import OTPFieldView
import Firebase

class VerifyOTPVC: UIViewController {
    
    @IBOutlet weak var resendBtn: UIButton!
    @IBOutlet weak var timerLbl: UILabel!
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var otpView: OTPFieldView!
    
    var otpEntered:String = String()
    var mail = ""
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
        self.setupOtpView()
        
    }
    
    func setupOtpView(){
        self.otpView.fieldsCount = 6
        self.otpView.fieldBorderWidth = 1
        self.otpView.defaultBorderColor = UIColor.darkGray
        self.otpView.filledBorderColor = UIColor.black
        self.otpView.cursorColor = UIColor.black
        self.otpView.displayType = .roundedCorner
        self.otpView.fieldSize = 40
        self.otpView.separatorSpace = 8
        self.otpView.shouldAllowIntermediateEditing = false
        self.otpView.delegate = self
        self.otpView.initializeUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }

    @IBAction func onClickHome(_ sender: UIButton) {
        APP_DELEGATE.showBuyerHomeTab(self)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickResendOtp(_ sender: UIButton) {
        
        self.resendOtp()
        
    }
    
    @IBAction func submitBtnAction(_ sender: Any) {
        if self.otpEntered.count == 0 {
            self.view.makeToast("Please enter OTP.")
            return
        }
        self.signupOtpVerifyApiCall()
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

        func signupOtpVerifyApiCall() {
            if Reachability.isConnectedToNetwork() {
                showProgressOnView(appDelegateInstance.window!)
                
            let param:[String:Any] = [ "otpId": UserDefaults.standard.object(forKey: USER_DEFAULTS_KEYS.VENDOR_SIGNUP_OTP_ID)!,"otp":self.otpEntered,"channel":"iOS"]
                ServerClass.sharedInstance.postRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.USER_SIGNUP_OTP_VERIFY, successBlock: { (json) in
                    print(json)
                    hideAllProgressOnView(appDelegateInstance.window!)
                    let success = json["success"].stringValue
                    if success == "true"
                    {
                        //save data in userdefault..
                        AnalyticsUtil.instance.trackEvent(AnalyticsEvents.kUserRegistered)
                        UserDefaults.standard.setValue(json["token"].stringValue, forKey: USER_DEFAULTS_KEYS.VENDOR_SIGNUP_TOKEN)
                        UserDefaults.standard.setValue(json["type"].stringValue, forKey: USER_DEFAULTS_KEYS.USER_TYPE)
                        UserDefaults.standard.setValue(json["userId"].stringValue, forKey: USER_DEFAULTS_KEYS.USER_ID)
                        UserDefaults.standard.setValue(json["encryptedId"].stringValue, forKey: USER_DEFAULTS_KEYS.ENCRYPTED_ID)
                        
                        UserDefaults.standard.set(json["emailMobile"].stringValue, forKey: USER_DEFAULTS_KEYS.LOGIN_EMAIL)
                        if json["emailMobile"].stringValue.contains("@") {
                            UserDefaults.standard.set("yes", forKey: "isEmailSaved")
                        } else {
                            UserDefaults.standard.set("no", forKey: "isEmailSaved")
                        }
                        
                        UserDefaults.standard.set("rgba(0,131,78,1)", forKey: USER_DEFAULTS_KEYS.COUNTRY_COLOR_CODE)
                        UserDefaults.standard.set("Nigeria", forKey: USER_DEFAULTS_KEYS.SELECTED_COUNTRY)
                        UserDefaults.standard.set("nigeria.png", forKey: USER_DEFAULTS_KEYS.SELECTED_FLAG)
                        
                        UserDefaults.standard.set("rgba(0,131,78,1)", forKey: USER_DEFAULTS_KEYS.COUNTRY_COLOR_CODE)
                        
                        DispatchQueue.global(qos: .userInitiated).async {
                            
                            self.getCartDetailOfUser()
                        }
                        
                        country = "Nigeria"

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
    
    func getCartDetailOfUser() {
        if Reachability.isConnectedToNetwork() {
//            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = [:]
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.USER_GET_CART_DETAIL_OF_USER, successBlock: { (json) in
                DispatchQueue.main.async {
                    debugPrint(json)
                }

                let success = json["success"].stringValue
                if success == "true"
                {
                    
                    UserDefaults.standard.setValue(json["cartId"].stringValue, forKey: USER_DEFAULTS_KEYS.CART_ID)
                    UserDefaults.standard.setValue(json["userId"].stringValue, forKey: USER_DEFAULTS_KEYS.USER_ID)
                    globalCartProducts.removeAll()
                    if json["metaData"]["items"].count > 0 {
                        for i in 0..<json["metaData"]["items"].count {
                            let productId =  json["metaData"]["items"][i]["productId"].stringValue
                            let itemId =  json["metaData"]["items"][i]["itemId"].stringValue
                            let quantity =  json["metaData"]["items"][i]["quantity"].stringValue
                            let discountPercent =  json["metaData"]["items"][i]["discountPercent"].stringValue
                            let name =  json["metaData"]["items"][i]["name"].stringValue
                            let price =  json["metaData"]["items"][i]["price"].stringValue
                            let stock =  json["metaData"]["items"][i]["stock"].stringValue
                            let discountedPrice =  json["metaData"]["items"][i]["discountedPrice"].stringValue
                            let currency =  json["metaData"]["items"][i]["currency"].stringValue
                            let vendorId =  json["metaData"]["items"][i]["itemId"].stringValue
                            let description =  json["metaData"]["items"][i]["metaData"]["description"].stringValue
                            
                            var imgArr = [String]()
                            for j in 0..<json["metaData"]["items"][i]["metaData"]["images"].count {
                                
                                let file = json["metaData"]["items"][i]["metaData"]["images"][j].stringValue
                                imgArr.append(file)
                            }
                            
                            globalCartProducts.append(cartProductListStruct.init(currency: currency, description: description, stock: stock, productId: productId, itemId: itemId, price: price, discountedPrice: discountedPrice, discountPercent: discountPercent, name: name, quantity: quantity, imagesArr: imgArr, vendorId: vendorId))
                            
                            let itemDic: NSMutableDictionary = NSMutableDictionary()
                            itemDic.setValue(productId, forKey: "productId")
                            itemDic.setValue(quantity, forKey: "quantity")
                            itemDic.setValue(itemId, forKey: "itemId")
                            
                            globalCartItemsArr.add(itemDic)
                            
//                            UserDefaults.standard.set(globalCartProducts.count, forKey: "cartCount")
                            UserDefaults.standard.setValue(json["cartSize"].intValue, forKey: "cartCount")
                        }
                        
                    }
                    
                    UserDefaults.standard.set(true, forKey: USER_DEFAULTS_KEYS.IS_LOGIN)
//                    APP_DELEGATE.showCountryScreen(self)
                    let encryptedId = UserDefaults.standard.string(forKey: USER_DEFAULTS_KEYS.ENCRYPTED_ID)
                                        
                    let userDict = [
                        "email": self.mail,
                        "name" : json["name"].stringValue,
                        "fcmKey" : UserDefaults.standard.object(forKey: "fcm_key") as! String
                    ]

                    Database.database().reference().child("users").child("\(encryptedId ?? "")").updateChildValues(userDict as [AnyHashable : Any])
                    
                    let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
                        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 4], animated: true)
                    NotificationCenter.default.post(name: NSNotification.Name("updateCartBadge"), object: nil, userInfo: nil)
                    
                } else {
                    UIAlertController.showInfoAlertWithTitle("Message", message: json["message"].stringValue, buttonTitle: "Okay")
                }
            }, errorBlock: { (NSError) in
                UIAlertController.showInfoAlertWithTitle("Alert", message: kUnexpectedErrorAlertString, buttonTitle: "Okay")
//                hideAllProgressOnView(appDelegateInstance.window!)
            })
            
        }else{
//            hideAllProgressOnView(appDelegateInstance.window!)
            UIAlertController.showInfoAlertWithTitle("Alert", message: "Please Check internet connection", buttonTitle: "Okay")
        }
    }
}

extension VerifyOTPVC: OTPFieldViewDelegate {
    func hasEnteredAllOTP(hasEnteredAll hasEntered: Bool) -> Bool {
        if hasEntered {
            self.continueBtn.alpha = 1.0
            self.continueBtn.isUserInteractionEnabled = true
            
        }
        return false
    }
    
    func shouldBecomeFirstResponderForOTP(otpTextFieldIndex index: Int) -> Bool {
        return true
    }
    
    func enteredOTP(otp otpString: String) {
        self.otpEntered = otpString
        print("OTPString: \(otpString)")
    }
}
