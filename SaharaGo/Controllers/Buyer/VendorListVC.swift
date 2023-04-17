//
//  VendorListVC.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 13/09/22.
//

import UIKit

class VendorListVC: UIViewController {

    private let itemsPerRow: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(
        top: 15.0,
        left: 20.0,
        bottom: 50.0,
        right: 20.0)
    
    var type = ""
    var header = ""
    var vendorListArr = [vendorListStruct]()
    var bannerImages = ["slide1", "slide2", "slider3", "slider4", "slider5"]
    var timer : Timer?
    var bannerImgName = ""
    
    @IBOutlet weak var bannerImg: UIImageView!
    @IBOutlet weak var vendorListCollView: UICollectionView!
    @IBOutlet weak var headerViewOne: MyCustomHeaderView!
    @IBOutlet weak var headerViewTwo: MyCustomHeaderView!
    @IBOutlet weak var headerTxt: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var bannerCollView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.bannerImg.image = UIImage.init(named: self.bannerImgName)
        self.getVendorList(country)
        self.headerTxt.text = self.header
//        self.pageControl.numberOfPages = 5
//        self.pageControl.currentPage = 0
        self.startTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        guard let countryColorStr = UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.COUNTRY_COLOR_CODE) as? String else {return}
        guard let rgba = countryColorStr.slice(from: "(", to: ")") else { return }
        let myStringArr = rgba.components(separatedBy: ",")
        //        layer.cornerRadius = 6
        
        self.headerViewOne.backgroundColor = UIColor(red: CGFloat((myStringArr[0] as NSString).doubleValue/255.0), green: CGFloat((myStringArr[1] as NSString).doubleValue/255.0), blue: CGFloat((myStringArr[2] as NSString).doubleValue/255.0), alpha: CGFloat((myStringArr[3] as NSString).doubleValue))
        self.headerViewTwo.backgroundColor = UIColor(red: CGFloat((myStringArr[0] as NSString).doubleValue/255.0), green: CGFloat((myStringArr[1] as NSString).doubleValue/255.0), blue: CGFloat((myStringArr[2] as NSString).doubleValue/255.0), alpha: CGFloat((myStringArr[3] as NSString).doubleValue))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        timer?.invalidate()
