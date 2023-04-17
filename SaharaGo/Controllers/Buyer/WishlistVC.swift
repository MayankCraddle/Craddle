//
//  WishlistVC.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 22/07/22.
//

import UIKit
import SkeletonView

class WishlistVC: UIViewController {
    
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var cartBadgeLbl: UILabel!
    @IBOutlet weak var cartBadgeView: UIView!
    @IBOutlet weak var headerViewTwo: MyCustomHeaderView!
    @IBOutlet weak var headerViewOne: MyCustomHeaderView!
    @IBOutlet weak var searchTxt: UITextField!
    @IBOutlet weak var searchCloseBtn: UIButton!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var searchViewWidth: NSLayoutConstraint!
    
    private let itemsPerRow: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(
        top: 15.0,
        left: 20.0,
        bottom: 50.0,
        right: 20.0)
    
    var data = [String]()
    var wishListArr = [categoryProductListStruct]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var finalItemDic: NSMutableDictionary = NSMutableDictionary()
    var dbItemsArr: NSMutableArray = NSMutableArray()
    var itemIdToRemove: String = String()
                                                                        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //        self.collView.dataSource = nil
        //        self.collView.delegate = nil
        
        self.collView.dataSource = self
        self.collView.delegate = self
        self.collView.isHidden = false
        self.collView.register(UINib(nibName: "WishlistLatestCollCell", bundle: nil), forCellWithReuseIdentifier: "WishlistLatestCollCell")
        NotificationCenter.default.addObserver(self, selector: #selector(updateCartBadge(_:)), name: Notification.Name("updateCartBadge"), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
        
        guard let countryColorStr = UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.COUNTRY_COLOR_CODE) as? String else {return}
        guard let rgba = countryColorStr.slice(from: "(", to: ")") else { return }
        let myStringArr = rgba.components(separatedBy: ",")
        
