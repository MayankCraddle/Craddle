//
//  TradeVC.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 01/11/22.
//

import UIKit

class TradeVC: UIViewController {

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var bannerCollView: UICollectionView!
    @IBOutlet weak var onsaleCollView: UICollectionView!
    @IBOutlet weak var topDealsCollView: UICollectionView!
    @IBOutlet weak var newArrivalsCollView: UICollectionView!
    
    let cellScale = 0.6
    var newArrivalsArr = [SimilarProducts_Struct]()
    var topDealsArr = [SimilarProducts_Struct]()
    var onSaleArr = [SimilarProducts_Struct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        let screenSize = UIScreen.main.bounds.size
//        let cellWidth = floor(screenSize.width * cellScale)
//        let cellHeight = floor(screenSize.height * cellScale)
//        let insetX = (view.bounds.width - cellWidth) / 2.0
//        let insetY = (view.bounds.height - cellHeight) / 2.0
//
//        let layout = bannerCollView.collectionViewLayout as! UICollectionViewFlowLayout
//        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
//        bannerCollView.contentInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)
        self.getNewArrivals()
        self.getTopDeals()
        self.getonSale()
        
        self.pageControl.numberOfPages = 3
        self.pageControl.currentPage = 0
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getNewArrivals() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = [:]
            
            let apiUrl = BASE_URL + PROJECT_URL.GET_NEW_PRODUCTS_BY_COUNTRY
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
                        
                        self.newArrivalsArr.append(SimilarProducts_Struct.init(currency: currency, vendorId: vendorId, productId: productId, name: name, description: description, dimension: dimension, wishlisted: wishlisted, discountType: discountType, itemId: itemId, categoryId: categoryId, actualPrice: actualPrice, discountValue: discountValue, stock: stock, discountedPrice: discountedPrice, rating: rating, images: imgArr))
                        
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
            
            let apiUrl = BASE_URL + PROJECT_URL.GET_TOP_DEALS_PRODUCTS_BY_COUNTRY
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
            
            let apiUrl = BASE_URL + PROJECT_URL.GET_ONSALE_PRODUCTS_BY_COUNTRY
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
    
}

extension TradeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.topDealsCollView {
            return self.topDealsArr.count
        } else if collectionView == self.newArrivalsCollView {
            return self.newArrivalsArr.count
        } else if collectionView == self.bannerCollView {
            return 3
        } else {
            return self.onSaleArr.count
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
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnSaleCollCell", for: indexPath) as! OnSaleCollCell
            let info = self.onSaleArr[indexPath.row]
            cell.cellProductLbl.text = info.name
            cell.cellPriceLbl.text = "₦\(info.discountedPrice)"
            if info.images!.count > 0 {
                cell.cellImg.sd_setImage(with: URL(string: FILE_BASE_URL + "\(info.images![0])"), placeholderImage: UIImage(named: "loading"))
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.newArrivalsCollView {
            let collectionWidth = self.newArrivalsCollView.bounds.width
            return CGSize(width: (collectionWidth - 10) / 3, height: 200)
            
        } else if collectionView == self.topDealsCollView {
            let collectionWidth = self.topDealsCollView.bounds.width
            let collectionHeight = self.topDealsCollView.bounds.height
            return CGSize(width: (collectionWidth - 10) / 2, height: (collectionHeight - 10) / 2)
            
        } else if collectionView == self.bannerCollView {
            let collectionWidth = self.bannerCollView.bounds.width
            let collectionHeight = self.bannerCollView.bounds.height
            return CGSize(width: (collectionWidth - 20), height: (collectionHeight))
            
        } else {
            let collectionWidth = self.onsaleCollView.bounds.width
            let collectionHeight = self.onsaleCollView.bounds.height
            return CGSize(width: (collectionWidth - 20) / 3, height: (collectionHeight - 20) / 2)
        }
      
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = bannerCollView.contentOffset.x / bannerCollView.frame.size.width
        self.pageControl.currentPage = Int(pageNumber)
    }
    
}
