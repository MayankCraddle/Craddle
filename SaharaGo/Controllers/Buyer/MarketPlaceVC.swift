//
//  MarketPlaceVC.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 02/03/23.
//

import UIKit

class MarketPlaceVC: UIViewController {
    
    @IBOutlet weak var cartBadgeLbl: UILabel!
    @IBOutlet weak var cartBadgeView: UIView!
    @IBOutlet weak var flagImg: UIImageView!
    @IBOutlet weak var countryNameLbl: UILabel!
    @IBOutlet weak var headerViewOne: MyCustomHeaderView!
    @IBOutlet weak var headerViewTwo: MyCustomHeaderView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var bannerCollView: UICollectionView!
    @IBOutlet weak var onsaleCollView: UICollectionView!
    @IBOutlet weak var topDealsCollView: UICollectionView!
    @IBOutlet weak var newArrivalsCollView: UICollectionView!
    
    var newArrivalsArr = [SimilarProducts_Struct]()
    var topDealsArr = [SimilarProducts_Struct]()
    var onSaleArr = [SimilarProducts_Struct]()
    var bannerImages = ["slide1", "slide2", "slider3", "slider4", "slider5"]
    
    var timer : Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layoutIfNeeded()
        self.pageControl.numberOfPages = 5
        self.pageControl.currentPage = 0
        
