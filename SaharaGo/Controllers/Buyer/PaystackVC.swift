//
//  PaystackVC.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 15/03/23.
//

import UIKit
import Foundation
import Paystack

class PaystackVC: UIViewController, PSTCKPaymentCardTextFieldDelegate {
    
    @IBOutlet weak var orderFailureView: UIView!
    @IBOutlet weak var orderSuccessView: UIView!
    @IBOutlet weak var cardDetailsForm: PSTCKPaymentCardTextField!
    @IBOutlet weak var chargeCardButton: UIButton!
    @IBOutlet weak var tokenLabel: UILabel!
    
    let card : PSTCKCard = PSTCKCard()
    
    let paystackPublicKey = "pk_test_1dfd4affcb0a1863c168a220cf8523d91c8ba7af"
    let backendURLString = "https://calm-scrubland-33409.herokuapp.com"
    var accessToken = ""
    var totalAmountIncludingShippingCharges : Double = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tokenLabel.text=nil
        chargeCardButton.isEnabled = false

    }
    
    // MARK: Helpers
    func showOkayableMessage(_ title: String, message: String){
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertController.Style.alert
        )
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func dismissKeyboardIfAny(){
        // Dismiss Keyboard if any
        cardDetailsForm.resignFirstResponder()
        
    }
    
    @IBAction func cardDetailsChanged(_ sender: PSTCKPaymentCardTextField) {
        chargeCardButton.isEnabled = sender.isValid
    }
    

    @IBAction func onTapBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func orderSuccessContinueAction(_ sender: Any) {
        let userStoryboard: UIStoryboard = UIStoryboard(name: "Buyer", bundle: nil)
        let viewController = userStoryboard.instantiateViewController(withIdentifier: "TabbarVC") as! TabbarVC
        let rootNC = UINavigationController(rootViewController: viewController)
        UIApplication.shared.delegate!.window!!.rootViewController = rootNC
    }
    
    @IBAction func orderSuccessViewOrdersAction(_ sender: UIButton) {
        let contentDetailVC = DIConfigurator.shared.getOrdersVC()
        self.navigationController?.pushViewController(contentDetailVC, animated: true)
    }
    
    @IBAction func chargeCard(_ sender: UIButton) {
        
        dismissKeyboardIfAny()
        
        // Make sure public key has been set
        if (paystackPublicKey == "" || !paystackPublicKey.hasPrefix("pk_")) {
            showOkayableMessage("You need to set your Paystack public key.", message:"You can find your public key at https://dashboard.paystack.co/#/settings/developer .")
            // You need to set your Paystack public key.
            return
        }
        
        Paystack.setDefaultPublicKey(paystackPublicKey)
        
        if cardDetailsForm.isValid {
            
            if backendURLString != "" {
                fetchAccessCodeAndChargeCard()
                return
            }
            showOkayableMessage("Backend not configured", message:"To run this sample, please configure your backend.")
//            chargeWithSDK(newCode:"");
            
        }
        
    }
    
    func outputOnLabel(str: String){
        DispatchQueue.main.async {
            if let former = self.tokenLabel.text {
                self.tokenLabel.text = former + "\n" + str
            } else {
                self.tokenLabel.text = str
            }
        }
    }
    
    func fetchAccessCodeAndChargeCard(){
        self.chargeWithSDK(newCode: self.accessToken as NSString)
//        if let url = URL(string: backendURLString  + "/new-access-code") {
//            self.makeBackendRequest(url: url, message: "fetching access code", completion: { str in
//                self.outputOnLabel(str: "Fetched access code: "+str)
//                self.chargeWithSDK(newCode: str as NSString)
//            })
//        }
    }
    
    func chargeWithSDK(newCode: NSString){
        let transactionParams = PSTCKTransactionParams.init();
        transactionParams.access_code = newCode as String;
//        transactionParams.amount = self.UInt(totalAmountIncludingShippingCharges)
        //transactionParams.additionalAPIParameters = ["enforce_otp": "true"];
//        transactionParams.email = "ibrahim@paystack.co";
//        transactionParams.amount = 2000;
//        let dictParams: NSMutableDictionary = [
//            "recurring": true
//        ];
//        let arrParams: NSMutableArray = [
//            "0","go"
//        ];
//        do {
//            try transactionParams.setMetadataValueDict(dictParams, forKey: "custom_filters");
//            try transactionParams.setMetadataValueArray(arrParams, forKey: "custom_array");
//        } catch {
//            print(error)
//        }
        // use library to create charge and get its reference
        PSTCKAPIClient.shared().chargeCard(self.cardDetailsForm.cardParams, forTransaction: transactionParams, on: self, didEndWithError: { (error, reference) in
            self.outputOnLabel(str: "Charge errored")
            // what should I do if an error occured?
            print(error)
            if error._code == PSTCKErrorCode.PSTCKExpiredAccessCodeError.rawValue{
                // access code could not be used
                // we may as well try afresh
            }
            if error._code == PSTCKErrorCode.PSTCKConflictError.rawValue{
                // another transaction is currently being
                // processed by the SDK... please wait
            }
            if let errorDict = (error._userInfo as! NSDictionary?){
                if let errorString = errorDict.value(forKeyPath: "com.paystack.lib:ErrorMessageKey") as! String? {
                    if let reference=reference {
                        self.showOkayableMessage("An error occured while completing "+reference, message: errorString)
                        self.outputOnLabel(str: reference + ": " + errorString)
                        self.verifyTransaction(reference: reference)
                    } else {
                        self.showOkayableMessage("An error occured", message: errorString)
                        self.outputOnLabel(str: errorString)
                    }
                }
            }
            self.chargeCardButton.isEnabled = true;
        }, didRequestValidation: { (reference) in
            self.outputOnLabel(str: "requested validation: " + reference)
        }, willPresentDialog: {
            // make sure dialog can show
            // if using a "processing" dialog, please hide it
            self.outputOnLabel(str: "will show a dialog")
        }, dismissedDialog: {
            // if using a processing dialog, please make it visible again
            self.outputOnLabel(str: "dismissed dialog")
        }) { (reference) in
            self.outputOnLabel(str: "succeeded: " + reference)
            self.chargeCardButton.isEnabled = true;
            self.verifyTransaction(reference: reference)
        }
        return
    }
    
