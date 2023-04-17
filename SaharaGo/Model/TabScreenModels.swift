//
//  TabScreenModels.swift
//  SaharaGo
//
//  Created by Ritesh Sinha on 25/07/22.
//

import Foundation
import UIKit

struct productVariantStruct {
    var itemId: String = ""
    var actualPrice: String = ""
    var discountedPrice: String = ""
    var discountValue: String = ""
    var isSelected: Bool = false
    var variant: String = ""
    var minQuantity: String = ""
}

struct categoryProductListStruct {
    var categoryId:String = ""
    var currency:String = ""
    var description:String = ""
    var productWeight: String = ""
    var category:String = ""
    var stock:String = ""
    var vendorName:String = ""
    var productId :String = ""
    var itemId :String = ""
    var price:String = ""
    var discountedPrice:String = ""
    var discountPercent:String = ""
    var rating:String = ""
    var name :String = ""
    //var images :String = ""
    var images: [String]?
    var actualPrice :String = ""
    var wishlisted:Bool = false
    var orderable:Bool = false
    var returnPolicy: String = ""
    var totalSize: Int = 0
    var vendorDetails: vendorDetailsStruct = vendorDetailsStruct()
    var socialMediaArr = [SocialMediaStruct]()
    var ratingData: VendorRatingStruct = VendorRatingStruct()
    var vendorId:String = ""
    var shareUrl:String = ""
    var minQuantity: String = ""
}

struct vendorDetailsStruct {
    var vendorName: String = ""
    var vendorStreetAddress: String = ""
    var vendorCity: String = ""
    var vendorCountry: String = ""
    var vendorState: String = ""
    var vendorEmailMobile: String = ""
    var vendorCompanyName: String = ""
    var vendorImage: String = ""
    var vendorRating: String = ""
    var totalSize: Int = 0
    var vendorId: String = ""
    var vendorEncryptedId: String = ""
    var fcmKey: String = ""
}

struct VendorRatingStruct {
    var one: Int = 0
    var two: Int = 0
    var three: Int = 0
    var four: Int = 0
    var five: Int = 0
    var total: Int = 0
}

struct SocialMediaStruct {
    var link: String = ""
    var type: String = ""
}

struct homeSectionDataStruct {
    var sectionName: String = ""
    var content: [contentStruct] = [contentStruct]()
    var priority: Int = 0
    var sectionId: Int = 0
}

struct contentStruct {
    var createdOn: String = ""
    var country: String = ""
    var shortDescription: String = ""
    var body: String = ""
    var subject: String = ""
    var type: String = ""
    var files = [Any]()
    var id: Int = 0
    var sectionName: String = ""
}

struct contentDetailStruct {
    var sectionName: String = ""
    var country: String = ""
    var featuredImage: String = ""
    var body: String = ""
    var subject: String = ""
    var author: String = ""
    var files = [Any]()
    var id: Int = 0
    var shortDescription: String = ""
    var readCount: Int = 0
    var createdOn: String = ""
    var shareURl: String = ""
    var videoUrl: String = ""
    var videoId: String = ""
    var commentCount: Int = 0
    var link: String = ""
}

struct address_Struct {
    var id:String = ""
    var firstName:String = ""
    var lastName:String = ""
    var phone:String = ""
    var streetAddress :String = ""
    var country :String = ""
    var state:String = ""
    var city:String = ""
    var zipcode:String = ""
    var landmark:String = ""
    var isDefault :Bool = false
    var addressType:String = ""
    var phoneCode:String = ""
    var emailMobile:String = ""
}

struct commentStruct {
    var createdBy: String = ""
    var createdOn: String = ""
    var comment: String = ""
    var image: String = ""
    var rating: Double = 0.0
    var id: Int = 0
}

struct notification_Struct {
    var body:String = ""
    var date:String = ""
    var title:String = ""
    var totalSize:Int = 0
    
}
