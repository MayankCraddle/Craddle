//
//  ChoosePaymentVC.swift
//  Craddle User
//
//  Created by ChawTech Solutions on 24/03/23.
//

import UIKit
import FlutterwaveSDK
import RaveSDK

class ChoosePaymentVC: UIViewController {
    
    @IBOutlet weak var orderFailureView: UIView!
    @IBOutlet weak var orderSuccessView: UIView!
    @IBOutlet weak var addressSubLbl: UILabel!
    @IBOutlet weak var addressMainLbl: UILabel!
    @IBOutlet weak var paystackRadioImg: UIImageView!
    @IBOutlet weak var flutterWaveRadioImg: UIImageView!
    @IBOutlet weak var subTotalLbl: UILabel!
    @IBOutlet weak var shippingLbl: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    
    var paymentMethod = ""
    var param = [String:Any]()
    
    var secretKey = ""
    var txRef = ""
    var encryptionKey = ""
    var publicKey = ""
    var totalAmountIncludingShippingCharges : Double = Double()
    var subTotalCost = ""
    var shippingCost = ""
    var totalCost = ""
    var itemsArr: NSMutableArray = NSMutableArray()
    var cartProducts = [cartProductListStruct]()
    var cartMetaDataDic: NSMutableDictionary = NSMutableDictionary()
    var deliverAddress = [address_Struct]()
    var addressTxt = ""
    var addressSubTxt = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setAddressAndShipping()
    }
    
    func setAddressAndShipping() {
        self.addressMainLbl.text = self.addressTxt
        self.addressSubLbl.text = self.addressSubTxt
        self.subTotalLbl.text = self.subTotalCost
        self.shippingLbl.text = self.shippingCost
        self.totalLbl.text = self.totalCost
    }
    
    @IBAction func onClickBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickPay(_ sender: UIButton) {
        if self.paymentMethod == "" {
            self.view.makeToast("Please select Payment Type.")
            return
        }
        self.createDataForOrder()
    }
    
    
    
    @IBAction func paymentActions(_ sender: UIButton) {
        if sender.tag == 101 {
            self.paymentMethod = "FLUTTERWAVE"
            self.flutterWaveRadioImg.image = UIImage(named: "radio_active")
            self.paystackRadioImg.image = UIImage(named: "radio")
        } else {
            self.paymentMethod = "PAYSTACK"
            self.paystackRadioImg.image = UIImage(named: "radio_active")
            self.flutterWaveRadioImg.image = UIImage(named: "radio")
        }
    }
    
    @IBAction func orderSuccessContinueAction(_ sender: Any) {
        let userStoryboard: UIStoryboard = UIStoryboard(name: "Buyer", bundle: nil)
        let viewController = userStoryboard.instantiateViewController(withIdentifier: "TabbarVC") as! TabbarVC
        let rootNC = UINavigationController(rootViewController: viewController)
        UIApplication.shared.delegate!.window!!.rootViewController = rootNC
    }
    
    @IBAction func orderSuccessViewOrdersAction(_ sender: UIButton) {
        let contentDetailVC = DIConfigurator.shared.getOrdersVC()
        self.navigationController?.pushViewController(contentDetailVC, animated: true)
    }
    
    func createDataForOrder() {
        self.itemsArr.removeAllObjects()
        for items in cartProducts {
            print(items)
            var itemDic: NSMutableDictionary = NSMutableDictionary()
            var metaDataDic: NSMutableDictionary = NSMutableDictionary()
            itemDic.setValue(items.productId, forKey: "productId")
            itemDic.setValue(items.itemId, forKey: "itemId")
            itemDic.setValue(items.quantity, forKey: "quantity")
            
            itemDic.setValue(items.name, forKey: "name")
            //itemDic.setValue("", forKey: "category")
            itemDic.setValue(items.stock, forKey: "stock")
            itemDic.setValue(items.currency, forKey: "currency")
            itemDic.setValue(items.price, forKey: "price")
            itemDic.setValue(items.discountPercent, forKey: "discountPercent")
            itemDic.setValue(items.discountedPrice, forKey: "discountedPrice")
            itemDic.setValue(items.actualPrice, forKey: "actualPrice")
            let total = (items.quantity as NSString).doubleValue * (items.discountedPrice as NSString).doubleValue
            itemDic.setValue(total, forKey: "totalPrice")
            metaDataDic.setValue(items.description, forKey: "description")
            
            metaDataDic.setValue(items.imagesArr, forKey: "images")
            metaDataDic.setValue(items.noOfPieces, forKey: "noOfPieces")
            metaDataDic.setValue(items.productLength, forKey: "productLength")
            metaDataDic.setValue(items.productHeight, forKey: "productHeight")
            metaDataDic.setValue(items.productWidth, forKey: "productWidth")
            metaDataDic.setValue(items.shortDescription, forKey: "shortDescription")
            metaDataDic.setValue(items.material, forKey: "material")
            metaDataDic.setValue(items.dimensionUnit, forKey: "dimensionUnit")
            metaDataDic.setValue(items.boxId, forKey: "boxId")
            metaDataDic.setValue(items.rating, forKey: "rating")
            metaDataDic.setValue(items.boxId, forKey: "country")
            metaDataDic.setValue(items.rating, forKey: "vendorEncryptedId")
            
            
            itemDic.setValue(metaDataDic, forKey: "metaData")
            self.itemsArr.add(itemDic)
        }
        self.cartMetaDataDic.setValue(self.itemsArr, forKey: "items")
        self.orderProcessApi()

    }
    
    func orderProcessApi() {
        
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
                        
            self.param["paymentMethod"] = self.paymentMethod
//            let param:[String:Any] = [ "cartId": UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.CART_ID)!,"cartMetaData":self.cartMetaDataDic,"totalPrice": "\(self.totalAmountIncludingShippingCharges)", "orderMetaData": self.orderMetaDataDic, "paymentMethod": "FLUTTERWAVE"]
            print(param)
            ServerClass.sharedInstance.postRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.USER_ORDER_PROCESS, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    
//                    self.showExample()
                    self.txRef = json["txRef"].stringValue
                    self.publicKey = json["publicKey"].stringValue
                    self.secretKey = json["secretKey"].stringValue
                    self.encryptionKey = json["encryptionKey"].stringValue
//                    self.customAlertView.removeFromSuperview()

                    if self.paymentMethod == "FLUTTERWAVE" {
                        self.paymentAction(email: UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.LOGIN_EMAIL) as! String, phoneNumber: "1234567890", firstName: "Ritesh", lastName: "Sinha", amount: "\(self.totalAmountIncludingShippingCharges)", ref: self.txRef)
                    } else {
                        let wishlistVC = DIConfigurator.shared.getPaystackVC()
                        wishlistVC.accessToken = json["accessCode"].stringValue
                        wishlistVC.totalAmountIncludingShippingCharges = self.totalAmountIncludingShippingCharges
                        self.navigationController?.pushViewController(wishlistVC, animated: true)
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
    
    func verifypayment() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = [:]
            
            let apiUrl = BASE_URL + PROJECT_URL.VERIFY_PAYMENT + "tx_ref=\(self.txRef)" + "&transaction_id=abcdef" + "&cartId=\(UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.CART_ID) as! String)"
            let url : NSString = apiUrl as NSString
            let urlStr : NSString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! as NSString
            
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: urlStr as String, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
//                    self.orderSuccessView.isHidden = false
//                    self.customAlertView.removeFromSuperview()
                    globalCartItemsArr.removeAllObjects()
                    UserDefaults.standard.set(0, forKey: "cartCount")
                    let cartCount = ["userInfo": ["cartCount": globalCartItemsArr.count]]
                    NotificationCenter.default.post(name: NSNotification.Name("updateCartBadge"), object: nil, userInfo: cartCount)
                }
                else {
                    UIAlertController.showInfoAlertWithTitle("Message", message: json["message"].stringValue, buttonTitle: "Okay")
                }
            }, errorBlock: { (NSError) in
//                self.orderFailureView.isHidden = false
                UIAlertController.showInfoAlertWithTitle("Alert", message: kUnexpectedErrorAlertString, buttonTitle: "Okay")
                hideAllProgressOnView(appDelegateInstance.window!)
            })
            
        }else{
            hideAllProgressOnView(appDelegateInstance.window!)
            UIAlertController.showInfoAlertWithTitle("Alert", message: "Please Check internet connection", buttonTitle: "Okay")
        }
    }
    
    func tranasctionSuccessful(flwRef: String?, responseData: [String : Any]?) {
        
//        var customerDict = [String:Any]()
//       // print(responseData)
//
//        //        guard responseData != nil else {
//        //                   print("Age is undefined")
//        //                   return
//        //                 }
//
//        if responseData != nil{
//
//            if responseData!["customer"] != nil
//            {
//                customerDict = responseData!["customer"] as! [String : Any]
//
//                self.status = responseData!["status"] as! String
//                //self.merchantbearsfee = responseData!["merchantbearsfee"] as! Int
//                //self.orderRef = responseData!["orderRef"] as! String
//                self.transactionId = customerDict["AccountId"] as! Int
//                self.refNo = responseData!["txRef"] as! String
//
//            }
//            else
//            {
//                let infoDict = responseData!["tx"]
//                let jsonData = convertDictionaryToJsonData(infoDict: infoDict as! NSDictionary)
//                if let json = convertJsonDataToSwiftyJSon(jsonData: jsonData)
//                {
//                    print(json)
//                    self.status = json["status"].stringValue
//                    self.transactionId = json["customer"]["AccountId"].intValue
//                    self.refNo = json["txRef"].stringValue
//                }
//            }
//
//            print("\(responseData!)")
//            //print("$$$$$$$$$$$$$$$$$$$$$$$$$$\n\(self.status)\n\()\n\(self.orderRef)\n\(self.amountString)\n\(self.feesType)\n\(self.transactionId)")
//            self.paymentDetailApi(transactionID: String(self.transactionId), feesType: self.feesType, status: self.status, refNumber: self.refNo, amount: self.amountString,feesCurrency: self.currencyCode)
//        }
        self.verifypayment()
        
        
        
    }
    
    func tranasctionFailed(flwRef: String?, responseData: [String : Any]?)
    {
        print ("payment failed")
    }

}