//    func verifyTransaction(reference: String){
//        if let url = URL(string: backendURLString  + "/verify/" + reference) {
//            makeBackendRequest(url: url, message: "verifying " + reference, completion:{(str) -> Void in
//                self.outputOnLabel(str: "Message from paystack on verifying " + reference + ": " + str)
//            })
//        }
//    }
    
    func verifyTransaction(reference: String) {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = [:]
            
            let apiUrl = BASE_URL + PROJECT_URL.VERIFY_PAYMENT + "tx_ref=\(reference)" + "&transaction_id=abcdef" + "&cartId=\(UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.CART_ID) as! String)"
            let url : NSString = apiUrl as NSString
            let urlStr : NSString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! as NSString
            
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: urlStr as String, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    self.orderSuccessView.isHidden = false
                   // self.customAlertView.removeFromSuperview()
                    globalCartItemsArr.removeAllObjects()
                    UserDefaults.standard.set(0, forKey: "cartCount")
                    let cartCount = ["userInfo": ["cartCount": globalCartItemsArr.count]]
                    NotificationCenter.default.post(name: NSNotification.Name("updateCartBadge"), object: nil, userInfo: cartCount)
                }
                else {
                    UIAlertController.showInfoAlertWithTitle("Message", message: json["message"].stringValue, buttonTitle: "Okay")
                }
            }, errorBlock: { (NSError) in
                self.orderFailureView.isHidden = false
                UIAlertController.showInfoAlertWithTitle("Alert", message: kUnexpectedErrorAlertString, buttonTitle: "Okay")
                hideAllProgressOnView(appDelegateInstance.window!)
            })
            
        }else{
            hideAllProgressOnView(appDelegateInstance.window!)
            UIAlertController.showInfoAlertWithTitle("Alert", message: "Please Check internet connection", buttonTitle: "Okay")
        }
    }
    
    func makeBackendRequest(url: URL, message: String, completion: @escaping (_ result: String) -> Void){
        let session = URLSession(configuration: URLSessionConfiguration.default)
        self.outputOnLabel(str: "Backend: " + message)
        session.dataTask(with: url, completionHandler: { data, response, error in
            let successfulResponse = (response as? HTTPURLResponse)?.statusCode == 200
            if successfulResponse && error == nil && data != nil {
                if let str = NSString(data: data!, encoding: String.Encoding.utf8.rawValue){
                    completion(str as String)
                } else {
                    self.outputOnLabel(str: "<Unable to read response> while "+message)
                    print("<Unable to read response>")
                }
            } else {
                if let error = error {
                    print(error.localizedDescription)
                    self.outputOnLabel(str: error.localizedDescription)
                } else {
                    // There was no error returned though status code was not 200
                    print("There was an error communicating with your payment backend.")
                    self.outputOnLabel(str: "There was an error communicating with your payment backend while "+message)
                }
            }
        }).resume()
    }

}
