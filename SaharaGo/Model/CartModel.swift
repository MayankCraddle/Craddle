//
//  CartModel.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 31/08/22.
//

import Foundation

struct cartProductListStruct {
    var currency:String = ""
    var description:String = ""
    var stock:String = ""
    var productId :String = ""
    var itemId :String = ""
    var price:String = ""
    var discountedPrice:String = ""
    var discountPercent:String = ""
    var name :String = ""
    var quantity:String = ""
    var images:String = ""
    var imagesArr: [String]?
    var vendorId :String = ""
    var noOfPieces :Int = 0
    var productLength :String = ""
    var productHeight :String = ""
    var productWidth :String = ""
    var shortDescription:String = ""
    var material:String = ""
    var dimensionUnit:String = ""
    var boxId :Int = 0
    var rating :Int = 0
    var country:String = ""
    var vendorEncryptedId :String = ""
    var actualPrice: String = ""
    var minQuantity: String = ""
    
}

// MARK: - Welcome2
struct CategoryNew : Codable{
    var categoryList: [CategoryList]?
    let parentCategoryList: [String]?
    let totalSize: Int?
    let success: Bool
    
    init() {
        categoryList = nil
        parentCategoryList = nil
        totalSize = nil
        success = false
    }
}

// MARK: - SubCategory
struct SubCategory : Codable {
    let id, name, parentCategory: String?
    let mainCategory: String?
    let isSubCategoryAvailable: Bool
    let metaData: MetaData
    let tags: [String]
    let status: String?
    let comment: String?
    let addedBy: String?
    let createdOn: String?
    let parentCategoryName: String?
    let subCategories: [CategoryList]?
    var opened: Bool?
}

// MARK: - CategoryList
struct CategoryList : Codable{
    let id, name, parentCategory: String?
    let mainCategory: String?
    let isSubCategoryAvailable: Bool
    let metaData: MetaData?
    let tags: [String]?
    let status: String?
    let comment: String?
    let addedBy, createdOn: String?
    let parentCategoryName: String
    let subCategories: [SubCategory]?
    var opened: Bool?
    
//    init() {
//        id = nil
//        name = nil
//        parentCategory = nil
//        opened = false
//    }
}

// MARK: - MetaData
struct MetaData : Codable{
    let metaDataDescription, image, mobileImage: String?
}

//struct Status : Codable{
//    let approved:String?
//}