        self.headerViewOne.backgroundColor = UIColor(red: CGFloat((myStringArr[0] as NSString).doubleValue/255.0), green: CGFloat((myStringArr[1] as NSString).doubleValue/255.0), blue: CGFloat((myStringArr[2] as NSString).doubleValue/255.0), alpha: CGFloat((myStringArr[3] as NSString).doubleValue))
        self.headerViewTwo.backgroundColor = UIColor(red: CGFloat((myStringArr[0] as NSString).doubleValue/255.0), green: CGFloat((myStringArr[1] as NSString).doubleValue/255.0), blue: CGFloat((myStringArr[2] as NSString).doubleValue/255.0), alpha: CGFloat((myStringArr[3] as NSString).doubleValue))
        self.setCartBadge()
        self.getWishlistProductsAPI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
 
    }
    
    func getWishlistProductsAPI() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = [:]
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.USER_GET_WISHLIST, successBlock: { (json) in
                debugPrint(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    self.wishListArr.removeAll()
                    for i in 0..<json["metaData"]["items"].count
                    {
                        var imgArr = [String]()
                        for j in 0..<json["metaData"]["items"][i]["metaData"]["images"].count {
                            let file = json["metaData"]["items"][i]["metaData"]["images"][j].stringValue
                            imgArr.append(file)
//                            let orderable = json["productList"][i]["orderable"].boolValue
                        }
                        self.wishListArr.append(categoryProductListStruct.init(currency: json["metaData"]["items"][i]["currency"].stringValue, description: json["metaData"]["items"][i]["metaData"]["description"].stringValue, category: json["metaData"]["items"][i]["category"].stringValue, stock: json["metaData"]["items"][i]["stock"].stringValue, productId: json["metaData"]["items"][i]["productId"].stringValue, itemId: json["metaData"]["items"][i]["itemId"].stringValue, price: json["metaData"]["items"][i]["actualPrice"].stringValue, discountedPrice: json["metaData"]["items"][i]["discountedPrice"].stringValue, discountPercent: json["metaData"]["items"][i]["discountValue"].stringValue, rating: json["metaData"]["items"][i]["rating"].stringValue, name: json["metaData"]["items"][i]["name"].stringValue, images: imgArr, orderable: json["metaData"]["items"][i]["orderable"].boolValue, vendorId: json["metaData"]["items"][i]["vendorId"].stringValue, minQuantity: json["metaData"]["items"][i]["minQuantity"].stringValue))
                        
                    }
                    
                    if self.wishListArr.count > 0 {
                        self.collView.isHidden = false
                        self.emptyView.isHidden = true
                    } else {
                        self.collView.isHidden = true
                        self.emptyView.isHidden = false
                  }
                    
                    DispatchQueue.main.async {
                        self.collView.dataSource = self
                        self.collView.delegate = self
                        self.collView.reloadData()
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
    
    func setCartBadge() {
        if let cartCount = UserDefaults.standard.value(forKey: "cartCount") as? Int {
            self.cartBadgeView.isHidden = false
            self.cartBadgeLbl.text = "\(cartCount)"
        } else {
            self.cartBadgeView.isHidden = true
        }
        
    }
    
    @objc func updateCartBadge(_ notification: Notification) {
        if let cartCount = UserDefaults.standard.value(forKey: "cartCount") as? Int {
            self.cartBadgeView.isHidden = false
            self.cartBadgeLbl.text = "\(cartCount)"
        } else {
            self.cartBadgeView.isHidden = true
        }
        
    }
    
    @IBAction func onTapBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickSearch(_ sender: UIButton) {
        print("Search Tapped")
        UIView.animate(withDuration: 0.1) {
            self.searchView.isHidden = false
            self.searchCloseBtn.isHidden = false
            self.headerView.isHidden = true
            self.searchViewWidth.constant = UIScreen.main.bounds.width-100
            
            self.view.layoutIfNeeded()
        }
        
        searchTxt.becomeFirstResponder()
        
    }
    
    @IBAction func onClickCart(_ sender: UIButton) {
        let cartVC = DIConfigurator.shared.getCartVC()
        self.navigationController?.pushViewController(cartVC, animated: true)
    }
    
    @IBAction func onClickCloseSearch(_ sender: UIButton) {
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
        
        DispatchQueue.main.async {
            self.collView.reloadData()
        }
    }
    
    @IBAction func onClickLogin(_ sender: UIButton) {
        isWishlistTab = "yes"
        let productsVC = DIConfigurator.shared.getLoginVC()
        self.navigationController?.pushViewController(productsVC, animated: true)
    }
    
    @IBAction func deleteItemAction(_ sender: UIButton) {
        
        
        self.showAlertWithActions("Are you sure you want to remove this product from Whislist?", titles: ["Yes", "No"]) { (value) in
            if value == 1{
                // delete product from cart
                let indexPath: IndexPath? = self.collView.indexPathForItem(at: sender.convert(CGPoint.zero, to: self.collView))
                let info = self.wishListArr[indexPath!.row]
                self.itemIdToRemove = info.itemId
                self.deleteApi(self.itemIdToRemove)
            }
        }
        
    }
    
    
    @IBAction func addToCartAction(_ sender: UIButton) {
        let indexPath: IndexPath? = collView.indexPathForItem(at: sender.convert(CGPoint.zero, to: collView))
        let info = self.wishListArr[indexPath!.row]
        self.itemIdToRemove = info.itemId
        
        if UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.VENDOR_SIGNUP_TOKEN) != nil {
            if !info.orderable {
                self.view.makeToast("Item not available for Online purchase")
                return
            }
            self.getCartDetailOfUserFromMainAddToCartDuplicate(info)
            
        } else {
            let cart = Cart(context: context)
            cart.name = info.name
            cart.price = Int64(info.discountedPrice)!
            cart.currency = info.currency
            cart.itemId = info.itemId
            cart.stock = 1

            do {
                try context.save()
                self.view.makeToast("Item added to Cart.")
            } catch {

            }
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
                        itemDic.setValue("1", forKey: "quantity")
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
                                let discountPercent =  json["metaData"]["items"][i]["discountPercent"].stringValue
                                let name =  json["metaData"]["items"][i]["name"].stringValue
                                let price =  json["metaData"]["items"][i]["price"].stringValue
                                let stock =  json["metaData"]["items"][i]["stock"].stringValue
                                let discountedPrice =  json["metaData"]["items"][i]["discountedPrice"].stringValue
                                let currency =  json["metaData"]["items"][i]["currency"].stringValue
                                let vendorId =  json["metaData"]["items"][i]["itemId"].stringValue
                                let description =  json["metaData"]["items"][i]["metaData"]["description"].stringValue
                                let minQuantity = json["metaData"]["items"][i]["quantity"].stringValue
                                
                                var imgArr = [String]()
                                for j in 0..<json["metaData"]["items"][i]["metaData"]["images"].count {
                                    
                                    let file = json["metaData"]["items"][i]["metaData"]["images"][j].stringValue
                                    imgArr.append(file)
                                }
                                
                                globalCartProducts.append(cartProductListStruct.init(currency: currency, description: description, stock: stock, productId: productId, itemId: itemId, price: price, discountedPrice: discountedPrice, discountPercent: discountPercent, name: name, quantity: quantity, imagesArr: imgArr, vendorId: vendorId, minQuantity: minQuantity))
                                
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
//                            itemDic.setValue("1", forKey: "quantity")
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
                    self.deleteApi(self.itemIdToRemove)
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
                    self.deleteApi(self.itemIdToRemove)
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
    
    func deleteApi(_ id: String) {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:Any] = [ "itemId": id]
            
            ServerClass.sharedInstance.putRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.USER_DELETE_WISHLIST, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                
                if success == "true"
                {
                    //self.view.makeToast(json["message"].stringValue)
                    self.getWishlistProductsAPI()
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
    
    @objc func deleteBtnClicked(sender: UIButton) {
        
        
        self.showAlertWithActions("Are you sure you want to remove this product from Whislist?", titles: ["Yes", "No"]) { (value) in
            if value == 1{
                // delete product from cart
//                let indexPath: IndexPath? = self.collView.indexPathForItem(at: sender.convert(CGPoint.zero, to: self.collView))
                let info = self.wishListArr[sender.tag]
                self.itemIdToRemove = info.itemId
                self.deleteApi(self.itemIdToRemove)
            }
        }
        
    }
    
    @objc func cartBtnClicked(sender: UIButton) {
//        let indexPath: IndexPath? = collView.indexPathForItem(at: sender.convert(CGPoint.zero, to: collView))
        let info = self.wishListArr[sender.tag]
//        self.deleteApi(info.productId)
        self.itemIdToRemove = info.itemId
        
        if UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.VENDOR_SIGNUP_TOKEN) != nil {
            //self.getCartDetailOfUser(info)
            if !info.orderable {
                self.view.makeToast("Item not available for Online purchase")
                return
            }
            self.getCartDetailOfUserFromMainAddToCartDuplicate(info)
            
        } else {
            let cart = Cart(context: context)
            cart.name = info.name
            cart.price = Int64(info.discountedPrice)!
            cart.currency = info.currency
            cart.itemId = info.itemId
            cart.stock = 1

            do {
                try context.save()
                self.view.makeToast("Item added to Cart.")
            } catch {

            }
        }
        
    }
    
}

extension WishlistVC: UICollectionViewDelegate, SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "WishlistCollCell"
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.wishListArr.count
        //        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WishlistLatestCollCell", for: indexPath) as! WishlistLatestCollCell
        //        cell.cellImg.image = UIImage(named: "wishlist_img")
        
        let info = self.wishListArr[indexPath.row]
        cell.cellLbl.text = info.name
        cell.cellDescLbl.text = info.description
        cell.cellDiscountLbl.text = "₦\(info.discountedPrice)"

        if info.discountPercent == "0" {
            cell.cellPercentageLbl.isHidden = true
        } else {
            cell.cellPercentageLbl.isHidden = false
            cell.cellPercentageLbl.text = "\(info.discountPercent)% OFF"
        }
        
//        cell.cellPercentageLbl.text = "\(info.discountPercent)% OFF"
        if info.images!.count > 0 {
            cell.cellImg.sd_setImage(with: URL(string: FILE_BASE_URL + "/\(info.images![0])"), placeholderImage: UIImage(named: "loading"))
        }
        
        cell.cellDeleteBtn.tag = (indexPath.section * 1000) + indexPath.row
        cell.cellDeleteBtn.addTarget(self, action: #selector(self.deleteBtnClicked(sender:)), for: UIControl.Event.touchUpInside)
        cell.cellAddToCartBtn.tag = (indexPath.section * 1000) + indexPath.row
        cell.cellAddToCartBtn.addTarget(self, action: #selector(self.cartBtnClicked(sender:)), for: UIControl.Event.touchUpInside)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productDetailVC = DIConfigurator.shared.getProductDetailVC()
//        productDetailVC.productDetails = self.categoriesProductListArr[indexPath.row]
        let info = self.wishListArr[indexPath.row]
        productDetailVC.itemID = info.itemId
        productDetailVC.productID = info.productId
        productDetailVC.vendorID = info.vendorId
        self.navigationController?.pushViewController(productDetailVC, animated: true)
    }
    
}
// MARK: - Collection View Flow Layout Delegate
extension WishlistVC: UICollectionViewDelegateFlowLayout {
    // 1
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        // 2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: 350)
    }
    
    // 3
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // 4
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return sectionInsets.left
    }
}

extension WishlistVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if self.searchTxt.text!.trim() != ""{
            //call API with Search Text
        }
        return true
    }
    
}
