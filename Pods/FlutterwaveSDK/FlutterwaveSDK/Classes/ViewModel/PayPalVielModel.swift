//
//  PayPalVielModel.swift
//  FlutterwaveSDK
//
//  Created by Rotimi Joshua on 30/09/2021.
//

import Foundation
import RxSwift
import Swinject

class PaypalViewModel: BaseViewModel{
    
    static let sharedViewModel: PaypalViewModel = Container.sharedContainer.resolve(PaypalViewModel.self)!
    
    let payPalRepository: PaypalRepository
    let payPalResponse = PublishSubject<PaypalResponse>()
    var flwRef = ""
    
    init(payPalRepository: PaypalRepository){
        self.payPalRepository = payPalRepository
    }
    
    
  
    func paypal(amount: String){
        let request = PaypalRequest(txRef: FlutterwaveConfig.sharedConfig().transcationRef, amount: amount, currency: FlutterwaveConfig.sharedConfig().currencyCode, country: FlutterwaveConfig.sharedConfig().country, email: FlutterwaveConfig.sharedConfig().email, phoneNumber: FlutterwaveConfig.sharedConfig().phoneNumber, fullname: "\(FlutterwaveConfig.sharedConfig().firstName.orEmpty()) \(FlutterwaveConfig.sharedConfig().lastName.orEmpty())", clientIP:(getIFAddresses().first), redirectURL: "",deviceFingerprint: (UIDevice.current.identifierForVendor?.uuidString), billingAddress:"", billingCity:"", billingZip:"", billingState:"", billingCountry:"", shippingName:"", shippingAddress:"", shippingCity:"", shippingZip:"", shippingState:"", shippingCountry:"")
        makeAPICallRx(request: request, apiRequest: payPalRepository.payPal(request:), successHandler: payPalResponse,onSuccessOperation: {[weak self] response in
            self?.checkAuth(response: response.data, flwRef: response.data?.flwRef ?? "", source: .paypal)
        }, apiName: .payPal, apiErrorName: .payPalError)
    }
    
   
}


