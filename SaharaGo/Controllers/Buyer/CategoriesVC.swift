//
//  CategoriesVC.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 26/08/22.
//

import UIKit

class CategoriesVC: UIViewController {
    
    @IBOutlet weak var cartBadgeLbl: UILabel!
    @IBOutlet weak var cartBadgeView: UIView!
    @IBOutlet weak var headerViewTwo: MyCustomHeaderView!
    @IBOutlet weak var headerViewOne: MyCustomHeaderView!
    
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var flagImg: UIImageView!
    @IBOutlet weak var collView: UICollectionView!
    var categoriesList = [categoryListStruct]()
    var categoriesListCopy = [categoryListStruct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
//        searchBar.delegate = self
        
        if UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.SELECTED_COUNTRY) != nil {
            self.getCategoriesList()
        } else {
            let sellerStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = sellerStoryboard.instantiateViewController(withIdentifier: "ChooseCountryVC") as! ChooseCountryVC
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.setCartBadge()
        let flag = UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.SELECTED_FLAG) as! String
        let imageUrl = FLAG_BASE_URL + "/" + flag
        if let data = try? Data(contentsOf: URL(string: imageUrl)!) {
                flagImg.image = UIImage(data: data)
            }
        
        guard let countryColorStr = UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.COUNTRY_COLOR_CODE) as? String else {return}
        guard let rgba = countryColorStr.slice(from: "(", to: ")") else { return }
        let myStringArr = rgba.components(separatedBy: ",")
        //        layer.cornerRadius = 6
        
        self.headerViewOne.backgroundColor = UIColor(red: CGFloat((myStringArr[0] as NSString).doubleValue/255.0), green: CGFloat((myStringArr[1] as NSString).doubleValue/255.0), blue: CGFloat((myStringArr[2] as NSString).doubleValue/255.0), alpha: CGFloat((myStringArr[3] as NSString).doubleValue))
        self.headerViewTwo.backgroundColor = UIColor(red: CGFloat((myStringArr[0] as NSString).doubleValue/255.0), green: CGFloat((myStringArr[1] as NSString).doubleValue/255.0), blue: CGFloat((myStringArr[2] as NSString).doubleValue/255.0), alpha: CGFloat((myStringArr[3] as NSString).doubleValue))
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
                    
                    if self.categoriesList.count > 0 {
                        self.collView.isHidden = false
                        self.emptyView.isHidden = true
                        DispatchQueue.main.async {
                            self.collView.reloadData()
                        }
                    } else {
                        self.collView.isHidden = true
                        self.emptyView.isHidden = false
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
    
    @IBAction func onClickCart(_ sender: UIButton) {
        if UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.VENDOR_SIGNUP_TOKEN) != nil {
            let cartVC = DIConfigurator.shared.getCartVC()
            self.navigationController?.pushViewController(cartVC, animated: true)
        } else {
            let vc = DIConfigurator.shared.getLoginVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func flagBtnAction(_ sender: UIButton) {
        let sellerStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = sellerStoryboard.instantiateViewController(withIdentifier: "ChooseCountryVC") as! ChooseCountryVC
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    func setCartBadge() {
        if let cartCount = UserDefaults.standard.value(forKey: "cartCount") as? Int {
            self.cartBadgeView.isHidden = false
            self.cartBadgeLbl.text = "\(cartCount)"
        } else {
            self.cartBadgeView.isHidden = true
        }
        
    }
    
}

extension CategoriesVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categoriesListCopy.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCollCell", for: indexPath) as! CategoriesCollCell
        let info = self.categoriesListCopy[indexPath.row]
        cell.cellLbl.text = info.name
        
        let imgUrl = "\(FILE_BASE_URL)/\(info.image)"
        cell.cellImg.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named: "loading"))
        //cell.setViewDocUploadCellData(docLabelArr, docValueArr: docUrlArr)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.categoriesListCopy[indexPath.row].isSubCategoryAvailable {
            let subCatVC = DIConfigurator.shared.getSubCatVC()
            subCatVC.catId = self.categoriesListCopy[indexPath.row].id
            self.navigationController?.pushViewController(subCatVC, animated: true)
        } else {
            self.view.makeToast("No Sub category available.")
//            let subCatVC = DIConfigurator.shared.getCatProductsVC()
//            subCatVC.catId = self.categoriesListCopy[indexPath.row].id
//            self.navigationController?.pushViewController(subCatVC, animated: true)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = collectionView.bounds.width
        //        return CGSize(width: (UIScreen.main.bounds.size.width - 30) / 2.0, height: (UIScreen.main.bounds.size.height))
        return CGSize(width: collectionWidth/3 - 10, height: 135)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}

extension CategoriesVC: UISearchBarDelegate {
    
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
            
            //                self.CountryList = self.CountryList.sorted(by: { (i1, i2) -> Bool in
            //                    return i1.countryName.contains(searchText)
            //                })
            
        }
        
        DispatchQueue.main.async {
            self.collView.reloadData()
        }
        
        print("searchText \(searchText)")
    }
}

extension CategoriesVC: ChooseCountryDelegate{
    func onSelectCountry(country: Select_Country_List_Struct, isFrom: String) {
        let flag = UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.SELECTED_FLAG) as! String
        let imageUrl = FLAG_BASE_URL + "/" + flag
//        self.flagImg.sd_setImage(with: URL(string: imageUrl), completed: nil)
        if let data = try? Data(contentsOf: URL(string: imageUrl)!) {
                // Create Image and Update Image View
                flagImg.image = UIImage(data: data)
            }
            
        let countryColorStr = country.colorCode
        guard let rgba = countryColorStr.slice(from: "(", to: ")") else { return }
        let myStringArr = rgba.components(separatedBy: ",")
        //        layer.cornerRadius = 6
        
        self.headerViewOne.backgroundColor = UIColor(red: CGFloat((myStringArr[0] as NSString).doubleValue/255.0), green: CGFloat((myStringArr[1] as NSString).doubleValue/255.0), blue: CGFloat((myStringArr[2] as NSString).doubleValue/255.0), alpha: CGFloat((myStringArr[3] as NSString).doubleValue))
        self.headerViewTwo.backgroundColor = UIColor(red: CGFloat((myStringArr[0] as NSString).doubleValue/255.0), green: CGFloat((myStringArr[1] as NSString).doubleValue/255.0), blue: CGFloat((myStringArr[2] as NSString).doubleValue/255.0), alpha: CGFloat((myStringArr[3] as NSString).doubleValue))
        countryColor = UIColor(red: CGFloat((myStringArr[0] as NSString).doubleValue/255.0), green: CGFloat((myStringArr[1] as NSString).doubleValue/255.0), blue: CGFloat((myStringArr[2] as NSString).doubleValue/255.0), alpha: CGFloat((myStringArr[3] as NSString).doubleValue))
    }
}
