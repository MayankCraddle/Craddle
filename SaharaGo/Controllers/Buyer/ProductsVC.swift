
import UIKit

class ProductsVC: UIViewController {
    
    @IBOutlet weak var cartBadgeLbl: UILabel!
    @IBOutlet weak var cartBadgeView: UIView!
    @IBOutlet weak var countryNameLbl: UILabel!
    @IBOutlet weak var segmentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var segmentView: UIView!
    @IBOutlet weak var headerViewTwo: MyCustomHeaderView!
    @IBOutlet weak var headerViewOne: MyCustomHeaderView!
    @IBOutlet weak var flagImg: UIImageView!
    @IBOutlet weak var mediaEmptyView: UIView!
    @IBOutlet weak var segment: MyCustomSegment!
    @IBOutlet weak var categoryCollView: UICollectionView!
    @IBOutlet weak var localProductsCollView: UICollectionView!
    @IBOutlet weak var exportCollView: UICollectionView!
    @IBOutlet weak var attractionProductCollView: UICollectionView!
    @IBOutlet weak var agriculturalProductsCollView: UICollectionView!
    
    @IBOutlet weak var localProductsCollView_height: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mediaTableView: UITableView!
    @IBOutlet weak var servicesView: UIView!
    @IBOutlet weak var mediaCollView: UICollectionView!
    @IBOutlet weak var catEmptyView: UIView!
    @IBOutlet weak var catCollView: UICollectionView!
    @IBOutlet weak var productsView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var bannerCollView: UICollectionView!
    @IBOutlet weak var onsaleCollView: UICollectionView!
    @IBOutlet weak var topDealsCollView: UICollectionView!
    @IBOutlet weak var newArrivalsCollView: UICollectionView!
    
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var view5: UIView!
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label5: UILabel!
    
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var image4: UIImageView!
    @IBOutlet weak var image5: UIImageView!

    
    @IBOutlet weak var imgSelected: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    
    
    private let itemsPerRow: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(
        top: 15.0,
        left: 20.0,
        bottom: 50.0,
        right: 20.0)
    
    var homeSectionList = [homeSectionDataStruct]()
    var contentList = [contentStruct]()
    var mediaTappedIndex = 0
    var colourSetArr = [UIColor]()
    var ColourCollArr = ["rgb(254, 61, 65)", "rgb(250, 134, 3)", "rgb(0, 198, 130)", "rgb(44, 146, 227)", "rgb(162, 67, 213)", "rgb(44, 147, 169)", "rgb(254, 61, 65)"]
    var categoriesList = [categoryListStruct]()
    var mediaCategoriesList = [mediaCategoryListStruct]()
    var mediaCategoriesListCopy = [mediaCategoryListStruct]()
    var mediaContentList = [mediaContentListStruct]()
    var categoriesListCopy = [categoryListStruct]()
    var allMediaCatAndContentListArr = [allMediaCatAndContentListStruct]()
    var newArrivalsArr = [SimilarProducts_Struct]()
    var topDealsArr = [SimilarProducts_Struct]()
    var onSaleArr = [SimilarProducts_Struct]()
    //    var sectionId = ""
    var filesArr = [Any]()
    var sectionId = ""
    var isFrom = "Multimedia"
    var selectedSection = 0
    
    var isExpandedArr = [Bool]()
    var searchIsFrom = ""
    var bannerImages = ["slide1", "slide2", "slider3", "slider4", "slider5"]
    
    @IBOutlet weak var productsSegmentBtn: MyCustomButton!
    @IBOutlet weak var multimediaSegmentBtn: MyCustomButton!
    
    var timer : Timer?
    var mediaWithProductsArr = [mediaContentListStruct]()
    var mediaContentListCopy = [Any]()

    let dispatchGroup = DispatchGroup()
    var currentPageIndex: Int = 1
    var totalDataCount: Int?
    var shouldReloadTable = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentPageIndex = 1
        // Do any additional setup after loading the view.
        self.categoryCollView.register(UINib(nibName: "ProductCategoryCell", bundle: nil), forCellWithReuseIdentifier: "ProductCategoryCell")
        self.localProductsCollView.register(UINib(nibName: "LocalProductsCollCell", bundle: nil), forCellWithReuseIdentifier: "LocalProductsCollCell")
        self.exportCollView.register(UINib(nibName: "ExportsCollCell", bundle: nil), forCellWithReuseIdentifier: "ExportsCollCell")
        self.attractionProductCollView.register(UINib(nibName: "ExportsCollCell", bundle: nil), forCellWithReuseIdentifier: "ExportsCollCell")
        self.agriculturalProductsCollView.register(UINib(nibName: "ExportsCollCell", bundle: nil), forCellWithReuseIdentifier: "ExportsCollCell")
        self.view.layoutIfNeeded()
        self.pageControl.numberOfPages = 5
        self.pageControl.currentPage = 0
        self.setTabBar()
        
        
        if self.isFrom == "Multimedia" {
            timer?.invalidate()
            timer = nil
            //            self.getMediaCategoriesList()
            self.searchIsFrom = "Multimedia"
            
            self.productsSegmentBtn.setImage(UIImage(named: "marketplace"), for: .normal)
            self.productsSegmentBtn.backgroundColor = UIColor(red: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1.0)
            self.multimediaSegmentBtn.setImage(UIImage(named: "multimedia_active"), for: .normal)
            self.multimediaSegmentBtn.backgroundColor = UIColor(red: 3.0/255.0, green: 135.0/255.0, blue: 82.0/255.0, alpha: 1.0)
            
//            self.getContentListBySectionId("")
//            self.getMediaCategoriesList()
            if country == "Nigeria" {
                self.view2.isHidden = false
                self.view4.isHidden = false
                self.servicesView.isHidden = false
                self.segment.selectedSegmentIndex = 1
            } else {
                self.view2.isHidden = true
                self.view4.isHidden = true
                self.servicesView.isHidden = false
                self.segment.selectedSegmentIndex = 1
                self.segmentViewHeight.constant = 0
//                self.segment.isHidden = true
            }
        } else {
            startTimer()
            self.searchIsFrom = "Products"
            //            self.getCategoriesList()
            self.getNewArrivals()
            self.getTopDeals()
            self.getonSale()
            self.showProducts()
            self.productsSegmentBtn.backgroundColor = UIColor(red: 3.0/255.0, green: 135.0/255.0, blue: 82.0/255.0, alpha: 1.0)
            self.multimediaSegmentBtn.backgroundColor = UIColor(red: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1.0)
            self.productsSegmentBtn.setImage(UIImage(named: "marketplace_active"), for: .normal)
            self.multimediaSegmentBtn.setImage(UIImage(named: "multimedia"), for: .normal)
            //            self.servicesView.isHidden = false
            self.segment.selectedSegmentIndex = 0
        }

