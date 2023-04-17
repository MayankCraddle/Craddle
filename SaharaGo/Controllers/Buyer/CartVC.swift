//
//  CartVC.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 03/08/22.
//

import UIKit
//import RaveSDK
import FlutterwaveSDK
import RaveSDK

class CartVC: UIViewController {

    @IBOutlet weak var orderFailureView: UIView!
    @IBOutlet weak var orderSuccessView: UIView!
    @IBOutlet weak var addressSubLbl: UILabel!
    @IBOutlet weak var addressMainLbl: UILabel!
    @IBOutlet weak var addressEmptyView: UIView!
    @IBOutlet weak var totalPriceLbl: UILabel!
    @IBOutlet weak var headerViewTwo: MyCustomHeaderView!
    @IBOutlet weak var headerViewOne: MyCustomHeaderView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var cartTableView: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var items: [Cart]?
    
    let objLogin = LoginVC()
    var finalItemDic: NSMutableDictionary = NSMutableDictionary()
    var cartProducts = [cartProductListStruct]()
    var cartItemsArr: NSMutableArray = NSMutableArray()
    var paramDicArr: NSMutableArray = NSMutableArray()
    var cartMetaDataDic: NSMutableDictionary = NSMutableDictionary()
    var orderMetaDataDic: NSMutableDictionary = NSMutableDictionary()
    var itemsArr: NSMutableArray = NSMutableArray()
    var totalAmount : Double = Double()
    var totalAmountIncludingShippingCharges : Double = Double()
    var deliverAddress = [address_Struct]()
    
    var secretKey = ""
    var txRef = ""
    var encryptionKey = ""
    var publicKey = ""
    
    let flutterLabel = UILabel()
    let exampleLabel = UILabel()
    let underLineView = UIView()
    let launchButton = UIButton(type: .system)
    
    var customAlertView : CustomAlertView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cartTableView.register(UINib(nibName: "CartCell", bundle: nil), forCellReuseIdentifier: "CartCell")
        
        AnalyticsUtil.instance.trackEvent(AnalyticsEvents.kCartViewed)
        
        self.getAddressAPI()
        
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
        
