//
//  CategoriesNewVC.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 28/10/22.
//

import UIKit
import SwiftyJSON

//struct mainCategory: Decodable {
//    struct category: Decodable {
//        let id: String
//        let status: String
//        let name: String
//        let parentCategory: String
//        let isSubCategoryAvailable: Bool
//        struct myMetaData: Decodable {
//            let description: String
//            let image: String
//        }
//        let metaData: myMetaData
//        let subCategories: [subCategory]
//    }
//
//    struct subCategory: Decodable {
//        let id: String
//        let status: String
//        let name: String
//        let parentCategory: String
//        let isSubCategoryAvailable: Bool
//        struct myMetaData: Decodable {
//            let description: String
//            let image: String
//        }
//        let metaData: myMetaData
//        let subSubCategories: [subSubCategory]
//    }
//
//    struct subSubCategory: Decodable {
//        let id: String
//        let status: String
//        let name: String
//        let parentCategory: String
//        let isSubCategoryAvailable: Bool
//        struct myMetaData: Decodable {
//            let description: String
//            let image: String
//        }
//        let metaData: myMetaData
//    }
//
//    let categoryList: [category]
//
//}

//struct Welcome2: Codable {
//    let categoryList: [CategoryList]?
//    let parentCategoryList: String?
//    let totalSize: Int?
//    let success: Bool?
//    
//}
//
//// MARK: - SubCategory
//struct SubCategory: Codable {
//    let id, name, parentCategory: String?
//    let mainCategory: String?
//    let isSubCategoryAvailable: Bool?
//    let metaData: MetaData?
//    let tags: [String]?
//    let status: Status?
//    let comment: String?
//    let addedBy: String?
//    let createdOn: String?
//    let parentCategoryName: String?
//    let subCategories: [CategoryList]?
//}
//
//// MARK: - CategoryList
//struct CategoryList: Codable {
//    let id, name, parentCategory: String?
//    let mainCategory: String?
//    let isSubCategoryAvailable: Bool?
//    let metaData: MetaData?
//    let tags: [String]?
//    let status: Status?
//    let comment: String?
//    let addedBy, createdOn: String?
//    let parentCategoryName: String?
//    let subCategories: [SubCategory]?
//}
//
//// MARK: - MetaData
//struct MetaData: Codable {
//    let metaDataDescription, image, mobileImage: String?
//}
//
//enum Status {
//    case approved
//}

class CategoriesNewVC: UIViewController {

    @IBOutlet weak var backLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerViewTwo: MyCustomHeaderView!
    @IBOutlet weak var headerViewOne: MyCustomHeaderView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var cartBadgeLbl: UILabel!
    @IBOutlet weak var cartBadgeView: UIView!
    @IBOutlet weak var countryNameLbl: UILabel!
    @IBOutlet weak var flagImg: UIImageView!
    
    
    private let catViewModel = CategoriesViewModel()
    
    var parentCategorytappedIndex = 0
    var showBackView = false
    var categoryNew = CategoryNew()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        AnalyticsUtil.instance.trackEvent("CategoriesScreen")
        
        if categoriesListCopy.count == 0 {
            self.getCategoriesList()
        } else {
            DispatchQueue.main.async {
                self.emptyView.isHidden = true
                self.tableView.reloadData()
            }
        }
        
