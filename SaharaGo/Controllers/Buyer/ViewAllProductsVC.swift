//
//  ViewAllProductsVC.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 03/11/22.
//

import UIKit

class ViewAllProductsVC: UIViewController {

    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var CRBtn: UIButton!
    @IBOutlet weak var LTHBtn: UIButton!
    @IBOutlet weak var HTLBtn: UIButton!
    @IBOutlet weak var sortMainView: UIView!
    @IBOutlet weak var sortView: UIView!
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var cartBadgeLbl: UILabel!
    @IBOutlet weak var cartBadgeView: UIView!
    @IBOutlet weak var collView: UICollectionView!
    var productsArr = [SimilarProducts_Struct]()
    var dbItemsArr: NSMutableArray = NSMutableArray()
    var finalItemDic: NSMutableDictionary = NSMutableDictionary()
    var headerStr = ""
    var sortingParam = ""
    var pageNo = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.headerLbl.text = self.headerStr
        self.headerLbl.textColor = UIColor.white
        NotificationCenter.default.addObserver(self, selector: #selector(updateCartBadge(_:)), name: Notification.Name("updateCartBadge"), object: nil)
        let mytapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.sortMainView.addGestureRecognizer(mytapGestureRecognizer)
        self.sortMainView.isUserInteractionEnabled = true
        if self.headerStr == "New Arrivals" {
            self.getNewArrivals("", sorting: "")
        } else if self.headerStr == "Top Deals" {
            self.getTopDeals("", sorting: "")
        } else {
            self.getonSale("", sorting: "")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setCartBadge()
        self.sortView.roundCorners(corners: [.topLeft, .topRight], cornerRadius: 12)
    }
    
    @objc func handleTap(_ sender:UITapGestureRecognizer){

        self.sortMainView.isHidden = true

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
    
    @IBAction func cellAddToCartAction(_ sender: UIButton) {
        if UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.VENDOR_SIGNUP_TOKEN) != nil {
            let indexPath: IndexPath? = collView.indexPathForItem(at: sender.convert(CGPoint.zero, to: collView))
            let info = self.productsArr[indexPath!.row]
            
    //        self.getCartDetailOfUser(info)
            if !info.orderable {
                self.view.makeToast("Item not available for Online purchase")
                return
            }
            self.getCartDetailOfUserFromMainAddToCartDuplicate(info)
        } else {
            let vc = DIConfigurator.shared.getLoginVC()
            vc.sendTo = "ViewAllProductsVC"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
    
    func getCartDetailOfUser(_ cartProductsInfo: SimilarProducts_Struct) {
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
    
    func getCartDetailOfUserFromMainAddToCartDuplicate(_ cartProductsInfo: SimilarProducts_Struct) {
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
    
    @IBAction func bottomButtonActions(_ sender: UIButton) {
        if sender.tag == 101 {
            self.sortMainView.isHidden = false
        } else {
            let viewAllVC = DIConfigurator.shared.getFilterCatVC()
            viewAllVC.completionHandlerCallback = {(catId: String!)->Void in

                self.getNewArrivals(catId, sorting: self.sortingParam)
            }
            self.present(viewAllVC, animated: true)
        }
    }
    
    func getNewArrivals(_ catId: String, sorting: String) {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = [:]
            
            let apiUrl = BASE_URL + PROJECT_URL.GET_NEW_PRODUCTS_BY_COUNTRY + "&categoryId=\(catId)" + "&pageNumber=\(self.pageNo)" + "&limit=30" + "&sorting=\(sorting)"
            let url : NSString = apiUrl as NSString
            let urlStr : NSString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! as NSString
            
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: urlStr as String, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    if self.pageNo == 1 {
                        self.productsArr.removeAll()
                    }
                    
                    let totalSize = json["count"].intValue
                    for i in 0..<json["productList"].count
                    {
                        let currency = json["productList"][i]["currency"].stringValue
                        let productId = json["productList"][i]["productId"].stringValue
                        let actualPrice = json["productList"][i]["actualPrice"].stringValue
                        let discountValue = json["productList"][i]["discountValue"].stringValue
                        let wishlisted = json["productList"][i]["wishlisted"].boolValue
                        let orderable = json["productList"][i]["orderable"].boolValue
                        let stock = json["productList"][i]["stock"].stringValue
                        let description = json["productList"][i]["metaData"]["description"].stringValue
                        let name = json["productList"][i]["name"].stringValue
                        let dimension = json["productList"][i]["dimension"].stringValue
                        let discountedPrice = json["productList"][i]["discountedPrice"].stringValue
                        let rating = json["productList"][i]["rating"].stringValue
                        let discountType = json["productList"][i]["discountType"].stringValue
                        let itemId = json["productList"][i]["itemId"].stringValue
                        let categoryId = json["productList"][i]["categoryId"].stringValue
                        let vendorId = json["productList"][i]["vendorId"].stringValue
                        
                        
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
                        
                        self.productsArr.append(SimilarProducts_Struct.init(currency: currency, vendorId: vendorId, productId: productId, name: name, description: description, dimension: dimension, wishlisted: wishlisted, orderable: orderable, discountType: discountType, itemId: itemId, categoryId: categoryId, actualPrice: actualPrice, discountValue: discountValue, stock: stock, discountedPrice: discountedPrice, rating: rating, images: imgArr, totalSize: totalSize, minQuantity: minQuantity))
                        
                    }
                    
                    if self.productsArr.count > 0 {
                        DispatchQueue.main.async {
                            //                            self.newProductsSectionView.isHidden = false
                            self.collView.isHidden = false
                            self.collView.reloadData()
                            self.emptyView.isHidden = true
                        }
                        
                    } else {
                        //                        self.newProductsSectionView.isHidden = true
                        
                        self.emptyView.isHidden = false
                        self.collView.isHidden = true
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
    
    func getTopDeals(_ catId: String, sorting: String) {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = [:]
            
            let apiUrl = BASE_URL + PROJECT_URL.GET_TOP_DEALS_PRODUCTS_BY_COUNTRY + "&categoryId=\(catId)" + "&pageNumber=\(self.pageNo)" + "&limit=30" + "&sorting=\(sorting)"
            let url : NSString = apiUrl as NSString
            let urlStr : NSString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! as NSString
            
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: urlStr as String, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    if self.pageNo == 1 {
                        self.productsArr.removeAll()
                    }
                    let totalSize = json["count"].intValue
                    for i in 0..<json["productList"].count
                    {
                        let currency = json["productList"][i]["currency"].stringValue
                        let productId = json["productList"][i]["productId"].stringValue
                        let actualPrice = json["productList"][i]["actualPrice"].stringValue
                        let discountValue = json["productList"][i]["discountValue"].stringValue
                        let wishlisted = json["productList"][i]["wishlisted"].boolValue
                        let orderable = json["productList"][i]["orderable"].boolValue
                        let stock = json["productList"][i]["stock"].stringValue
                        let description = json["productList"][i]["metaData"]["description"].stringValue
                        let name = json["productList"][i]["name"].stringValue
                        let dimension = json["productList"][i]["dimension"].stringValue
                        let discountedPrice = json["productList"][i]["discountedPrice"].stringValue
                        let rating = json["productList"][i]["rating"].stringValue
                        let discountType = json["productList"][i]["discountType"].stringValue
                        let itemId = json["productList"][i]["itemId"].stringValue
                        let categoryId = json["productList"][i]["categoryId"].stringValue
                        let vendorId = json["productList"][i]["vendorId"].stringValue
                        
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
                        
                        self.productsArr.append(SimilarProducts_Struct.init(currency: currency, vendorId: vendorId, productId: productId, name: name, description: description, dimension: dimension, wishlisted: wishlisted, orderable: orderable, discountType: discountType, itemId: itemId, categoryId: categoryId, actualPrice: actualPrice, discountValue: discountValue, stock: stock, discountedPrice: discountedPrice, rating: rating, images: imgArr, totalSize: totalSize, minQuantity: minQuantity))
                        
                    }
                    
                    if self.productsArr.count > 0 {
                        DispatchQueue.main.async {
                            //                            self.newProductsSectionView.isHidden = false
                            self.collView.isHidden = false
                            self.emptyView.isHidden = true
                            self.collView.reloadData()
                        }
                        
                    } else {
                        //                        self.newProductsSectionView.isHidden = true
                        self.emptyView.isHidden = false
                        self.collView.isHidden = true
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
    
    func getonSale(_ catId: String, sorting: String) {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = [:]
            
            let apiUrl = BASE_URL + PROJECT_URL.GET_ONSALE_PRODUCTS_BY_COUNTRY + "&categoryId=\(catId)" + "&pageNumber=\(self.pageNo)" + "&limit=30" + "&sorting=\(sorting)"
            let url : NSString = apiUrl as NSString
            let urlStr : NSString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! as NSString
            
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: urlStr as String, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    if self.pageNo == 1 {
                        self.productsArr.removeAll()
                    }
                    let totalSize = json["count"].intValue
                    for i in 0..<json["productList"].count
                    {
                        let currency = json["productList"][i]["currency"].stringValue
                        let productId = json["productList"][i]["productId"].stringValue
                        let actualPrice = json["productList"][i]["actualPrice"].stringValue
                        let discountValue = json["productList"][i]["discountValue"].stringValue
                        let wishlisted = json["productList"][i]["wishlisted"].boolValue
                        let orderable = json["productList"][i]["orderable"].boolValue
                        let stock = json["productList"][i]["stock"].stringValue
                        let description = json["productList"][i]["metaData"]["description"].stringValue
                        let name = json["productList"][i]["name"].stringValue
                        let dimension = json["productList"][i]["dimension"].stringValue
                        let discountedPrice = json["productList"][i]["discountedPrice"].stringValue
                        let rating = json["productList"][i]["rating"].stringValue
                        let discountType = json["productList"][i]["discountType"].stringValue
                        let itemId = json["productList"][i]["itemId"].stringValue
                        let categoryId = json["productList"][i]["categoryId"].stringValue
                        let vendorId = json["productList"][i]["vendorId"].stringValue
                        
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
                        
                        self.productsArr.append(SimilarProducts_Struct.init(currency: currency, vendorId: vendorId, productId: productId, name: name, description: description, dimension: dimension, wishlisted: wishlisted, orderable: orderable, discountType: discountType, itemId: itemId, categoryId: categoryId, actualPrice: actualPrice, discountValue: discountValue, stock: stock, discountedPrice: discountedPrice, rating: rating, images: imgArr, totalSize: totalSize, minQuantity: minQuantity))
                        
                    }
                    
                    if self.productsArr.count > 0 {
                        DispatchQueue.main.async {
                            //                            self.newProductsSectionView.isHidden = false
                            self.collView.isHidden = false
                            self.emptyView.isHidden = true
                            self.collView.reloadData()
                        }
                        
                    } else {
                        //                        self.newProductsSectionView.isHidden = true
                        self.emptyView.isHidden = false
                        self.collView.isHidden = true
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
    
    @IBAction func sortActions(_ sender: UIButton) {
        if sender.tag == 101 {
            self.HTLBtn.setImage(UIImage.init(named: "check-radio"), for: .normal)
            self.LTHBtn.setImage(UIImage.init(named: "uncheck-radio"), for: .normal)
            self.CRBtn.setImage(UIImage.init(named: "uncheck-radio"), for: .normal)
            self.sortingParam = "Price_HL"
        } else if sender.tag == 102 {
            self.LTHBtn.setImage(UIImage.init(named: "check-radio"), for: .normal)
            self.HTLBtn.setImage(UIImage.init(named: "uncheck-radio"), for: .normal)
            self.CRBtn.setImage(UIImage.init(named: "uncheck-radio"), for: .normal)
            self.sortingParam = "Price_LH"
        } else {
            self.CRBtn.setImage(UIImage.init(named: "check-radio"), for: .normal)
            self.HTLBtn.setImage(UIImage.init(named: "uncheck-radio"), for: .normal)
            self.LTHBtn.setImage(UIImage.init(named: "uncheck-radio"), for: .normal)
            self.sortingParam = "rating"
        }
        self.sortMainView.isHidden = true
        self.getNewArrivals("", sorting: self.sortingParam)
    }
    
}

extension ViewAllProductsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.productsArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CatProductsCollCell", for: indexPath) as! CatProductsCollCell
        
        cell.increaseCountBtn.tag = indexPath.row
        cell.decreaseCountBtn.tag = indexPath.row
        
        let info = self.productsArr[indexPath.row]
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

        if indexPath.row == self.productsArr.count - 1 { // last cell
            if info.totalSize > self.productsArr.count { // more items to fetch
                self.pageNo += 1
                if self.headerStr == "New Arrivals" {
                    self.getNewArrivals("", sorting: "")
                } else if self.headerStr == "Top Deals" {
                    self.getTopDeals("", sorting: "")
                } else {
                    self.getonSale("", sorting: "")
                }
            }
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productDetailVC = DIConfigurator.shared.getProductDetailVC()
//        productDetailVC.productDetails = self.categoriesProductListArr[indexPath.row]
        let info = self.productsArr[indexPath.row]
        productDetailVC.itemID = info.itemId
        productDetailVC.productID = info.productId
        productDetailVC.vendorID = info.vendorId
        self.navigationController?.pushViewController(productDetailVC, animated: true)
    }
    
}

extension ViewAllProductsVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = collectionView.bounds.width
        //        return CGSize(width: (UIScreen.main.bounds.size.width - 30) / 2.0, height: (UIScreen.main.bounds.size.height))
        return CGSize(width: ((collectionWidth - 10)/2), height: 320)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
}
