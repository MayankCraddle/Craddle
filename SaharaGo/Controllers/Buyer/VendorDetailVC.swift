//
//  VendorDetailVC.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 13/09/22.
//

import UIKit
import Cosmos

class VendorDetailVC: UIViewController {

    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var cartBadgeLbl: UILabel!
    @IBOutlet weak var cartBadgeView: UIView!
    @IBOutlet weak var vendorCoverImg: UIImageView!
    @IBOutlet weak var ratingsTableHeight: NSLayoutConstraint!
    @IBOutlet weak var requestedSampleSectionView: UIView!
    @IBOutlet weak var discountedSectionView: UIView!
    @IBOutlet weak var newProductsSectionView: UIView!
    @IBOutlet weak var reviewtableView: UITableView!
    @IBOutlet weak var discountedCollView: UICollectionView!
    @IBOutlet weak var sampleProductsCollView: UICollectionView!
    @IBOutlet weak var newProductsCollView: UICollectionView!
    @IBOutlet weak var headerViewTwo: MyCustomHeaderView!
    @IBOutlet weak var headerViewOne: MyCustomHeaderView!
    @IBOutlet weak var vendorNameLbl: UILabel!
    @IBOutlet weak var vemdorImg: UIImageView!
    @IBOutlet weak var vendorDetailLbl: UILabel!
    @IBOutlet weak var vendorRating: CosmosView!
    