        // Do any additional setup after loading the view.
        if UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.SELECTED_COUNTRY) != nil {
//            self.getCategoriesList()
        } else {
            let sellerStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = sellerStoryboard.instantiateViewController(withIdentifier: "ChooseCountryVC") as! ChooseCountryVC
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(updateCartBadge(_:)), name: Notification.Name("updateCartBadge"), object: nil)
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let flag = "nigeria.png"
        let imageUrl = FLAG_BASE_URL + "/" + flag
        if let data = try? Data(contentsOf: URL(string: imageUrl)!) {
            flagImg.image = UIImage(data: data)
        }
        self.countryNameLbl.text = "Nigeria"
        guard let countryColorStr = UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.COUNTRY_COLOR_CODE) as? String else {return}
        guard let rgba = countryColorStr.slice(from: "(", to: ")") else { return }
        let myStringArr = rgba.components(separatedBy: ",")
        //        layer.cornerRadius = 6
        
        self.headerViewOne.backgroundColor = UIColor(red: CGFloat((myStringArr[0] as NSString).doubleValue/255.0), green: CGFloat((myStringArr[1] as NSString).doubleValue/255.0), blue: CGFloat((myStringArr[2] as NSString).doubleValue/255.0), alpha: CGFloat((myStringArr[3] as NSString).doubleValue))
        self.headerViewTwo.backgroundColor = UIColor(red: CGFloat((myStringArr[0] as NSString).doubleValue/255.0), green: CGFloat((myStringArr[1] as NSString).doubleValue/255.0), blue: CGFloat((myStringArr[2] as NSString).doubleValue/255.0), alpha: CGFloat((myStringArr[3] as NSString).doubleValue))
        if self.showBackView {
            self.backView.isHidden = false
            self.backLeadingConstraint.constant = 15.0
        } else {
            self.backView.isHidden = true
            self.backLeadingConstraint.constant = 0.0
        }
        self.setCartBadge()
    }

    @IBAction func onTapBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getCategoriesList() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = [:]
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.GET_CATEGORIES_WITH_SUBCATEGORIES, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    categoriesList.removeAll()
//                    for i in 0..<json["categoryList"].count
//                    {
//                        let id = json["categoryList"][i]["id"].stringValue
//                        let status = json["categoryList"][i]["status"].stringValue
//                        let name = json["categoryList"][i]["name"].stringValue
//                        // let metadata = json["categoryList"][i]["metaData"]
//
//                        let description = json["categoryList"][i]["metaData"]["description"].stringValue
//                        let image = json["categoryList"][i]["metaData"]["mobileImage"].stringValue
//                        let isSubCategoryAvailable = json["categoryList"][i]["isSubCategoryAvailable"].boolValue
//
//                        let parentCategory = json["categoryList"][i]["parentCategory"].stringValue
//                        if isSubCategoryAvailable {
//                            subCategoriesList.removeAll()
//                            for j in 0..<json["categoryList"][i]["subCategories"].count {
//
//                                let id = json["categoryList"][i]["subCategories"][j]["id"].stringValue
//                                let status = json["categoryList"][i]["subCategories"][j]["status"].stringValue
//                                let name = json["categoryList"][i]["subCategories"][j]["name"].stringValue
//                                // let metadata = json["categoryList"][i]["metaData"]
//
//                                let description = json["categoryList"][i]["subCategories"][j]["metaData"]["description"].stringValue
//                                let image = json["categoryList"][i]["subCategories"][j]["metaData"]["image"].stringValue
//                                let isSubCategoryAvailable = json["categoryList"][i]["subCategories"][j]["isSubCategoryAvailable"].boolValue
//
//                                let parentCategory = json["categoryList"][i]["subCategories"][j]["parentCategory"].stringValue
//
//                                if json["categoryList"][i]["subCategories"][j]["isSubCategoryAvailable"].boolValue {
//                                    lastCategoriesList.removeAll()
//                                    for k in 0..<json["categoryList"][i]["subCategories"][j]["subCategories"].count {
//
//                                        let id = json["categoryList"][i]["subCategories"][j]["subCategories"][k]["id"].stringValue
//                                        let status = json["categoryList"][i]["subCategories"][j]["subCategories"][k]["status"].stringValue
//                                        let name = json["categoryList"][i]["subCategories"][j]["subCategories"][k]["name"].stringValue
//
//                                        let description = json["categoryList"][i]["subCategories"][j]["subCategories"][k]["metaData"]["description"].stringValue
//                                        let image = json["categoryList"][i]["subCategories"][j]["subCategories"][k]["metaData"]["image"].stringValue
//                                        let isSubCategoryAvailable = json["categoryList"][i]["subCategories"][j]["subCategories"][k]["isSubCategoryAvailable"].boolValue
//
//                                        let parentCategory = json["categoryList"][i]["subCategories"][k]["parentCategory"].stringValue
//                                        lastCategoriesList.append(categoryListStruct.init(id: id, status: status, name: name, description: description, image: image, isSubCategoryAvailable: isSubCategoryAvailable, parentCategory: parentCategory, opened: false, subcategoriesList: []))
//                                    }
//                                    subCategoriesList.append(categoryListStruct.init(id: id, status: status, name: name, description: description, image: image, isSubCategoryAvailable: isSubCategoryAvailable, parentCategory: parentCategory, opened: false, subcategoriesList: lastCategoriesList))
//                                } else {
//                                    subCategoriesList.append(categoryListStruct.init(id: id, status: status, name: name, description: description, image: image, isSubCategoryAvailable: isSubCategoryAvailable, parentCategory: parentCategory, opened: false, subcategoriesList: []))
//                                }
//
//                            }
//                            categoriesList.append(categoryListStruct.init(id: id, status: status, name: name, description: description, image: image, isSubCategoryAvailable: isSubCategoryAvailable, parentCategory: parentCategory, opened: false, subcategoriesList: subCategoriesList))
//                        } else {
//                            categoriesList.append(categoryListStruct.init(id: id, status: status, name: name, description: description, image: image, isSubCategoryAvailable: isSubCategoryAvailable, parentCategory: parentCategory, opened: false, subcategoriesList: []))
//                        }
//
//
//                    }
                    
