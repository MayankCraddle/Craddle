//
//  ExploreVC.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 27/09/22.
//

import UIKit

class ExploreVC: UIViewController, UISearchBarDelegate {
    
    
    @IBOutlet weak var typeView: UIView!
    @IBOutlet weak var countryNameLbl: UILabel!
//    @IBOutlet weak var headerLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var headerViewTwo: MyCustomHeaderView!
    @IBOutlet weak var headerViewOne: MyCustomHeaderView!
    @IBOutlet weak var flagImg: UIImageView!
    @IBOutlet weak var searchTypeLbl: UILabel!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var vendorListArr = [vendorDetailsStruct]()
    var productListArr = [categoryProductListStruct]()
    var filesArr = [String]()
    var pageNo = 1
    var searchText = ""
    var mediaContentList = [mediaContentListStruct]()
    var isFromProductSearch = false
    var isFromMultimediaSearch = false
    var searchIsFrom = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        searchBar.delegate = self
        searchBar.setSearchFieldBackgroundImage(UIImage(), for: .normal)
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        bgView.roundCorners(corners: [.topLeft, .topRight], cornerRadius: 25)
        AnalyticsUtil.instance.trackEvent(AnalyticsEvents.kSearchScreen)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let flag = UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.SELECTED_FLAG) as! String
        let imageUrl = FLAG_BASE_URL + "/" + flag
        if let data = try? Data(contentsOf: URL(string: imageUrl)!) {
            flagImg.image = UIImage(data: data)
        }
        self.countryNameLbl.text = "\(UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.SELECTED_COUNTRY) as! String)"
        guard let countryColorStr = UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.COUNTRY_COLOR_CODE) as? String else {return}
        guard let rgba = countryColorStr.slice(from: "(", to: ")") else { return }
        let myStringArr = rgba.components(separatedBy: ",")
        
        self.headerViewOne.backgroundColor = UIColor(red: CGFloat((myStringArr[0] as NSString).doubleValue/255.0), green: CGFloat((myStringArr[1] as NSString).doubleValue/255.0), blue: CGFloat((myStringArr[2] as NSString).doubleValue/255.0), alpha: CGFloat((myStringArr[3] as NSString).doubleValue))
        self.headerViewTwo.backgroundColor = UIColor(red: CGFloat((myStringArr[0] as NSString).doubleValue/255.0), green: CGFloat((myStringArr[1] as NSString).doubleValue/255.0), blue: CGFloat((myStringArr[2] as NSString).doubleValue/255.0), alpha: CGFloat((myStringArr[3] as NSString).doubleValue))
        
//        self.searchIsFrom = UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.SELECTED_COUNTRY) as! String == "Nigeria" ? "Products" : "Multimedia"
        
        
        if let search = UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.SEARCH_IS_FROM) as? String, search != nil {
//            if UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.SELECTED_COUNTRY) as! String == "Nigeria" {
//                self.searchIsFrom = ""
//            } else {
//                self.searchIsFrom = search
//            }
            self.searchIsFrom = search
            
        }
        
        if searchIsFrom == "Products" {
            searchBar.becomeFirstResponder()
//            self.backView.isHidden = false
//            self.headerLeftConstraint.constant = 8.0
            self.searchTypeLbl.text = UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.SELECTED_COUNTRY) as! String == "Nigeria" ? "Products" : "Multimedia"