        guard let countryColorStr = UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.COUNTRY_COLOR_CODE) as? String else {return}
        guard let rgba = countryColorStr.slice(from: "(", to: ")") else { return }
        let myStringArr = rgba.components(separatedBy: ",")
        //        layer.cornerRadius = 6
        
        self.headerViewOne.backgroundColor = UIColor(red: CGFloat((myStringArr[0] as NSString).doubleValue/255.0), green: CGFloat((myStringArr[1] as NSString).doubleValue/255.0), blue: CGFloat((myStringArr[2] as NSString).doubleValue/255.0), alpha: CGFloat((myStringArr[3] as NSString).doubleValue))
        self.headerViewTwo.backgroundColor = UIColor(red: CGFloat((myStringArr[0] as NSString).doubleValue/255.0), green: CGFloat((myStringArr[1] as NSString).doubleValue/255.0), blue: CGFloat((myStringArr[2] as NSString).doubleValue/255.0), alpha: CGFloat((myStringArr[3] as NSString).doubleValue))
        
        do {
            self.items = try context.fetch(Cart.fetchRequest())
        } catch {

        }
        
        self.emptyView.isHidden = globalCartProducts.count == 0 ? false : true
        self.createGlobalCartMetaDataDic()
        self.getCartDetailOfUser()

    }
    
    func setAddress() {
        let info = self.deliverAddress[0]
        self.addressMainLbl.text = "\(info.firstName) \(info.lastName)"
        self.addressSubLbl.text = "\(info.streetAddress),\nMobile: \(info.phone), \n\(info.state), \(info.city),\n\(info.country)"
        self.orderMetaDataDic.setValue(info.id, forKey: "billingAddressId")
        self.orderMetaDataDic.setValue(info.id, forKey: "shippingAddressId")
    }
    
    @IBAction func backACTION(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func changeProductCount(index: Int, changeBy: Int64) {
        let productToChange = self.items![index]
        productToChange.stock += changeBy
        
        if productToChange.stock < 1 {
            self.context.delete(productToChange)
            
        }
        
        do {
            try self.context.save()
        } catch {
            
        }
        
    }
    
    func getCartDetailOfUser() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = [:]
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.USER_GET_CART_DETAIL_OF_USER, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    let items = json["metaData"]["items"].arrayValue
                    
                    UserDefaults.standard.setValue(json["cartSize"].intValue, forKey: "cartCount")
                    
//                    UserDefaults.standard.set(items.count, forKey: "cartCount")
                    UserDefaults.standard.setValue(json["cartId"].stringValue, forKey: USER_DEFAULTS_KEYS.CART_ID)
                    UserDefaults.standard.setValue(json["userId"].stringValue, forKey: USER_DEFAULTS_KEYS.USER_ID)
                    
                    self.cartProducts.removeAll()
                    globalCartProducts.removeAll()
                    globalCartItemsArr.removeAllObjects()
                    globalDbCartItemsArr.removeAllObjects()
                    self.paramDicArr.removeAllObjects()
                    do {
//                        let items =  try self.context.fetch(Cart.fetchRequest())
                        for item in self.items! {
                            self.context.delete(item)
                        }
                        try self.context.save()
                    } catch {
                        
                    }
                    
                    self.totalAmount = 0.0
                    
                    if json["metaData"]["items"].count > 0 {
                        for i in 0..<json["metaData"]["items"].count {
                            let productId =  json["metaData"]["items"][i]["productId"].stringValue
                            let itemId =  json["metaData"]["items"][i]["itemId"].stringValue
                            let quantity =  json["metaData"]["items"][i]["quantity"].stringValue
                            let minQuantity =  json["metaData"]["items"][i]["variantMetadata"]["minQuantity"].stringValue
                            let vendorEncryptedId =  json["metaData"]["items"][i]["vendorEncryptedId"].stringValue
                            let country =  json["metaData"]["items"][i]["country"].stringValue
                            let discountPercent =  json["metaData"]["items"][i]["discountPercent"].stringValue
                            let name =  json["metaData"]["items"][i]["name"].stringValue
                            let price =  json["metaData"]["items"][i]["price"].stringValue
                            let actualPrice =  json["metaData"]["items"][i]["actualPrice"].stringValue
                            let stock =  json["metaData"]["items"][i]["stock"].stringValue
                            let discountedPrice =  json["metaData"]["items"][i]["discountedPrice"].stringValue
                            let currency =  json["metaData"]["items"][i]["currency"].stringValue
                            let vendorId =  json["metaData"]["items"][i]["vendorId"].stringValue
                            let productWidth =  json["metaData"]["items"][i]["metaData"]["productWidth"].stringValue
                            let productHeight =  json["metaData"]["items"][i]["metaData"]["productHeight"].stringValue
                            let productLength =  json["metaData"]["items"][i]["metaData"]["productLength"].stringValue
                            let shortDescription =  json["metaData"]["items"][i]["metaData"]["shortDescription"].stringValue
                            let material =  json["metaData"]["items"][i]["metaData"]["material"].stringValue
                            let noOfPieces =  json["metaData"]["items"][i]["metaData"]["noOfPieces"].intValue
                            let rating =  json["metaData"]["items"][i]["metaData"]["rating"].intValue
                            let boxId =  json["metaData"]["items"][i]["metaData"]["boxId"].intValue
                            let dimensionUnit =  json["metaData"]["items"][i]["metaData"]["dimensionUnit"].stringValue
                            let description =  json["metaData"]["items"][i]["metaData"]["description"].stringValue
                            
                            var imgArr = [String]()
                            for j in 0..<json["metaData"]["items"][i]["metaData"]["images"].count {
                                
                                let file = json["metaData"]["items"][i]["metaData"]["images"][j].stringValue
                                imgArr.append(file)
                            }
                            
                            var itemTotalPrice = (Double(discountedPrice) ?? 0.0) * (Double(quantity) ?? 0.0)
                            self.totalAmount += itemTotalPrice
                            
                            self.cartProducts.append(cartProductListStruct.init(currency: currency, description: description, stock: stock, productId: productId, itemId: itemId, price: price, discountedPrice: discountedPrice, discountPercent: discountPercent, name: name, quantity: quantity, imagesArr: imgArr, vendorId: vendorId, noOfPieces: noOfPieces, productLength: productLength, productHeight: productHeight, productWidth: productWidth, shortDescription: shortDescription, material: material, dimensionUnit: dimensionUnit, boxId: boxId, rating: rating, country: country, vendorEncryptedId: vendorEncryptedId, actualPrice: actualPrice, minQuantity: minQuantity))
                                                        
                            
                            let itemDic: NSMutableDictionary = NSMutableDictionary()
                            itemDic.setValue(productId, forKey: "productId")
                            itemDic.setValue(quantity, forKey: "quantity")
                            itemDic.setValue(itemId, forKey: "itemId")
                            
                            self.cartItemsArr.add(itemDic)

                            
                            
                        }
                        globalCartProducts = self.cartProducts
//                        globalCartItemsArr = self.cartItemsArr
                    }
                    
                    self.emptyView.isHidden = globalCartProducts.count == 0 ? false : true
                    
                    
                    DispatchQueue.main.async {
                        self.cartTableView.reloadData()
                        self.totalPriceLbl.text = "₦\(self.totalAmount)"
                    }
                    
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
    
    func createGlobalCartMetaDataDic() {
        for i in 0..<self.items!.count {
            let itemDic: NSMutableDictionary = NSMutableDictionary()
            itemDic.setValue(self.items![i].itemId, forKey: "productId")
            itemDic.setValue(self.items![i].stock, forKey: "quantity")
            itemDic.setValue(self.items![i].itemId, forKey: "itemId")

            globalDbCartItemsArr.add(itemDic)
        }
        self.mergeCartApiandDbProducts()
    }
    
    private func isProductExistInCart(_ itemId: String) -> (Bool, Int) {
        var isExist = false
        var count = -1
        for i in 0..<globalCartItemsArr.count {
            count += 1
            let dbObj = globalCartItemsArr[i] as! NSMutableDictionary
            if itemId == dbObj.value(forKey: "itemId") as! String {
                isExist = true
                break
            }
        }
        return (isExist, count)
    }
    
    func mergeCartApiandDbProducts() {
        
        if globalDbCartItemsArr.count > 0 && globalCartItemsArr.count > 0 {
            
            for i in 0..<globalDbCartItemsArr.count {
                let dbInfo = globalDbCartItemsArr[i] as! NSMutableDictionary
                
                let isExist = self.isProductExistInCart(dbInfo.value(forKey: "itemId") as! String)
                
                if isExist.0 {
                    
                    //let dbCartInfo = dbInfo
                    let cartInfo = globalDbCartItemsArr[isExist.1] as! NSMutableDictionary
                    
                    let itemDic: NSMutableDictionary = NSMutableDictionary()
                    itemDic.setValue(cartInfo.value(forKey: "productId") as! String, forKey: "productId")
                    itemDic.setValue(cartInfo.value(forKey: "itemId") as! String, forKey: "itemId")
                    
                    let newQuantity = dbInfo.value(forKey: "quantity") as! Int64 + Int64(cartInfo.value(forKey: "quantity") as! String)!
                    
//                    let updatedCount = cartInfo.value(forKey: "quantity") as! Int64  + Int64(dbInfo.value(forKey: "quantity"))
                    itemDic.setValue(newQuantity, forKey: "quantity")
                    self.paramDicArr.add(itemDic)

                } else {
                    let itemDic: NSMutableDictionary = NSMutableDictionary()
                    itemDic.setValue(dbInfo.value(forKey: "productId") as! String, forKey: "productId")
                    itemDic.setValue(dbInfo.value(forKey: "itemId") as! String, forKey: "itemId")
                    itemDic.setValue(dbInfo.value(forKey: "quantity") as! String, forKey: "quantity")
                    self.paramDicArr.add(itemDic)
                }
            }
            self.finalItemDic.setValue(self.paramDicArr, forKey: "items")
            UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.CART_ID) != nil ? self.updateCartAPI() : self.saveCartApiCall()

        } else if globalDbCartItemsArr.count > 0 && globalCartItemsArr.count == 0 {
            self.finalItemDic.setValue(globalDbCartItemsArr, forKey: "items")
            print(self.finalItemDic)
            UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.CART_ID) != nil ? self.updateCartAPI() : self.saveCartApiCall()
        } else if globalDbCartItemsArr.count == 0 && globalCartItemsArr.count > 0 {
            self.finalItemDic.setValue(globalCartItemsArr, forKey: "items")
            print(self.finalItemDic)
            UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.CART_ID) != nil ? self.updateCartAPI() : self.saveCartApiCall()
        }
                
    }
    
    func saveCartApiCall() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:Any] = [ "metaData": self.finalItemDic]
            ServerClass.sharedInstance.postRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.USER_SAVE_CART, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    //save data in userdefault..
                    UserDefaults.standard.setValue(json["cartId"].stringValue, forKey: USER_DEFAULTS_KEYS.CART_ID)
