//
//  RaveCardClient.swift
//  GetBarter
//
//  Created by texyz on 10/02/2020.
//  Copyright (c) 2020 texyz. All rights reserved.

import Foundation
import UIKit

class FlutterwaveCardClient{
    public var cardNumber:String?
    public var cardfirst6:String?
    public var cvv:String?
    public var amount:String?
    public var expYear:String?
    public var expMonth:String?
    public var saveCard = true
    public var otp:String?
    
    public var isSaveCardCharge:String?
    public var saveCardPayment:String?
    public var savedCardHash:String?
    public var savedCardMobileNumber:String?
    
    public var transactionReference:String?
    public var bodyParam:[String:Any]? = [:]
    
    typealias FeeSuccessHandler = ((String?,String?) -> Void)
    typealias SuccessHandler = ((String?,FlutterwaveDataResponse?) -> Void)
    typealias ErrorHandler = ((String?,FlutterwaveDataResponse?) -> Void)
    typealias SuggestedAuthHandler = ((SuggestedAuthModel,[String:Any]?, String?) -> Void)
    typealias OTPAuthHandler = ((String,String) -> Void)
    typealias WebAuthHandler = ((String,String) -> Void)
    typealias SaveCardSuccessHandler = (([SavedCard]?) -> Void)
    typealias SaveCardErrorHandler = ((String?) -> Void)
    typealias RemoveSavedCardSuccessHandler = (() -> Void)
    typealias RemoveSavedCardErrorHandler = ((String?) -> Void)
    
    public var error:ErrorHandler?
    public var saveCardError:SaveCardErrorHandler?
    public var saveCardSuccess:SaveCardSuccessHandler?
    public var removesavedCardError:RemoveSavedCardErrorHandler?
    public var removesavedCardSuccess:RemoveSavedCardSuccessHandler?
    public var validateError:ErrorHandler?
    public var feeSuccess:FeeSuccessHandler?
    public var chargeSuggestedAuth: SuggestedAuthHandler?
    public var chargeOTPAuth: OTPAuthHandler?
    public var chargeWebAuth: WebAuthHandler?
    public var chargeSuccess: SuccessHandler?
    public var sendOTPSuccess:SaveCardErrorHandler?
    public var sendOTPError:SaveCardErrorHandler?
    public var selectedCard:SavedCard?
    
    private var isRetryCharge = false
    private var retryChargeValue:String?
    
    
    
