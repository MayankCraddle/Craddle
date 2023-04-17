//
//  HomeVC.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 22/07/22.
//

import UIKit

class HomeVC: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var cartBadgeLbl: UILabel!
    @IBOutlet weak var cartBadgeView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    
    var homeSectionList = [homeSectionDataStruct]()
    var contentList = [contentStruct]()
    var frame = CGRect.zero
    var bannersArr = [String]()
    var colourSetArr = [UIColor]()
    var headerColourStr = ["rgb(254, 61, 65)", "rgb(250, 134, 3)", "rgb(0, 198, 130)", "rgb(44, 146, 227)", "rgb(162, 67, 213)", "rgb(44, 147, 169)"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.getContentWithSection("")
        self.getBanners()
        
        scrollView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        self.navigationController?.navigationBar.isHidden = true
        
        self.setCartBadge()
    }
    
    func setCartBadge() {
        if let cartCount = UserDefaults.standard.value(forKey: "cartCount") as? Int {
            self.cartBadgeView.isHidden = false
            self.cartBadgeLbl.text = "\(cartCount)"
        } else {
            self.cartBadgeView.isHidden = true
        }
        
    }
    
    func setupScreens() {
        for index in 0..<self.bannersArr.count {
            frame.origin.x = scrollView.frame.size.width * CGFloat(index)
            frame.size = scrollView.frame.size
            
            let imgView = UIImageView(frame: frame)
            imgView.sd_setImage(with: URL(string: self.bannersArr[index]), placeholderImage: UIImage(named: "loading"))

            self.scrollView.addSubview(imgView)
        }

        // 3.
        scrollView.contentSize = CGSize(width: (scrollView.frame.size.width * CGFloat(self.bannersArr.count)), height: scrollView.frame.size.height)
        scrollView.delegate = self
    }
    
    func createColourSet() {
        for items in self.headerColourStr {
            guard let rgba = items.slice(from: "(", to: ")") else { return }
            let myStringArr = rgba.components(separatedBy: ",")
            
            self.colourSetArr.append(UIColor(red: CGFloat((myStringArr[0] as NSString).doubleValue/255.0), green: CGFloat((myStringArr[1] as NSString).doubleValue/255.0), blue: CGFloat((myStringArr[2] as NSString).doubleValue/255.0), alpha: 1.0))
        }
    }
    
    func getContentWithSection(_ country: String) {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = [:]
            
            let apiUrl = BASE_URL + PROJECT_URL.GET_CONTENT_WITH_SECTIONS
            let url : NSString = apiUrl as NSString
            let urlStr : NSString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! as NSString
            
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
                        
                        if self.contentList.count > 0 {
                            self.homeSectionList.append(homeSectionDataStruct.init(sectionName: "\(key)", content: self.contentList, priority: value["priority"].intValue, sectionId: value["sectionId"].intValue))
                        }
                                           
                    }
                    
                    self.homeSectionList = self.homeSectionList.sorted(by: { $0.priority < $1.priority })
                    self.createColourSet()
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
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
    
    func getBanners() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = [:]
            
            let apiUrl = BASE_URL + PROJECT_URL.GET_BANNERS
            let url : NSString = apiUrl as NSString
            let urlStr : NSString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! as NSString
            
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: urlStr as String, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {

                    self.bannersArr.removeAll()
                    for i in 0..<json["bannerList"].count {
                        let bannerUrl = FILE_BASE_URL + "\(json["bannerList"][i])"
                        self.bannersArr.append(bannerUrl)
                    }

                    print(self.bannersArr)
                    DispatchQueue.main.async {
                        hideAllProgressOnView(appDelegateInstance.window!)
                        self.pageControl.numberOfPages = self.bannersArr.count
                        self.setupScreens()
                        
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

    
    func moveOnViewAllVC(index: Int) {
        let viewAllVC = DIConfigurator.shared.getViewAllVC()
        viewAllVC.sectioId = self.homeSectionList[index].sectionId
        viewAllVC.isFromHome = true
        self.navigationController?.pushViewController(viewAllVC, animated: true)
    }
    
    func moveOnContentDetailVC(tabIndex: Int, collIndex: Int) {
        let contentDetailVC = DIConfigurator.shared.getContentDetailVC()
        contentDetailVC.blogId = self.homeSectionList[tabIndex].content[collIndex].id
        contentDetailVC.sectionId = "\(self.homeSectionList[tabIndex].sectionId)"
        contentDetailVC.isFromHome = true
        self.navigationController?.pushViewController(contentDetailVC, animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControl.currentPage = Int(pageNumber)
    }
    
    @IBAction func onClickBuySell(_ sender: UIButton) {
        let sellerStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = sellerStoryboard.instantiateViewController(withIdentifier: "ChooseCountryVC") as! ChooseCountryVC
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func onClickCart(_ sender: UIButton) {
        let cartVC = DIConfigurator.shared.getCartVC()
        self.navigationController?.pushViewController(cartVC, animated: true)
    }
    
    @IBAction func onClickWishlist(_ sender: UIButton) {
        let wishlistVC = DIConfigurator.shared.getWishlistVC()
        self.navigationController?.pushViewController(wishlistVC, animated: true)
    }
    
    
}

extension HomeVC: ChooseCountryDelegate{
    func onSelectCountry(country: Select_Country_List_Struct, isFrom: String) {
        let flag = UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.SELECTED_FLAG) as! String
        let productsVC = DIConfigurator.shared.getProductsVC()
        self.navigationController?.pushViewController(productsVC, animated: true)
    }
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 210
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.homeSectionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeSectionCell", for: indexPath) as! HomeSectionCell
        if self.colourSetArr.count > indexPath.row {
            cell.cellHeaderView.backgroundColor = self.colourSetArr[indexPath.row]
        }
        cell.homeList = self.homeSectionList[indexPath.row]
        cell.index = indexPath.row
        cell.onClickViewAllClosure = { index in
            if let indexp = index {
                self.moveOnViewAllVC(index: indexp)
            }
            
        }
        
        cell.didselectClosure = { tabIndex, cellIndex in
            if let tabIndexp = tabIndex, let cellIndexp = cellIndex {
                self.moveOnContentDetailVC(tabIndex: tabIndexp, collIndex: cellIndexp)
            }
            
        }
        return cell
    }
    
    
}