//            self.searchTypeLbl.text = "Products"
            UserDefaults.standard.set("Products", forKey: USER_DEFAULTS_KEYS.SEARCH_IS_FROM)
        } else if searchIsFrom == "Multimedia" {
            searchBar.becomeFirstResponder()
//            self.backView.isHidden = false
//            self.headerLeftConstraint.constant = 8.0
            self.searchTypeLbl.text = "Multimedia"
            UserDefaults.standard.set("Multimedia", forKey: USER_DEFAULTS_KEYS.SEARCH_IS_FROM)
        } else if searchIsFrom == "Vendors" {
            searchBar.becomeFirstResponder()
//            self.backView.isHidden = false
//            self.headerLeftConstraint.constant = 8.0
//            self.searchTypeLbl.text = "Vendors"
            self.searchTypeLbl.text = UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.SELECTED_COUNTRY) as! String == "Nigeria" ? "Vendors" : "Multimedia"
            UserDefaults.standard.set("Vendors", forKey: USER_DEFAULTS_KEYS.SEARCH_IS_FROM)
        } else {
            if UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.SELECTED_COUNTRY) as! String == "Nigeria" {
                searchBar.becomeFirstResponder()
//                self.backView.isHidden = true
//                self.headerLeftConstraint.constant = 0.0
//                self.searchTypeLbl.text = "Products"
                self.searchTypeLbl.text = self.searchIsFrom == "" ? "Products" : self.searchIsFrom
                UserDefaults.standard.set("Products", forKey: USER_DEFAULTS_KEYS.SEARCH_IS_FROM)
            } else {
                searchBar.becomeFirstResponder()
//                self.backView.isHidden = true
//                self.headerLeftConstraint.constant = 0.0
                self.searchTypeLbl.text = "Multimedia"
                UserDefaults.standard.set("Multimedia", forKey: USER_DEFAULTS_KEYS.SEARCH_IS_FROM)
            }
            
        }
        
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
//    @objc func readMoreBtnClicked(sender: UIButton) {
//
//        let row = sender.tag % 1000
//        let section = sender.tag / 1000
//
//        let indexPath = IndexPath(row: row, section: section)
//        let cell = (sender.superview?.superview?.superview?.superview?.superview?.superview as? MediaContentCell) // track your cell here
//        //let indexPath: IndexPath = self.mediaTableView.indexPathForRow(at: sender.convert(CGPoint.zero, to: self.mediaTableView))!
//
//        cell!.cellSubTitleLbl.numberOfLines = 0
//        DispatchQueue.main.async {
//            self.mediaTableView.reloadRows(at: [indexPath], with: .none)
//        }
//
////        self.mediaTableView.reloadRows(at: [indexPath], with: .none)
//    }
//
    @objc func viewAllCommentBtnClicked(sender: UIButton) {

        let row = sender.tag % 1000
        let section = sender.tag / 1000

        let indexPath = IndexPath(row: row, section: section)
        
        
        let viewAllVC = DIConfigurator.shared.getViewCommentsVC()
        viewAllVC.blogId = self.mediaContentList[row].id
        viewAllVC.shortDesc = "\(self.mediaContentList[row].subject)"
//        viewAllVC.blogId = self.allMediaCatAndContentListArr[section].sectionContent[row].id
//        viewAllVC.shortDesc = self.allMediaCatAndContentListArr[section].sectionContent[row].subject
        self.navigationController?.pushViewController(viewAllVC, animated: true)
    }