//        timer = nil
    }
    
    @IBAction func onTapBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
    
    @IBAction func onClickSearch(_ sender: UIButton) {
        let viewAllVC = DIConfigurator.shared.getExploreVC()
        viewAllVC.searchIsFrom = "Vendors"
        self.navigationController?.pushViewController(viewAllVC, animated: true)
    }
    
    func getVendorList(_ countryy: String) {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            //{id}/{pageNumber}/{limit}?searchText= &country=
            let apiUrl = BASE_URL + PROJECT_URL.GET_VENDOR_LIST + "?type=\(self.type)" + "&country=\(countryy)"
            let url : NSString = apiUrl as NSString
            let urlStr : NSString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! as NSString

            let param:[String:String] = [:]
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: urlStr as String, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    self.vendorListArr.removeAll()
                    for i in 0..<json["vendorList"].count
                    {
                        let vendorId = json["vendorList"][i]["vendorId"].stringValue
                        let companyName = json["vendorList"][i]["metaData"]["companyName"].stringValue
                        let streetAddress = json["vendorList"][i]["metaData"]["streetAddress"].stringValue
                        let rating = json["vendorList"][i]["rating"].stringValue
                        let image = json["vendorList"][i]["metaData"]["image"].stringValue
                        let vendorEncryptedId = json["vendorList"][i]["vendorEncryptedId"].stringValue
                        let fcmKey = json["vendorList"][i]["fcmKey"].stringValue
                        
                        
                        
                        
                        self.vendorListArr.append(vendorListStruct.init(status: false, vendorId: vendorId, emailMobile: "", firstName: "", lastName: "", sourcing: "", image: image, country: "", state: "", city: "", zipcode: "", landmark: "", coverImage: "", rating: rating, companyName: companyName, streetAddress: streetAddress, vendorEncryptedId: vendorEncryptedId, fcmKey: fcmKey))
                    }
//
                    DispatchQueue.main.async {
                        if self.vendorListArr.count > 0 {
//                            self.mediaEmptyView.isHidden = true
                            self.vendorListCollView.isHidden = false
                            self.vendorListCollView.delegate = self
                            self.vendorListCollView.dataSource = self
                            self.vendorListCollView.reloadData()
                        } else {
//                            self.mediaEmptyView.isHidden = false
                            self.vendorListCollView.isHidden = true
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
}

extension VendorListVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.bannerCollView {
            return 5
        } else {
            return self.vendorListArr.count
        }
            
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.bannerCollView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeNewBannerCollCell", for: indexPath) as! HomeNewBannerCollCell
            cell.cellImg.image = UIImage(named: self.bannerImages[indexPath.row])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VendorListCell", for: indexPath) as! VendorListCell
            let info = self.vendorListArr[indexPath.row]
            cell.cellLbl.text = info.companyName
            cell.cellLocationLbl.text = info.streetAddress
            cell.ratingView.rating = Double(info.rating)!
            cell.ratingView.settings.updateOnTouch = false
            cell.ratingView.settings.fillMode = .precise
            cell.cellImg.sd_setImage(with: URL(string: FILE_BASE_URL + "\(info.image)"), placeholderImage: UIImage(named: "loading"))
            
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.bannerCollView {
            if indexPath.row == 0 {
                let contentDetailVC = DIConfigurator.shared.getVendorListVC()
                contentDetailVC.type = "wholesaler"
                contentDetailVC.header = "Wholesalers"
                self.navigationController?.pushViewController(contentDetailVC, animated: true)
            } else if indexPath.row == 1 {
                let contentDetailVC = DIConfigurator.shared.getVendorListVC()
                contentDetailVC.type = "exporter"
                contentDetailVC.header = "Exporters"
                self.navigationController?.pushViewController(contentDetailVC, animated: true)
            } else if indexPath.row == 2 {
                let contentDetailVC = DIConfigurator.shared.getVendorListVC()
                contentDetailVC.type = "manufacturer"
                contentDetailVC.header = "Manufacturers"
                self.navigationController?.pushViewController(contentDetailVC, animated: true)
            } else if indexPath.row == 3 {
                let contentDetailVC = DIConfigurator.shared.getVendorListVC()
                contentDetailVC.type = "all"
                contentDetailVC.header = "Retailers"
                self.navigationController?.pushViewController(contentDetailVC, animated: true)
            } else {
                let contentDetailVC = DIConfigurator.shared.getVendorListVC()
                contentDetailVC.type = "farmer"
                contentDetailVC.header = "Farmers"
                self.navigationController?.pushViewController(contentDetailVC, animated: true)
            }
            
        } else {
            let vendorDetailVC = DIConfigurator.shared.getVendorDetailVC()
            let info = self.vendorListArr[indexPath.row]
            vendorDetailVC.vendorId = info.vendorId
            vendorDetailVC.vendorEncryptedId = info.vendorEncryptedId
            vendorDetailVC.fcmKey = info.fcmKey
            vendorDetailVC.vendorName = "\(info.firstName) \(info.lastName)"
            self.navigationController?.pushViewController(vendorDetailVC, animated: true)
        }
        
    }
    
}

// MARK: - Collection View Flow Layout Delegate
extension VendorListVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.bannerCollView {
            let collectionHeight = self.bannerCollView.bounds.height
            let collectionWidth = UIScreen.main.bounds.size.width
            return CGSize(width: collectionWidth - 5, height: collectionHeight)
        } else {
            let collectionWidth = collectionView.bounds.width
            return CGSize(width: ((collectionWidth - 10)/2), height: 220)
        }
        
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 10
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 5
        }

}
