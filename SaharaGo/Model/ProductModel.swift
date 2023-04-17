//
//  ProductModel.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 25/08/22.
//

import Foundation
import UIKit

struct SimilarProducts_Struct {
    var currency:String = ""
    var vendorName:String = ""
    var vendorId:String = ""
    var productId:String = ""
    var name:String = ""
    var description:String = ""
    var dimension :String = ""
    var wishlisted:Bool = false
    var orderable:Bool = false
    var discountType :String = ""
    var itemId :String = ""
    var categoryId :String = ""
    //    var actualPrice :Int = 0
    //    var discountValue :Int = 0
    //    var stock :Int = 0
    //    var discountedPrice :Int = 0
    //    var rating :Int = 0
    var actualPrice :String = ""
    var discountValue :String = ""
    var stock :String = ""
    var discountedPrice :String = ""
    var rating :String = ""
    var images: [String]?
    var discountPercent:String = ""
    var totalSize: Int = 0
    var minQuantity: String = ""
    var type: String = ""
}

struct categoryListStruct {
    var id:String = ""
    var status:String = ""
    var name:String = ""
    var description:String = ""
    var image :String = ""
    var isSubCategoryAvailable:Bool = false
    var parentCategory :String = ""
    var comment :String = ""
    var opened: Bool = false
    var subcategoriesList: [categoryListStruct] = [categoryListStruct]()
}

struct mediaCategoryListStruct {
    var id:String = ""
    var priority:Int = 0
    var sectionName:String = ""
    var createdOn:String = ""
    var isSelected:Bool = false
    var icon:String = ""
    var type:String = ""
}

struct mediaContentListStruct {
    var subject:String = ""
    var id:Int = 0
    var shortDescription:String = ""
    var files = [Any]()
    var sectionId:Int = 0
    var totalSize:Int = 0
    var videoUrl:String = ""
    var videoId:String = ""
    var readCount:String = ""
    var comments:[commentTypeStruct] = [commentTypeStruct]()
    var commentCount:String = ""
    var isReadMore:Bool = false
    var shareURl:String = ""
    var sectionName:String = ""
    var createdOn:String = ""
    var type:String = ""
}

struct allMediaCatAndContentListStruct {
    var sectionName:String = ""
    var sectionContent:[mediaContentListStruct] = [mediaContentListStruct]()
    var priority:Int = 0
}

struct commentTypeStruct {
    var createdBy:String = ""
    var comment:String = ""
    var createdOn:String = ""
}

struct topDeals_Struct {
    var currency:String = ""
    var productId:String = ""
    var name:String = ""
    var description:String = ""
    var dimension :String = ""
    var wishlisted:Bool = false
    var discountType :String = ""
    var itemId :String = ""
    var categoryId :String = ""
    var actualPrice :String = ""
    var discountValue :String = ""
    var stock :String = ""
    var discountedPrice :String = ""
    var rating :String = ""
    var images: [String]?
}

struct profileDetail_Struct {
    var firstName:String = ""
    var lastName:String = ""
    var emailMobile:String = ""
    var country:String = ""
    var userImage:String = ""
    var coverImage:String = ""
    var address = address_Struct()
}
