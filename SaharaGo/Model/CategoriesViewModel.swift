//
//  CategoriesViewModel.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 28/10/22.
//

import Foundation

struct CategoriesViewModel {
    
    func getCategoriesWithSubCategories(onSuccess:@escaping([categoryListStruct]) -> Void, onError:@escaping(String) -> Void) {
        var categoriesList = [categoryListStruct]()
        var subCategoriesList = [categoryListStruct]()
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
                        let image = json["categoryList"][i]["metaData"]["image"].stringValue
                        let isSubCategoryAvailable = json["categoryList"][i]["isSubCategoryAvailable"].boolValue
                        
                        let parentCategory = json["categoryList"][i]["parentCategory"].stringValue
                        
                        var subcategoriesList: [categoryListStruct] = [categoryListStruct]()
                        if isSubCategoryAvailable {
                            for j in 0..<json["categoryList"][i]["subCategories"].count {
                                let id = json["categoryList"][i]["subCategories"][j]["id"].stringValue
                                let status = json["categoryList"][i]["subCategories"][j]["status"].stringValue
                                let name = json["categoryList"][i]["subCategories"][j]["name"].stringValue
                                // let metadata = json["categoryList"][i]["metaData"]
                                
                                let description = json["categoryList"][i]["subCategories"][j]["metaData"]["description"].stringValue
                                let image = json["categoryList"][i]["subCategories"][j]["metaData"]["image"].stringValue
                                let isSubCategoryAvailable = json["categoryList"][i]["subCategories"][j]["isSubCategoryAvailable"].boolValue
                                
                                let parentCategory = json["categoryList"][i]["subCategories"][j]["parentCategory"].stringValue
                                
                                subcategoriesList.append(categoryListStruct.init(id: id, status: status, name: name, description: description, image: image, isSubCategoryAvailable: isSubCategoryAvailable, parentCategory: parentCategory, opened: false))
                                
                                var subSubCategoriesList: [categoryListStruct] = [categoryListStruct]()
                                
                                if json["categoryList"][i]["subCategories"][j]["isSubCategoryAvailable"].boolValue {
                                    
                                    
                                    for k in 0..<json["categoryList"][i]["subCategories"][j]["subCategories"].count {
                                        
                                        let id = json["categoryList"][i]["subCategories"][j]["subCategories"][k]["id"].stringValue
                                        let status = json["categoryList"][i]["subCategories"][j]["subCategories"][k]["status"].stringValue
                                        let name = json["categoryList"][i]["subCategories"][j]["subCategories"][k]["name"].stringValue
                                        // let metadata = json["categoryList"][i]["metaData"]
                                        
                                        let description = json["categoryList"][i]["subCategories"][j]["subCategories"][k]["metaData"]["description"].stringValue
                                        let image = json["categoryList"][i]["subCategories"][j]["subCategories"][k]["metaData"]["image"].stringValue
                                        let isSubCategoryAvailable = json["categoryList"][i]["subCategories"][j]["subCategories"][k]["isSubCategoryAvailable"].boolValue
                                        
                                        let parentCategory = json["categoryList"][i]["subCategories"][j]["subCategories"][k]["parentCategory"].stringValue
                                        
                                        subSubCategoriesList.append(categoryListStruct.init(id: id, status: status, name: name, description: description, image: image, isSubCategoryAvailable: isSubCategoryAvailable, parentCategory: parentCategory, opened: false))
                                                                        
                                    }
                                    
                                    subCategoriesList.append(categoryListStruct.init(id: id, status: status, name: name, description: description, image: image, isSubCategoryAvailable: isSubCategoryAvailable, parentCategory: parentCategory, opened: false, subcategoriesList: subSubCategoriesList))
                                    
                                    categoriesList.append(categoryListStruct.init(id: id, status: status, name: name, description: description, image: image, isSubCategoryAvailable: isSubCategoryAvailable, parentCategory: parentCategory, opened: false, subcategoriesList: subCategoriesList))
                                    
                                } else {
                                    categoriesList.append(categoryListStruct.init(id: id, status: status, name: name, description: description, image: image, isSubCategoryAvailable: isSubCategoryAvailable, parentCategory: parentCategory, opened: false, subcategoriesList: subCategoriesList))
                                }

                                
                                
                                                                
                            }
                            categoriesList.append(categoryListStruct.init(id: id, status: status, name: name, description: description, image: image, isSubCategoryAvailable: isSubCategoryAvailable, parentCategory: parentCategory, opened: false, subcategoriesList: subcategoriesList))
                        } else {
                            categoriesList.append(categoryListStruct.init(id: id, status: status, name: name, description: description, image: image, isSubCategoryAvailable: isSubCategoryAvailable, parentCategory: parentCategory, opened: false, subcategoriesList: []))
                        }
                        
                        
                        
                        
                    }
                    onSuccess(categoriesList)
                    
                }
                else {
                    onSuccess(categoriesList)
                }
            }, errorBlock: { (NSError) in

            })
            
        }else{
            onSuccess(categoriesList)
            
        }

    }
    
    func getParentCategories(onSuccess:@escaping([categoryListStruct]) -> Void, onError:@escaping(String) -> Void) {
        var categoriesList = [categoryListStruct]()
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = [:]
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.VENDOR_GET_ALL_CATEGORY, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    categoriesList.removeAll()
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
                            categoriesList.append(categoryListStruct.init(id: id, status: status, name: name, description: description, image: image, isSubCategoryAvailable: isSubCategoryAvailable, parentCategory: parentCategory, opened: false))
                        }
                        
                        
                    }
                    onSuccess(categoriesList)
                    
                }
                else {
                    onSuccess(categoriesList)
                }
            }, errorBlock: { (NSError) in

            })
            
        }else{
            onSuccess(categoriesList)
            
        }

    }
    
    func getSubcategories(catId: String? = "abc", onSuccess:@escaping([categoryListStruct]) -> Void){
        
        var subCategoriesList = [categoryListStruct]()
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)

            var  apiUrl =  BASE_URL + PROJECT_URL.GET_ALL_SUBCATEGORY
            apiUrl = apiUrl + "\(catId)"

            let param:[String:String] = [:]
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: apiUrl, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    subCategoriesList.removeAll()
                    for i in 0..<json["categoryList"].count
                    {
                        let id = json["categoryList"][i]["id"].stringValue

                        let status = json["categoryList"][i]["status"].stringValue
                        let name = json["categoryList"][i]["name"].stringValue
                        let isSubCategoryAvailable = json["categoryList"][i]["isSubCategoryAvailable"].boolValue

                        let parentCategory = json["categoryList"][i]["parentCategory"].stringValue

                       // let metadata = json["categoryList"][i]["metaData"]

                        let description = json["categoryList"][i]["metaData"]["description"].stringValue
                        let image = json["categoryList"][i]["metaData"]["image"].stringValue


                        subCategoriesList.append(categoryListStruct.init(id: id, status: status, name: name, description: description, image: image, isSubCategoryAvailable: isSubCategoryAvailable, parentCategory: parentCategory ))
                    }
                    onSuccess(subCategoriesList)
                }
                else {
                    onSuccess(subCategoriesList)
                }
            }, errorBlock: { (NSError) in
            })

        }else{
            onSuccess(subCategoriesList)
        }

    }
}