extension ChoosePaymentVC : RavePayProtocol {
 
    func onDismiss() {
        print ("payment dismissed")
    }
    func paymentAction(email:String,phoneNumber:String, firstName: String, lastName:String, amount:String,ref:String)
    {
        let config = RaveConfig.sharedConfig()
        //config.country = "NG" // Country Code
        config.isPreAuth = false
        config.currencyCode = "NGN" //"NGN" // Currency
        config.email = email // Customer's email
        config.isStaging = false //For Live
        
        // Toggle this for staging and live environment //== true use for testing
        //config.isStaging = true //For testing
        
        
        config.phoneNumber = phoneNumber // Phone number
        config.transcationRef = ref // transaction ref
        config.firstName = firstName
        config.lastName = lastName
        config.meta = [["metaname":"sdk", "metavalue":"ios"]]
        
//        config.subAccounts = [SubAccount.init(id: self.subAccNumber, ratio: 1, charge_type: SubAccountChargeType.init(rawValue: "flat"), charge: 0.0)]

        
//        config.publicKey = "FLWPUBK_TEST-762735fda598e687d7c1d33e89f2c8ab-X" //Public key
//        config.encryptionKey = "FLWSECK_TESTadf7025e4f28" //Encryption key
        config.publicKey = self.publicKey //Public key
        config.encryptionKey = self.encryptionKey //Encryption key
        let controller = NewRavePayViewController()
        let nav = UINavigationController(rootViewController: controller)
        controller.amount = amount //"[amount]"
        controller.delegate = self
        self.present(nav, animated: true)
    }
}
