//
//  LogOutVC.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 22/08/22.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn

class AccountVC: UIViewController {

    @IBOutlet weak var addressEmtyView: UIView!
    @IBOutlet weak var userMailLbl: UILabel!
    @IBOutlet weak var userMobileLbl: UILabel!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    
    @IBOutlet weak var addressLbl1: UILabel!
    @IBOutlet weak var addressLbl2: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    
    var addressInfo = address_Struct()
    var profileInfo = profileDetail_Struct()
    var showbackBtn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        backBtn.isHidden = !showbackBtn
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        self.navigationController?.navigationBar.isHidden = true
        if UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.VENDOR_SIGNUP_TOKEN) != nil {
            self.getProfileDetail()
        } else {
            let vc = DIConfigurator.shared.getLoginVC()
            vc.sendTo = "Home"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func getProfileDetail() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = [:]
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.USER_GET_DETAIL_BY_TOKEN, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                //success == "true"
                if success == "true"
                {
                    let firstName = json["metaData"]["firstName"].stringValue
                    let lastName = json["metaData"]["lastName"].stringValue
                    let userImage = json["metaData"]["image"].stringValue
                    let coverImage = json["metaData"]["coverImage"].stringValue
                    let emailMobile = json["emailMobile"].stringValue
                   
                    let country = json["country"].stringValue
                    
                    let adId = json["address"]["id"].stringValue
                    let adFirstName = json["address"]["metaData"]["firstName"].stringValue
                    let adLastName = json["address"]["metaData"]["lastName"].stringValue
                    let adPhone = json["address"]["metaData"]["phone"].stringValue
                    let adStreetAddress = json["address"]["metaData"]["streetAddress"].stringValue
                    let adCountry = json["address"]["metaData"]["country"].stringValue
                    let adState = json["address"]["metaData"]["state"].stringValue
                    let adCity = json["address"]["metaData"]["city"].stringValue
                    let adZipcode = json["address"]["metaData"]["zipcode"].stringValue
                    let adLandmark = json["address"]["metaData"]["landmark"].stringValue
                    let addressType = json["address"]["metaData"]["addressType"].stringValue
                                        
                    let addressObj = address_Struct.init(id: adId, firstName: adFirstName, lastName: adLastName, phone: adPhone, streetAddress: adStreetAddress, country: adCountry, state: adState, city: adCity, zipcode: adZipcode, landmark: adLandmark, isDefault: true, addressType: addressType)
                    
                    self.addressInfo = addressObj
                    self.profileInfo = profileDetail_Struct.init(firstName: firstName, lastName: lastName, emailMobile: emailMobile, country: country, userImage: userImage, coverImage: coverImage, address: addressObj)
                    self.setData(self.profileInfo)
//                    self.setData(profileDetail_Struct.init(firstName: firstName, lastName: lastName, emailMobile: emailMobile, country: country, userImage: userImage, coverImage: coverImage, address: addressObj))
                    
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

    
    func setData(_ profileInfo: profileDetail_Struct) {
        
        self.profileImg.contentMode = .scaleToFill
        self.profileImg.sd_setImage(with: URL(string: FILE_BASE_URL + "/\(profileInfo.userImage)"), placeholderImage: UIImage(named: "avatar-2"))
        self.userMobileLbl.text = profileInfo.emailMobile
        self.userNameLbl.text = "\(profileInfo.firstName) \(profileInfo.lastName)"
        UserDefaults.standard.set("\(profileInfo.firstName) \(profileInfo.lastName)", forKey: USER_DEFAULTS_KEYS.LOGIN_NAME)
        
        let info = profileInfo.address
        if info.id != "" {
            self.addressEmtyView.isHidden = true
            self.addressLbl1.text = "\(info.firstName) \(info.lastName)"
            self.addressLbl2.text = "\(info.streetAddress),\nMobile: \(info.phone), \n\(info.state), \(info.city),\n\(info.country)"
        } else {
            self.addressEmtyView.isHidden = false
        }
        
    }
    
    @IBAction func onClickBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func editProfileAction(_ sender: UIButton) {
        let addAddressVC = DIConfigurator.shared.getEditProfileVC()
        addAddressVC.profileInfo = self.profileInfo
        self.navigationController?.pushViewController(addAddressVC, animated: true)
    }
    
    @IBAction func editAddressAction(_ sender: UIButton) {
        let addAddressVC = DIConfigurator.shared.getAddAddressVC()
        addAddressVC.addressInfo = self.addressInfo
        addAddressVC.isEdit = true
        self.navigationController?.pushViewController(addAddressVC, animated: true)
    }

    @IBAction func manageAddressAction(_ sender: UIButton) {
        let productDetailVC = DIConfigurator.shared.getAddressVC()
        self.navigationController?.pushViewController(productDetailVC, animated: true)
    }
    
    @IBAction func accountActions(_ sender: UIButton) {
        
        switch sender.tag {
        case 101:
            let sellerLoginVC = DIConfigurator.shared.getOrdersVC()
            self.navigationController?.pushViewController(sellerLoginVC, animated: true)
            
        case 102:
            self.showOkAlertWithHandler("Currenlty Under Development.") {
                print("ok")
            }
            
        case 103:
            let changePasswordVC = DIConfigurator.shared.getChangePasswordVC()
            self.navigationController?.pushViewController(changePasswordVC, animated: true)
            
        case 104:
            let changePasswordVC = DIConfigurator.shared.getDeactivateVC()
            self.navigationController?.pushViewController(changePasswordVC, animated: true)
            
        case 105:
            let changePasswordVC = DIConfigurator.shared.getDeleteVC()
            self.navigationController?.pushViewController(changePasswordVC, animated: true)
            
        case 107:
            let changePasswordVC = DIConfigurator.shared.getNotificationsVC()
            self.navigationController?.pushViewController(changePasswordVC, animated: true)
            
        default:
            self.showAlertWithActions("Are you sure you want to LogOut ?", titles: ["Yes", "No"]) { (value) in
                if value == 1{
                    AnalyticsUtil.instance.trackEvent(AnalyticsEvents.kUserLoggedOut)
                    isLogOut = "yes"

                    UserDefaults.standard.set(nil, forKey: USER_DEFAULTS_KEYS.VENDOR_SIGNUP_TOKEN)
                    UserDefaults.standard.set("", forKey: USER_DEFAULTS_KEYS.LOGIN_TOKEN)
                    UserDefaults.standard.set("", forKey: USER_DEFAULTS_KEYS.IS_LOGIN)
                    UserDefaults.standard.set("", forKey: USER_DEFAULTS_KEYS.LOGIN_NAME)
                    UserDefaults.standard.set(false, forKey: USER_DEFAULTS_KEYS.IS_SOCIAL_MEDIA_LOGGED_IN)

                    let manager = LoginManager()
                    manager.logOut()
                    
                    GIDSignIn.sharedInstance()?.signOut()
                    
                    UserDefaults.standard.setValue(0, forKey: "cartCount")
                    let userStoryboard: UIStoryboard = UIStoryboard(name: "Buyer", bundle: nil)
                    let viewController = userStoryboard.instantiateViewController(withIdentifier: "TabbarVC") as! TabbarVC
                    
                    let rootNC = UINavigationController(rootViewController: viewController)
                    UIApplication.shared.delegate!.window!!.rootViewController = rootNC
                }
            }
        }

    }
    
    @IBAction func emptyAddressAddAction(_ sender: UIButton) {
        let addAddressVC = DIConfigurator.shared.getAddAddressVC()
        self.navigationController?.pushViewController(addAddressVC, animated: true)
    }
    
    @IBAction func onClickNotification(_ sender: UIButton) {
        let changePasswordVC = DIConfigurator.shared.getNotificationsVC()
        self.navigationController?.pushViewController(changePasswordVC, animated: true)
    }
    
    
    
}