        startTimer()
        self.getNewArrivals()
        self.getTopDeals()
        self.getonSale()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateCartBadge(_:)), name: Notification.Name("updateCartBadge"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.setCartBadge()
        self.navigationController?.navigationBar.isHidden = true
//        let flag = UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.SELECTED_FLAG) as! String
//        let imageUrl = FLAG_BASE_URL + "/" + flag
//        if let data = try? Data(contentsOf: URL(string: imageUrl)!) {
//            flagImg.image = UIImage(data: data)
//        }
        let flag = "nigeria.png"
        let imageUrl = FLAG_BASE_URL + "/" + flag
        if let data = try? Data(contentsOf: URL(string: imageUrl)!) {
            flagImg.image = UIImage(data: data)
        }
//        self.countryNameLbl.text = "Nigeria"
//        self.countryNameLbl.text = "\(UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.SELECTED_COUNTRY) as! String)'s Products"
        self.countryNameLbl.text = "Products"
        guard let countryColorStr = UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.COUNTRY_COLOR_CODE) as? String else {return}
        guard let rgba = countryColorStr.slice(from: "(", to: ")") else { return }
        let myStringArr = rgba.components(separatedBy: ",")
        //        layer.cornerRadius = 6
        countryColor = UIColor(red: CGFloat((myStringArr[0] as NSString).doubleValue/255.0), green: CGFloat((myStringArr[1] as NSString).doubleValue/255.0), blue: CGFloat((myStringArr[2] as NSString).doubleValue/255.0), alpha: CGFloat((myStringArr[3] as NSString).doubleValue))
        self.headerViewOne.backgroundColor = UIColor(red: CGFloat((myStringArr[0] as NSString).doubleValue/255.0), green: CGFloat((myStringArr[1] as NSString).doubleValue/255.0), blue: CGFloat((myStringArr[2] as NSString).doubleValue/255.0), alpha: CGFloat((myStringArr[3] as NSString).doubleValue))
        self.headerViewTwo.backgroundColor = UIColor(red: CGFloat((myStringArr[0] as NSString).doubleValue/255.0), green: CGFloat((myStringArr[1] as NSString).doubleValue/255.0), blue: CGFloat((myStringArr[2] as NSString).doubleValue/255.0), alpha: CGFloat((myStringArr[3] as NSString).doubleValue))
        
        
        
        self.countryNameLbl.text = "Products"

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        timer = nil
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
    
    func startTimer() {
        guard timer == nil else { return }
        timer = Timer.scheduledTimer(timeInterval: 3, target: self , selector:
                                        #selector(scrollToNextCell), userInfo: nil, repeats: true)
    }
    //      Scroll to Next Cell
    @objc func scrollToNextCell(){
        //get cell size
        let cellSize = view.frame.size
        //get current content Offset of the Collection view
        let contentOffset = self.bannerCollView.contentOffset
        
        if self.bannerCollView.contentSize.width <= self.bannerCollView.contentOffset.x + cellSize.width
        {
            let r = CGRect(x: 0, y: contentOffset.y, width: cellSize.width, height: cellSize.height)
            self.bannerCollView.scrollRectToVisible(r, animated: true)
            
        }
        else
        {
            let r = CGRect(x: contentOffset.x + cellSize.width, y: contentOffset.y, width: cellSize.width, height: cellSize.height)
            self.bannerCollView.scrollRectToVisible(r, animated: true);
        }
        
        if pageControl.currentPage == pageControl.numberOfPages - 1 {
            pageControl.currentPage = 0
        }
        else
        {
            pageControl.currentPage += 1
        }
        //self.collView.scrollToItem(at: IndexPath(row: pageControl.currentPage, section: 0), at: .right, animated: true)
    }
    
    func getNewArrivals() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = [:]
            
            let apiUrl = BASE_URL + PROJECT_URL.GET_NEW_PRODUCTS_BY_COUNTRY + "&pageNumber=\(1)" + "&limit=5"
            //&categoryId=&pageNumber=1&limit=10&sorting=
            let url : NSString = apiUrl as NSString
            let urlStr : NSString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! as NSString
            
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: urlStr as String, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    self.newArrivalsArr.removeAll()
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
                        
                        self.newArrivalsArr.append(SimilarProducts_Struct.init(currency: currency, vendorId: vendorId, productId: productId, name: name, description: description, dimension: dimension, wishlisted: wishlisted, orderable: orderable, discountType: discountType, itemId: itemId, categoryId: categoryId, actualPrice: actualPrice, discountValue: discountValue, stock: stock, discountedPrice: discountedPrice, rating: rating, images: imgArr))
                        
                    }
                    
                    if self.newArrivalsArr.count > 0 {
                        DispatchQueue.main.async {
                            //                            self.newProductsSectionView.isHidden = false
                            self.newArrivalsCollView.reloadData()
                        }
                        
                    } else {
                        //                        self.newProductsSectionView.isHidden = true
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
    
    func getTopDeals() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = [:]
            
            let apiUrl = BASE_URL + PROJECT_URL.GET_TOP_DEALS_PRODUCTS_BY_COUNTRY + "&pageNumber=\(1)" + "&limit=4"
            let url : NSString = apiUrl as NSString
            let urlStr : NSString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! as NSString
            
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: urlStr as String, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    self.topDealsArr.removeAll()
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
                        let itemId = json["productList"][i]["itemId"].stringValue
                        let categoryId = json["productList"][i]["categoryId"].stringValue
                        let vendorId = json["productList"][i]["vendorId"].stringValue
                        
                        var imgArr = [String]()
                        for j in 0..<json["productList"][i]["metaData"]["images"].count {
                            let file = json["productList"][i]["metaData"]["images"][j].stringValue
                            imgArr.append(file)
                        }
                        
                        self.topDealsArr.append(SimilarProducts_Struct.init(currency: currency, vendorId: vendorId, productId: productId, name: name, description: description, dimension: dimension, wishlisted: wishlisted, discountType: discountType, itemId: itemId, categoryId: categoryId, actualPrice: actualPrice, discountValue: discountValue, stock: stock, discountedPrice: discountedPrice, rating: rating, images: imgArr))
                        
                    }
                    
                    if self.topDealsArr.count > 0 {
                        DispatchQueue.main.async {
                            //                            self.newProductsSectionView.isHidden = false
                            self.topDealsCollView.reloadData()
                        }
                        
                    } else {
                        //                        self.newProductsSectionView.isHidden = true
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
    
    func getonSale() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = [:]
            
            let apiUrl = BASE_URL + PROJECT_URL.GET_ONSALE_PRODUCTS_BY_COUNTRY + "&pageNumber=\(1)" + "&limit=6"
            let url : NSString = apiUrl as NSString
            let urlStr : NSString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! as NSString
            
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: urlStr as String, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    self.onSaleArr.removeAll()
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
                        let itemId = json["productList"][i]["itemId"].stringValue
                        let categoryId = json["productList"][i]["categoryId"].stringValue
                        let vendorId = json["productList"][i]["vendorId"].stringValue
                        
                        var imgArr = [String]()
                        for j in 0..<json["productList"][i]["metaData"]["images"].count {
                            let file = json["productList"][i]["metaData"]["images"][j].stringValue
                            imgArr.append(file)
                        }
                        
                        self.onSaleArr.append(SimilarProducts_Struct.init(currency: currency, vendorId: vendorId, productId: productId, name: name, description: description, dimension: dimension, wishlisted: wishlisted, discountType: discountType, itemId: itemId, categoryId: categoryId, actualPrice: actualPrice, discountValue: discountValue, stock: stock, discountedPrice: discountedPrice, rating: rating, images: imgArr))
                        
                    }
                    
                    if self.onSaleArr.count > 0 {
                        DispatchQueue.main.async {
                            //                            self.newProductsSectionView.isHidden = false
                            self.onsaleCollView.reloadData()
                        }
                        
                    } else {
                        //                        self.newProductsSectionView.isHidden = true
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
    
    @IBAction func viewAllActions(_ sender: UIButton) {
        if sender.tag == 101 {
            // New Arrivals
            let productDetailVC = DIConfigurator.shared.getViewAllProductsVC()
            productDetailVC.headerStr = "New Arrivals"
//            productDetailVC.productsArr = self.newArrivalsArr
            self.navigationController?.pushViewController(productDetailVC, animated: true)
        } else if sender.tag == 102 {
            // Top Deals
            let productDetailVC = DIConfigurator.shared.getViewAllProductsVC()
//            productDetailVC.productsArr = self.topDealsArr
            productDetailVC.headerStr = "Top Deals"
            self.navigationController?.pushViewController(productDetailVC, animated: true)
        } else {
            // On sale
            let productDetailVC = DIConfigurator.shared.getViewAllProductsVC()
//            productDetailVC.productsArr = self.onSaleArr
            productDetailVC.headerStr = "On Sale"
            self.navigationController?.pushViewController(productDetailVC, animated: true)
        }
    }
    
    @IBAction func onClickWishlist(_ sender: UIButton) {
        if UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.VENDOR_SIGNUP_TOKEN) != nil {
            let wishlistVC = DIConfigurator.shared.getWishlistVC()
            self.navigationController?.pushViewController(wishlistVC, animated: true)
        } else {
            let vc = DIConfigurator.shared.getLoginVC()
            self.navigationController?.pushViewController(vc, animated: true)
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
    
}

extension MarketPlaceVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.topDealsCollView {
            return self.topDealsArr.count > 4 ? 4 : self.topDealsArr.count
        } else if collectionView == self.newArrivalsCollView {
            return self.newArrivalsArr.count > 5 ? 5 : self.newArrivalsArr.count
            
        } else if collectionView == self.bannerCollView {
            return 5
        } else if collectionView == self.onsaleCollView {
            return  self.onSaleArr.count > 6 ? 6 : self.onSaleArr.count
        } else {
            return 4
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.newArrivalsCollView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewArrivalCollCell", for: indexPath) as! NewArrivalCollCell
            let info = self.newArrivalsArr[indexPath.row]
            cell.cellProductLbl.text = info.name
            cell.cellPriceLbl.text = "₦\(info.discountedPrice)"
            if info.images!.count > 0 {
                cell.cellImg.sd_setImage(with: URL(string: FILE_BASE_URL + "\(info.images![0])"), placeholderImage: UIImage(named: "loading"))
            }
            return cell
        } else if collectionView == self.topDealsCollView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopDealsCollCell", for: indexPath) as! TopDealsCollCell
            let info = self.topDealsArr[indexPath.row]
            cell.cellProductLbl.text = info.name
            cell.cellPriceLbl.text = "₦\(info.discountedPrice)"
            if info.images!.count > 0 {
                cell.cellImg.sd_setImage(with: URL(string: FILE_BASE_URL + "\(info.images![0])"), placeholderImage: UIImage(named: "loading"))
            }
            return cell
        } else if collectionView == self.bannerCollView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeNewBannerCollCell", for: indexPath) as! HomeNewBannerCollCell
            cell.cellImg.image = UIImage(named: self.bannerImages[indexPath.row])
            return cell
        } else if collectionView == self.onsaleCollView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnSaleCollCell", for: indexPath) as! OnSaleCollCell
            let info = self.onSaleArr[indexPath.row]
            cell.cellProductLbl.text = info.name
            cell.cellPriceLbl.text = "₦\(info.discountedPrice)"
            if info.images!.count > 0 {
                cell.cellImg.sd_setImage(with: URL(string: FILE_BASE_URL + "\(info.images![0])"), placeholderImage: UIImage(named: "loading"))
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LocalProductsCollCell", for: indexPath) as! LocalProductsCollCell
            
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.newArrivalsCollView {
            let productDetailVC = DIConfigurator.shared.getProductDetailVC()
            let info = self.newArrivalsArr[indexPath.row]
            productDetailVC.itemID = info.itemId
            productDetailVC.productID = info.productId
            productDetailVC.vendorID = info.vendorId
            self.navigationController?.pushViewController(productDetailVC, animated: true)
        } else if collectionView == self.topDealsCollView {
            let productDetailVC = DIConfigurator.shared.getProductDetailVC()
            let info = self.topDealsArr[indexPath.row]
            productDetailVC.itemID = info.itemId
            productDetailVC.productID = info.productId
            productDetailVC.vendorID = info.vendorId
            self.navigationController?.pushViewController(productDetailVC, animated: true)
        } else if collectionView == self.onsaleCollView {
            let productDetailVC = DIConfigurator.shared.getProductDetailVC()
            let info = self.onSaleArr[indexPath.row]
            productDetailVC.itemID = info.itemId
            productDetailVC.productID = info.productId
            productDetailVC.vendorID = info.vendorId
            self.navigationController?.pushViewController(productDetailVC, animated: true)
        }else if collectionView == self.bannerCollView {
            if indexPath.row == 0 {
                let contentDetailVC = DIConfigurator.shared.getVendorListVC()
                contentDetailVC.type = "wholesaler"
                contentDetailVC.header = "Wholesalers"
                contentDetailVC.bannerImgName = self.bannerImages[indexPath.row]
                self.navigationController?.pushViewController(contentDetailVC, animated: true)
            } else if indexPath.row == 1 {
                let contentDetailVC = DIConfigurator.shared.getVendorListVC()
                contentDetailVC.type = "exporter"
                contentDetailVC.header = "Exporters"
                contentDetailVC.bannerImgName = self.bannerImages[indexPath.row]
                self.navigationController?.pushViewController(contentDetailVC, animated: true)
            } else if indexPath.row == 2 {
                let contentDetailVC = DIConfigurator.shared.getVendorListVC()
                contentDetailVC.type = "manufacturer"
                contentDetailVC.header = "Manufacturers"
                contentDetailVC.bannerImgName = self.bannerImages[indexPath.row]
                self.navigationController?.pushViewController(contentDetailVC, animated: true)
            } else if indexPath.row == 3 {
                let contentDetailVC = DIConfigurator.shared.getVendorListVC()
                contentDetailVC.type = "all"
                contentDetailVC.header = "Retailers"
                contentDetailVC.bannerImgName = self.bannerImages[indexPath.row]
                self.navigationController?.pushViewController(contentDetailVC, animated: true)
            } else {
                let contentDetailVC = DIConfigurator.shared.getVendorListVC()
                contentDetailVC.type = "farmer"
                contentDetailVC.header = "Farmers"
                contentDetailVC.bannerImgName = self.bannerImages[indexPath.row]
                self.navigationController?.pushViewController(contentDetailVC, animated: true)
            }
            
        }
    }
    
}