//                    print(categoriesList)
                    
                    do{
                        let jsonData = self.getDataFrom(JSON: json)
                        let responseData = try JSONDecoder().decode(CategoryNew.self, from: jsonData!)
                        self.categoryNew = responseData
                    }catch let error{
                        print(error.localizedDescription)
                    }
                    
                    categoriesListCopy = categoriesList
                    DispatchQueue.main.async {
                        self.emptyView.isHidden = true
                        self.tableView.reloadData()
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

//    @IBAction func flagAction(_ sender: UIButton) {
//        let sellerStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = sellerStoryboard.instantiateViewController(withIdentifier: "ChooseCountryVC") as! ChooseCountryVC
//        vc.delegate = self
////        vc.isFrom = self.isFrom
//        self.present(vc, animated: true, completion: nil)
//    }
    
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
    
}

extension CategoriesNewVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return categoriesListCopy.count
        return self.categoryNew.categoryList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoriesTableCell", for: indexPath) as! CategoriesTableCell
//        let info = categoriesListCopy[indexPath.row]
        let info = self.categoryNew.categoryList![indexPath.row]
        if info.opened! {
            cell.tableView.isHidden = false
            cell.cellDownArrowImg.image = UIImage(named: "category_up_icon")
        } else {
            cell.tableView.isHidden = true
            cell.cellDownArrowImg.image = UIImage(named: "category_down_icon")
        }
        cell.cellLbl.text = info.name
        
//        cell.cellImg.sd_setImage(with: URL(string: FILE_BASE_URL + "/\(info.image)"), placeholderImage: UIImage(named: "loading"))
        cell.cellImg.sd_setImage(with: URL(string: FILE_BASE_URL + "/\(info.metaData!.mobileImage!)"), placeholderImage: UIImage(named: "loading"))
