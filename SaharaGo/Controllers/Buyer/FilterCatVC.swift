//
//  FilterCatVC.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 07/12/22.
//

import UIKit

class FilterCatVC: UIViewController {

    @IBOutlet weak var subCatTableView: UITableView!
    @IBOutlet weak var parentCatTableView: UITableView!
    
    var selectedIndex = 0
    var completionHandlerCallback:((String?) ->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        print(categoriesListCopy)
        if categoriesListCopy.count == 0 {
            self.getCategoriesList()
        } else {
            DispatchQueue.main.async {
//                self.emptyView.isHidden = true
                self.subCatTableView.reloadData()
                self.subCatTableView.delegate = self
                self.subCatTableView.dataSource = self
                self.parentCatTableView.reloadData()
                self.parentCatTableView.delegate = self
                self.parentCatTableView.dataSource = self
            }
        }
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
                    for i in 0..<json["categoryList"].count
                    {
                        let id = json["categoryList"][i]["id"].stringValue
                        let status = json["categoryList"][i]["status"].stringValue
                        let name = json["categoryList"][i]["name"].stringValue
                        // let metadata = json["categoryList"][i]["metaData"]
                        
                        let description = json["categoryList"][i]["metaData"]["description"].stringValue
                        let image = json["categoryList"][i]["metaData"]["mobileImage"].stringValue
                        let isSubCategoryAvailable = json["categoryList"][i]["isSubCategoryAvailable"].boolValue
                        
                        let parentCategory = json["categoryList"][i]["parentCategory"].stringValue
                        if isSubCategoryAvailable {
                            subCategoriesList.removeAll()
                            for j in 0..<json["categoryList"][i]["subCategories"].count {
                                
                                let id = json["categoryList"][i]["subCategories"][j]["id"].stringValue
                                let status = json["categoryList"][i]["subCategories"][j]["status"].stringValue
                                let name = json["categoryList"][i]["subCategories"][j]["name"].stringValue
                                // let metadata = json["categoryList"][i]["metaData"]
                                
                                let description = json["categoryList"][i]["subCategories"][j]["metaData"]["description"].stringValue
                                let image = json["categoryList"][i]["subCategories"][j]["metaData"]["image"].stringValue
                                let isSubCategoryAvailable = json["categoryList"][i]["subCategories"][j]["isSubCategoryAvailable"].boolValue
                                
                                let parentCategory = json["categoryList"][i]["subCategories"][j]["parentCategory"].stringValue
                                
                                if json["categoryList"][i]["subCategories"][j]["isSubCategoryAvailable"].boolValue {
                                    lastCategoriesList.removeAll()
                                    for k in 0..<json["categoryList"][i]["subCategories"][j]["subCategories"].count {
                                        
                                        let id = json["categoryList"][i]["subCategories"][j]["subCategories"][k]["id"].stringValue
                                        let status = json["categoryList"][i]["subCategories"][j]["subCategories"][k]["status"].stringValue
                                        let name = json["categoryList"][i]["subCategories"][j]["subCategories"][k]["name"].stringValue
                                        // let metadata = json["categoryList"][i]["metaData"]
                                        
                                        let description = json["categoryList"][i]["subCategories"][j]["subCategories"][k]["metaData"]["description"].stringValue
                                        let image = json["categoryList"][i]["subCategories"][j]["subCategories"][k]["metaData"]["image"].stringValue
                                        let isSubCategoryAvailable = json["categoryList"][i]["subCategories"][j]["subCategories"][k]["isSubCategoryAvailable"].boolValue
                                        
                                        let parentCategory = json["categoryList"][i]["subCategories"][k]["parentCategory"].stringValue
                                        lastCategoriesList.append(categoryListStruct.init(id: id, status: status, name: name, description: description, image: image, isSubCategoryAvailable: isSubCategoryAvailable, parentCategory: parentCategory, opened: false, subcategoriesList: []))
                                    }
                                    subCategoriesList.append(categoryListStruct.init(id: id, status: status, name: name, description: description, image: image, isSubCategoryAvailable: isSubCategoryAvailable, parentCategory: parentCategory, opened: false, subcategoriesList: lastCategoriesList))
                                } else {
                                    subCategoriesList.append(categoryListStruct.init(id: id, status: status, name: name, description: description, image: image, isSubCategoryAvailable: isSubCategoryAvailable, parentCategory: parentCategory, opened: false, subcategoriesList: []))
                                }
                                
                                
                                
                            }
                            categoriesList.append(categoryListStruct.init(id: id, status: status, name: name, description: description, image: image, isSubCategoryAvailable: isSubCategoryAvailable, parentCategory: parentCategory, opened: false, subcategoriesList: subCategoriesList))
                        } else {
                            categoriesList.append(categoryListStruct.init(id: id, status: status, name: name, description: description, image: image, isSubCategoryAvailable: isSubCategoryAvailable, parentCategory: parentCategory, opened: false, subcategoriesList: []))
                        }
                        
                        
                    }
                    
//                    print(categoriesList)
                    categoriesListCopy = categoriesList
                    DispatchQueue.main.async {
//                        self.emptyView.isHidden = true
                        self.subCatTableView.reloadData()
                        self.subCatTableView.delegate = self
                        self.subCatTableView.dataSource = self
                        self.parentCatTableView.reloadData()
                        self.parentCatTableView.delegate = self
                        self.parentCatTableView.dataSource = self
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

extension FilterCatVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == self.parentCatTableView {
            return 1
        } else {
            return categoriesListCopy[selectedIndex].subcategoriesList.count
           
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.parentCatTableView {
            return categoriesListCopy.count
        } else {
            return categoriesListCopy[selectedIndex].subcategoriesList[section].subcategoriesList.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.parentCatTableView {
            self.selectedIndex = indexPath.row
            DispatchQueue.main.async {
                self.subCatTableView.reloadData()
            }
        } else {
            if self.completionHandlerCallback != nil {
                let info = categoriesListCopy[selectedIndex].subcategoriesList[indexPath.section].subcategoriesList[indexPath.row]
                self.completionHandlerCallback!(info.id)
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.parentCatTableView {
            let info = categoriesListCopy[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCatCell", for: indexPath) as! FilterCatCell
            cell.cellLbl.text = info.name
            return cell
        } else {
            let info = categoriesListCopy[selectedIndex].subcategoriesList[indexPath.section].subcategoriesList[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "FilterSubCatCell", for: indexPath) as! FilterSubCatCell
            cell.cellSubCatLbl.text = info.name
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return ""
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if tableView == self.subCatTableView {
            return 50.0
        } else {
            return 0
        }
        
    }
   
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        if tableView == self.subCatTableView {
            let view = UIView()
            let dropDownBtn = UIButton()
            view.frame = CGRect.init(x: 0, y: 0, width: tableView.frame.size.width, height: 50)
            view.backgroundColor = .groupTableViewBackground
            let lbl = UILabel()
            lbl.frame =  CGRect.init(x: 20, y: 0, width: tableView.frame.size.width, height: 50)
            lbl.textAlignment = .left
            lbl.numberOfLines = 0
            let title = categoriesListCopy[selectedIndex].subcategoriesList[section].name
            lbl.text = title
            lbl.textColor = .black
            
            view.addSubview(lbl)
            return view
        } else {
            return UIView()
        }
        
    }
    
}
