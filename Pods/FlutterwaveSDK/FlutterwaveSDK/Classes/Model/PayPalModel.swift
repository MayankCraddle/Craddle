//
//  PaypalModel.swift
//  FlutterwaveSDK
//
//  Created by Rotimi Joshua on 19/03/2021.
//

// MARK: - PaypalRequest
struct PaypalRequest: Codable {
    let txRef, amount, currency, country: String?
    let email, phoneNumber, fullname, clientIP: String?
    let redirectURL: String?
    let deviceFingerprint, billingAddress, billingCity, billingZip: String?
    let billingState, billingCountry, shippingName, shippingAddress: String?
    let shippingCity, shippingZip, shippingState, shippingCountry: String?

    enum CodingKeys: String, CodingKey {
        case txRef = "tx_ref"
        case amount, currency, country, email
        case phoneNumber = "phone_number"
        case fullname
        case clientIP = "client_ip"
        case redirectURL = "redirect_url"
        case deviceFingerprint = "device_fingerprint"
        case billingAddress = "billing_address"
        case billingCity = "billing_city"
        case billingZip = "billing_zip"
        case billingState = "billing_state"
        case billingCountry = "billing_country"
        case shippingName = "shipping_name"
        case shippingAddress = "shipping_address"
        case shippingCity = "shipping_city"
        case shippingZip = "shipping_zip"
        case shippingState = "shipping_state"
        case shippingCountry = "shipping_country"
    }
}

// MARK: - PaypalResponse
struct PaypalResponse: Codable {
    let status, message: String?
    let data: PaypalData?
    let meta: Meta?
}

// MARK: - DataClass
struct PaypalData: Codable, FlutterChargeResponse {
    let id: Int?
    let txRef, flwRef, deviceFingerprint: String?
    let amount, chargedAmount: Double?
    let appFee: Double?
    let merchantFee: Double?
    let processorResponse, authModel, currency, ip: String?
    let narration, status: String?
    let authURL: String?
    let paymentType, fraudStatus, chargeType, createdAt: String?
    let accountID: Int?
    let customer: Customer?
    let meta: Meta?

    enum CodingKeys: String, CodingKey {
        case id
        case txRef = "tx_ref"
        case flwRef = "flw_ref"
        case deviceFingerprint = "device_fingerprint"
        case amount
        case chargedAmount = "charged_amount"
        case appFee = "app_fee"
        case merchantFee = "merchant_fee"
        case processorResponse = "processor_response"
        case authModel = "auth_model"
        case currency, ip, narration, status
        case authURL = "auth_url"
        case paymentType = "payment_type"
        case fraudStatus = "fraud_status"
        case chargeType = "charge_type"
        case createdAt = "created_at"
        case accountID = "account_id"
        case customer, meta
    }
}





extension PaypalData{
    func toFlutterResponse() -> FlutterwaveDataResponse{
        return FlutterwaveDataResponse(txRef: txRef, flwRef: flwRef, deviceFingerprint: nil, amount: amount, chargedAmount: chargedAmount, appFee: appFee, merchantFee: merchantFee, processorResponse: processorResponse, authModel: nil, currency: currency, ip: ip, narration: narration, status: status, authURL:nil, paymentType: nil, fraudStatus: nil, chargeType: nil, createdAt: nil, paymentPlan: nil, id: nil, accountID: nil, customer: customer, card: nil)
    }
}