//
//    @objc func sendCommentBtnClicked(sender: UIButton) {
//        let row = sender.tag % 1000
//        let section = sender.tag / 1000
////        let indexPath = IndexPath(row:row, section: section)
//        let info = self.allMediaCatAndContentListArr[section].sectionContent[row]
//        let cell = (sender.superview?.superview?.superview?.superview?.superview as? MediaContentCell)
//        if cell!.commentTxtView.text == "" {
//            self.view.makeToast("Please write your comment.")
//        } else {
//            self.postCommentAPI("\(info.id)", comment: cell!.commentTxtView.text)
//
//            DispatchQueue.main.async {
//                cell?.commentTxtView.text = ""
//            }
//        }
//
//    }
//
    @objc func shareBtnClicked(sender: UIButton)
       {
           let row = sender.tag % 1000
           let section = sender.tag / 1000
//           let rowId = sender.tag
//           let info = self.mediaContentList[rowId]
           let info = self.mediaContentList[row]
           let imageUrl = info.shareURl
           self.shareButton(Url: imageUrl)

       }
    
    func shareButton(Url: String) {
        
        // text to share
        let text = Url
        
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func onClickWishlistProduct(_ sender: UIButton) {
        if UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.VENDOR_SIGNUP_TOKEN) != nil {
            let indexPath: IndexPath? = searchTableView.indexPathForRow(at: sender.convert(CGPoint.zero, to: searchTableView))
            let info = self.productListArr[indexPath!.row]
            self.wishlistAPI(info.itemId)
        } else {
            self.view.makeToast("Hey, you need to login in order to add product to Wishlist.")
        }
        
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
    
    @IBAction func onClickSearchType(_ sender: UIButton) {
        
        if UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.SELECTED_COUNTRY) as! String != "Nigeria" {
            return
        }
        
        let alert = UIAlertController(title: "Search", message: "What do you want to search ?", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Products", style: .default , handler:{ (UIAlertAction)in
            self.view.endEditing(true)
            self.emptyView.isHidden = true
            self.typeView.isHidden = false
            self.searchTableView.isHidden = true
            self.searchBar.text = ""
            self.searchTypeLbl.text = "Products"
            UserDefaults.standard.set("Products", forKey: USER_DEFAULTS_KEYS.SEARCH_IS_FROM)
        }))
        
        alert.addAction(UIAlertAction(title: "Vendors", style: .default , handler:{ (UIAlertAction)in
            self.view.endEditing(true)
            self.emptyView.isHidden = true
            self.typeView.isHidden = false
            self.searchTableView.isHidden = true
            self.searchBar.text = ""
            self.searchTypeLbl.text = "Vendors"
            UserDefaults.standard.set("Vendors", forKey: USER_DEFAULTS_KEYS.SEARCH_IS_FROM)
        }))
        
        alert.addAction(UIAlertAction(title: "Multimedia", style: .default , handler:{ (UIAlertAction)in
            self.view.endEditing(true)
            self.emptyView.isHidden = true
            self.typeView.isHidden = false
            self.searchTableView.isHidden = true
            self.searchBar.text = ""
            self.searchTypeLbl.text = "Multimedia"
            UserDefaults.standard.set("Multimedia", forKey: USER_DEFAULTS_KEYS.SEARCH_IS_FROM)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
        
    }
    
    func searchVendorAndProductApi() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            let apiUrl = BASE_URL + PROJECT_URL.SEARCH_VENDOR_PRODUCT + "?country=Nigeria" + "&searchType=\(self.searchTypeLbl.text == "Products" ? "Product" : "Vendor")" + "&searchText=\(self.searchText)" + "&pageNumber=\(self.pageNo)" + "&limit=\(20)"
            let url : NSString = apiUrl as NSString
            let urlStr : NSString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! as NSString
            
            let param:[String:String] = [:]
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: urlStr as String, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    self.view.endEditing(true)
                    if self.searchTypeLbl.text == "Vendors" {
                                                
                        for i in 0..<json["vendorList"].count
                        {
                            let streetAddress = json["vendorList"][i]["metaData"]["streetAddress"].stringValue
                            let city = json["vendorList"][i]["metaData"]["city"].stringValue
                            let state = json["vendorList"][i]["metaData"]["state"].stringValue
                            let country = json["vendorList"][i]["metaData"]["country"].stringValue
                            let image = json["vendorList"][i]["metaData"]["image"].stringValue
                            let companyName = json["vendorList"][i]["metaData"]["companyName"].stringValue
                            let rating = json["vendorList"][i]["metaData"]["rating"].stringValue
                            //                        let status = json["vendorList"][i]["metaData"]["status"].boolValue
                            //                        let vendorId = json["vendorList"][i]["vendorId"].stringValue
                            let emailMobile = json["vendorList"][i]["emailMobile"].stringValue
                            let vendorEncryptedId = json["vendorList"][i]["vendorEncryptedId"].stringValue
                            let vendorId = json["vendorList"][i]["vendorId"].stringValue
                            let fcmKey = json["vendorList"][i]["fcmKey"].stringValue
                            let vendorFName = json["vendorList"][i]["metaData"]["firstName"].stringValue
                            let vendorLName = json["vendorList"][i]["metaData"]["lastName"].stringValue
                            
                            UserDefaults.standard.set(fcmKey, forKey: "vendor_fcm_key")
                            
                            self.vendorListArr.append(vendorDetailsStruct.init(vendorName: "\(vendorFName) \(vendorLName)", vendorStreetAddress: streetAddress, vendorCity: city, vendorCountry: country, vendorState: state, vendorEmailMobile: emailMobile, vendorCompanyName: companyName, vendorImage: image, vendorRating: rating, totalSize: json["totalSize"].intValue, vendorId: vendorId, vendorEncryptedId: vendorEncryptedId, fcmKey: fcmKey))
                            
                        }
                        
                        DispatchQueue.main.async {
                            self.typeView.isHidden = true
                            if self.vendorListArr.count > 0 {
                                self.emptyView.isHidden = true
                                self.searchTableView.isHidden = false
                                self.searchTableView.delegate = self
                                self.searchTableView.dataSource = self
                                self.searchTableView.reloadData()
                            } else {
                                self.emptyView.isHidden = false
                                self.searchTableView.isHidden = true
                            }
                        }
                        
                    } else {
                        
                        
                        for i in 0..<json["productList"].count
                        {
                            let discountedPrice = json["productList"][i]["discountedPrice"].stringValue
                            let actualPrice = json["productList"][i]["actualPrice"].stringValue
                            let productId = json["productList"][i]["productId"].stringValue
                            let itemId = json["productList"][i]["itemId"].stringValue
                            let name = json["productList"][i]["name"].stringValue
                            let currency = json["productList"][i]["currency"].stringValue
                            let rating = json["productList"][i]["rating"].stringValue
                            let wishlisted = json["productList"][i]["wishlisted"].boolValue
                            let description = json["productList"][i]["metaData"]["description"].stringValue
                            let vendorId = json["productList"][i]["vendorId"].stringValue
                            let discountValue = json["productList"][i]["discountValue"].stringValue
                            
                            self.filesArr.removeAll()
                            
                            for j in 0..<json["productList"][i]["metaData"]["images"].count {
                                self.filesArr.append(json["productList"][i]["metaData"]["images"][j].stringValue)
                            }
                            
                            self.productListArr.append(categoryProductListStruct.init(categoryId: "", currency: currency, description: description, category: "", stock: "", vendorName: "", productId: productId, itemId: itemId, price: "", discountedPrice: discountedPrice, discountPercent: discountValue, rating: rating ?? "0.0", name: name, images: self.filesArr, actualPrice: actualPrice, wishlisted: wishlisted, returnPolicy: "", totalSize: json["totalSize"].intValue, vendorDetails: vendorDetailsStruct.init(vendorName: "", vendorStreetAddress: "", vendorCity: "", vendorCountry: "", vendorState: "", vendorEmailMobile: "", vendorCompanyName: "", vendorImage: "", vendorRating: ""), socialMediaArr: [], vendorId: vendorId))
                            
                        }
                        
                        DispatchQueue.main.async {
                            self.typeView.isHidden = true
                            if self.productListArr.count > 0 {
                                self.emptyView.isHidden = true
                                self.searchTableView.isHidden = false
                                self.searchTableView.delegate = self
                                self.searchTableView.dataSource = self
                                self.searchTableView.reloadData()
                            } else {
                                self.emptyView.isHidden = false
                                self.searchTableView.isHidden = true
                            }
                        }
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
    
    func searchContentApi() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let apiUrl = BASE_URL + PROJECT_URL.SEARCH_CONTENT + "?country=\(country)" + "&searchText=\(self.searchText)" + "&pageNumber=\(self.pageNo)" + "&limit=\(20)"
            let url : NSString = apiUrl as NSString
            let urlStr : NSString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! as NSString
            
            let param:[String:String] = [:]
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: urlStr as String, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    self.view.endEditing(true)
                    self.mediaContentList.removeAll()
                    for i in 0..<json["contentList"].count
                    {
//                        let subject = json["contentList"][i]["subject"].stringValue
//                        let shortDescription = json["contentList"][i]["shortDescription"].stringValue
//                        let id = json["contentList"][i]["id"].intValue
//                        let sectionId = json["contentList"][i]["sectionId"].intValue
//                        let comments = value["content"][i]["comments"].arrayValue
                        
                        let subject = json["contentList"][i]["subject"].stringValue
                        let shortDescription = json["contentList"][i]["shortDescription"].stringValue
                        let id = json["contentList"][i]["id"].intValue
                        let videoUrl = json["contentList"][i]["videoUrl"].stringValue
                        let videoId = json["contentList"][i]["videoId"].stringValue
                        let readCount = json["contentList"][i]["readCount"].stringValue
                        let comments = json["contentList"][i]["comments"].arrayValue
                        let commentCount = json["contentList"][i]["commentCount"].stringValue
                        let shareURl = json["contentList"][i]["shareURl"].stringValue
                        let sectionId = json["contentList"][i]["sectionId"].intValue
                        let createdOn = json["contentList"][i]["createdOn"].stringValue
                        
                        self.filesArr.removeAll()
                        for j in 0..<json["contentList"][i]["files"].count {
                            
                            self.filesArr.append(json["contentList"][i]["files"][j].stringValue)
                        }
                        
                        var commentArr = [commentTypeStruct]()
                        for k in 0..<comments.count {
                            
                            commentArr.append(commentTypeStruct.init(createdBy: comments[k]["createdBy"].stringValue, comment: comments[k]["comment"].stringValue, createdOn: comments[k]["createdOn"].stringValue))
                        }
                        
//                        self.mediaContentList.append(mediaContentListStruct.init(subject: subject, id: id, shortDescription: shortDescription, files: self.filesArr, sectionId: sectionId, totalSize: json["totalSize"].intValue))
                        self.mediaContentList.append(mediaContentListStruct.init(subject: subject, id: id, shortDescription: shortDescription, files: self.filesArr, sectionId: sectionId, videoUrl: videoUrl, videoId: videoId, readCount: readCount, comments: commentArr, commentCount: commentCount, isReadMore: false, shareURl: shareURl, createdOn: createdOn))
                        
                    }
                    
                    DispatchQueue.main.async {
                        self.typeView.isHidden = true
                        if self.mediaContentList.count > 0 {
                            self.emptyView.isHidden = true
                            self.searchTableView.isHidden = false
                            self.searchTableView.delegate = self
                            self.searchTableView.dataSource = self
                            self.searchTableView.reloadData()
                        } else {
                            self.emptyView.isHidden = false
                            self.searchTableView.isHidden = true
                        }
                        
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("searchText \(searchText)")
        if searchText == "" {
            self.view.endEditing(true)
            self.emptyView.isHidden = true
            self.typeView.isHidden = false
            self.searchTableView.isHidden = true
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.pageNo = 1
        self.vendorListArr.removeAll()
        self.productListArr.removeAll()
        self.mediaContentList.removeAll()
        
        if self.searchTypeLbl.text == "Multimedia" {
            self.searchText = searchBar.text!
            self.searchContentApi()
        } else {
            self.searchText = searchBar.text!
            self.searchVendorAndProductApi()
        }
    }
    
    @IBAction func flagAction(_ sender: UIButton) {
        let sellerStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = sellerStoryboard.instantiateViewController(withIdentifier: "ChooseCountryVC") as! ChooseCountryVC
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    func moveOnContentDetailVC(tabIndex: Int, collIndex: Int) {

        let contentDetailVC = DIConfigurator.shared.getContentDetailVC()
        contentDetailVC.blogId = self.mediaContentList[collIndex].id
        contentDetailVC.sectionId = "\(self.mediaContentList[collIndex].sectionId)"
//        self.mediaContentList
//        contentDetailVC.blogId = self.allMediaCatAndContentListArr[tabIndex].sectionContent[collIndex].id
//        contentDetailVC.sectionId = "\(self.allMediaCatAndContentListArr[tabIndex].sectionContent[collIndex].sectionId)"
        self.navigationController?.pushViewController(contentDetailVC, animated: true)
    }
    
}

extension ExploreVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.searchTypeLbl.text == "Vendors" {
            return 145.0
        } else if self.searchTypeLbl.text == "Products" {
            return 180.0
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchTypeLbl.text == "Vendors" {
            return self.vendorListArr.count
        } else if self.searchTypeLbl.text == "Products" {
            return self.productListArr.count
        } else {
            return self.mediaContentList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.searchTypeLbl.text == "Vendors" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "VendorSearchTableCell", for: indexPath) as! VendorSearchTableCell
            
            let info = vendorListArr[indexPath.row]
            cell.cellVendorLbl.text = info.vendorCompanyName
            cell.cellAddressLbl.text = info.vendorStreetAddress
            cell.cellImg.sd_setImage(with: URL(string: FILE_BASE_URL + "\(info.vendorImage)"), placeholderImage: UIImage(named: "loading"))
            cell.cellRating.rating = Double(Int(info.vendorRating) ?? 0)
            cell.cellRating.settings.updateOnTouch = false
            cell.cellRating.settings.fillMode = .precise
            
            //            if info.wishlisted {
            //                cell.cellWishlistBtn.setImage(UIImage(named: "wishlist_active"), for: .normal)
            //            } else {
            //                cell.cellWishlistBtn.setImage(UIImage(named: "wishlist"), for: .normal)
            //            }
            
            if indexPath.row == self.vendorListArr.count - 1 { // last cell
                if info.totalSize > self.vendorListArr.count { // more items to fetch
                    self.pageNo += 1
                    self.searchVendorAndProductApi() // increment `fromIndex` by 20 before server call
                }
            }
            
            return cell
        } else if self.searchTypeLbl.text == "Products" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductSearchTableCell", for: indexPath) as! ProductSearchTableCell
            
            let info = productListArr[indexPath.row]
            
            cell.cellProductLbl.text = info.name
            cell.cellDescLbl.text = info.description
            cell.cellRatingView.rating = Double(info.rating)!
            cell.cellRatingView.settings.updateOnTouch = false
            cell.cellRatingView.settings.fillMode = .precise
            cell.cellDiscountPriceLbl.text = "₦\(info.discountedPrice)"
            
            if info.discountPercent == "0" {
                cell.cellActualPriceLbl.isHidden = true
            } else {
                cell.cellActualPriceLbl.isHidden = false
            }
            
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "₦\(info.actualPrice)")
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            cell.cellActualPriceLbl.attributedText = attributeString
            
            if info.images!.count > 0 {
                cell.cellImg.sd_setImage(with: URL(string: FILE_BASE_URL + "\(info.images![0])"), placeholderImage: UIImage(named: "loading"))
            }
            
            if info.wishlisted {
                cell.cellWishlistBtn.setImage(UIImage(named: "wishlist_active"), for: .normal)
            } else {
                cell.cellWishlistBtn.setImage(UIImage(named: "wishlist"), for: .normal)
            }
            
            if indexPath.row == self.productListArr.count - 1 { // last cell
                if info.totalSize > self.productListArr.count { // more items to fetch
                    self.pageNo += 1
                    self.searchVendorAndProductApi() // increment `fromIndex` by 20 before server call
                }
            }
            
            return cell
        } else {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "MediaContentCell", for: indexPath) as! MediaContentCell
//
//            let info = self.mediaContentList[indexPath.row]
//
//            cell.cellTitleLbl.text = info.subject
//            cell.cellSubTitleLbl.text = info.shortDescription
//            //        cell.cellTitleLbl.font = UIFont(name: "Poppins-SemiBold", size: 11)
//            let imageArr = info.files
//            cell.cellImg.sd_setImage(with: URL(string: FILE_BASE_URL + "\(imageArr[0])"), placeholderImage: UIImage(named: "loading"))
//
//            if indexPath.row == self.mediaContentList.count - 1 { // last cell
//                if info.totalSize > self.mediaContentList.count { // more items to fetch
//                    self.pageNo += 1
//                    self.searchVendorAndProductApi() // increment `fromIndex` by 20 before server call
//                }
//            }
//
//            return cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "MediaContentCell", for: indexPath) as! MediaContentCell
            
    //        let info = self.mediaContentList[indexPath.row]
            let info = self.mediaContentList[indexPath.row]
            cell.section = indexPath.section
            cell.row = indexPath.row
            
            cell.cellViewAllCommentBtn.tag = (indexPath.section * 1000) + indexPath.row
            cell.cellViewAllCommentBtn.addTarget(self, action: #selector(self.viewAllCommentBtnClicked(sender:)), for: UIControl.Event.touchUpInside)
            
            cell.cellReadMoreBtn.tag = (indexPath.section * 1000) + indexPath.row
//            cell.cellReadMoreBtn.addTarget(self, action: #selector(self.readMoreBtnClicked(sender:)), for: UIControl.Event.touchUpInside)
            
            cell.sendCommentBtn.tag = (indexPath.section * 1000) + indexPath.row
//            cell.sendCommentBtn.addTarget(self, action: #selector(self.sendCommentBtnClicked(sender:)), for: UIControl.Event.touchUpInside)
            
            cell.cellShareBtn.tag = (indexPath.section * 1000) + indexPath.row
            cell.cellShareBtn.addTarget(self, action: #selector(self.shareBtnClicked(sender:)), for: UIControl.Event.touchUpInside)
            
            cell.mediaInfo = info
            
            cell.didselectClosure = { tabIndex, cellIndex in
                if let tabIndexp = tabIndex, let cellIndexp = cellIndex {
                    self.moveOnContentDetailVC(tabIndex: tabIndexp, collIndex: cellIndexp)
                }
                
            }
            
            return cell

        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.searchTypeLbl.text == "Products" {
            let productDetailVC = DIConfigurator.shared.getProductDetailVC()
            let info = self.productListArr[indexPath.row]
            productDetailVC.itemID = info.itemId
            productDetailVC.productID = info.productId
            productDetailVC.vendorID = info.vendorId
            self.navigationController?.pushViewController(productDetailVC, animated: true)
        } else if self.searchTypeLbl.text == "Multimedia" {
            let contentDetailVC = DIConfigurator.shared.getContentDetailVC()
            //        contentDetailVC.id = self.homeSectionList[self.mediaTappedIndex].content[indexPath.row].id
            contentDetailVC.blogId = self.mediaContentList[indexPath.row].id
            contentDetailVC.sectionId = "\(self.mediaContentList[indexPath.row].sectionId)"
            self.navigationController?.pushViewController(contentDetailVC, animated: true)
        } else {
            let vendorDetailVC = DIConfigurator.shared.getVendorDetailVC()
            let info = self.vendorListArr[indexPath.row]
            vendorDetailVC.vendorId = info.vendorId
            vendorDetailVC.vendorEncryptedId = info.vendorEncryptedId
            vendorDetailVC.vendorName = info.vendorName
            vendorDetailVC.fcmKey = info.fcmKey
            self.navigationController?.pushViewController(vendorDetailVC, animated: true)
//            let vc = DIConfigurator.shared.getChatVC()
//            let info = self.vendorListArr[indexPath.row]
//            vc.toId = info.vendorEncryptedId
//            vc.fcmKey = info.fcmKey
//            UserDefaults.standard.set(info.vendorName, forKey: USER_DEFAULTS_KEYS.TO_LOGIN_NAME)
//            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
}

extension ExploreVC: ChooseCountryDelegate{
    func onSelectCountry(country: Select_Country_List_Struct, isFrom: String) {
//        self.searchIsFrom = country.countryName == "Nigeria" ? "Products" : "Multimedia"
        
        if let search = UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.SEARCH_IS_FROM) as? String, search != nil {

            self.searchIsFrom = search
            
        }
        
        if searchIsFrom == "Products" {
            searchBar.becomeFirstResponder()
//            self.backView.isHidden = false
//            self.headerLeftConstraint.constant = 8.0
//            self.searchTypeLbl.text = "Products"
            self.searchTypeLbl.text = UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.SELECTED_COUNTRY) as! String != "Nigeria" ? "Multimedia" : "Products"
            UserDefaults.standard.set("Products", forKey: USER_DEFAULTS_KEYS.SEARCH_IS_FROM)
        } else if searchIsFrom == "Multimedia" {
            searchBar.becomeFirstResponder()
//            self.backView.isHidden = false
//            self.headerLeftConstraint.constant = 8.0
            self.searchTypeLbl.text = "Multimedia"
            UserDefaults.standard.set("Multimedia", forKey: USER_DEFAULTS_KEYS.SEARCH_IS_FROM)
        } else if searchIsFrom == "Vendors" {
            searchBar.becomeFirstResponder()
//            self.backView.isHidden = false
//            self.headerLeftConstraint.constant = 8.0
//            self.searchTypeLbl.text = "Vendors"
            self.searchTypeLbl.text = UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.SELECTED_COUNTRY) as! String != "Nigeria" ? "Multimedia" : "Vendors"
            UserDefaults.standard.set("Vendors", forKey: USER_DEFAULTS_KEYS.SEARCH_IS_FROM)
        } else {
//            self.backView.isHidden = true
//            self.headerLeftConstraint.constant = 0.0
            
            if UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.SELECTED_COUNTRY) as! String == "Nigeria" {
                searchBar.becomeFirstResponder()
//                self.backView.isHidden = true
//                self.headerLeftConstraint.constant = 0.0
//                self.searchTypeLbl.text = "Products"
                self.searchTypeLbl.text = self.searchIsFrom == "" ? "Products" : self.searchIsFrom
                UserDefaults.standard.set("Products", forKey: USER_DEFAULTS_KEYS.SEARCH_IS_FROM)
            } else {
                searchBar.becomeFirstResponder()
//                self.backView.isHidden = true
//                self.headerLeftConstraint.constant = 0.0
                self.searchTypeLbl.text = "Multimedia"
                UserDefaults.standard.set("Multimedia", forKey: USER_DEFAULTS_KEYS.SEARCH_IS_FROM)
            }
                
            
        }
        
        let flag = UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.SELECTED_FLAG) as! String
        let imageUrl = FLAG_BASE_URL + "/" + flag
//        self.flagImg.sd_setImage(with: URL(string: imageUrl), completed: nil)
        if let data = try? Data(contentsOf: URL(string: imageUrl)!) {
                // Create Image and Update Image View
                flagImg.image = UIImage(data: data)
            }
        self.countryNameLbl.text = "\(country.countryName)"
        self.emptyView.isHidden = false
        self.searchTableView.isHidden = true
        self.searchBar.text = ""
            
        let countryColorStr = country.colorCode
        guard let rgba = countryColorStr.slice(from: "(", to: ")") else { return }
        let myStringArr = rgba.components(separatedBy: ",")
        //        layer.cornerRadius = 6
        
        self.headerViewOne.backgroundColor = UIColor(red: CGFloat((myStringArr[0] as NSString).doubleValue/255.0), green: CGFloat((myStringArr[1] as NSString).doubleValue/255.0), blue: CGFloat((myStringArr[2] as NSString).doubleValue/255.0), alpha: CGFloat((myStringArr[3] as NSString).doubleValue))
        self.headerViewTwo.backgroundColor = UIColor(red: CGFloat((myStringArr[0] as NSString).doubleValue/255.0), green: CGFloat((myStringArr[1] as NSString).doubleValue/255.0), blue: CGFloat((myStringArr[2] as NSString).doubleValue/255.0), alpha: CGFloat((myStringArr[3] as NSString).doubleValue))
        countryColor = UIColor(red: CGFloat((myStringArr[0] as NSString).doubleValue/255.0), green: CGFloat((myStringArr[1] as NSString).doubleValue/255.0), blue: CGFloat((myStringArr[2] as NSString).doubleValue/255.0), alpha: CGFloat((myStringArr[3] as NSString).doubleValue))
//        self.tabBarController?.tabBar.tintColor = UIColor(red: CGFloat((myStringArr[0] as NSString).doubleValue/255.0), green: CGFloat((myStringArr[1] as NSString).doubleValue/255.0), blue: CGFloat((myStringArr[2] as NSString).doubleValue/255.0), alpha: CGFloat((myStringArr[3] as NSString).doubleValue))
    }
}