        NotificationCenter.default.addObserver(self, selector: #selector(updateCartBadge(_:)), name: Notification.Name("updateCartBadge"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(openNotification(_:)), name: NSNotification.Name(rawValue: "openNotification"), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        currentPageIndex = 1
        self.setCartBadge()
        self.navigationController?.navigationBar.isHidden = true
        let flag = UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.SELECTED_FLAG) as! String
        let imageUrl = FLAG_BASE_URL + "/" + flag
        if let data = try? Data(contentsOf: URL(string: imageUrl)!) {
            flagImg.image = UIImage(data: data)
        }
//        self.countryNameLbl.text = "\(UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.SELECTED_COUNTRY) as! String)'s Products"
        self.countryNameLbl.text = "Products"
        guard let countryColorStr = UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.COUNTRY_COLOR_CODE) as? String else {return}
        guard let rgba = countryColorStr.slice(from: "(", to: ")") else { return }
        let myStringArr = rgba.components(separatedBy: ",")
        //        layer.cornerRadius = 6
        countryColor = UIColor(red: CGFloat((myStringArr[0] as NSString).doubleValue/255.0), green: CGFloat((myStringArr[1] as NSString).doubleValue/255.0), blue: CGFloat((myStringArr[2] as NSString).doubleValue/255.0), alpha: CGFloat((myStringArr[3] as NSString).doubleValue))
        self.headerViewOne.backgroundColor = UIColor(red: CGFloat((myStringArr[0] as NSString).doubleValue/255.0), green: CGFloat((myStringArr[1] as NSString).doubleValue/255.0), blue: CGFloat((myStringArr[2] as NSString).doubleValue/255.0), alpha: CGFloat((myStringArr[3] as NSString).doubleValue))
        self.headerViewTwo.backgroundColor = UIColor(red: CGFloat((myStringArr[0] as NSString).doubleValue/255.0), green: CGFloat((myStringArr[1] as NSString).doubleValue/255.0), blue: CGFloat((myStringArr[2] as NSString).doubleValue/255.0), alpha: CGFloat((myStringArr[3] as NSString).doubleValue))
      
        if (UserDefaults.standard.value(forKey: "isMultimediaProductsAvailable") != nil) {
            self.getMultimediaProductsAPI()
        }
        
        if self.isFrom == "MarketPlace" {
            self.startTimer()
            label2.textColor = countryColor
            guard let countryColorStr = UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.COUNTRY_COLOR_CODE) as? String else {return}
            guard let rgba = countryColorStr.slice(from: "(", to: ")") else { return }
            let myStringArr = rgba.components(separatedBy: ",")
            //        layer.cornerRadius = 6
            image2.image = image2.image?.withRenderingMode(.alwaysTemplate)
            image2.tintColor = UIColor(red: CGFloat((myStringArr[0] as NSString).doubleValue/255.0), green: CGFloat((myStringArr[1] as NSString).doubleValue/255.0), blue: CGFloat((myStringArr[2] as NSString).doubleValue/255.0), alpha: CGFloat((myStringArr[3] as NSString).doubleValue))
        } else {
//            self.getContentListBySectionId("")
            self.getMediaCategoriesList()
        }
        
        if self.searchIsFrom == "Products" {
//            self.countryNameLbl.text = "\(UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.SELECTED_COUNTRY) as! String)'s Products"
            self.countryNameLbl.text = "Products"
        } else {
            self.countryNameLbl.text = UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.SELECTED_COUNTRY) as! String
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        timer = nil
    }
    
    override func viewDidLayoutSubviews() {
        self.changecollectionHeight()
        
        let font = UIFont(name: "Poppins-Regular", size: 11.0)!
        let fontSelected = UIFont(name: "Poppins-Medium", size: 11.0)!
        
        let normalAttribute: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: UIColor.gray]
        segment.setTitleTextAttributes(normalAttribute, for: .normal)
        
        let selectedAttribute: [NSAttributedString.Key: Any] = [.font: fontSelected, .foregroundColor: UIColor.white]
        segment.setTitleTextAttributes(selectedAttribute, for: .selected)
    }
    
    func setCartBadge() {
        if let cartCount = UserDefaults.standard.value(forKey: "cartCount") as? Int {
            self.cartBadgeView.isHidden = false
            self.cartBadgeLbl.text = "\(cartCount)"
        } else {
            self.cartBadgeView.isHidden = true
        }
        
    }
    
    @objc func openNotification(_ notification: Notification) {
        if self.isFrom == "Multimedia" {
            timer?.invalidate()
            timer = nil
            //            self.getMediaCategoriesList()
            self.searchIsFrom = "Multimedia"
            
            self.productsSegmentBtn.setImage(UIImage(named: "marketplace"), for: .normal)
            self.productsSegmentBtn.backgroundColor = UIColor(red: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1.0)
            self.multimediaSegmentBtn.setImage(UIImage(named: "multimedia_active"), for: .normal)
            self.multimediaSegmentBtn.backgroundColor = UIColor(red: 3.0/255.0, green: 135.0/255.0, blue: 82.0/255.0, alpha: 1.0)
            
            self.getContentListBySectionId("")
//            self.getMediaCategoriesList()
            if country == "Nigeria" {
                self.view2.isHidden = false
                self.view4.isHidden = false
                self.servicesView.isHidden = false
                self.segment.selectedSegmentIndex = 1
            } else {
                self.view2.isHidden = true
                self.view4.isHidden = true
                self.servicesView.isHidden = false
                self.segment.selectedSegmentIndex = 1
                self.segmentViewHeight.constant = 0
//                self.segment.isHidden = true
            }
        } else {
            startTimer()
            self.searchIsFrom = "Products"
            //            self.getCategoriesList()
            self.getNewArrivals()
            self.getTopDeals()
            self.getonSale()
            self.showProducts()
            self.productsSegmentBtn.backgroundColor = UIColor(red: 3.0/255.0, green: 135.0/255.0, blue: 82.0/255.0, alpha: 1.0)
            self.multimediaSegmentBtn.backgroundColor = UIColor(red: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1.0)
            self.productsSegmentBtn.setImage(UIImage(named: "marketplace_active"), for: .normal)
            self.multimediaSegmentBtn.setImage(UIImage(named: "multimedia"), for: .normal)
            //            self.servicesView.isHidden = false
            self.segment.selectedSegmentIndex = 0
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
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getContentWithSection(_ country: String) {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = [:]
            
            let apiUrl = BASE_URL + PROJECT_URL.GET_CONTENT_WITH_SECTIONS + "?country=\(country)"
            let url : NSString = apiUrl as NSString
            let urlStr : NSString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! as NSString
            
            //            let apiUrl = BASE_URL + PROJECT_URL.GET_CONTENT_WITH_SECTION_ID + "\(1)" + "/\(1)" + "/\(50)" + "?searchText=" + "&country=\(country)"
            //            let url : NSString = apiUrl as NSString
            //            let urlStr : NSString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! as NSString
            
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: urlStr as String, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    self.homeSectionList.removeAll()
                    for (key,value) in json["detail"] {
                        print("\(key) = \(value)")
                        self.contentList.removeAll()
                        for i in 0..<value["content"].count {
                            self.contentList.append(contentStruct.init(createdOn: value["content"][i]["createdOn"].stringValue, country: value["content"][i]["country"].stringValue, shortDescription: value["content"][i]["shortDescription"].stringValue, body: value["content"][i]["body"].stringValue, subject: value["content"][i]["subject"].stringValue, type: value["content"][i]["type"].stringValue, files: value["content"][i]["files"].arrayObject!, id: value["content"][i]["id"].intValue))
                        }
                        self.homeSectionList.append(homeSectionDataStruct.init(sectionName: "\(key)", content: self.contentList, priority: value["priority"].intValue, sectionId: value["sectionId"].intValue))
                        
                    }
                    
                    self.homeSectionList = self.homeSectionList.sorted(by: { $0.priority < $1.priority })
                    self.createColourSet()
                    DispatchQueue.main.async {
                        //                        self.mediaTableView.isHidden = false
                        //                        self.productsView.isHidden = true
                        //                        self.mediaTableView.delegate = self
                        //                        self.mediaTableView.dataSource = self
                        //                        self.mediaTableView.reloadData()
                        guard let countryName = UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.SELECTED_COUNTRY) as? String else {
                            return
                        }
                        //                        if countryName == "Nigeria" {
                        ////                            self.segment.insertSegment(withTitle: "Products", at: 0, animated: true)
                        //                            self.showProducts()
                        //                        } else {
                        //                            self.segment.removeSegment(at: 0, animated: true)
                        //                            self.showMedia()
                        //                        }
                        self.showMedia()
                        
                        hideAllProgressOnView(appDelegateInstance.window!)
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
    
    func getCategoriesList() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = [:]
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.VENDOR_GET_ALL_CATEGORY, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    self.categoriesList.removeAll()
                    for i in 0..<json["parentCategoryList"].count
                    {
                        let id = json["parentCategoryList"][i]["id"].stringValue
                        let status = json["parentCategoryList"][i]["status"].stringValue
                        let name = json["parentCategoryList"][i]["name"].stringValue
                        // let metadata = json["categoryList"][i]["metaData"]
                        
                        let description = json["parentCategoryList"][i]["metaData"]["description"].stringValue
                        let image = json["parentCategoryList"][i]["metaData"]["image"].stringValue
                        let isSubCategoryAvailable = json["parentCategoryList"][i]["isSubCategoryAvailable"].boolValue
                        
                        let parentCategory = json["parentCategoryList"][i]["parentCategory"].stringValue
                        
                        if parentCategory == "0" {
                            self.categoriesList.append(categoryListStruct.init(id: id, status: status, name: name, description: description, image: image, isSubCategoryAvailable: isSubCategoryAvailable, parentCategory: parentCategory))
                        }
                        
                        
                    }
                    self.categoriesListCopy = self.categoriesList
                    
                    
                    DispatchQueue.main.async {
                        self.showProducts()
                        if self.categoriesList.count > 0 {
                            self.catCollView.isHidden = false
                            self.catEmptyView.isHidden = true
                            self.catCollView.reloadData()
                        } else {
                            self.catCollView.isHidden = true
                            self.catEmptyView.isHidden = false
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
    
    func getMediaCategoriesList() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            //{pageNumber}/{limit}?searchText=&country=
//            let apiUrl = BASE_URL + PROJECT_URL.GET_SECTION_LIST + "/\(1)" + "/\(20)" + "?searchText=" + "&country=\(country)"
            let apiUrl = BASE_URL + PROJECT_URL.GET_MEDIA_CATEGORY_LIST + "\(country)"
            let url : NSString = apiUrl as NSString
            let urlStr : NSString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! as NSString
            
            let param:[String:String] = [:]
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: urlStr as String, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    self.mediaCategoriesList.removeAll()
                    for i in 0..<json["sections"].count
                    {
                        let id = json["sections"][i]["id"].stringValue
                        let priority = json["sections"][i]["priority"].intValue
                        let sectionName = json["sections"][i]["sectionName"].stringValue
                        let createdOn = json["sections"][i]["createdOn"].stringValue
                        let icon = json["sections"][i]["icon"].stringValue
                        
                        self.mediaCategoriesList.append(mediaCategoryListStruct.init(id: id, priority: priority, sectionName: sectionName, createdOn: createdOn, icon: icon, type: "Media"))
                        
                        
                    }
                    self.mediaCategoriesList = self.mediaCategoriesList.sorted(by: { $0.priority < $1.priority })
                    self.mediaCategoriesListCopy = self.mediaCategoriesList
                    self.createColourSet()
                    
                    self.makeCategoriesHiglighted(self.mediaTappedIndex)

                    if self.mediaCategoriesListCopy.count > 0 {
                        
                        self.getContentListBySectionIdWithPagination(self.mediaCategoriesListCopy[self.mediaTappedIndex].id)
                        self.getMultimediaProductsAPI()
                        
                        self.dispatchGroup.notify(queue: .main) {
                            // whatever you want to do when both are done

                            if mediaProductsList.count > 0 {
                                self.createMediaWithProductArr()
                            } else {
                                DispatchQueue.main.async {
                                    if self.mediaContentList.count > 0 {

                                        self.mediaEmptyView.isHidden = true
                                        self.mediaTableView.isHidden = false
                                        self.mediaTableView.delegate = self
                                        self.mediaTableView.dataSource = self
                                        self.mediaTableView.reloadData()
                                        
                                    } else {
                                        self.mediaEmptyView.isHidden = false
                                        self.mediaTableView.isHidden = true
                                    }
                                }
                            }

                        }
                        
                        
                    }
                    
                    DispatchQueue.main.async {
                        self.showMedia()
                        self.mediaCollView.dataSource = self
                        self.mediaCollView.delegate = self
                        self.mediaCollView.reloadData()
                        
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
    
    func getContentListBySectionIdWithPagination(_ sectionId: String) {
        self.dispatchGroup.enter()
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            //{id}/{pageNumber}/{limit}?searchText= &country=
            let countryy = UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.SELECTED_COUNTRY) as! String
            let apiUrl = BASE_URL + PROJECT_URL.GET_CONTENT_LIST_BY_SECTION + "\(sectionId)" + "/\(currentPageIndex)" + "/\(50)" + "?searchText=" + "&country=\(countryy)" + "&type=all"
            let url : NSString = apiUrl as NSString
            let urlStr : NSString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! as NSString

            let param:[String:String] = [:]
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: urlStr as String, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    self.totalDataCount = json["totalSize"].intValue
                    if self.currentPageIndex == 1 {
                        self.mediaContentList.removeAll()
                    }
                    
                    for i in 0..<json["contentList"].count
                    {
                        let subject = json["contentList"][i]["subject"].stringValue
                        let shortDescription = json["contentList"][i]["shortDescription"].stringValue
                        let id = json["contentList"][i]["id"].intValue
                        let videoUrl = json["contentList"][i]["videoUrl"].stringValue
                        let videoId = json["contentList"][i]["videoId"].stringValue
                        let readCount = json["contentList"][i]["readCount"].stringValue
                        let comments = json["contentList"][i]["comments"].arrayValue
                        let commentCount = json["contentList"][i]["commentCount"].stringValue
                        let shareURl = json["contentList"][i]["shareURl"].stringValue


                        self.filesArr.removeAll()
                        for j in 0..<json["contentList"][i]["files"].count {

                            self.filesArr.append(json["contentList"][i]["files"][j].stringValue)
                        }

                        var commentArr = [commentTypeStruct]()
                        for k in 0..<comments.count {

                            commentArr.append(commentTypeStruct.init(createdBy: comments[k]["createdBy"].stringValue, comment: comments[k]["comment"].stringValue))
                        }

                        self.mediaContentList.append(mediaContentListStruct.init(subject: subject, id: id, shortDescription: shortDescription, files: self.filesArr, videoUrl: videoUrl, videoId: videoId, readCount: readCount, comments: commentArr, commentCount: commentCount, isReadMore: false, shareURl: shareURl, type: "Media"))

                    }
                    
                    self.createColourSet()
                    
//                    if self.shouldReloadTable {
//                        self.shouldReloadTable = false
//                        self.mediaTableView.reloadData()
//                    } else {
//                        DispatchQueue.main.async {
//                            self.dispatchGroup.leave()
//                        }
//                    }
                    
                    
                    
                    DispatchQueue.main.async {

                        self.dispatchGroup.leave()
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
    
    func getContentListBySectionId(_ sectionId: String) {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            let apiUrl = BASE_URL + PROJECT_URL.GET_ALL_CONTENT_SECTION + "country=\(country)" + "&type=all"
            let url : NSString = apiUrl as NSString
            let urlStr : NSString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! as NSString
            
            let param:[String:String] = [:]
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: urlStr as String, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    self.allMediaCatAndContentListArr.removeAll()
                    self.mediaContentList.removeAll()
                    self.mediaCategoriesList.removeAll()
                    var index = -1
                    for (key,value) in json["detail"] {
                        index += 1
                        print("\(key) = \(value)")
                        
                        if value["content"].count > 0 {
                            self.mediaCategoriesList.append(mediaCategoryListStruct.init(id: value["sectionId"].stringValue, priority: value["priority"].intValue, sectionName: key, createdOn: "", isSelected: false, icon: value["icon"].stringValue))
                            
                            self.mediaContentList.removeAll()
                            for i in 0..<value["content"].count
                            {
                                let subject = value["content"][i]["subject"].stringValue
                                let shortDescription = value["content"][i]["shortDescription"].stringValue
                                let id = value["content"][i]["id"].intValue
                                let videoUrl = value["content"][i]["videoUrl"].stringValue
                                let videoId = value["content"][i]["videoId"].stringValue
                                let readCount = value["content"][i]["readCount"].stringValue
                                let comments = value["content"][i]["comments"].arrayValue
                                let commentCount = value["content"][i]["commentCount"].stringValue
                                let shareURl = value["content"][i]["shareURl"].stringValue
                                let sectionId = value["content"][i]["sectionId"].intValue
                                let createdOn = value["content"][i]["createdOn"].stringValue
                                
                                self.filesArr.removeAll()
                                for j in 0..<value["content"][i]["files"].count {
                                    
                                    self.filesArr.append(value["content"][i]["files"][j].stringValue)
                                }
                                
                                var commentArr = [commentTypeStruct]()
                                for k in 0..<comments.count {
                                    
                                    commentArr.append(commentTypeStruct.init(createdBy: comments[k]["createdBy"].stringValue, comment: comments[k]["comment"].stringValue, createdOn: comments[k]["createdOn"].stringValue))
                                }
                                
                                self.mediaContentList.append(mediaContentListStruct.init(subject: subject, id: id, shortDescription: shortDescription, files: self.filesArr, sectionId: sectionId, videoUrl: videoUrl, videoId: videoId, readCount: readCount, comments: commentArr, commentCount: commentCount, isReadMore: false, shareURl: shareURl, createdOn: createdOn))
                                
                            }
                            self.allMediaCatAndContentListArr.append(allMediaCatAndContentListStruct.init(sectionName: key, sectionContent: self.mediaContentList, priority: value["priority"].intValue))
                        }
                        
                        
                        
                    }
                    self.allMediaCatAndContentListArr = self.allMediaCatAndContentListArr.sorted(by: { $0.priority < $1.priority })
                    self.mediaCategoriesList = self.mediaCategoriesList.sorted(by: { $0.priority < $1.priority })
                    self.makeCategoriesHiglighted(0)
                    self.createColourSet()
                    
                    DispatchQueue.main.async {
                        if self.allMediaCatAndContentListArr.count > 0 {
                            
                            self.showMedia()
                            //                            self.mediaCollView.dataSource = self
                            //                            self.mediaCollView.delegate = self
                            //                            self.mediaCollView.reloadData()
                            
                            self.mediaEmptyView.isHidden = true
                            self.mediaTableView.isHidden = false
                            self.mediaTableView.delegate = self
                            self.mediaTableView.dataSource = self
                            self.mediaTableView.reloadData()
                            
                        } else {
                            self.mediaEmptyView.isHidden = false
                            self.mediaTableView.isHidden = true
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
    //    func getContentListBySectionId(_ sectionId: String) {
    //        if Reachability.isConnectedToNetwork() {
    //            showProgressOnView(appDelegateInstance.window!)
    //            //{id}/{pageNumber}/{limit}?searchText= &country=
    //            let apiUrl = BASE_URL + PROJECT_URL.GET_CONTENT_LIST_BY_SECTION + "\(sectionId)" + "/\(1)" + "/\(50)" + "?searchText=" + "&country=\(country)" + "&type=all"
    //            let url : NSString = apiUrl as NSString
    //            let urlStr : NSString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! as NSString
    //
    //            let param:[String:String] = [:]
    //            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: urlStr as String, successBlock: { (json) in
    //                print(json)
    //                hideAllProgressOnView(appDelegateInstance.window!)
    //                let success = json["success"].stringValue
    //                if success == "true"
    //                {
    //                    self.mediaContentList.removeAll()
    //                    for i in 0..<json["contentList"].count
    //                    {
    //                        let subject = json["contentList"][i]["subject"].stringValue
    //                        let shortDescription = json["contentList"][i]["shortDescription"].stringValue
    //                        let id = json["contentList"][i]["id"].intValue
    //                        let videoUrl = json["contentList"][i]["videoUrl"].stringValue
    //                        let videoId = json["contentList"][i]["videoId"].stringValue
    //                        let readCount = json["contentList"][i]["readCount"].stringValue
    //                        let comments = json["contentList"][i]["comments"].arrayValue
    //                        let commentCount = json["contentList"][i]["commentCount"].stringValue
    //                        let shareURl = json["contentList"][i]["shareURl"].stringValue
    //
    //
    //                        self.filesArr.removeAll()
    //                        for j in 0..<json["contentList"][i]["files"].count {
    //
    //                            self.filesArr.append(json["contentList"][i]["files"][j].stringValue)
    //                        }
    //
    //                        var commentArr = [commentTypeStruct]()
    //                        for k in 0..<comments.count {
    //
    //                            commentArr.append(commentTypeStruct.init(createdBy: comments[k]["createdBy"].stringValue, comment: comments[k]["comment"].stringValue))
    //                        }
    //
    //                        self.mediaContentList.append(mediaContentListStruct.init(subject: subject, id: id, shortDescription: shortDescription, files: self.filesArr, videoUrl: videoUrl, videoId: videoId, readCount: readCount, comments: commentArr, commentCount: commentCount, isReadMore: false, shareURl: shareURl))
    //
    //                    }
    //
    //                    DispatchQueue.main.async {
    //                        if self.mediaContentList.count > 0 {
    //                            self.mediaEmptyView.isHidden = true
    //                            self.mediaTableView.isHidden = false
    //                            self.mediaTableView.delegate = self
    //                            self.mediaTableView.dataSource = self
    //                            self.mediaTableView.reloadData()
    //                        } else {
    //                            self.mediaEmptyView.isHidden = false
    //                            self.mediaTableView.isHidden = true
    //                        }
    //                     }
    //                }
    //                else {
    //                    UIAlertController.showInfoAlertWithTitle("Message", message: json["message"].stringValue, buttonTitle: "Okay")
    //                }
    //            }, errorBlock: { (NSError) in
    //                UIAlertController.showInfoAlertWithTitle("Alert", message: kUnexpectedErrorAlertString, buttonTitle: "Okay")
    //                hideAllProgressOnView(appDelegateInstance.window!)
    //            })
    //
    //        }else{
    //            hideAllProgressOnView(appDelegateInstance.window!)
    //            UIAlertController.showInfoAlertWithTitle("Alert", message: "Please Check internet connection", buttonTitle: "Okay")
    //        }
    //    }
    
    func postCommentAPI(_ id: String, comment: String) {
        
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
           
            let param:[String:Any] = [ "id": id,"comment": comment]
            ServerClass.sharedInstance.postRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.ADD_COMMENT, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    self.view.resignFirstResponder()
                    self.view.makeToast("Comment added successfully.")
//                    self.getContentListBySectionId("")
                    self.getContentListBySectionIdWithPagination(self.mediaCategoriesListCopy[self.mediaTappedIndex].id)
                    self.getMultimediaProductsAPI()
                    
                    self.dispatchGroup.notify(queue: .main) {
                        // whatever you want to do when both are done

                        if mediaProductsList.count > 0 {
                            self.createMediaWithProductArr()
                        } else {
                            DispatchQueue.main.async {
                                if self.mediaContentList.count > 0 {

                                    self.mediaEmptyView.isHidden = true
                                    self.mediaTableView.isHidden = false
                                    self.mediaTableView.delegate = self
                                    self.mediaTableView.dataSource = self
                                    self.mediaTableView.reloadData()
                                    
                                } else {
                                    self.mediaEmptyView.isHidden = false
                                    self.mediaTableView.isHidden = true
                                }
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
    
    func createColourSet() {
        for items in self.ColourCollArr {
            guard let rgba = items.slice(from: "(", to: ")") else { return }
            let myStringArr = rgba.components(separatedBy: ",")
            
            self.colourSetArr.append(UIColor(red: CGFloat((myStringArr[0] as NSString).doubleValue/255.0), green: CGFloat((myStringArr[1] as NSString).doubleValue/255.0), blue: CGFloat((myStringArr[2] as NSString).doubleValue/255.0), alpha: 1.0))
        }
    }
    
    func makeCategoriesHiglighted(_ higlightedIndex: Int) {
        self.mediaCategoriesListCopy = self.mediaCategoriesList
        var index = -1
        for items in self.mediaCategoriesListCopy {
            index += 1
            var item = items as! mediaCategoryListStruct
            if index == higlightedIndex {
                item.isSelected = true
                mediaCategoriesListCopy.remove(at: index)
                mediaCategoriesListCopy.insert(item, at: index)
            }
            
            
        }
        print(self.mediaCategoriesListCopy)
    }
    
    func moveOnViewAllVC(index: Int) {
        let viewAllVC = DIConfigurator.shared.getViewAllVC()
        viewAllVC.sectioId = self.homeSectionList[index].sectionId
        viewAllVC.isFromHome = false
        self.navigationController?.pushViewController(viewAllVC, animated: true)
    }
    
    func moveOnContentDetailVC(tabIndex: Int, collIndex: Int) {
        
        let contentDetailVC = DIConfigurator.shared.getContentDetailVC()
        contentDetailVC.blogId = self.mediaContentList[collIndex].id
        contentDetailVC.sectionId = self.mediaCategoriesListCopy[self.mediaTappedIndex].id
//        contentDetailVC.blogId = self.allMediaCatAndContentListArr[tabIndex].sectionContent[collIndex].id
//        contentDetailVC.sectionId = "\(self.allMediaCatAndContentListArr[tabIndex].sectionContent[collIndex].sectionId)"
        self.navigationController?.pushViewController(contentDetailVC, animated: true)
    }
    
    @IBAction func sellerSegmentValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            let contentDetailVC = DIConfigurator.shared.getVendorListVC()
            contentDetailVC.type = "exporter"
            self.navigationController?.pushViewController(contentDetailVC, animated: true)
        case 1:
            let contentDetailVC = DIConfigurator.shared.getVendorListVC()
            contentDetailVC.type = "manufacturer"
            self.navigationController?.pushViewController(contentDetailVC, animated: true)
        case 2:
            let contentDetailVC = DIConfigurator.shared.getVendorListVC()
            contentDetailVC.type = "wholesaler"
            self.navigationController?.pushViewController(contentDetailVC, animated: true)
        default:
            break
        }
    }
    
    
    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.searchIsFrom = "Products"
            if country == "Nigeria" {
                //                self.getCategoriesList()
                self.getNewArrivals()
                self.getTopDeals()
                self.getonSale()
                showProducts()
                
            } else {
                self.servicesView.isHidden = false
            }
            
        case 1:
            self.searchIsFrom = "Multimedia"
            //            self.getMediaCategoriesList()
//            self.getContentListBySectionId("")
            self.getContentListBySectionIdWithPagination(self.mediaCategoriesListCopy[self.mediaTappedIndex].id)
            self.getMultimediaProductsAPI()
            
            self.dispatchGroup.notify(queue: .main) {
                // whatever you want to do when both are done

                if mediaProductsList.count > 0 {
                    self.createMediaWithProductArr()
                } else {
                    DispatchQueue.main.async {
                        if self.mediaContentList.count > 0 {

                            self.mediaEmptyView.isHidden = true
                            self.mediaTableView.isHidden = false
                            self.mediaTableView.delegate = self
                            self.mediaTableView.dataSource = self
                            self.mediaTableView.reloadData()
                            
                        } else {
                            self.mediaEmptyView.isHidden = false
                            self.mediaTableView.isHidden = true
                        }
                    }
                }

            }
            
        case 2:
            showServices()
        default:
            break
        }
        
    }
    
    @IBAction func onClickSellerSegmentsBtn(_ sender: UIButton) {
        
        switch sender.tag {
        case 200:
            self.searchIsFrom = "Products"
            self.productsSegmentBtn.setImage(UIImage(named: "marketplace_active"), for: .normal)
            self.productsSegmentBtn.backgroundColor = UIColor(red: 3.0/255.0, green: 135.0/255.0, blue: 82.0/255.0, alpha: 1.0)
            self.multimediaSegmentBtn.setImage(UIImage(named: "multimedia"), for: .normal)
            self.multimediaSegmentBtn.backgroundColor = UIColor(red: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1.0)
            if country == "Nigeria" {
                //                self.getCategoriesList()
                self.getNewArrivals()
                self.getTopDeals()
                self.getonSale()
                showProducts()
                
            } else {
                self.servicesView.isHidden = false
            }
            
        case 201:
            self.searchIsFrom = "Multimedia"
            self.productsSegmentBtn.setImage(UIImage(named: "marketplace"), for: .normal)
            self.productsSegmentBtn.backgroundColor = UIColor(red: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1.0)
            self.multimediaSegmentBtn.setImage(UIImage(named: "multimedia_active"), for: .normal)
            self.multimediaSegmentBtn.backgroundColor = UIColor(red: 3.0/255.0, green: 135.0/255.0, blue: 82.0/255.0, alpha: 1.0)
            //            self.getMediaCategoriesList()
//            self.getContentListBySectionId("")
            self.getContentListBySectionIdWithPagination(self.mediaCategoriesListCopy[self.mediaTappedIndex].id)
            self.getMultimediaProductsAPI()
            
            self.dispatchGroup.notify(queue: .main) {
                // whatever you want to do when both are done

                if mediaProductsList.count > 0 {
                    self.createMediaWithProductArr()
                } else {
                    DispatchQueue.main.async {
                        if self.mediaContentList.count > 0 {

                            self.mediaEmptyView.isHidden = true
                            self.mediaTableView.isHidden = false
                            self.mediaTableView.delegate = self
                            self.mediaTableView.dataSource = self
                            self.mediaTableView.reloadData()
                            
                        } else {
                            self.mediaEmptyView.isHidden = false
                            self.mediaTableView.isHidden = true
                        }
                    }
                }

            }
            
        case 2:
            showServices()
        default:
            break
        }

    }
    
    
    
    func showProducts() {
        self.productsView.isHidden = false
        self.mediaCollView.isHidden = true
        self.mediaTableView.isHidden = true
        self.servicesView.isHidden = true
        self.mediaEmptyView.isHidden = true
        self.catEmptyView.isHidden = true
    }
    
    func showMedia() {
        if self.mediaCategoriesList.count > 0 {
            //            self.sectionId = self.mediaCategoriesList[0].id
            //            self.getContentListBySectionId(self.mediaCategoriesList[0].id)
        } else {
            self.mediaEmptyView.isHidden = false
            self.mediaTableView.isHidden = true
        }

        label4.textColor = countryColor
        timer?.invalidate()
        timer = nil
//            imgSelected.image = UIImage(named: "dadi_ki_rasoi_selected_tabbar")
        
        guard let countryColorStr = UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.COUNTRY_COLOR_CODE) as? String else {return}
        guard let rgba = countryColorStr.slice(from: "(", to: ")") else { return }
        let myStringArr = rgba.components(separatedBy: ",")
        //        layer.cornerRadius = 6
        image4.image = image4.image?.withRenderingMode(.alwaysTemplate)
        image4.tintColor = UIColor(red: CGFloat((myStringArr[0] as NSString).doubleValue/255.0), green: CGFloat((myStringArr[1] as NSString).doubleValue/255.0), blue: CGFloat((myStringArr[2] as NSString).doubleValue/255.0), alpha: CGFloat((myStringArr[3] as NSString).doubleValue))
        
        self.mediaCollView.isHidden = false
        self.productsView.isHidden = true
        self.servicesView.isHidden = true
        
        
        self.mediaCollView.delegate = self
        self.mediaCollView.dataSource = self
        self.mediaCollView.reloadData()
    }
    
    func showServices() {
        self.productsView.isHidden = true
        self.mediaTableView.isHidden = true
        self.mediaCollView.isHidden = true
        self.servicesView.isHidden = false
        self.mediaEmptyView.isHidden = true
    }
    
    @IBAction func vendorListingActions(_ sender: UIButton) {
        if sender.tag == 101 {
            let contentDetailVC = DIConfigurator.shared.getVendorListVC()
            contentDetailVC.type = "exporter"
            self.navigationController?.pushViewController(contentDetailVC, animated: true)
        } else if sender.tag == 102 {
            let contentDetailVC = DIConfigurator.shared.getVendorListVC()
            contentDetailVC.type = "manufacturer"
            self.navigationController?.pushViewController(contentDetailVC, animated: true)
        } else {
            let contentDetailVC = DIConfigurator.shared.getVendorListVC()
            contentDetailVC.type = "wholesaler"
            self.navigationController?.pushViewController(contentDetailVC, animated: true)
        }
    }
    
    @IBAction func searchAction(_ sender: UIButton) {
        let viewAllVC = DIConfigurator.shared.getExploreVC()
        viewAllVC.searchIsFrom = self.searchIsFrom
        self.navigationController?.pushViewController(viewAllVC, animated: true)
    }
    
    
    @IBAction func flagAction(_ sender: UIButton) {
        let sellerStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = sellerStoryboard.instantiateViewController(withIdentifier: "ChooseCountryVC") as! ChooseCountryVC
        vc.delegate = self
        vc.isFrom = self.isFrom
        self.present(vc, animated: true, completion: nil)
        //        let indexPath = IndexPath(row: 3, section: 0)
        //        self.mediaCollView.scrollToItem(at: indexPath, at: .top, animated: true)
        //        mediaCollView.isPagingEnabled = false
        //        mediaCollView.scrollToItem(
        //            at: IndexPath(item: 3, section: 0),
        //            at: .centeredHorizontally,
        //            animated: true
        //        )
        //        mediaCollView.isPagingEnabled = true
    }
    
    @IBAction func onClickWishlist(_ sender: UIButton) {
        if UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.VENDOR_SIGNUP_TOKEN) != nil {
            let wishlistVC = DIConfigurator.shared.getWishlistVC()
//            let wishlistVC = DIConfigurator.shared.getPaystackVC()
            self.navigationController?.pushViewController(wishlistVC, animated: true)
        } else {
            let vc = DIConfigurator.shared.getLoginVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }
//        let numbers = [0]
//        let _ = numbers[1]
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
    
    func countLabelLines(label: UILabel) -> Int {
        // Call self.layoutIfNeeded() if your view uses auto layout
        let myText = label.text! as NSString
        
        let rect = CGSize(width: label.bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: label.font], context: nil)
        
        return Int(ceil(CGFloat(labelSize.height) / label.font.lineHeight))
    }
    
    @objc func readMoreBtnClicked(sender: UIButton) {
        
        let row = sender.tag % 1000
        let section = sender.tag / 1000
        
        let indexPath = IndexPath(row: row, section: section)
        let cell = (sender.superview?.superview?.superview?.superview?.superview?.superview as? MediaContentCell) // track your cell here
        //let indexPath: IndexPath = self.mediaTableView.indexPathForRow(at: sender.convert(CGPoint.zero, to: self.mediaTableView))!
        
        cell!.cellSubTitleLbl.numberOfLines = 0
        DispatchQueue.main.async {
            self.mediaTableView.reloadRows(at: [indexPath], with: .none)
        }
        
        //        self.mediaTableView.reloadRows(at: [indexPath], with: .none)
    }
    
    @objc func viewAllCommentBtnClicked(sender: UIButton) {
        
        let row = sender.tag % 1000
        let section = sender.tag / 1000
        
        let indexPath = IndexPath(row: row, section: section)
        
        let viewAllVC = DIConfigurator.shared.getViewCommentsVC()
//        viewAllVC.blogId = self.allMediaCatAndContentListArr[section].sectionContent[row].id
//        viewAllVC.shortDesc = self.allMediaCatAndContentListArr[section].sectionContent[row].subject
        viewAllVC.blogId = self.mediaContentList[indexPath.row].id
        viewAllVC.shortDesc = self.mediaContentList[indexPath.row].subject
        self.navigationController?.pushViewController(viewAllVC, animated: true)
    }
    
    @objc func sendCommentBtnClicked(sender: UIButton) {
        let row = sender.tag % 1000
        let section = sender.tag / 1000
        //        let indexPath = IndexPath(row:row, section: section)
        let info = self.allMediaCatAndContentListArr[section].sectionContent[row]
        let cell = (sender.superview?.superview?.superview?.superview?.superview as? MediaContentCell)
        if cell!.commentTxtView.text == "" {
            self.view.makeToast("Please write your comment.")
        } else {
            self.postCommentAPI("\(info.id)", comment: cell!.commentTxtView.text)
            
            DispatchQueue.main.async {
                cell?.commentTxtView.text = ""
            }
        }
        
    }
    
    @objc func shareBtnClicked(sender: UIButton)
    {
        let row = sender.tag % 1000
        let section = sender.tag / 1000
        //           let rowId = sender.tag
        //           let info = self.mediaContentList[rowId]
        let info = self.allMediaCatAndContentListArr[section].sectionContent[row]
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
    
    @IBAction func tapButtons(_ sender: UIButton) {
//        imgSelected.image = nil
//        self.instance?.selectedIndex = sender.tag
        self.allItemsVisible()
        
        let widthS = (stackView.bounds.width/5)
        
        if sender.tag == 0{
            //image1.alpha = 0
//            label1.textColor = countryColor
//            //image1.image = UIImage(named: "Home_select")
//            guard let countryColorStr = UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.COUNTRY_COLOR_CODE) as? String else {return}
//            guard let rgba = countryColorStr.slice(from: "(", to: ")") else { return }
//            let myStringArr = rgba.components(separatedBy: ",")
//            //        layer.cornerRadius = 6
//            image1.image = image1.image?.withRenderingMode(.alwaysTemplate)
//            image1.tintColor = UIColor(red: CGFloat((myStringArr[0] as NSString).doubleValue/255.0), green: CGFloat((myStringArr[1] as NSString).doubleValue/255.0), blue: CGFloat((myStringArr[2] as NSString).doubleValue/255.0), alpha: CGFloat((myStringArr[3] as NSString).doubleValue))
            let categoriesNewVC = DIConfigurator.shared.getCategoriesNewVC()
            categoriesNewVC.showBackView = true
            self.navigationController?.pushViewController(categoriesNewVC, animated: true)
            
        }else if sender.tag == 1{
            //image2.alpha = 0
            label2.textColor = countryColor
//            imgSelected.image = UIImage(named: "travel_fam_selected_tabbar")
//            image1.tintColor = UIColor.green
            
            
            self.startTimer()
            guard let countryColorStr = UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.COUNTRY_COLOR_CODE) as? String else {return}
            guard let rgba = countryColorStr.slice(from: "(", to: ")") else { return }
            let myStringArr = rgba.components(separatedBy: ",")
            //        layer.cornerRadius = 6
            image2.image = image2.image?.withRenderingMode(.alwaysTemplate)
            image2.tintColor = UIColor(red: CGFloat((myStringArr[0] as NSString).doubleValue/255.0), green: CGFloat((myStringArr[1] as NSString).doubleValue/255.0), blue: CGFloat((myStringArr[2] as NSString).doubleValue/255.0), alpha: CGFloat((myStringArr[3] as NSString).doubleValue))
            self.searchIsFrom = "Products"
            self.isFrom = "MarketPlace"
//            self.countryNameLbl.text = "\(UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.SELECTED_COUNTRY) as! String)'s Products"
            self.countryNameLbl.text = "Products"
            if country == "Nigeria" {
                //                self.getCategoriesList()
                self.getNewArrivals()
                self.getTopDeals()
                self.getonSale()
                showProducts()
                
            } else {
                self.servicesView.isHidden = false
            }
            
        }else if sender.tag == 2{
            //image3.alpha = 0
            label3.textColor = countryColor
//            imgSelected.image = UIImage(named: "family_memories_selected_tabbar")
            guard let countryColorStr = UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.COUNTRY_COLOR_CODE) as? String else {return}
            guard let rgba = countryColorStr.slice(from: "(", to: ")") else { return }
            let myStringArr = rgba.components(separatedBy: ",")
            //        layer.cornerRadius = 6
            image3.image = image3.image?.withRenderingMode(.alwaysTemplate)
            image3.tintColor = UIColor(red: CGFloat((myStringArr[0] as NSString).doubleValue/255.0), green: CGFloat((myStringArr[1] as NSString).doubleValue/255.0), blue: CGFloat((myStringArr[2] as NSString).doubleValue/255.0), alpha: CGFloat((myStringArr[3] as NSString).doubleValue))
            let productsVC = DIConfigurator.shared.getExploreVC()
            
            if UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.SELECTED_COUNTRY) as! String != "Nigeria" && (self.searchIsFrom == "Products" || self.searchIsFrom == "Vendors") {
                productsVC.searchIsFrom = "Multimedia"
            } else {
                productsVC.searchIsFrom = self.searchIsFrom
            }
            
            self.navigationController?.pushViewController(productsVC, animated: true)
            
        }else if sender.tag == 3{
            //image4.alpha = 0
            label4.textColor = countryColor
            timer?.invalidate()
            timer = nil
//            imgSelected.image = UIImage(named: "dadi_ki_rasoi_selected_tabbar")
            
            guard let countryColorStr = UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.COUNTRY_COLOR_CODE) as? String else {return}
            guard let rgba = countryColorStr.slice(from: "(", to: ")") else { return }
            let myStringArr = rgba.components(separatedBy: ",")
            //        layer.cornerRadius = 6
            image4.image = image4.image?.withRenderingMode(.alwaysTemplate)
            image4.tintColor = UIColor(red: CGFloat((myStringArr[0] as NSString).doubleValue/255.0), green: CGFloat((myStringArr[1] as NSString).doubleValue/255.0), blue: CGFloat((myStringArr[2] as NSString).doubleValue/255.0), alpha: CGFloat((myStringArr[3] as NSString).doubleValue))
            
            self.searchIsFrom = "Multimedia"
            self.isFrom = "Multimedia"
            self.countryNameLbl.text = "\(UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.SELECTED_COUNTRY) as! String)"
//            self.getContentListBySectionId("")
            self.getContentListBySectionIdWithPagination(self.mediaCategoriesListCopy[self.mediaTappedIndex].id)
            self.getMultimediaProductsAPI()
            
            self.dispatchGroup.notify(queue: .main) {
                // whatever you want to do when both are done

                if mediaProductsList.count > 0 {
                    self.createMediaWithProductArr()
                } else {
                    DispatchQueue.main.async {
                        if self.mediaContentList.count > 0 {

                            self.mediaEmptyView.isHidden = true
                            self.mediaTableView.isHidden = false
                            self.mediaTableView.delegate = self
                            self.mediaTableView.dataSource = self
                            self.mediaTableView.reloadData()
                            
                        } else {
                            self.mediaEmptyView.isHidden = false
                            self.mediaTableView.isHidden = true
                        }
                    }
                }

            }
            
        }else if sender.tag == 4{
            //image5.alpha = 0
            label5.textColor = countryColor
//            imgSelected.image = UIImage(named: "dadi_ki_kahani_selected_tabbar")
            guard let countryColorStr = UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.COUNTRY_COLOR_CODE) as? String else {return}
            guard let rgba = countryColorStr.slice(from: "(", to: ")") else { return }
            let myStringArr = rgba.components(separatedBy: ",")
            //        layer.cornerRadius = 6
            image5.image = image5.image?.withRenderingMode(.alwaysTemplate)
            image5.tintColor = UIColor(red: CGFloat((myStringArr[0] as NSString).doubleValue/255.0), green: CGFloat((myStringArr[1] as NSString).doubleValue/255.0), blue: CGFloat((myStringArr[2] as NSString).doubleValue/255.0), alpha: CGFloat((myStringArr[3] as NSString).doubleValue))
            let productsVC = DIConfigurator.shared.getAccountVC()
            productsVC.showbackBtn = true
            self.navigationController?.pushViewController(productsVC, animated: true)
            
        }
        
    }
    
    func setTabBar() {
        self.allItemsVisible()
        if self.isFrom == "Multimedia" {
            image4.image = image4.image?.withRenderingMode(.alwaysTemplate)
            image4.tintColor = countryColor
            label4.textColor = countryColor
        } else if self.isFrom == "MarketPlace" {
            image2.image = image2.image?.withRenderingMode(.alwaysTemplate)
            image2.tintColor = countryColor
            label2.textColor = countryColor
        }
    }
    
    private func allItemsVisible() {
        image1.image = UIImage(named: "category-1")
        image2.image = UIImage(named: "product")
        image3.image = UIImage(named: "search-4")
        image4.image = UIImage(named: "multimedia-1")
        image5.image = UIImage(named: "account-1")
        
        label1.textColor = UIColor.gray
        label2.textColor = UIColor.gray
        label3.textColor = UIColor.gray
        label4.textColor = UIColor.gray
        label5.textColor = UIColor.gray
        
    }
    
    func getMultimediaProductsAPI() {
        self.dispatchGroup.enter()
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            let countryy = UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.SELECTED_COUNTRY) as! String
            let apiUrl = BASE_URL + PROJECT_URL.GET_MULTIMEDIA_PRODUCTS + "\(countryy)"
            let url : NSString = apiUrl as NSString
            let urlStr : NSString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! as NSString
            
            let param:[String:String] = [:]
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: urlStr as String, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    UserDefaults.standard.set(true, forKey: "isMultimediaProductsAvailable")
                    mediaProductsList.removeAll()
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
                        
                        var imgArr = [Any]()
                        for j in 0..<json["productList"][i]["metaData"]["images"].count {
                            let file = json["productList"][i]["metaData"]["images"][j].stringValue
                            imgArr.append(file)
                        }
                        
                        mediaProductsList.append(mediaContentListStruct.init(subject: name, id: 0, shortDescription: "", files: imgArr, sectionId: 0, totalSize: 0, videoUrl: rating, videoId: productId, readCount: discountedPrice, comments: [], commentCount: itemId, isReadMore: false, shareURl: "", sectionName: productId, createdOn: vendorId, type: "Product"))
                        
                        
                        
//                        mediaProductsList.append(SimilarProducts_Struct.init(currency: currency, vendorId: vendorId, productId: productId, name: name, description: description, dimension: dimension, wishlisted: wishlisted, discountType: discountType, itemId: itemId, categoryId: categoryId, actualPrice: actualPrice, discountValue: discountValue, stock: stock, discountedPrice: discountedPrice, rating: rating, images: imgArr, type: "Product"))
                        
                    }
                    
                    DispatchQueue.main.async {
                        self.dispatchGroup.leave()
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
    
    func createMediaWithProductArr() {
//        var index = -1
//        for i in 0..<mediaContentList.count {
//
//            if i%4 != 0 && i>0 {
//                self.mediaWithProductsArr.append(mediaContentList[i])
//            } else {
//                index += 1
//                self.mediaWithProductsArr.append(mediaProductsList[index])
//
//            }
//        }
//        print(mediaWithProductsArr)
        
        self.mediaContentListCopy = mediaContentList
        var index = 0
        for i in 0..<mediaContentList.count{
            print(i)
//            var index = i
            if (i+1) % 3 == 0 {
                print(i)
                index += 1
                if i == 2 {
                    self.mediaContentList.insert(mediaProductsList[0], at: i + 1)
                } else {
                    if mediaProductsList.count > 0 {
                        self.mediaContentList.insert(mediaProductsList[0], at: i + index)
                    } else {
                        break
                    }
                    
                }
                
                mediaProductsList.remove(at: 0)
                
                
            }
        }
        
        DispatchQueue.main.async {
            if self.mediaContentList.count > 0 {

                self.mediaEmptyView.isHidden = true
                self.mediaTableView.isHidden = false
                self.mediaTableView.delegate = self
                self.mediaTableView.dataSource = self
                self.mediaTableView.reloadData()
                
            } else {
                self.mediaEmptyView.isHidden = false
                self.mediaTableView.isHidden = true
            }
        }
                
    }
    
    @IBAction func mediaProductCellBuyAction(_ sender: UIButton) {
        let indexPath: IndexPath? = mediaTableView.indexPathForRow(at: sender.convert(CGPoint.zero, to: mediaTableView))
//        let info = self.mediaContentList[indexPath!.row]
        
        let productDetailVC = DIConfigurator.shared.getProductDetailVC()
        let info = self.mediaContentList[indexPath!.row]
        productDetailVC.itemID = info.commentCount
        productDetailVC.productID = info.sectionName
        productDetailVC.vendorID = info.createdOn
        self.navigationController?.pushViewController(productDetailVC, animated: true)
    }
    
    
}

extension ProductsVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func changecollectionHeight() {
        self.localProductsCollView_height.constant = self.localProductsCollView.contentSize.height
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.categoryCollView {
            return 15
        } else if collectionView == self.exportCollView || collectionView == self.agriculturalProductsCollView || collectionView == self.attractionProductCollView {
            return 15
        } else if collectionView == self.mediaCollView {
            //            return self.homeSectionList.count
            return self.mediaCategoriesListCopy.count
        } else if collectionView == self.catCollView {
            return self.categoriesListCopy.count
        } else if collectionView == self.topDealsCollView {
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
        if collectionView == self.categoryCollView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCategoryCell", for: indexPath) as! ProductCategoryCell
            
            return cell
        } else if collectionView == self.exportCollView || collectionView == self.agriculturalProductsCollView || collectionView == self.attractionProductCollView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExportsCollCell", for: indexPath) as! ExportsCollCell
            
            return cell
        } else if collectionView == self.mediaCollView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MediaCategoryCell", for: indexPath) as! MediaCategoryCell
            cell.layoutIfNeeded()
            cell.cellLbl.text = self.mediaCategoriesListCopy[indexPath.row].sectionName
            cell.cellImg.sd_setImage(with: URL(string: FILE_BASE_URL + "/\(self.mediaCategoriesListCopy[indexPath.row].icon)"), placeholderImage: UIImage(named: "avatar"))
            cell.mediaCategoriesObj = self.mediaCategoriesListCopy[indexPath.row]
            //            if self.colourSetArr.count > indexPath.row {
            //                cell.cellView.backgroundColor = self.colourSetArr[indexPath.row]
            //            }
            
            
            //            cell.cellView.roundCorners(corners: [.topLeft, .topRight], cornerRadius: 10)
            
            return cell
        } else if collectionView == self.catCollView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCollCell", for: indexPath) as! CategoriesCollCell
            let info = self.categoriesListCopy[indexPath.row]
            cell.cellLbl.text = info.name
            
            let imgUrl = "\(FILE_BASE_URL)/\(info.image)"
            cell.cellImg.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named: "loading"))
            return cell
        } else if collectionView == self.newArrivalsCollView {
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
        if collectionView == self.exportCollView {
            let productDetailVC = DIConfigurator.shared.getProductDetailVC()
            self.navigationController?.pushViewController(productDetailVC, animated: true)
        } else if collectionView == self.localProductsCollView {
            let productDetailVC = DIConfigurator.shared.getVendorListVC()
            self.navigationController?.pushViewController(productDetailVC, animated: true)
        } else if collectionView == self.mediaCollView {
//
//            let indexPath = IndexPath(row: 0, section: indexPath.row)
//            self.mediaTableView.scrollToRow(at: indexPath, at: .middle, animated: true)
//            self.makeCategoriesHiglighted(indexPath.section)
//            DispatchQueue.main.async {
//                self.mediaCollView.reloadData()
//            }
            
            self.mediaTappedIndex = indexPath.row
            self.makeCategoriesHiglighted(indexPath.row)
            DispatchQueue.main.async {
                self.mediaCollView.reloadData()
            }
            let info = self.mediaCategoriesListCopy[indexPath.row]
//            DispatchQueue.main.async {
//                self.getContentListBySectionIdWithPagination(info.id)
//                self.getMultimediaProductsAPI()
//            }
            self.currentPageIndex = 1
            self.getContentListBySectionIdWithPagination(info.id)
            self.getMultimediaProductsAPI()
            
            self.dispatchGroup.notify(queue: .main) {
                // whatever you want to do when both are done

                if mediaProductsList.count > 0 {
                    self.createMediaWithProductArr()
                } else {
                    DispatchQueue.main.async {
                        if self.mediaContentList.count > 0 {

                            self.mediaEmptyView.isHidden = true
                            self.mediaTableView.isHidden = false
                            self.mediaTableView.delegate = self
                            self.mediaTableView.dataSource = self
                            self.mediaTableView.reloadData()
                            
                        } else {
                            self.mediaEmptyView.isHidden = false
                            self.mediaTableView.isHidden = true
                        }
                    }
                }

            }
            
        } else if collectionView == self.catCollView {
            if self.categoriesListCopy[indexPath.row].isSubCategoryAvailable {
                let subCatVC = DIConfigurator.shared.getSubCatVC()
                subCatVC.catId = self.categoriesListCopy[indexPath.row].id
                self.navigationController?.pushViewController(subCatVC, animated: true)
            } else {
                self.view.makeToast("No Subcategories Available.")
            }
            
        } else if collectionView == self.newArrivalsCollView {
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
extension ProductsVC: UICollectionViewDelegateFlowLayout {
    // 1
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        
        if collectionView == self.localProductsCollView {
            let collectionWidth = collectionView.bounds.width
            //          return CGSize(width: collectionWidth / 2 - 10, height: collectionWidth / 2 + 80)
            return CGSize(width: collectionWidth / 2 - 10, height: 200)
        } else if collectionView == self.exportCollView || collectionView == self.agriculturalProductsCollView || collectionView == self.attractionProductCollView {
            let collectionWidth = collectionView.bounds.width
            return CGSize(width: collectionWidth / 2, height: collectionWidth)
        } else if collectionView == self.mediaCollView {
            let collectionWidth = collectionView.bounds.width
            //          return CGSize(width: collectionWidth / 2 - 10, height: collectionWidth / 2 + 80)
            //return CGSize(width: collectionWidth / 3, height: collectionView.bounds.height - 10)
            return CGSize(width: collectionWidth / 4, height: collectionView.bounds.height)
            
        } else if collectionView == self.catCollView {
            let collectionWidth = collectionView.bounds.width
            return CGSize(width: collectionWidth/3 - 10, height: 135)
        } else if collectionView == self.newArrivalsCollView {
            let collectionWidth = self.newArrivalsCollView.bounds.width
            return CGSize(width: (collectionWidth - 10) / 3, height: 200)
            
        } else if collectionView == self.topDealsCollView {
            let collectionWidth = self.topDealsCollView.bounds.width
            let collectionHeight = self.topDealsCollView.bounds.height
            return CGSize(width: (collectionWidth - 10) / 2, height: (collectionHeight - 10) / 2)
            
        } else if collectionView == self.bannerCollView {
//            let collectionWidth = self.bannerCollView.bounds.width
            let collectionHeight = self.bannerCollView.bounds.height
            let collectionWidth = UIScreen.main.bounds.size.width
//            let collectionHeight = UIScreen.main.bounds.size.height
            return CGSize(width: collectionWidth - 5, height: collectionHeight)
            
        } else if collectionView == self.onsaleCollView {
            let collectionWidth = self.onsaleCollView.bounds.width
            let collectionHeight = self.onsaleCollView.bounds.height
            return CGSize(width: (collectionWidth - 20) / 3, height: (collectionHeight - 20) / 2)
        } else {
            return CGSize(width: 150, height: 70)
        }
                
    }
}

extension ProductsVC: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row < self.mediaContentList.count {
            if self.mediaContentList[indexPath.row].type == "Media" {
                return UITableView.automaticDimension  //145
            } else {
                return 280
            }
        } else {
            return 0
        }
        
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
//        return self.allMediaCatAndContentListArr.count
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return self.mediaContentList.count
//        return self.allMediaCatAndContentListArr[section].sectionContent.count
        return self.mediaContentList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < self.mediaContentList.count {
            if self.mediaContentList[indexPath.row].type == "Media" {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MediaContentCell", for: indexPath) as! MediaContentCell
                
                let info = self.mediaContentList[indexPath.row]
        //        let info = self.allMediaCatAndContentListArr[indexPath.section].sectionContent[indexPath.row]
                cell.section = indexPath.section
                cell.row = indexPath.row
                
                cell.cellViewAllCommentBtn.tag = (indexPath.section * 1000) + indexPath.row
                cell.cellViewAllCommentBtn.addTarget(self, action: #selector(self.viewAllCommentBtnClicked(sender:)), for: UIControl.Event.touchUpInside)
                
                cell.cellReadMoreBtn.tag = (indexPath.section * 1000) + indexPath.row
                cell.cellReadMoreBtn.addTarget(self, action: #selector(self.readMoreBtnClicked(sender:)), for: UIControl.Event.touchUpInside)
                
                cell.sendCommentBtn.tag = (indexPath.section * 1000) + indexPath.row
                cell.sendCommentBtn.addTarget(self, action: #selector(self.sendCommentBtnClicked(sender:)), for: UIControl.Event.touchUpInside)
                
                cell.cellShareBtn.tag = (indexPath.section * 1000) + indexPath.row
                cell.cellShareBtn.addTarget(self, action: #selector(self.shareBtnClicked(sender:)), for: UIControl.Event.touchUpInside)
                
                cell.mediaInfo = info
                
                cell.didselectClosure = { tabIndex, cellIndex in
                    if let tabIndexp = tabIndex, let cellIndexp = cellIndex {
                        self.moveOnContentDetailVC(tabIndex: tabIndexp, collIndex: cellIndexp)
                    }
                    
                }
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MediaProductCell", for: indexPath) as! MediaProductCell
                
                let info = self.mediaContentList[indexPath.row]
                
                
                cell.cellRatingView.rating = Double(info.videoUrl)!
                cell.cellRatingView.settings.updateOnTouch = false
                cell.cellRatingView.settings.fillMode = .precise
                
                cell.cellPriceLbl.text = "₦\(info.readCount)"
                cell.cellNameLbl.text = info.subject
                
                let imageArr = info.files
                if imageArr.count > 0 {
                    cell.cellImg.sd_setImage(with: URL(string: FILE_BASE_URL + "\(imageArr[0])"), placeholderImage: UIImage(named: "loading"))
                }
                
                return cell
            }
        } else {
            return UITableViewCell()
        }

        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.mediaContentList[indexPath.row].type == "Media" {
            let contentDetailVC = DIConfigurator.shared.getContentDetailVC()
            //        contentDetailVC.blogId = self.mediaContentList[indexPath.row].id
            contentDetailVC.blogId = self.mediaContentList[indexPath.row].id
            contentDetailVC.sectionId = self.mediaCategoriesListCopy[self.mediaTappedIndex].id
    //        contentDetailVC.blogId = self.allMediaCatAndContentListArr[indexPath.section].sectionContent[indexPath.row].id
    //        contentDetailVC.sectionId = "\(self.allMediaCatAndContentListArr[indexPath.section].sectionContent[indexPath.row].sectionId)"
            self.navigationController?.pushViewController(contentDetailVC, animated: true)
        } else {
            let productDetailVC = DIConfigurator.shared.getProductDetailVC()
            let info = self.mediaContentList[indexPath.row]
            productDetailVC.itemID = info.commentCount
            productDetailVC.productID = info.sectionName
            productDetailVC.vendorID = info.createdOn
            self.navigationController?.pushViewController(productDetailVC, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        print("Default IndexPath = \(indexPath)")
//
//        if self.selectedSection != indexPath.section {
//            self.selectedSection = indexPath.section
//            self.makeCategoriesHiglighted(indexPath.section)
//            DispatchQueue.main.async {
//                self.mediaCollView.reloadData()
//                self.mediaCollView.isPagingEnabled = false
//                self.mediaCollView.scrollToItem(
//                    at: IndexPath(item: indexPath.section, section: 0),
//                    at: .centeredHorizontally,
//                    animated: true
//                )
//                self.mediaCollView.isPagingEnabled = true
//            }
//        }
//        //        let indexPathh = self.mediaTableView.indexPathsForVisibleRows
//        //        print("calculated IndexPath = \(String(describing: indexPathh))")
        
        if indexPath.row == (mediaContentList.count - 1) {
            if (mediaContentList.count < (totalDataCount ?? 0)) && (currentPageIndex != -1) {
                currentPageIndex = currentPageIndex + 1
                self.shouldReloadTable = true
                self.getContentListBySectionIdWithPagination(self.mediaCategoriesListCopy[self.mediaTappedIndex].id)
//                self.getMultimediaProductsAPI()
                
                self.dispatchGroup.notify(queue: .main) {
                    // whatever you want to do when both are done

                    if mediaProductsList.count > 0 {
                        self.createMediaWithProductArr()
                    } else {
                        DispatchQueue.main.async {
                            if self.mediaContentList.count > 0 {

                                self.mediaEmptyView.isHidden = true
                                self.mediaTableView.isHidden = false
                                self.mediaTableView.delegate = self
                                self.mediaTableView.dataSource = self
                                self.mediaTableView.reloadData()
                                
                            } else {
                                self.mediaEmptyView.isHidden = false
                                self.mediaTableView.isHidden = true
                            }
                        }
                    }

                }
            }
        }
        
    }
    
    
}

extension ProductsVC: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.categoriesListCopy = categoriesList
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.categoriesListCopy = categoriesList
        if searchText.isEmpty {
            self.categoriesListCopy = categoriesList
        } else {
            self.categoriesListCopy = self.categoriesListCopy.filter({ (item) -> Bool in
                return item.name.contains(searchText)
            })
        }
        
        DispatchQueue.main.async {
            self.catCollView.reloadData()
        }
        
    }
}

extension ProductsVC: ChooseCountryDelegate{
    func onSelectCountry(country: Select_Country_List_Struct, isFrom: String) {
        self.setTabBar()
        let flag = UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.SELECTED_FLAG) as! String
        let imageUrl = FLAG_BASE_URL + "/" + flag
        if let data = try? Data(contentsOf: URL(string: imageUrl)!) {
            // Create Image and Update Image View
            flagImg.image = UIImage(data: data)
        }
        
        guard let countryColorStr = UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.COUNTRY_COLOR_CODE) as? String else {return}
        guard let rgba = countryColorStr.slice(from: "(", to: ")") else { return }
        let myStringArr = rgba.components(separatedBy: ",")
        
        segment.selectedSegmentTintColor = UIColor(red: CGFloat((myStringArr[0] as NSString).doubleValue/255.0), green: CGFloat((myStringArr[1] as NSString).doubleValue/255.0), blue: CGFloat((myStringArr[2] as NSString).doubleValue/255.0), alpha: CGFloat((myStringArr[3] as NSString).doubleValue))
        self.headerViewOne.backgroundColor = UIColor(red: CGFloat((myStringArr[0] as NSString).doubleValue/255.0), green: CGFloat((myStringArr[1] as NSString).doubleValue/255.0), blue: CGFloat((myStringArr[2] as NSString).doubleValue/255.0), alpha: CGFloat((myStringArr[3] as NSString).doubleValue))
        self.headerViewTwo.backgroundColor = UIColor(red: CGFloat((myStringArr[0] as NSString).doubleValue/255.0), green: CGFloat((myStringArr[1] as NSString).doubleValue/255.0), blue: CGFloat((myStringArr[2] as NSString).doubleValue/255.0), alpha: CGFloat((myStringArr[3] as NSString).doubleValue))
        countryColor = UIColor(red: CGFloat((myStringArr[0] as NSString).doubleValue/255.0), green: CGFloat((myStringArr[1] as NSString).doubleValue/255.0), blue: CGFloat((myStringArr[2] as NSString).doubleValue/255.0), alpha: CGFloat((myStringArr[3] as NSString).doubleValue))
        
        
        
        if self.isFrom == "Multimedia" {
            timer?.invalidate()
            timer = nil
            //            self.getMediaCategoriesList()
            self.countryNameLbl.text = "\(country.countryName)"
//            self.getContentListBySectionId("")
            self.getMediaCategoriesList()
            self.segmentViewHeight.constant = 0
            if country.countryName == "Nigeria" {
//                self.segmentViewHeight.constant = 80
                self.view2.isHidden = false
                self.view4.isHidden = false
//                self.segment.isHidden = false
                self.servicesView.isHidden = false
                self.segment.selectedSegmentIndex = 1
            } else {
                self.servicesView.isHidden = false
                self.segment.selectedSegmentIndex = 1
//                self.segmentViewHeight.constant = 0
                self.view2.isHidden = true
                self.view4.isHidden = true
//                self.segment.isHidden = true
            }
        } else {
            
            startTimer()
            
            
//            self.servicesView.isHidden = false
//            self.segment.selectedSegmentIndex = 0
            if country.countryName == "Nigeria" {
//                self.countryNameLbl.text = "\(country.countryName)'s Products"
                self.countryNameLbl.text = "Products"
//                self.getCategoriesList()
                self.getMediaCategoriesList()
//                self.segmentViewHeight.constant = 80
                self.view2.isHidden = false
                self.view4.isHidden = false
//                self.segment.isHidden = false
                self.servicesView.isHidden = false
                self.segment.selectedSegmentIndex = 1
            } else {
                self.countryNameLbl.text = "\(country.countryName)"
//                self.getContentListBySectionId("")
                self.getMediaCategoriesList()
                self.servicesView.isHidden = false
                self.segment.selectedSegmentIndex = 1
//                self.segmentViewHeight.constant = 0
                self.view2.isHidden = true
                self.view4.isHidden = true
//                self.segment.isHidden = true
            }
        }
        
        
    }
}

extension ProductsVC: SelectTabDelegate{
    func onSelectTab(tabIndex: Int) {
        if tabIndex == 0 {
            self.navigationController?.popViewController(animated: true)
        } else if tabIndex == 1 {
            self.searchIsFrom = "Products"
            if country == "Nigeria" {
                //                self.getCategoriesList()
                self.getNewArrivals()
                self.getTopDeals()
                self.getonSale()
                showProducts()
                
            } else {
                self.servicesView.isHidden = false
            }

        } else if tabIndex == 2 {
            let productsVC = DIConfigurator.shared.getExploreVC()
            self.navigationController?.pushViewController(productsVC, animated: true)
        } else if tabIndex == 3 {
            self.searchIsFrom = "Multimedia"
//            self.getContentListBySectionId("")
            self.getContentListBySectionIdWithPagination(self.mediaCategoriesListCopy[self.mediaTappedIndex].id)
            self.getMultimediaProductsAPI()
            
            self.dispatchGroup.notify(queue: .main) {
                // whatever you want to do when both are done

                if mediaProductsList.count > 0 {
                    self.createMediaWithProductArr()
                } else {
                    DispatchQueue.main.async {
                        if self.mediaContentList.count > 0 {

                            self.mediaEmptyView.isHidden = true
                            self.mediaTableView.isHidden = false
                            self.mediaTableView.delegate = self
                            self.mediaTableView.dataSource = self
                            self.mediaTableView.reloadData()
                            
                        } else {
                            self.mediaEmptyView.isHidden = false
                            self.mediaTableView.isHidden = true
                        }
                    }
                }

            }
        } else {
            let productsVC = DIConfigurator.shared.getAccountVC()
            self.navigationController?.pushViewController(productsVC, animated: true)
        }
    }
}
