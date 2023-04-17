//
//  CatProductsVC.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 29/08/22.
//

import UIKit
import CountryPickerView

class CatProductsVC: UIViewController {
    
    @IBOutlet weak var countryNameLbl: UILabel!
    @IBOutlet weak var previousHeaderView: UIView!
    @IBOutlet weak var cartBadgeLbl: UILabel!
    @IBOutlet weak var cartBadgeView: UIView!
    @IBOutlet weak var headerViewTwo: MyCustomHeaderView!
    @IBOutlet weak var headerViewOne: MyCustomHeaderView!
    @IBOutlet weak var searchTxt: UITextField!
    @IBOutlet weak var searchViewWidth: NSLayoutConstraint!
    @IBOutlet weak var searchCloseBtn: UIButton!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var flagImg: UIImageView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var collView: UICollectionView!
    
    var catId: String = String()
    var categoriesProductListArr = [categoryProductListStruct]()
    var categoriesProductListArrCopy = [categoryProductListStruct]()
    private let itemsPerRow: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(
        top: 15.0,
        left: 20.0,
        bottom: 50.0,
        right: 20.0)
    
    var dbItemsArr: NSMutableArray = NSMutableArray()
    var finalItemDic: NSMutableDictionary = NSMutableDictionary()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        AnalyticsUtil.instance.trackEvent(AnalyticsEvents.kCategoryProductsScreen)
        searchTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        NotificationCenter.default.addObserver(self, selector: #selector(updateCartBadge(_:)), name: Notification.Name("updateCartBadge"), object: nil)

        self.getCategoriesProductsList(catId: self.catId, country: country, searchStr: "", batchSize: "100", sort: "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.setCartBadge()
        self.navigationController?.navigationBar.isHidden = true
//        let flag = UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.SELECTED_FLAG) as! String
        let flag = "nigeria.png"
        let imageUrl = FLAG_BASE_URL + "/" + flag
//        self.flagImg.sd_setImage(with: URL(string: imageUrl), completed: nil)
        if let data = try? Data(contentsOf: URL(string: imageUrl)!) {
                // Create Image and Update Image View
                flagImg.image = UIImage(data: data)
            }
//        self.countryNameLbl.text = "\(UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.SELECTED_COUNTRY) as! String)"
        self.countryNameLbl.text = "Nigeria"
        guard let countryColorStr = UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.COUNTRY_COLOR_CODE) as? String else {return}
        guard let rgba = countryColorStr.slice(from: "(", to: ")") else { return }
        let myStringArr = rgba.components(separatedBy: ",")
        //        layer.cornerRadius = 6
        
        self.headerViewOne.backgroundColor = UIColor(red: CGFloat((myStringArr[0] as NSString).doubleValue/255.0), green: CGFloat((myStringArr[1] as NSString).doubleValue/255.0), blue: CGFloat((myStringArr[2] as NSString).doubleValue/255.0), alpha: CGFloat((myStringArr[3] as NSString).doubleValue))
        self.headerViewTwo.backgroundColor = UIColor(red: CGFloat((myStringArr[0] as NSString).doubleValue/255.0), green: CGFloat((myStringArr[1] as NSString).doubleValue/255.0), blue: CGFloat((myStringArr[2] as NSString).doubleValue/255.0), alpha: CGFloat((myStringArr[3] as NSString).doubleValue))
        self.previousHeaderView.backgroundColor = UIColor(red: CGFloat((myStringArr[0] as NSString).doubleValue/255.0), green: CGFloat((myStringArr[1] as NSString).doubleValue/255.0), blue: CGFloat((myStringArr[2] as NSString).doubleValue/255.0), alpha: CGFloat((myStringArr[3] as NSString).doubleValue))
    }
    
    @objc func updateCartBadge(_ notification: Notification) {
        if let cartCount = UserDefaults.standard.value(forKey: "cartCount") as? Int {
            self.cartBadgeView.isHidden = false
            self.cartBadgeLbl.text = "\(cartCount)"
        } else {
            self.cartBadgeView.isHidden = true
        }
        
    }