    //MARK: Charge Saved Card
    public func saveCardCharge(){
        if let pubkey = FlutterwaveConfig.sharedConfig().publicKey{
            var country :String = ""
            switch FlutterwaveConfig.sharedConfig().currencyCode {
            case "KES","TZS","GHS","ZAR":
                country = FlutterwaveConfig.sharedConfig().country
            default:
                country = "NG"
            }
            var param:[String:Any] = ["PBFPubKey":pubkey,
                                      "IP": getIFAddresses().first!,
                                      "device_fingerprint": (UIDevice.current.identifierForVendor?.uuidString)!,
                                      "email": FlutterwaveConfig.sharedConfig().email!,
                                      "currency": FlutterwaveConfig.sharedConfig().currencyCode,
                                      "country":country,
                                      "amount":amount ?? "",
                                      "firstname":FlutterwaveConfig.sharedConfig().firstName ?? "",
                                      "lastname": FlutterwaveConfig.sharedConfig().lastName ?? "",
                                      "otp":"123456",
                                      "txRef": FlutterwaveConfig.sharedConfig().transcationRef!]
            if let saveCard = isSaveCardCharge{
                param.merge(["is_saved_card_charge":saveCard])
            }
//            if let _otp = otp{
//                param.merge(["otp":_otp])
//            }
            if let saveCardType = saveCardPayment{
                param.merge(["payment_type":saveCardType])
            }
            if let brand = selectedCard?.card?.cardBrand{
                if brand.lowercased() == "visa"{
                    param.merge(["is_visa":true])
                }else{
                    param.merge(["is_visa":false])
                }
                
            }
            if let device = selectedCard?.mobileNumber{
                param.merge(["device_key":device])
            }
            if let hash = selectedCard?.cardHash{
                param.merge(["card_hash":hash])
            }
            if FlutterwaveConfig.sharedConfig().isPreAuth{
                param.merge(["charge_type":"preauth"])
            }
            if let subAccounts = FlutterwaveConfig.sharedConfig().subAccounts{
                let subAccountDict =  subAccounts.map { (subAccount) -> [String:String] in
                    var dict = ["id":subAccount.id]
                    if let ratio = subAccount.ratio{
                        dict.merge(["transaction_split_ratio":"\(ratio)"])
                    }
                    if let chargeType = subAccount.charge_type{
                        switch chargeType{
                        case .flat :
                            dict.merge(["transaction_charge_type":"flat"])
                            if let charge = subAccount.charge{
                                dict.merge(["transaction_charge":"\(charge)"])
                            }
                        case .percentage:
                            dict.merge(["transaction_charge_type":"percentage"])
                            if let charge = subAccount.charge{
                                dict.merge(["transaction_charge":"\((charge / 100))"])
                            }
                        }
                    }
                    
                    return dict
                }
                param.merge(["subaccounts":subAccountDict])
            }
            if let meta = FlutterwaveConfig.sharedConfig().meta{
                param.merge(["meta":meta])
            }
            
            let jsonString  = param.jsonStringify()
            
            print("This is the payload before encryption\(jsonString)")
            
            let secret = FlutterwaveConfig.sharedConfig().encryptionKey!
            let data =  TripleDES.encrypt(string: jsonString, key:secret)
            let base64String = data?.base64EncodedString()
            
            
            CardViewModel.sharedViewModel.chargeSavedCard(client: base64String!)
           

        }
    }
    
    
    //MARK: Charge Card
    public func chargeCard(replaceData:Bool = false){
        if let pubkey = FlutterwaveConfig.sharedConfig().publicKey{
            var country :String = ""
            switch FlutterwaveConfig.sharedConfig().currencyCode {
            case "KES","TZS","GHS","ZAR":
                country = FlutterwaveConfig.sharedConfig().country
            default:
                country = "NG"
            }
            guard let _ = cardNumber else {
                fatalError("Card Number is missing")
            }
            guard let _ = cvv else {
                fatalError("CVV Number is missing")
            }
            guard let _ = amount else {
                fatalError("Amount is missing")
            }
            guard let _ = expYear else {
                fatalError("Expiry Year is missing")
            }
            guard let _ = expMonth else {
                fatalError("Expiry Month is missing")
            }
            guard let _ = FlutterwaveConfig.sharedConfig().email else {
                fatalError("Email address is missing")
            }
            guard let _ = FlutterwaveConfig.sharedConfig().transcationRef else {
                fatalError("transactionRef is missing")
            }
            var param:[String:Any] = ["PBFPubKey":pubkey ,
                                      "card_number":cardNumber ?? "",
                                      "cvv":cvv ?? "",
                                      "amount":amount ?? "",
                                      "expiry_year":expYear ?? "",
                                      "expiry_month": expMonth ?? "",
                                      "preauthorize":FlutterwaveConfig.sharedConfig().isPreAuth,
                                      "fullname": "\(FlutterwaveConfig.sharedConfig().firstName.orEmpty()) \(FlutterwaveConfig.sharedConfig().lastName.orEmpty())",
                "email": FlutterwaveConfig.sharedConfig().email!,
                "currency": FlutterwaveConfig.sharedConfig().currencyCode,
                "country":country,
                "payment_plan":FlutterwaveConfig.sharedConfig().paymentPlan ?? 0,
                //                                      "IP": getIFAddresses().first!,
                "tx_ref": FlutterwaveConfig.sharedConfig().transcationRef!,
                "device_fingerprint": (UIDevice.current.identifierForVendor?.uuidString)!]
            if let narrate = FlutterwaveConfig.sharedConfig().narration{
                param.merge(["narration":narrate])
            }
           
            
            if let subAccounts = FlutterwaveConfig.sharedConfig().subAccounts{
                let subAccountDict =  subAccounts.map { (subAccount) -> [String:String] in
                    var dict = ["id":subAccount.id]
                    if let ratio = subAccount.ratio{
                        dict.merge(["transaction_split_ratio":"\(ratio)"])
                    }
                    if let chargeType = subAccount.charge_type{
                        switch chargeType{
                        case .flat :
                            dict.merge(["transaction_charge_type":"flat"])
                            if let charge = subAccount.charge{
                                dict.merge(["transaction_charge":"\(charge)"])
                            }
                        case .percentage:
                            dict.merge(["transaction_charge_type":"percentage"])
                            if let charge = subAccount.charge{
                                dict.merge(["transaction_charge":"\((charge / 100))"])
                            }
                        }
                    }
                    
                    return dict
                }
                param.merge(["subaccounts":subAccountDict])
            }
            
            if let meta = FlutterwaveConfig.sharedConfig().meta{
                param.merge(["meta":meta])
            }
            if saveCard {
                if let phone = FlutterwaveConfig.sharedConfig().phoneNumber, phone != ""{
                    param.merge(["remember_device_mobile_key": phone, "remember_device_email":FlutterwaveConfig.sharedConfig().email!, "is_remembered":"1"])
                }
            }
           
            
            if replaceData {
                bodyParam = param
            
            }
            if isRetryCharge{
                if let retryValue = self.retryChargeValue{
                    bodyParam?.merge(["retry_charge":retryValue])
                }
            }
          

            let jsonString  = bodyParam?.jsonStringify()
//                        print("JSON SENT \(jsonString)")
            let secret = FlutterwaveConfig.sharedConfig().encryptionKey!
            let data =  TripleDES.encrypt(string: jsonString ?? "", key:secret)
            let base64String = data?.base64EncodedString()

            CardViewModel.sharedViewModel.saveCard = saveCard
            PaymentServicesViewModel.sharedViewModel.chargeCard(client: base64String!)
            
        }else{
            self.error?("Public Key is not specified",nil)
        }
    }
    