    var vendorId = ""
    var vendorDetailsObj = vendorListStruct()
    var vendorEncryptedId :String = ""
    var vendorName = ""
    var fcmKey :String = ""
    var newProductsArr = [SimilarProducts_Struct]()
    var sampleProductsArr = [SimilarProducts_Struct]()
    var discountedProductsArr = [SimilarProducts_Struct]()
    var finalItemDic: NSMutableDictionary = NSMutableDictionary()
    var commentArr = [commentStruct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        self.newProductsCollView.register(UINib(nibName: "LocalProductsCollCell", bundle: nil), forCellWithReuseIdentifier: "LocalProductsCollCell")
//        self.sampleProductsCollView.register(UINib(nibName: "LocalProductsCollCell", bundle: nil), forCellWithReuseIdentifier: "LocalProductsCollCell")
//        self.discountedCollView.register(UINib(nibName: "LocalProductsCollCell", bundle: nil), forCellWithReuseIdentifier: "LocalProductsCollCell")
        
        self.newProductsCollView.register(UINib(nibName: "WishlistLatestCollCell", bundle: nil), forCellWithReuseIdentifier: "WishlistLatestCollCell")
        self.sampleProductsCollView.register(UINib(nibName: "WishlistLatestCollCell", bundle: nil), forCellWithReuseIdentifier: "WishlistLatestCollCell")
        self.discountedCollView.register(UINib(nibName: "WishlistLatestCollCell", bundle: nil), forCellWithReuseIdentifier: "WishlistLatestCollCell")
        
        self.reviewtableView.register(UINib(nibName: "ReviewsCell", bundle: nil), forCellReuseIdentifier: "ReviewsCell")
        
        self.reviewtableView.dataSource = nil
        self.reviewtableView.delegate = nil
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateCartBadge(_:)), name: Notification.Name("updateCartBadge"), object: nil)
        self.reviewtableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setCartBadge()
        guard let countryColorStr = UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.COUNTRY_COLOR_CODE) as? String else {return}
        guard let rgba = countryColorStr.slice(from: "(", to: ")") else { return }
        let myStringArr = rgba.components(separatedBy: ",")
        //        layer.cornerRadius = 6
        
        self.headerViewOne.backgroundColor = UIColor(red: CGFloat((myStringArr[0] as NSString).doubleValue/255.0), green: CGFloat((myStringArr[1] as NSString).doubleValue/255.0), blue: CGFloat((myStringArr[2] as NSString).doubleValue/255.0), alpha: CGFloat((myStringArr[3] as NSString).doubleValue))
        self.headerViewTwo.backgroundColor = UIColor(red: CGFloat((myStringArr[0] as NSString).doubleValue/255.0), green: CGFloat((myStringArr[1] as NSString).doubleValue/255.0), blue: CGFloat((myStringArr[2] as NSString).doubleValue/255.0), alpha: CGFloat((myStringArr[3] as NSString).doubleValue))
        getvendorDetails(self.vendorId)
        self.getRatings(self.vendorId)
        self.getNewProducts(self.vendorId)
        self.getSampleProducts(self.vendorId)
        self.getDiscountedProducts(self.vendorId)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (object as! UITableView) == self.reviewtableView {
          if(keyPath == "contentSize"){
            if let newvalue = change?[.newKey]
            {
              let newsize = newvalue as! CGSize
                ratingsTableHeight.constant = newsize.height
//                self.participantTableView.height = newsize.height
            }
          }
        } else {
            if(keyPath == "contentSize"){
              if let newvalue = change?[.newKey]
              {
                let newsize = newvalue as! CGSize
                  ratingsTableHeight.constant = newsize.height
  //                self.participantTableView.height = newsize.height
              }
            }
            
        }
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
    
    @IBAction func onClickSearch(_ sender: UIButton) {
        let viewAllVC = DIConfigurator.shared.getExploreVC()
        viewAllVC.searchIsFrom = "Vendors"
        self.navigationController?.pushViewController(viewAllVC, animated: true)
    }
    
    @IBAction func onTapBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickCategories(_ sender: Any) {
        let vc = DIConfigurator.shared.getChatVC()
        let info = self.vendorDetailsObj
        if self.vendorEncryptedId != "" {
//            vc.toId = self.vendorEncryptedId
//            vc.fcmKey = self.fcmKey
            vc.toId = self.vendorDetailsObj.vendorEncryptedId
            vc.fcmKey = self.vendorDetailsObj.fcmKey
            vc.vendorName = self.vendorName
            UserDefaults.standard.set(self.vendorName, forKey: USER_DEFAULTS_KEYS.TO_LOGIN_NAME)
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            self.view.makeToast("Vendor Encrypted Id is not available.")
        }
        
    }
    
    @IBAction func onClickChat(_ sender: UIButton) {
        if UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.VENDOR_SIGNUP_TOKEN) != nil {
            let vc = DIConfigurator.shared.getChatVC()
            let info = self.vendorDetailsObj
            if self.vendorEncryptedId != "" {
                vc.toId = self.vendorEncryptedId
    //            vc.fcmKey = self.fcmKey
                vc.fcmKey = info.fcmKey
                vc.vendorName = "\(info.firstName) \(info.lastName)"
                UserDefaults.standard.set(self.vendorName, forKey: USER_DEFAULTS_KEYS.TO_LOGIN_NAME)
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                self.view.makeToast("Vendor Encrypted Id is not available.")
            }
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

    
    func getvendorDetails(_ id: String) {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = [:]
            
            let apiUrl = BASE_URL + PROJECT_URL.GET_VENDOR_DETAILS + id
            let url : NSString = apiUrl as NSString
            let urlStr : NSString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! as NSString
            
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: urlStr as String, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    
                    let countryy = json["country"].stringValue
                    let vendorId = json["vendorId"].stringValue
                    let emailMobile = json["emailMobile"].stringValue
                    let status = json["status"].boolValue
                    let vendorEncryptedId = json["vendorEncryptedId"].stringValue
                    let fcmKey = json["fcmKey"].stringValue
                    
                    let streetAddress = json["metaData"]["description"].stringValue
                    let zipcode = json["metaData"]["zipcode"]["image"].stringValue
                    let landmark = json["metaData"]["landmark"].stringValue
                    
                    let lastName = json["metaData"]["lastName"].stringValue
                    
                    let state = json["metaData"]["state"].stringValue
                    let firstName = json["metaData"]["firstName"].stringValue
                    let image = json["metaData"]["image"].stringValue
                    let coverImage = json["metaData"]["coverImage"].stringValue
                    let city = json["metaData"]["city"].stringValue
                    let companyName = json["metaData"]["companyName"].stringValue
                    
                    self.vendorDetailsObj = vendorListStruct.init(status: status, vendorId: vendorId, emailMobile: emailMobile, firstName: firstName, lastName: lastName, sourcing: emailMobile, image: image, country: countryy, state: state, city: city, zipcode: zipcode, landmark: landmark, coverImage: coverImage, companyName: companyName, vendorEncryptedId: vendorEncryptedId, fcmKey: fcmKey)

                    DispatchQueue.main.async {
                        self.vendorNameLbl.text = self.vendorDetailsObj.companyName
                        self.vendorRating.rating = Double(self.vendorDetailsObj.rating) ?? 0.0
                        self.headerLbl.text = "\(self.vendorDetailsObj.firstName) \(self.vendorDetailsObj.lastName) Store"
                        
                        //  self.vendorAddressLbl.text = "\(self.vendorDetailsObj.landmark), \(self.vendorDetailsObj.city), \(self.vendorDetailsObj.state), \(self.vendorDetailsObj.country)"
                        let imgUrl = "\(FILE_BASE_URL)/\(self.vendorDetailsObj.image)"
                        let coverImgUrl = "\(FILE_BASE_URL)/\(self.vendorDetailsObj.coverImage)"
                        self.vemdorImg.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named: "loading"))
                        self.vendorCoverImg.sd_setImage(with: URL(string: coverImgUrl), placeholderImage: UIImage(named: "loading"))
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
    
    func getNewProducts(_ id: String) {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = [:]
            
            let apiUrl = BASE_URL + PROJECT_URL.GET_NEW_PRODUCTS_LIST + id
            let url : NSString = apiUrl as NSString
            let urlStr : NSString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! as NSString
            
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: urlStr as String, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    self.newProductsArr.removeAll()
                    for i in 0..<json["productList"].count
                    {
                        let currency = json["productList"][i]["currency"].stringValue
                        let productId = json["productList"][i]["productId"].stringValue
                        let actualPrice = json["productList"][i]["actualPrice"].stringValue
                        let discountValue = json["productList"][i]["discountValue"].stringValue
                        let wishlisted = json["productList"][i]["wishlisted"].boolValue
                        let stock = json["productList"][i]["stock"].stringValue
                        let description = json["productList"][i]["metaData"]["description"].stringValue
                        let name = json["productList"][i]["name"].stringValue
                        let dimension = json["productList"][i]["dimension"].stringValue
                        let discountedPrice = json["productList"][i]["discountedPrice"].stringValue
                        let rating = json["productList"][i]["rating"].stringValue
                        let discountType = json["productList"][i]["discountType"].stringValue
                        let discountPercent = json["productList"][i]["discountValue"].stringValue
                        let itemId = json["productList"][i]["itemId"].stringValue
                        let categoryId = json["productList"][i]["categoryId"].stringValue
                        let vendorId = json["productList"][i]["vendorId"].stringValue
                        
                        var imgArr = [String]()
                        for j in 0..<json["productList"][i]["metaData"]["images"].count {
                            let file = json["productList"][i]["metaData"]["images"][j].stringValue
                            imgArr.append(file)
                        }
                        
                        self.newProductsArr.append(SimilarProducts_Struct.init(currency: currency, vendorId: vendorId, productId: productId, name: name, description: description, dimension: dimension, wishlisted: wishlisted, discountType: discountType, itemId: itemId, categoryId: categoryId, actualPrice: actualPrice, discountValue: discountValue, stock: stock, discountedPrice: discountedPrice, rating: rating, images: imgArr, discountPercent: discountPercent))
                        
                    }

                    if self.newProductsArr.count > 0 {
                        DispatchQueue.main.async {
                            self.newProductsSectionView.isHidden = false
                            self.newProductsCollView.reloadData()
                        }

                    } else {
                        self.newProductsSectionView.isHidden = true
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
    
    func getSampleProducts(_ id: String) {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = [:]
            
            let apiUrl = BASE_URL + PROJECT_URL.GET_SAMPLE_PRODUCTS_LIST + id
            let url : NSString = apiUrl as NSString
            let urlStr : NSString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! as NSString
            
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: urlStr as String, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    self.sampleProductsArr.removeAll()
                    for i in 0..<json["productList"].count
                    {
                        let currency = json["productList"][i]["currency"].stringValue
                        let productId = json["productList"][i]["productId"].stringValue
                        let actualPrice = json["productList"][i]["actualPrice"].stringValue
                        let discountValue = json["productList"][i]["discountValue"].stringValue
                        let wishlisted = json["productList"][i]["wishlisted"].boolValue
                        let stock = json["productList"][i]["stock"].stringValue
                        let description = json["productList"][i]["metaData"]["description"].stringValue
                        let name = json["productList"][i]["name"].stringValue
                        let dimension = json["productList"][i]["dimension"].stringValue
                        let discountedPrice = json["productList"][i]["discountedPrice"].stringValue
                        let rating = json["productList"][i]["rating"].stringValue
                        let discountType = json["productList"][i]["discountType"].stringValue
                        let discountPercent = json["productList"][i]["discountValue"].stringValue
                        let itemId = json["productList"][i]["itemId"].stringValue
                        let categoryId = json["productList"][i]["categoryId"].stringValue
                        let vendorId = json["productList"][i]["vendorId"].stringValue
                        
                        var imgArr = [String]()
                        for j in 0..<json["productList"][i]["metaData"]["images"].count {
                            let file = json["productList"][i]["metaData"]["images"][j].stringValue
                            imgArr.append(file)
                        }
                        
                        self.sampleProductsArr.append(SimilarProducts_Struct.init(currency: currency, vendorId: vendorId, productId: productId, name: name, description: description, dimension: dimension, wishlisted: wishlisted, discountType: discountType, itemId: itemId, categoryId: categoryId, actualPrice: actualPrice, discountValue: discountValue, stock: stock, discountedPrice: discountedPrice, rating: rating, images: imgArr, discountPercent: discountPercent))
                        
                    }

                    if self.sampleProductsArr.count > 0 {
                        DispatchQueue.main.async {
                            self.requestedSampleSectionView.isHidden = false
                            self.sampleProductsCollView.reloadData()
                        }

                    } else {
                        self.requestedSampleSectionView.isHidden = true
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
    
    func getDiscountedProducts(_ id: String) {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = [:]
            
            let apiUrl = BASE_URL + PROJECT_URL.GET_DISCOUNTED_LIST + id
            let url : NSString = apiUrl as NSString
            let urlStr : NSString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! as NSString
            
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: urlStr as String, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    self.discountedProductsArr.removeAll()
                    for i in 0..<json["productList"].count
                    {
                        let currency = json["productList"][i]["currency"].stringValue
                        let productId = json["productList"][i]["productId"].stringValue
                        let actualPrice = json["productList"][i]["actualPrice"].stringValue
                        let discountValue = json["productList"][i]["discountValue"].stringValue
                        let wishlisted = json["productList"][i]["wishlisted"].boolValue
                        let stock = json["productList"][i]["stock"].stringValue
                        let description = json["productList"][i]["metaData"]["description"].stringValue
                        let name = json["productList"][i]["name"].stringValue
                        let dimension = json["productList"][i]["dimension"].stringValue
                        let discountedPrice = json["productList"][i]["discountedPrice"].stringValue
                        let rating = json["productList"][i]["rating"].stringValue
                        let discountType = json["productList"][i]["discountType"].stringValue
                        let discountPercent = json["productList"][i]["discountValue"].stringValue
                        let itemId = json["productList"][i]["itemId"].stringValue
                        let categoryId = json["productList"][i]["categoryId"].stringValue
                        let vendorId = json["productList"][i]["vendorId"].stringValue
                        
                        var imgArr = [String]()
                        for j in 0..<json["productList"][i]["metaData"]["images"].count {
                            let file = json["productList"][i]["metaData"]["images"][j].stringValue
                            imgArr.append(file)
                        }
                        
                        self.discountedProductsArr.append(SimilarProducts_Struct.init(currency: currency, vendorId: vendorId, productId: productId, name: name, description: description, dimension: dimension, wishlisted: wishlisted, discountType: discountType, itemId: itemId, categoryId: categoryId, actualPrice: actualPrice, discountValue: discountValue, stock: stock, discountedPrice: discountedPrice, rating: rating, images: imgArr, discountPercent: discountPercent))
                        
                    }

                    if self.discountedProductsArr.count > 0 {
                        DispatchQueue.main.async {
                            self.discountedSectionView.isHidden = false
                            self.discountedCollView.reloadData()
                        }

                    } else {
                        self.discountedSectionView.isHidden = true
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
    
    func getRatings(_ id: String) {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = [:]
            
            let apiUrl = BASE_URL + PROJECT_URL.USER_GET_RATING_DETAILS + id
            let url : NSString = apiUrl as NSString
            let urlStr : NSString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! as NSString
            
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: urlStr as String, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    
                    self.commentArr.removeAll()
                    for i in 0..<json["ratingList"].count {
                        let comment = json["ratingList"][i]["review"].stringValue
                        let createdOn = json["ratingList"][i]["date"].stringValue
                        let image = json["ratingList"][i]["image"].stringValue
                        let createdBy = json["ratingList"][i]["title"].stringValue
                        let rating = json["ratingList"][i]["rating"].doubleValue
                        let id = json["ratingList"][i]["id"].intValue
                        
                        self.commentArr.append(commentStruct.init(createdBy: createdBy, createdOn: createdOn, comment: comment, image: image, rating: rating, id: id))
                    }
                    
                    
                    
                    DispatchQueue.main.async {
                        if self.commentArr.count > 0 {
                            self.ratingsTableHeight.constant = 60.0
                            self.reviewtableView.isHidden = false
                            self.reviewtableView.reloadData()
                            self.reviewtableView.dataSource = self
                            self.reviewtableView.delegate = self
                        } else {
                            self.reviewtableView.isHidden = true
                            self.ratingsTableHeight.constant = 0.0
                        }
//                        self.vendorNameLbl.text = "\(self.vendorDetailsObj.firstName) \(self.vendorDetailsObj.lastName)"
//                        let imgUrl = "\(FILE_BASE_URL)/\(self.vendorDetailsObj.image)"
//                        self.vemdorImg.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named: "loading"))
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
    
    @objc func newProductsAddBtnClicked(sender: UIButton) {
        
        if UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.VENDOR_SIGNUP_TOKEN) != nil {
            let info = self.newProductsArr[sender.tag]
            
    //        self.getCartDetailOfUser(info)
            self.getCartDetailOfUserFromMainAddToCartDuplicate(info)
        } else {
            let vc = DIConfigurator.shared.getLoginVC()
            vc.sendTo = "VendorDetailVC"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
    
    @objc func discountedProductsAddBtnClicked(sender: UIButton) {
        
        if UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.VENDOR_SIGNUP_TOKEN) != nil {
            let info = self.discountedProductsArr[sender.tag]
            
    //        self.getCartDetailOfUser(info)
            self.getCartDetailOfUserFromMainAddToCartDuplicate(info)
        } else {
            let vc = DIConfigurator.shared.getLoginVC()
            vc.sendTo = "VendorDetailVC"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
    
    @objc func sampleProductsAddBtnClicked(sender: UIButton) {
        
        if UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.VENDOR_SIGNUP_TOKEN) != nil {
            let info = self.sampleProductsArr[sender.tag]
            
    //        self.getCartDetailOfUser(info)
            self.getCartDetailOfUserFromMainAddToCartDuplicate(info)
        } else {
            let vc = DIConfigurator.shared.getLoginVC()
            vc.sendTo = "VendorDetailVC"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
    

    @objc func discountedProductsWishlistBtnClicked(sender: UIButton) {
        
        let info = self.discountedProductsArr[sender.tag]
        
        self.wishlistAPI(info.itemId)
        
    }
    
    @objc func newProductsWishlistBtnClicked(sender: UIButton) {
        
        let info = self.newProductsArr[sender.tag]
        
        self.wishlistAPI(info.itemId)
        
    }
    
    @objc func sampleProductssWishlistBtnClicked(sender: UIButton) {
        
        let info = self.sampleProductsArr[sender.tag]
        
        self.wishlistAPI(info.itemId)
        
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
//                    UserDefaults.standard.set(globalCartItemsArr.count, forKey: "cartCount")
                    UserDefaults.standard.setValue(json["cartSize"].intValue, forKey: "cartCount")
                    let cartCount = ["userInfo": ["cartCount": globalCartItemsArr.count]]
                    NotificationCenter.default
                        .post(name:           NSNotification.Name("updateCartBadge"),
                              object: nil,
                              userInfo: cartCount)
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
    
    @IBAction func onClickWriteReview(_ sender: UIButton) {
        let viewAllVC = DIConfigurator.shared.getRatingsVC()
        // viewAllVC.blogId = Int(self.productDetails.itemId) ?? 0
        viewAllVC.toId = self.vendorDetailsObj.vendorId
        self.navigationController?.pushViewController(viewAllVC, animated: true)
    }
    
    
    
}

extension VendorDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.commentArr.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewsCell", for: indexPath) as! ReviewsCell
        
        let info = self.commentArr[indexPath.row]
        cell.cellMainLbl.text = info.createdBy
        cell.cellSubLbl.text = info.comment
        cell.cellRating.rating = info.rating
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            self.ratingsTableHeight.constant = self.reviewtableView.contentSize.height
        }
    
}

extension VendorDetailVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.newProductsCollView {
            return self.newProductsArr.count
        } else if collectionView == self.discountedCollView {
            return self.discountedProductsArr.count
        } else {
            return self.sampleProductsArr.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        var cell = UICollectionViewCell()
        var info = SimilarProducts_Struct()
        if collectionView == self.newProductsCollView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WishlistLatestCollCell", for: indexPath) as! WishlistLatestCollCell
            
//            info = self.newProductsArr[indexPath.row]
//            cell.cellProductLbl.text = info.name
//            cell.cellPriceLbl.text = "₦\(info.discountedPrice)"
//            if info.images!.count > 0 {
//                cell.cellImg.sd_setImage(with: URL(string: FILE_BASE_URL + "\(info.images![0])"), placeholderImage: UIImage(named: "loading"))
//            }
//
//            if info.wishlisted {
//                cell.cellWishlistBtn.setImage(UIImage(named: "wishlist_active"), for: .normal)
//            } else {
//                cell.cellWishlistBtn.setImage(UIImage(named: "wishlist"), for: .normal)
//            }
//
//            cell.cellAddToCartBtn.tag = (indexPath.section * 1000) + indexPath.row
//            cell.cellAddToCartBtn.addTarget(self, action: #selector(self.newProductsAddBtnClicked(sender:)), for: UIControl.Event.touchUpInside)
//
//            cell.cellWishlistBtn.tag = (indexPath.section * 1000) + indexPath.row
//            cell.cellWishlistBtn.addTarget(self, action: #selector(self.newProductsWishlistBtnClicked(sender:)), for: UIControl.Event.touchUpInside)
            
            let info = self.newProductsArr[indexPath.row]
            cell.cellLbl.text = info.name
            cell.cellDescLbl.text = info.description
            cell.cellDiscountLbl.text = "₦\(info.discountedPrice)"
    //        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "₦\(info.price)")
    //        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
    //        cell.cellActualPriceLbl.attributedText = attributeString
    //        cell.cellActualPriceLbl.text = "₦\(info.price)"
            cell.cellPercentageLbl.text = "\(info.discountPercent)% OFF"
            if info.images!.count > 0 {
                cell.cellImg.sd_setImage(with: URL(string: FILE_BASE_URL + "/\(info.images![0])"), placeholderImage: UIImage(named: "loading"))
            }
            
            cell.cellDeleteView.isHidden = true
            cell.cellAddToCartBtn.tag = (indexPath.section * 1000) + indexPath.row
            cell.cellAddToCartBtn.addTarget(self, action: #selector(self.newProductsAddBtnClicked(sender:)), for: UIControl.Event.touchUpInside)
            
            return cell
            
        } else if collectionView == self.discountedCollView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WishlistLatestCollCell", for: indexPath) as! WishlistLatestCollCell
//            info = self.discountedProductsArr[indexPath.row]
//            cell.cellProductLbl.text = info.name
//            cell.cellPriceLbl.text = "₦\(info.discountedPrice)"
//            if info.images!.count > 0 {
//                cell.cellImg.sd_setImage(with: URL(string: FILE_BASE_URL + "\(info.images![0])"), placeholderImage: UIImage(named: "loading"))
//            }
//
//            if info.wishlisted {
//                cell.cellWishlistBtn.setImage(UIImage(named: "wishlist_active"), for: .normal)
//            } else {
//                cell.cellWishlistBtn.setImage(UIImage(named: "wishlist"), for: .normal)
//            }
//
//            cell.cellAddToCartBtn.tag = (indexPath.section * 1000) + indexPath.row
//            cell.cellAddToCartBtn.addTarget(self, action: #selector(self.discountedProductsAddBtnClicked(sender:)), for: UIControl.Event.touchUpInside)
//
//            cell.cellWishlistBtn.tag = (indexPath.section * 1000) + indexPath.row
//            cell.cellWishlistBtn.addTarget(self, action: #selector(self.discountedProductsWishlistBtnClicked(sender:)), for: UIControl.Event.touchUpInside)
            let info = self.discountedProductsArr[indexPath.row]
            cell.cellLbl.text = info.name
            cell.cellDescLbl.text = info.description
            cell.cellDiscountLbl.text = "₦\(info.discountedPrice)"
    //        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "₦\(info.price)")
    //        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
    //        cell.cellActualPriceLbl.attributedText = attributeString
    //        cell.cellActualPriceLbl.text = "₦\(info.price)"
            cell.cellPercentageLbl.text = "\(info.discountPercent)% OFF"
            if info.images!.count > 0 {
                cell.cellImg.sd_setImage(with: URL(string: FILE_BASE_URL + "/\(info.images![0])"), placeholderImage: UIImage(named: "loading"))
            }
            
            cell.cellDeleteView.isHidden = true
            cell.cellAddToCartBtn.tag = (indexPath.section * 1000) + indexPath.row
            cell.cellAddToCartBtn.addTarget(self, action: #selector(self.discountedProductsAddBtnClicked(sender:)), for: UIControl.Event.touchUpInside)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WishlistLatestCollCell", for: indexPath) as! WishlistLatestCollCell

            let info = self.sampleProductsArr[indexPath.row]
            cell.cellLbl.text = info.name
            cell.cellDescLbl.text = info.description
            cell.cellDiscountLbl.text = "₦\(info.discountedPrice)"

            cell.cellPercentageLbl.text = "\(info.discountPercent)% OFF"
            if info.images!.count > 0 {
                cell.cellImg.sd_setImage(with: URL(string: FILE_BASE_URL + "/\(info.images![0])"), placeholderImage: UIImage(named: "loading"))
            }
            
            cell.cellDeleteView.isHidden = true
            cell.cellAddToCartBtn.tag = (indexPath.section * 1000) + indexPath.row
            cell.cellAddToCartBtn.addTarget(self, action: #selector(self.sampleProductsAddBtnClicked(sender:)), for: UIControl.Event.touchUpInside)
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.newProductsCollView {
            let productDetailVC = DIConfigurator.shared.getProductDetailVC()
            let info = self.newProductsArr[indexPath.row]
            productDetailVC.itemID = info.itemId
            productDetailVC.productID = info.productId
            productDetailVC.vendorID = info.vendorId
            self.navigationController?.pushViewController(productDetailVC, animated: true)
        } else if collectionView == self.discountedCollView {
            let productDetailVC = DIConfigurator.shared.getProductDetailVC()
            let info = self.discountedProductsArr[indexPath.row]
            productDetailVC.itemID = info.itemId
            productDetailVC.productID = info.productId
            productDetailVC.vendorID = info.vendorId
            self.navigationController?.pushViewController(productDetailVC, animated: true)
        } else if collectionView == self.sampleProductsCollView {
            let productDetailVC = DIConfigurator.shared.getProductDetailVC()
            let info = self.discountedProductsArr[indexPath.row]
            productDetailVC.itemID = info.itemId
            productDetailVC.productID = info.productId
            productDetailVC.vendorID = info.vendorId
            self.navigationController?.pushViewController(productDetailVC, animated: true)
        }
    }
    
    
}

extension VendorDetailVC: UICollectionViewDelegateFlowLayout {
    // 1
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        
        let collectionWidth = collectionView.bounds.width
        //          return CGSize(width: collectionWidth / 2 - 10, height: collectionWidth / 2 + 80)
        return CGSize(width: collectionWidth / 2.1 - 10, height: 370)
        
        
    }
}