//        cell.subcategoriesList = categoriesListCopy[indexPath.row].subcategoriesList
        cell.subcategoriesList = info.subCategories
        cell.didselectClosure = { tabIndex, cellIndex in
            if let tabIndexp = tabIndex, let cellIndexp = cellIndex {
                print("\(tabIndexp)", "\(cellIndexp)")
                
                if cellIndexp >= 0 {
                    let subCatVC = DIConfigurator.shared.getCatProductsVC()
                    //categoriesListCopy[self.parentCategorytappedIndex].subcategoriesList[tabIndexp].subcategoriesList.count > 0
                    if self.categoryNew.categoryList![self.parentCategorytappedIndex].subCategories![tabIndexp].subCategories!.count > 0 {
//                        subCatVC.catId = categoriesListCopy[self.parentCategorytappedIndex].subcategoriesList[tabIndexp].subcategoriesList[cellIndexp].id
                        subCatVC.catId = self.categoryNew.categoryList![self.parentCategorytappedIndex].subCategories![tabIndexp].subCategories![cellIndexp].id!
//                        subCatVC.catId = categoriesListCopy[self.parentCategorytappedIndex].subcategoriesList[tabIndexp].subcategoriesList[cellIndexp].id
                        
                        self.navigationController?.pushViewController(subCatVC, animated: true)
                        self.tableView.beginUpdates()
                        self.tableView.endUpdates()
                    }
                    
                } else {
                    self.tableView.beginUpdates()
                    self.tableView.endUpdates()
                }
                
                
                
            }
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.parentCategorytappedIndex = indexPath.row
        if self.categoryNew.categoryList![indexPath.row].opened! {

            self.categoryNew.categoryList![indexPath.row].opened = false
        } else {

            self.categoryNew.categoryList![indexPath.row].opened = true
        }
        self.tableView.reloadData()
    }
    
}

extension CategoriesNewVC: ChooseCountryDelegate{
    func onSelectCountry(country: Select_Country_List_Struct, isFrom: String) {
        let flag = UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.SELECTED_FLAG) as! String
        let imageUrl = FLAG_BASE_URL + "/" + flag
//        self.flagImg.sd_setImage(with: URL(string: imageUrl), completed: nil)
        self.countryNameLbl.text = "\(country.countryName)'s Products"
        if let data = try? Data(contentsOf: URL(string: imageUrl)!) {
                // Create Image and Update Image View
                flagImg.image = UIImage(data: data)
            }

        let countryColorStr = country.colorCode
        guard let rgba = countryColorStr.slice(from: "(", to: ")") else { return }
        let myStringArr = rgba.components(separatedBy: ",")

        self.headerViewOne.backgroundColor = UIColor(red: CGFloat((myStringArr[0] as NSString).doubleValue/255.0), green: CGFloat((myStringArr[1] as NSString).doubleValue/255.0), blue: CGFloat((myStringArr[2] as NSString).doubleValue/255.0), alpha: CGFloat((myStringArr[3] as NSString).doubleValue))
        self.headerViewTwo.backgroundColor = UIColor(red: CGFloat((myStringArr[0] as NSString).doubleValue/255.0), green: CGFloat((myStringArr[1] as NSString).doubleValue/255.0), blue: CGFloat((myStringArr[2] as NSString).doubleValue/255.0), alpha: CGFloat((myStringArr[3] as NSString).doubleValue))
        countryColor = UIColor(red: CGFloat((myStringArr[0] as NSString).doubleValue/255.0), green: CGFloat((myStringArr[1] as NSString).doubleValue/255.0), blue: CGFloat((myStringArr[2] as NSString).doubleValue/255.0), alpha: CGFloat((myStringArr[3] as NSString).doubleValue))
    }
}

extension URLSession {
//  func fetchData(at url: URL, completion: @escaping (Result<[mainCategory], Error>) -> Void) {
//    self.dataTask(with: url) { (data, response, error) in
//      if let error = error {
//        completion(.failure(error))
//      }
//
//      if let data = data {
//        do {
//          let toDos = try JSONDecoder().decode([mainCategory].self, from: data)
//          completion(.success(toDos))
//        } catch let decoderError {
//          completion(.failure(decoderError))
//        }
//      }
//    }.resume()
//  }
    
    func fetchData<T: Decodable>(for url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        self.dataTask(with: url) { (data, response, error) in
          if let error = error {
            completion(.failure(error))
          }

          if let data = data {
            do {
              let object = try JSONDecoder().decode(T.self, from: data)
              completion(.success(object))
            } catch let decoderError {
              completion(.failure(decoderError))
            }
          }
        }.resume()
      }
    
    
}

extension UIViewController{
    
    func getDataFrom(JSON json: JSON) -> Data? {
        do {
            return try json.rawData(options: .prettyPrinted)
        } catch _ {
            return nil
        }
    }
}