    //MARK: Validate Card
    public func validateCardOTP(){
        guard let ref = self.transactionReference, let _otp = otp else {
            self.error?("Transaction Reference  or OTP is not set",nil)
            return
        }
        
        PaymentServicesViewModel.sharedViewModel.validateCharge(otp: _otp, flwRef: ref, type: "card")
        
    }
    
    //MARK: Fetch saved card
//    func fetchSavedCards(){
//        if let pubkey = FlutterwaveConfig.sharedConfig().publicKey{
//            if let deviceNumber = FlutterwaveConfig.sharedConfig().phoneNumber {
//                let param = ["public_key":pubkey, "device_key":deviceNumber]
//                
//                FlutterwavePayService.getSavedCards(param, resultCallback: {[weak self] (cardResponse) in
//                    guard let  strongSelf = self else{ return}
//                    strongSelf.saveCardSuccess?(cardResponse.cards)
//                })  {[weak self] (err) in
//                    guard let  strongSelf = self else{ return}
//                    strongSelf.saveCardError?(err)
//                }
//            }
//            
//        }
//    }
    //MARK: Transaction Fee
//    public func removeSavedCard(){
//        if let pubkey = FlutterwaveConfig.sharedConfig().publicKey{
//            let param = [
//                "public_key": pubkey,
//                "card_hash": savedCardHash!,
//                "mobile_number": savedCardMobileNumber!]
//            FlutterwavePayService.removeSavedCard(param, resultCallback: {[weak self] (result) in
//                guard let strongSelf = self else {return}
//                strongSelf.removesavedCardSuccess?()
//                }, errorCallback: {[weak self] (err) in
//                    guard let strongSelf = self else {return}
//                    strongSelf.removesavedCardError?(err)
//            })
//        }else{
//            self.removesavedCardError?("Public Key is not specified")
//        }
//    }
    
    //MARK: Send OTP
//    func sendOTP(card: SavedCard){
//        if let pubkey = FlutterwaveConfig.sharedConfig().publicKey{
//            let param = ["public_key":pubkey,"card_hash":card.cardHash ?? "","device_key":card.mobileNumber ?? ""]
//            FlutterwavePayService.sendOTP(param, resultCallback: {[weak self] (message) in
//                guard let  strongSelf = self else{ return}
//                strongSelf.sendOTPSuccess?(message)
//            }) {[weak self] (err) in
//                guard let  strongSelf = self else{ return}
//                strongSelf.sendOTPError?(err)
//            }
//        }
//    }
    
    func isMasterCard() -> Bool{
        if let cardNumber = self.cardNumber{
            if cardNumber.hasPrefix("5"){
                return true
            }else{
                return false
            }
        }else{
            return false
        }
    }
    
    
    
}