    func setCartBadge() {
        if let cartCount = UserDefaults.standard.value(forKey: "cartCount") as? Int {
            self.cartBadgeView.isHidden = false
            self.cartBadgeLbl.text = "\(cartCount)"
        } else {
            self.cartBadgeView.isHidden = true
        }
        
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    

    func getCategoriesProductsList(catId: String, country: String, searchStr: String, batchSize: String, sort: String) {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            //{country}/{pageNumber}/{limit}?categoryId=&search=&sort=
            var  apiUrl =  BASE_URL + PROJECT_URL.USER_GET_PRODUCTS
            apiUrl = apiUrl + "1/" + "\(batchSize)" + "?country=\(country)" + "&categoryId=\(catId)" + "&search=\(searchStr)" + "&sort=\(sort)"
            
            let url : NSString = apiUrl as NSString
            let urlStr : NSString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! as NSString
            
            
            // api/v1/user/getProducts/{country}/{pageNumber}/{limit}?categoryId=&search=&sort=
            let param:[String:String] = [:]
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: urlStr as String, successBlock: { (json) in
                print(json)
                
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    self.categoriesProductListArr.removeAll()
                    self.categoriesProductListArrCopy.removeAll()
                    
                    for i in 0..<json["productList"].count
                    {
                        let currency = json["productList"][i]["currency"].stringValue
                        let description = json["productList"][i]["metaData"]["description"].stringValue
                        let category = json["productList"][i]["category"].stringValue
                        let stock = json["productList"][i]["stock"].stringValue
                        let actualPrice = json["productList"][i]["actualPrice"].stringValue
                        let productId = json["productList"][i]["productId"].stringValue
                        let itemId = json["productList"][i]["itemId"].stringValue
                        let price = json["productList"][i]["price"].stringValue
                        let discountedPrice = json["productList"][i]["discountedPrice"].stringValue
                        let rating = json["productList"][i]["rating"].stringValue
                        
                        let discountPercent = json["productList"][i]["discountValue"].stringValue
                        let name = json["productList"][i]["name"].stringValue
                        let vendorId = json["productList"][i]["vendorId"].stringValue
                        let orderable = json["productList"][i]["orderable"].boolValue
                        
                        
                        var imgArr = [String]()
                        for j in 0..<json["productList"][i]["metaData"]["images"].count {
                            
                            let file = json["productList"][i]["metaData"]["images"][j].stringValue
                            imgArr.append(file)
                        }
                        
                        let variants = json["productList"][i]["variants"].arrayValue
                        var minQuantity = ""
                        if variants.count > 0 {
                            minQuantity = json["productList"][i]["variants"][0]["minQuantity"].stringValue
                        }
                                                
                        self.categoriesProductListArr.append(categoryProductListStruct.init(currency: currency, description: description, category: category, stock: stock, productId: productId, itemId: itemId, price: price, discountedPrice: discountedPrice, discountPercent: discountPercent, rating: rating, name: name, images: imgArr, actualPrice: actualPrice, orderable: orderable, vendorId: vendorId, minQuantity: minQuantity))
                        
                    }
                    
                    self.categoriesProductListArrCopy = self.categoriesProductListArr
                    
                    print(self.categoriesProductListArr)
                    if self.categoriesProductListArrCopy.count > 0 {
                        self.collView.isHidden = false
                        self.emptyView.isHidden = true
                    } else {
                        self.collView.isHidden = true
                        self.emptyView.isHidden = false
                    }
                    
                    DispatchQueue.main.async {
                        self.collView.reloadData()
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
    
    @IBAction func cellAddToCartAction(_ sender: UIButton) {
        if UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.VENDOR_SIGNUP_TOKEN) != nil {
            let indexPath: IndexPath? = collView.indexPathForItem(at: sender.convert(CGPoint.zero, to: collView))
            let info = self.categoriesProductListArrCopy[indexPath!.row]
            
            
            
    //        self.getCartDetailOfUser(info)
            if !info.orderable {
                self.view.makeToast("Item not available for Online purchase")
                return
            }
            self.getCartDetailOfUser(info)
//            self.getCartDetailOfUserFromMainAddToCartDuplicate(info)
        } else {
            let vc = DIConfigurator.shared.getLoginVC()
            vc.sendTo = "ViewAllProductsVC"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
        
        
//        let indexPath: IndexPath? = collView.indexPathForItem(at: sender.convert(CGPoint.zero, to: collView))
//        let info = self.categoriesProductListArrCopy[indexPath!.row]
//
//        self.getCartDetailOfUser(info)
        
    }
    
    func getCartDetailOfUserFromMainAddToCartDuplicate(_ cartProductsInfo: categoryProductListStruct) {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = [:]
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.USER_GET_CART_DETAIL_OF_USER, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    
                    UserDefaults.standard.setValue(json["cartId"].stringValue, forKey: USER_DEFAULTS_KEYS.CART_ID)
                    UserDefaults.standard.setValue(json["userId"].stringValue, forKey: USER_DEFAULTS_KEYS.USER_ID)
                    globalCartProducts.removeAll()
                    globalCartItemsArr.removeAllObjects()
                    if json["metaData"]["items"].count > 0 {
                        for i in 0..<json["metaData"]["items"].count {
                            let productId =  json["metaData"]["items"][i]["productId"].stringValue
                            let itemId =  json["metaData"]["items"][i]["itemId"].stringValue
                            let quantity =  json["metaData"]["items"][i]["quantity"].stringValue
                            let discountPercent =  json["metaData"]["items"][i]["discountValue"].stringValue
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
                        }
                    }
                    
                    let isAvailable = self.isAvailableInCart(cartProductsInfo.itemId)
                    if isAvailable.0 {
                        let selectedProduct = globalCartItemsArr[isAvailable.1] as! NSMutableDictionary
                        let quantity = selectedProduct.value(forKey: "quantity") as! String
                        let updatedQuanity = Int(quantity)! + 1
                        let stock = Int(globalCartProducts[isAvailable.1].stock)!
                        if updatedQuanity > stock {
                            self.view.makeToast("Only \(stock) items available in stock.")
                            return
                        }
                        let itemDic: NSMutableDictionary = NSMutableDictionary()
                        itemDic.setValue(cartProductsInfo.productId, forKey: "productId")
                        itemDic.setValue("\(updatedQuanity)", forKey: "quantity")
                        itemDic.setValue(cartProductsInfo.itemId, forKey: "itemId")
                        globalCartItemsArr.removeObject(at: isAvailable.1)
                        globalCartItemsArr.insert(itemDic, at: isAvailable.1)
                        self.finalItemDic.setValue(globalCartItemsArr, forKey: "items")
                    } else {
                        let itemDic: NSMutableDictionary = NSMutableDictionary()
                        itemDic.setValue(cartProductsInfo.productId, forKey: "productId")
                        itemDic.setValue(cartProductsInfo.minQuantity, forKey: "quantity")
                        itemDic.setValue(cartProductsInfo.itemId, forKey: "itemId")
                        globalCartItemsArr.add(itemDic)
                        self.finalItemDic.setValue(globalCartItemsArr, forKey: "items")
                    }
                    
                    UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.CART_ID) as! String != "" ? self.updateCartAPI() : self.saveCartApiCall()
                    
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
    
    func getCartDetailOfUser(_ cartProductsInfo: categoryProductListStruct) {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = [:]
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.USER_GET_CART_DETAIL_OF_USER, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    
                    UserDefaults.standard.setValue(json["cartId"].stringValue, forKey: USER_DEFAULTS_KEYS.CART_ID)
                    UserDefaults.standard.setValue(json["userId"].stringValue, forKey: USER_DEFAULTS_KEYS.USER_ID)
                    globalCartProducts.removeAll()
                    globalCartItemsArr.removeAllObjects()
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
                        }
                    }
                    
                    let isAvailable = self.isAvailableInCart(cartProductsInfo.itemId)
                    if isAvailable.0 {
                        let selectedProduct = globalCartItemsArr[isAvailable.1] as! NSMutableDictionary
                        let quantity = selectedProduct.value(forKey: "quantity") as! String
                        let updatedQuanity = Int(quantity)! + 1
                        let stock = Int(globalCartProducts[isAvailable.1].stock)!
                        if updatedQuanity > stock {
                            self.view.makeToast("Only \(stock) items available in stock.")
                            return
                        }
                        let itemDic: NSMutableDictionary = NSMutableDictionary()
                        itemDic.setValue(cartProductsInfo.productId, forKey: "productId")
                        itemDic.setValue("\(updatedQuanity)", forKey: "quantity")
                        itemDic.setValue(cartProductsInfo.itemId, forKey: "itemId")
                        globalCartItemsArr.removeObject(at: isAvailable.1)
                        globalCartItemsArr.insert(itemDic, at: isAvailable.1)
                        self.finalItemDic.setValue(globalCartItemsArr, forKey: "items")
                    } else {
                        let itemDic: NSMutableDictionary = NSMutableDictionary()
                        itemDic.setValue(cartProductsInfo.productId, forKey: "productId")
                        itemDic.setValue(cartProductsInfo.minQuantity, forKey: "quantity")
                        itemDic.setValue(cartProductsInfo.itemId, forKey: "itemId")
                        globalCartItemsArr.add(itemDic)
                        self.finalItemDic.setValue(globalCartItemsArr, forKey: "items")
                    }
                    
                    UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.CART_ID) != nil ? self.updateCartAPI() : self.saveCartApiCall()
                    
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
    
    func isAvailableInCart(_ itemId: String) -> (Bool, Int) {
        var index = -1
        var isAvailble = false
        for items in globalCartItemsArr {
            index += 1
            let item  = items as! NSMutableDictionary
            if (item.value(forKey: "itemId") as! NSString) as String == itemId {
                isAvailble = true
                break
            }
        }
        return (isAvailble, index)
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
                    NotificationCenter.default
                        .post(name:           NSNotification.Name("updateCartBadge"),
                              object: nil,
                              userInfo: cartCount)
                    self.dbItemsArr.removeAllObjects()
                    self.finalItemDic.removeAllObjects()
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

//                    UserDefaults.standard.set(self.dbItemsArr.count, forKey: "cartCount")
//                    UserDefaults.standard.set(globalCartItemsArr.count, forKey: "cartCount")
                    UserDefaults.standard.setValue(json["cartSize"].intValue, forKey: "cartCount")
                    let cartCount = ["userInfo": ["cartCount": globalCartItemsArr.count]]
                    NotificationCenter.default
                        .post(name:           NSNotification.Name("updateCartBadge"),
                              object: nil,
                              userInfo: cartCount)
                    self.dbItemsArr.removeAllObjects()
                    self.finalItemDic.removeAllObjects()
                    
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

    @IBAction func flagAction(_ sender: UIButton) {
//        let sellerStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = sellerStoryboard.instantiateViewController(withIdentifier: "ChooseCountryVC") as! ChooseCountryVC
//        vc.delegate = self
//        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func onClickSearch(_ sender: UIButton) {
//        print("Search Tapped")
        UIView.animate(withDuration: 0.1) {
            self.searchView.isHidden = false
            self.searchCloseBtn.isHidden = false
            self.headerView.isHidden = true
            self.searchViewWidth.constant = UIScreen.main.bounds.width-100

            self.view.layoutIfNeeded()
        }

        searchTxt.becomeFirstResponder()
        
//        let cartVC = DIConfigurator.shared.getExploreVC()
//        cartVC.isFromProductSearch = true
//        self.navigationController?.pushViewController(cartVC, animated: true)
        
    }
    
    @IBAction func onClickCart(_ sender: UIButton) {
        if UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.VENDOR_SIGNUP_TOKEN) != nil {
            let cartVC = DIConfigurator.shared.getCartVC()
            self.navigationController?.pushViewController(cartVC, animated: true)
        } else {
            let vc = DIConfigurator.shared.getLoginVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func searchCloseAction(_ sender: UIButton) {
        print("Close Search Tapped")
        searchTxt.text = ""
        searchTxt.resignFirstResponder()
        
        UIView.animate(withDuration: 0.1) {
            self.searchView.isHidden = true
            self.searchCloseBtn.isHidden = true
            self.headerView.isHidden = false
            
            self.searchViewWidth.constant = 0
            
            self.view.layoutIfNeeded()
        }
        
        self.categoriesProductListArrCopy = categoriesProductListArr
        
        DispatchQueue.main.async {
            self.collView.reloadData()
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        self.categoriesProductListArrCopy = categoriesProductListArr
        if searchTxt.text!.isEmpty {
            self.categoriesProductListArrCopy = categoriesProductListArr
        } else {
            self.categoriesProductListArrCopy = self.categoriesProductListArrCopy.filter({ (item) -> Bool in
                return item.name.contains(searchTxt.text!)
            })
            
            //                self.CountryList = self.CountryList.sorted(by: { (i1, i2) -> Bool in
            //                    return i1.countryName.contains(searchText)
            //                })
            
        }
        
        DispatchQueue.main.async {
            self.collView.reloadData()
        }
        
    }
    
}

extension CatProductsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categoriesProductListArrCopy.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CatProductsCollCell", for: indexPath) as! CatProductsCollCell
        
        cell.increaseCountBtn.tag = indexPath.row
        cell.decreaseCountBtn.tag = indexPath.row
        
        let info = self.categoriesProductListArrCopy[indexPath.row]
        cell.cellLbl.text = info.name
        cell.cellPriceLbl.text = "₦\(info.discountedPrice)"
        if info.images!.count > 0 {
            cell.cellImg.sd_setImage(with: URL(string: FILE_BASE_URL + "/\(info.images![0])"), placeholderImage: UIImage(named: "loading"))
        } else {
            cell.cellImg.image = UIImage(named: "loading")
        }

        cell.onClickIncreaseCountClosure = { index, changeBy in
            if let indexp = index {
//                self.changeProductCount(index: indexp, changeBy: Int64(changeBy ?? 0))
            }
        }

        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productDetailVC = DIConfigurator.shared.getProductDetailVC()
//        productDetailVC.productDetails = self.categoriesProductListArr[indexPath.row]
        let info = self.categoriesProductListArrCopy[indexPath.row]
        productDetailVC.itemID = info.itemId
        productDetailVC.productID = info.productId
        productDetailVC.vendorID = info.vendorId
        self.navigationController?.pushViewController(productDetailVC, animated: true)
    }
    
}

extension CatProductsVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let collectionWidth = collectionView.bounds.width
    //        return CGSize(width: (UIScreen.main.bounds.size.width - 30) / 2.0, height: (UIScreen.main.bounds.size.height))
        return CGSize(width: ((collectionWidth - 10)/2), height: 270)
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 10
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 5
        }
    
}

extension CatProductsVC: ChooseCountryDelegate{
    func onSelectCountry(country: Select_Country_List_Struct, isFrom: String) {
        let flag = UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.SELECTED_FLAG) as! String
        let imageUrl = FLAG_BASE_URL + "/" + flag
//        self.flagImg.sd_setImage(with: URL(string: imageUrl), completed: nil)
        if let data = try? Data(contentsOf: URL(string: imageUrl)!) {
                // Create Image and Update Image View
                flagImg.image = UIImage(data: data)
            }
        self.countryNameLbl.text = "\(country.countryName)"
        let countryColorStr = country.colorCode
        guard let rgba = countryColorStr.slice(from: "(", to: ")") else { return }
        let myStringArr = rgba.components(separatedBy: ",")
        //        layer.cornerRadius = 6
        