//                    self.udCartId = json["cartId"].stringValue
                    self.view.makeToast("Cart saved.")
//                    UserDefaults.standard.set(globalCartItemsArr.count, forKey: "cartCount")
                    UserDefaults.standard.setValue(json["cartSize"].intValue, forKey: "cartCount")
                    let cartCount = ["userInfo": ["cartCount": globalCartItemsArr.count]]
                    NotificationCenter.default.post(name: NSNotification.Name("updateCartBadge"), object: nil, userInfo: cartCount)
//                    globalDbCartItemsArr.removeAllObjects()
                    self.finalItemDic.removeAllObjects()
                    self.getCartDetailOfUser()
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
    
    func updateCartAPI() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            var  apiUrl =  BASE_URL + PROJECT_URL.USER_UPDATE_CART
            apiUrl = apiUrl + "\(String(describing: UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.CART_ID)!))"
            
            let url : NSString = apiUrl as NSString
            let urlStr : NSString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! as NSString
            
            let param:[String:Any] = [ "metaData": self.finalItemDic]
            
            ServerClass.sharedInstance.putRequestWithUrlParameters(param, path: urlStr as String, successBlock: { [self] (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                
                if success == "true"
                {
                    self.view.makeToast(json["message"].stringValue)

//                    UserDefaults.standard.set(self.cartItemsArr.count, forKey: "cartCount")
                    UserDefaults.standard.setValue(json["cartSize"].intValue, forKey: "cartCount")
                    self.cartItemsArr.removeAllObjects()
                    self.finalItemDic.removeAllObjects()
                    
                    self.getCartDetailOfUser()
                    
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
    
    func removeCartItemsAPI(_ itemToRemove: String, index: Int) {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            var apiUrl = BASE_URL + PROJECT_URL.USER_REMOVE_ITEM_FROM_CART
            apiUrl = apiUrl + "\(UserDefaults.standard.object(forKey: USER_DEFAULTS_KEYS.CART_ID) ?? "")" + "/\(itemToRemove)"
            
            let param:[String:Any] = [:]
            
            ServerClass.sharedInstance.putRequestWithUrlParameters(param, path: apiUrl, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                
                if success == "true"
                {
                    self.view.makeToast(json["message"].stringValue)
                    
                    self.getCartDetailOfUser()
                    
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
    
    func getAddressAPI() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = [:]
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.USER_GET_ADDRESSES, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                //success == "true"
                if success == "true"
                {
                    self.deliverAddress.removeAll()
                    for i in 0..<json["addressList"].count {
                        let firstName =  json["addressList"][i]["metaData"]["firstName"].stringValue
                        let lastName =  json["addressList"][i]["metaData"]["lastName"].stringValue
                        let phone =  json["addressList"][i]["metaData"]["phone"].stringValue
                        let streetAddress =  json["addressList"][i]["metaData"]["streetAddress"].stringValue
                        let landmark =  json["addressList"][i]["metaData"]["landmark"].stringValue
                        let city =  json["addressList"][i]["metaData"]["city"].stringValue
                        let state =  json["addressList"][i]["metaData"]["state"].stringValue
                        let zipcode =  json["addressList"][i]["metaData"]["zipcode"].stringValue
                        let country =  json["addressList"][i]["metaData"]["country"].stringValue
                        let isDefault =  json["addressList"][i]["isDefault"].boolValue
                        let id =  json["addressList"][i]["id"].stringValue
                        let addressType =  json["addressList"][i]["metaData"]["addressType"].stringValue
                        
                        if isDefault {
                            self.deliverAddress.append(address_Struct.init(id: id, firstName: firstName, lastName: lastName, phone: phone, streetAddress: streetAddress, country: country, state: state, city: city, zipcode: zipcode, landmark: landmark, isDefault: isDefault, addressType: addressType))
                        }
//                        self.addressArr.append(address_Struct.init(id: id, firstName: firstName, lastName: lastName, phone: phone, streetAddress: streetAddress, country: country, state: state, city: city, zipcode: zipcode, landmark: landmark, isDefault: isDefault, addressType: addressType))
                        
                    }
                    
                    if self.deliverAddress.count > 0 {
                        self.addressEmptyView.isHidden = true
                        
                        self.setAddress()
                    } else {
                        self.addressEmptyView.isHidden = false
                    }
                                        
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
    
    func getShippingRate(_ shippingAddressId: String) {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
          
            let param:[String:Any] = ["cartId": UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.CART_ID) as! String,"shippingAddressId": shippingAddressId]
            ServerClass.sharedInstance.postRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.GET_SHIPPING_RATE_API, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    let shippingCost = json["shippingRate"].stringValue
                    var itemTotalPrice = (Double(shippingCost) ?? 0.0) + self.totalAmount
//                    self.totalAmount += itemTotalPrice
                    self.totalAmountIncludingShippingCharges = self.totalAmount
                    self.totalAmountIncludingShippingCharges += itemTotalPrice
                    
                    let param:[String:Any] = [ "cartId": UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.CART_ID)!,"cartMetaData":self.cartMetaDataDic,"totalPrice": "\(self.totalAmountIncludingShippingCharges)", "orderMetaData": self.orderMetaDataDic]
                    
                    let cartVC = DIConfigurator.shared.getChoosePaymentVC()
                    cartVC.param = param
                    cartVC.shippingCost = "₦\(shippingCost)"
                    cartVC.subTotalCost = "₦\(self.totalAmount)"
                    cartVC.totalCost = "₦\(itemTotalPrice)"
                    cartVC.totalAmountIncludingShippingCharges = self.totalAmountIncludingShippingCharges
                    cartVC.cartProducts = self.cartProducts
                    cartVC.cartMetaDataDic = self.cartMetaDataDic
                    cartVC.itemsArr = self.itemsArr
                    let addressInfo = self.deliverAddress[0]
                    cartVC.addressTxt = "\(addressInfo.firstName) \(addressInfo.lastName)"
                    cartVC.addressSubTxt = "\(addressInfo.streetAddress),\nMobile: \(addressInfo.phone), \n\(addressInfo.state), \(addressInfo.city),\n\(addressInfo.country)"
                    self.navigationController?.pushViewController(cartVC, animated: true)
                    
//                    self.customAlertView = CustomAlertView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
//                            self.customAlertView.subTotalLbl.text = "₦\(self.totalAmount)"
//                            self.customAlertView.shippingLbl.text = "₦\(shippingCost)"
//                            self.customAlertView.totalLbl.text = "₦\(itemTotalPrice)"
//                            self.customAlertView.okButton.addTarget(self, action: #selector(self.okButtonPressed), for: .touchUpInside)
//
//                    self.view.addSubview(self.customAlertView)
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
    
    @IBAction func checkoutAction(_ sender: UIButton) {
        if self.deliverAddress.count == 0 {
            self.view.makeToast("Please select your Delivery Address.")
            return
        } else if globalCartProducts.count == 0 {
            self.view.makeToast("Please add items to your cart.")
            return
        }
        AnalyticsUtil.instance.trackEvent(AnalyticsEvents.kCheckoutClicked)
        self.getShippingRate(self.deliverAddress[0].id)
        
        
//        if globalCartProducts.count > 0 {
//            self.createDataForOrder()
//        } else {
//            self.view.makeToast("Please add items to your cart.")
//        }
        
    }
    
    @objc func okButtonPressed() {
        print("Ok Button pressed.")
        AnalyticsUtil.instance.trackEvent(AnalyticsEvents.kShippingRateAccepted)
//        self.createDataForOrder()
    }
    
    @IBAction func addAddressAction(_ sender: UIButton) {
        AnalyticsUtil.instance.trackEvent(AnalyticsEvents.kChangeAddressClicked)
        let productDetailVC = DIConfigurator.shared.getAddressVC()
        
        productDetailVC.completionHandlerCallback = {(attributesDic: address_Struct!)->Void in
            self.deliverAddress.removeAll()
            
            self.orderMetaDataDic.setValue(attributesDic.id, forKey: "billingAddressId")
            self.orderMetaDataDic.setValue(attributesDic.id, forKey: "shippingAddressId")
            
            self.deliverAddress.append(address_Struct.init(id: attributesDic.id, firstName: attributesDic.firstName, lastName: attributesDic.lastName, phone: attributesDic.phone, streetAddress: attributesDic.streetAddress, country: attributesDic.country, state: attributesDic.state, city: attributesDic.city, zipcode: attributesDic.zipcode, landmark: attributesDic.landmark, isDefault: attributesDic.isDefault))
            
            if self.deliverAddress.count > 0 {
                self.addressEmptyView.isHidden = true
                self.setAddress()
            } else {
                self.addressEmptyView.isHidden = false
            }
            
        }
        self.navigationController?.pushViewController(productDetailVC, animated: true)
    }
    
    

    

    
    func wishlistAPI(_ itemId: String) {
        
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:Any] = [ "itemId": itemId]
            ServerClass.sharedInstance.postRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.USER_ADD_TO_WISHLIST, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    
                    self.view.makeToast("Product added to wishlist.")
                    self.removeCartItemsAPI(itemId, index: 0)
                                        
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
     
    func showExample(){
        let config = FlutterwaveConfig.sharedConfig()
        config.paymentOptionsToExclude = []
        config.currencyCode = "NGN" // This is the specified currency to charge in.
        config.email = "user@flw.com" // This is the email address of the customer
        config.isStaging = false // Toggle this for staging and live environment
//        config.phoneNumber = "077883***1" //Phone number
        config.transcationRef = self.txRef // This is a unique reference, unique to the particular transaction being carried out. It is generated when it is not provided by the merchant for every transaction.
        config.firstName = "Yemi" // This is the customers first name.
        config.lastName = "Desola" //This is the customers last name.
        config.meta = [["metaname":"sdk", "metavalue":"ios"]] //This is used to include additional payment information
        config.narration = "simplifying payments for endless possibilities"
        //       config.publicKey = "[PUB_KEY]" //Public key
        //       config.encryptionKey = "[ENCRYPTION_KEY]" //Encryption key
        config.publicKey = self.publicKey //Public key
        config.encryptionKey = self.encryptionKey //Encryption key
        config.isPreAuth = false  // This should be set to true for preauthorize card transactions
        let controller = FlutterwavePayViewController()
        let nav = UINavigationController(rootViewController: controller)
        controller.amount = "\(self.totalAmount)" // This is the amount to be charged. //.abs()
//        controller.delegate = self
        self.present(nav, animated: true)
    }

    func tranasctionSuccessful(flwRef: String?, responseData: FlutterwaveDataResponse?) {
        print("Transaction Succes")
    }
    
    func tranasctionFailed(flwRef: String?, responseData: FlutterwaveDataResponse?) {
        print("Transaction Failed")
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
    
    
}

extension CartVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.VENDOR_SIGNUP_TOKEN) != nil {
            return globalCartProducts.count
        } else {
            return items?.count ?? 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartCell
        
        cell.increaseCountBtn.tag = indexPath.row
        cell.decreaseCountBtn.tag = indexPath.row
        cell.wishlistBtn.tag = indexPath.row
        cell.cellRemoveBtn.tag = indexPath.row
        
        if UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.VENDOR_SIGNUP_TOKEN) != nil {
            
            let info = globalCartProducts[indexPath.row]
            cell.setCartData(info)
            
            cell.onClickIncreaseCountClosure = { index, changeBy in
//                let tappedObj = self.cartItemsArr[index!] as! NSMutableDictionary
                let tappedObj = globalCartProducts[index!]
                if (tappedObj.quantity as NSString).intValue + (Int32(changeBy!)) > (tappedObj.stock as NSString).intValue {
                    self.view.makeToast("Only \((tappedObj.stock as NSString).intValue) items available in stock.")
                    return
                }
                let updatedCount = (tappedObj.quantity as NSString).intValue + (Int32(changeBy!))
                
                if updatedCount < (tappedObj.minQuantity as NSString).intValue {
                    self.showAlertWithActions("Are you sure you want to remove this product from Cart?", titles: ["Yes", "No"]) { (value) in
                        if value == 1{
                            // delete product from cart
                            self.removeCartItemsAPI(tappedObj.itemId, index: index!)
                        }
                    }
                } else {
                    
                    for i in 0..<globalCartProducts.count {
                        if (tappedObj.itemId as NSString) as String == globalCartProducts[i].itemId {
                            let itemDic: NSMutableDictionary = NSMutableDictionary()
                            itemDic.setValue(globalCartProducts[i].productId, forKey: "productId")
                            itemDic.setValue("\(Int(updatedCount))", forKey: "quantity")
                            itemDic.setValue(globalCartProducts[i].itemId, forKey: "itemId")
                            
                            self.paramDicArr.add(itemDic)
                        } else {
                            let itemDic: NSMutableDictionary = NSMutableDictionary()
                            itemDic.setValue(globalCartProducts[i].productId, forKey: "productId")
                            itemDic.setValue(globalCartProducts[i].quantity, forKey: "quantity")
                            itemDic.setValue(globalCartProducts[i].itemId, forKey: "itemId")
                            
                            self.paramDicArr.add(itemDic)
                        }
                    }
                    
                    
                    self.finalItemDic.setValue(self.paramDicArr, forKey: "items")
                    print(self.finalItemDic)
                    self.updateCartAPI()

                }
                
            }
            
            cell.onClickMoveToWishlistClosure = { index in
//                let tappedObj = self.cartItemsArr[index!] as! NSMutableDictionary
                let tappedObj = globalCartProducts[index!]
                self.wishlistAPI(tappedObj.itemId)
                
            }
            
            cell.onClickRemoveFromCartClosure = { index in
                self.showAlertWithActions("Are you sure you want to remove this product from Cart?", titles: ["Yes", "No"]) { (value) in
                    if value == 1{
                        // delete product from cart
                        let tappedObj = globalCartProducts[index!]
                        self.removeCartItemsAPI(tappedObj.itemId, index: index!)
                    }
                }
                
                
            }
            
        } else {
            let cartData = items![indexPath.row]
            cell.cellProductLbl.text = cartData.name
            cell.cellProductCountLbl.text = "\(cartData.stock)"
            cell.cellPriceLbl.text = "USD \(cartData.price)"
            
            
            
            cell.onClickIncreaseCountClosure = { index, changeBy in
                if let indexp = index {
                    self.changeProductCount(index: indexp, changeBy: Int64(changeBy ?? 0))
                }
            }
            
            
        }
        
        cell.selectionStyle = .none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let productDetailVC = DIConfigurator.shared.getProductDetailVC()
        let info = globalCartProducts[indexPath.row]
        productDetailVC.itemID = info.itemId
        productDetailVC.productID = info.productId
        productDetailVC.vendorID = info.vendorId
        self.navigationController?.pushViewController(productDetailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    
}


