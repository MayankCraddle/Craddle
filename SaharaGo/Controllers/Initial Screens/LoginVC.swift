//
//  LoginVC.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 05/08/22.
//

import UIKit
import TransitionButton
import SkyFloatingLabelTextField
import FirebaseDatabase
import FBSDKLoginKit
import GoogleSignIn
import AuthenticationServices

typealias APICompletionClosure = ((_ completedExecution: Bool?) -> Void)

class LoginVC: UIViewController {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var mailTxt: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTxt: SkyFloatingLabelTextField!
    
    @IBOutlet weak var btnGoogle: TransitionButton!
    @IBOutlet weak var btnFacebook: TransitionButton!
    @IBOutlet weak var btnApple: TransitionButton!
    
    var itemsArr: NSMutableArray = NSMutableArray()
    var onClickAPICompletionClosure: APICompletionClosure?
    var sendTo = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        AnalyticsUtil.instance.trackEvent(AnalyticsEvents.kLoginScreen)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.mailTxt.text = ""
        self.passwordTxt.text = ""
    }
    
    @IBAction func viewPaswordAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        sender.tintColor = sender.isSelected ? UIColor(red: 0/255.0, green: 125/255.0, blue: 67/255.0, alpha: 1.0) : UIColor.lightGray
        self.passwordTxt.isSecureTextEntry = !sender.isSelected
    }
    
    @IBAction func onClickBackBtn(_ sender: UIButton) {
        if sendTo == "Home" {
            let userStoryboard: UIStoryboard = UIStoryboard(name: "Buyer", bundle: nil)
            let viewController = userStoryboard.instantiateViewController(withIdentifier: "TabbarVC") as! TabbarVC
            let rootNC = UINavigationController(rootViewController: viewController)
            UIApplication.shared.delegate!.window!!.rootViewController = rootNC
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    @IBAction func onClickForgetPswrd(_ sender: UIButton) {
        let forgetPswrdVC = DIConfigurator.shared.getForgetPswrdVC()
        self.navigationController?.pushViewController(forgetPswrdVC, animated: true)
    }
    
    
    @IBAction func onClickSignup(_ sender: UIButton) {

        let signUpVC = DIConfigurator.shared.getSignUpVC()
        self.navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    @IBAction func onClickLogin(_ sender: UIButton) {
        if self.mailTxt.text!.isEmpty {
            self.view.makeToast("Please Enter Email.")
            return
        } else if self.passwordTxt.text!.isEmpty {
            self.view.makeToast("Please Enter Password.")
            return
        }
        self.loginApiCall()
    }
    
    func reactivateAccountApi() {
        
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
            UserDefaults.standard.set(fcmKey, forKey: "fcm_key")
            
            let param:[String:Any] = [ "status": "Active","password":self.passwordTxt.text!, "fcmKey": fcmKey,"comment":""]
            ServerClass.sharedInstance.postRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.CHANGE_ACCOUNT_STATUS, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {

                    AnalyticsUtil.instance.trackEvent(AnalyticsEvents.kAccountReactivated)
                    self.showOkAlertWithHandler("Your account has been Reactivated.") {
                        let userStoryboard: UIStoryboard = UIStoryboard(name: "Buyer", bundle: nil)
                        let viewController = userStoryboard.instantiateViewController(withIdentifier: "TabbarVC") as! TabbarVC
                        
                        let rootNC = UINavigationController(rootViewController: viewController)
                        UIApplication.shared.delegate!.window!!.rootViewController = rootNC
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
    
    func loginApiCall() {
        
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
            UserDefaults.standard.set(fcmKey, forKey: "fcm_key")
            let param:[String:Any] = [ "emailMobile": self.mailTxt.text!,"password":self.passwordTxt.text!, "fcmKey": fcmKey,"channel":"iOS"]
            ServerClass.sharedInstance.postRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.USER_LOGIN, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    
                    //save data in userdefault..
                    AnalyticsUtil.instance.trackEvent(AnalyticsEvents.kUserLoggedIn)
                    UserDefaults.standard.setValue(json["token"].stringValue, forKey: USER_DEFAULTS_KEYS.VENDOR_SIGNUP_TOKEN)
                    UserDefaults.standard.setValue(json["socialMediaLoggedIn"].boolValue, forKey: USER_DEFAULTS_KEYS.IS_SOCIAL_MEDIA_LOGGED_IN)
                    UserDefaults.standard.setValue(json["type"].stringValue, forKey: USER_DEFAULTS_KEYS.USER_TYPE)
                    UserDefaults.standard.setValue(json["userId"].stringValue, forKey: USER_DEFAULTS_KEYS.USER_ID)
                    UserDefaults.standard.setValue(json["encryptedId"].stringValue, forKey: USER_DEFAULTS_KEYS.ENCRYPTED_ID)
                    UserDefaults.standard.setValue(json["name"].stringValue, forKey: USER_DEFAULTS_KEYS.LOGIN_NAME)
                    UserDefaults.standard.set(json["emailMobile"].stringValue, forKey: USER_DEFAULTS_KEYS.LOGIN_EMAIL)
                    if json["emailMobile"].stringValue.contains("@") {
                        UserDefaults.standard.set("yes", forKey: "isEmailSaved")
                    } else {
                        UserDefaults.standard.set("no", forKey: "isEmailSaved")
                    }
                    
                    UserDefaults.standard.set("rgba(0,131,78,1)", forKey: USER_DEFAULTS_KEYS.COUNTRY_COLOR_CODE)
                    UserDefaults.standard.set("Nigeria", forKey: USER_DEFAULTS_KEYS.SELECTED_COUNTRY)
                    UserDefaults.standard.set("nigeria.png", forKey: USER_DEFAULTS_KEYS.SELECTED_FLAG)
                    
                    DispatchQueue.global(qos: .userInitiated).async {
                        if !json["deactivated"].boolValue {
                            self.getCartDetailOfUser()
                        }
                        
                    }
                    
                    let encryptedId = UserDefaults.standard.string(forKey: USER_DEFAULTS_KEYS.ENCRYPTED_ID)
                                        
                    let userDict = [
                        "email": self.mailTxt.text!,
                        "name" : json["name"].stringValue,
                        "fcmKey" : UserDefaults.standard.object(forKey: "fcm_key") as! String
                    ]

                    Database.database().reference().child("users").child("\(encryptedId ?? "")").updateChildValues(userDict as [AnyHashable : Any])
                    UserDefaults.standard.set(nil, forKey: USER_DEFAULTS_KEYS.IS_LOGIN)
                    
                    if json["deactivated"].boolValue {
                        self.showAlertWithActions("Your account has been deactivated. Do you want to reactivate your account ?", titles: ["Yes", "No"]) { (value) in
                            if value == 1{
                                self.reactivateAccountApi()
                            }
                        }
                        
                        return
                    }
                    
                    
                    
                    if self.sendTo == "Home" {
                        APP_DELEGATE.showBuyerHomeTab(self)
                    } else {
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
    
    func updateFcmApi() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)

            let param:[String:String] = ["fcmKey": UserDefaults.standard.object(forKey: "fcm_key") as! String]
                        
            ServerClass.sharedInstance.putRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.USER_UPDATE_FCM, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                
                if success == "true"
                {
                    
                } else {
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
            
            let param:[String:String] = [:]
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.USER_GET_CART_DETAIL_OF_USER, successBlock: { (json) in
                DispatchQueue.main.async {
                    print(json)
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
                    self.onClickAPICompletionClosure?(true)
                    
                } else {
                    UIAlertController.showInfoAlertWithTitle("Message", message: json["message"].stringValue, buttonTitle: "Okay")
                }
            }, errorBlock: { (NSError) in
                UIAlertController.showInfoAlertWithTitle("Alert", message: kUnexpectedErrorAlertString, buttonTitle: "Okay")
            })
            
        }else{
            UIAlertController.showInfoAlertWithTitle("Alert", message: "Please Check internet connection", buttonTitle: "Okay")
        }
    }
    
    
    
    @IBAction func onTapFBLoginButton(_ sender: TransitionButton) {
        appDelegateInstance.instanceForSocialLogin = self
        if let token = AccessToken.current,
           !token.isExpired {
            // User is logged in, do work such as go to next view controller.
            if UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.VENDOR_SIGNUP_TOKEN) != nil {
                
            } else {
                UserDefaults.standard.setValue(token.tokenString, forKey: USER_DEFAULTS_KEYS.VENDOR_SIGNUP_TOKEN)
            }
            appDelegateInstance.fetchDataFromFacebook()
        }else{
            let login = LoginManager()
            login.logIn(permissions: ["public_profile", "email"], from: self) { (result, error) in
                print(result)
                if (error != nil){
                    print(String(describing: error?.localizedDescription))
                }else if ((result?.isCancelled)!){
                    print("FB Cancel")
                }else{
                    appDelegateInstance.fetchDataFromFacebook()
                }
            }
        }
    }
  
    @IBAction func onTapGoogleLoginBtn(_ sender: TransitionButton) {
         appDelegateInstance.instanceForSocialLogin = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        if GIDSignIn.sharedInstance()?.hasPreviousSignIn() ?? false{
            // Automatically sign in the user.
            GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        }else{
            GIDSignIn.sharedInstance()?.signIn()
        }
    }
    
    @IBAction func onTapApple(_ sender: TransitionButton) {
        appDelegateInstance.instanceForSocialLogin = self
        if #available(iOS 13.0, *) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.performRequests()
        } else {
            // Fallback on earlier versions
        }

    }
}

//MARK:- ASAuthorizationControllerDelegate
extension LoginVC: ASAuthorizationControllerDelegate{
    @available(iOS 13.0, *)
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let fullName = getFullName(fullName: appleIDCredential.fullName)
            var email = ""
            email = appleIDCredential.email ?? ""
            if email == "" {
                email = userIdentifier
            }
            var dict = [String:Any]()
            dict["name"] = fullName
            dict["email"] = email
            dict["socialProviderUid"] = userIdentifier
            dict["socialProviderType"] = "apple"
            print(dict)
            
            //call Api here
            appDelegateInstance.hitSocialLoginAPI(socialData: dict)
            
//            print_debug("User id: \(userIdentifier) \n Full Name: \(fullName?.givenName ?? "")\n EmailId: \(email ?? "")")
            
        }
              
    }

}

func getFullName(fullName: PersonNameComponents?) -> String {
    let firstName: String = fullName?.givenName ?? ""
    let middleName: String = fullName?.middleName ?? ""
    let lastName: String = fullName?.familyName ?? ""
    
//    return "\(firstName) \(middleName) \(lastName)".trim()
    return "\(firstName) \(middleName) \(lastName)"

}