        self.headerViewOne.backgroundColor = UIColor(red: CGFloat((myStringArr[0] as NSString).doubleValue/255.0), green: CGFloat((myStringArr[1] as NSString).doubleValue/255.0), blue: CGFloat((myStringArr[2] as NSString).doubleValue/255.0), alpha: CGFloat((myStringArr[3] as NSString).doubleValue))
        self.headerViewTwo.backgroundColor = UIColor(red: CGFloat((myStringArr[0] as NSString).doubleValue/255.0), green: CGFloat((myStringArr[1] as NSString).doubleValue/255.0), blue: CGFloat((myStringArr[2] as NSString).doubleValue/255.0), alpha: CGFloat((myStringArr[3] as NSString).doubleValue))
        self.previousHeaderView.backgroundColor = UIColor(red: CGFloat((myStringArr[0] as NSString).doubleValue/255.0), green: CGFloat((myStringArr[1] as NSString).doubleValue/255.0), blue: CGFloat((myStringArr[2] as NSString).doubleValue/255.0), alpha: CGFloat((myStringArr[3] as NSString).doubleValue))
        countryColor = UIColor(red: CGFloat((myStringArr[0] as NSString).doubleValue/255.0), green: CGFloat((myStringArr[1] as NSString).doubleValue/255.0), blue: CGFloat((myStringArr[2] as NSString).doubleValue/255.0), alpha: CGFloat((myStringArr[3] as NSString).doubleValue))
        self.getCategoriesProductsList(catId: self.catId, country: country.countryName, searchStr: "", batchSize: "100", sort: "")
            
    }
}

