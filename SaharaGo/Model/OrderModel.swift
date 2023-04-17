//
//  OrderModel.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 07/11/22.
//

import Foundation

struct current_order_Address_main_struct {
    var orderState: String = ""
    var shippingRate: String = ""
    var totalPrice: String = ""
    var orderId: String = ""
    var createdOn:String = ""
    var orderBy: String = ""
    var country:String = ""
    var state:String = ""
    var lastName:String = ""
    var firstName:String = ""
    var city :String = ""
    var phone :String = ""
    var zipcode:String = ""
    var streetAddress :String = ""
    var landmark :String = ""
    //var addressMetaData :current_order_Address_struct = current_order_Address_struct()
    var cartMetaData :[current_order_cartData_struct] = [current_order_cartData_struct]()
    var vendorName:String = ""
    var vendorId:String = ""
}

struct current_order_cartData_struct {
    var itemId:String = ""
    var vendorId:String = ""
    var productId:String = ""
    var price:String = ""
    var discountedPrice:String = ""
    var name :String = ""
    var currency :String = ""
    var quantity:String = ""
    var discountPercent :String = ""
    var stock :String = ""
    var totalPrice :String = ""
    var isRated :Bool = false
    var metaData :current_order_metaData_struct = current_order_metaData_struct()
    var rating:Double = 0.0
    var userRating:Double = 0.0
    var userReview :String = ""
    
}

struct current_order_metaData_struct {
    var images = [Any]()
    var description :String = ""
}