// MARK: - Collection View Flow Layout Delegate
extension MarketPlaceVC: UICollectionViewDelegateFlowLayout {
    // 1
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        
        if collectionView == self.topDealsCollView {
            let collectionWidth = self.topDealsCollView.bounds.width
            let collectionHeight = self.topDealsCollView.bounds.height
            return CGSize(width: (collectionWidth - 10) / 2, height: (collectionHeight - 10) / 2)
            
        } else if collectionView == self.bannerCollView {
//            let collectionWidth = self.bannerCollView.bounds.width
            let collectionHeight = self.bannerCollView.bounds.height
            let collectionWidth = UIScreen.main.bounds.size.width
//            let collectionHeight = UIScreen.main.bounds.size.height
            return CGSize(width: collectionWidth - 8, height: collectionHeight)
            
        } else if collectionView == self.onsaleCollView {
            let collectionWidth = self.onsaleCollView.bounds.width
            let collectionHeight = self.onsaleCollView.bounds.height
            return CGSize(width: (collectionWidth - 20) / 3, height: (collectionHeight - 20) / 2)
        } else if collectionView == self.newArrivalsCollView {
            let collectionWidth = self.newArrivalsCollView.bounds.width
            return CGSize(width: (collectionWidth - 10) / 3, height: 200)
            
        } else {
            return CGSize(width: 150, height: 70)
        }
                
    }
}
