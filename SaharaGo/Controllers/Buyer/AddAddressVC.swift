//
//  AddAddressVC.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 05/09/22.
//

import UIKit
import CountryPickerView
import GooglePlaces

class AddAddressVC: UIViewController, UITextFieldDelegate {

    var finalItemDic: NSMutableDictionary = NSMutableDictionary()
    var addressType = ""
    var addressInfo = address_Struct()
    var countryPickerView: CountryPickerView?
    var phoneCode = ""
    var isEdit = false
//    var paramsDic:NSMutableDictionary = NSMutableDictionary()
    var completionHandlerCallback:((address_Struct?) ->Void)?
    var isFrom = ""
    var oyoCodeArr = ["200251","200281","200213","200235","200285","200222","200224","200244","200262","200232","200263","200254","200231","200225","200001","200284","200283","200223","200261","200272","200241","200255","200002","200273","200221","200242","200258","200252","200212","200243","200256","200234","200257","200233","200253","200271","200282","200214","200009","200005","200211","440001","440002","440003","440004","440005","440006","440007","440008","440009","440010","440112","440014","440015","440021","441002","441008","441010","441011","441012","441013","442001","442002","442003","443001","443003","443004","443005","450001","450002","450003","451001","451002","451003","451004","452001","100001","100002","100003","100005","100006","100007","100009","100011","100013","100014","100015","100211","100212","100213","100215","100216","100217","100221","100222","100223","100224","100225","100226","100227","100231","100232","100233","100234","100235","100241","100242","100243","100244","100245","100246","100247","100248","100252","100253","100254","100261","100262","100263","100264","100266","100271","100272","100273","100275","100278","100281","100282","100283","100285","101001","101003","101004","101005","101006","101010","101012","101013","101014","101015","101016","101017","101018","101211","101212","101213","101221","101223","101224","101229","101231","101232","101233","101241","101243","101245","101251","101252","101253","101254","101255","101271","101281","101282","101283","102001","102003","102004","102101","102102","102103","102104","102105","102106","102107","102108","102109","102101","102102","102103","102104","102105","102106","102107","102108","102109","102110","102111","102112","102113","102114","102211","102212","102213","102214","102215","102216","102224","102231","102232","102241","102262","102263","102264","102265","102265","102271","102272","102273","102311","102312","102313","102314","102341","103001","103101","104001","104002","104101","104102","104225","105102","106104","110102","110222","112005","112105","112107","919080"]

    
    @IBOutlet weak var mailTxt: UITextField!
    @IBOutlet weak var txtCountryCode: UITextField!
    @IBOutlet weak var headerViewTwo: MyCustomHeaderView!
    @IBOutlet weak var headerViewOne: MyCustomHeaderView!
    @IBOutlet var countryTxt: UITextField!
    @IBOutlet var zipcodeTxt: UITextField!
    @IBOutlet var stateTxt: UITextField!
    @IBOutlet var cityTxt: UITextField!
    @IBOutlet var landmarkTxt: UITextField!
    @IBOutlet var addressTxt: UITextField!
    @IBOutlet var mobileTxt: UITextField!
    @IBOutlet var lastNameTxt: UITextField!
    @IBOutlet var firstNameTxt: UITextField!
    @IBOutlet weak var homeBtn: UIButton!
    @IBOutlet weak var workBtn: UIButton!
    
    @IBOutlet weak var homeView: UIView!
    @IBOutlet weak var officeImg: UIImageView!
    @IBOutlet weak var homeImg: UIImageView!
    @IBOutlet weak var workView: UIView!
    @IBOutlet weak var saveBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        countryTxt.delegate = self
        txtCountryCode.delegate = self
        addressTxt.delegate = self
        configCountryCodePicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.firstNameTxt.text = self.addressInfo.firstName
        self.lastNameTxt.text = self.addressInfo.lastName
        self.mobileTxt.text = self.addressInfo.phone
        self.addressTxt.text = self.addressInfo.streetAddress
        self.landmarkTxt.text = self.addressInfo.landmark
        self.cityTxt.text = self.addressInfo.city
        self.stateTxt.text = self.addressInfo.state
        self.zipcodeTxt.text = self.addressInfo.zipcode
        self.countryTxt.text = self.addressInfo.country == "" ? "Nigeria" : self.addressInfo.country
        self.txtCountryCode.text = self.addressInfo.phoneCode
        self.phoneCode = self.addressInfo.phoneCode
        if self.addressInfo.addressType == "home" {
            self.activateHome()
        } else if self.addressInfo.addressType == "work" {
            self.activateWork()
        }
        if UserDefaults.standard.value(forKey: "isEmailSaved") as! String == "yes" {
            let UDEmail = UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.LOGIN_EMAIL) as! String
            self.mailTxt.text = UDEmail
            self.mailTxt.isUserInteractionEnabled = false
        } else {
            self.mailTxt.isUserInteractionEnabled = true
        }
        self.saveBtn.setTitle(isEdit ? "Update Address" : "Add New Address", for: .normal)
        guard let countryColorStr = UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.COUNTRY_COLOR_CODE) as? String else {return}
        guard let rgba = countryColorStr.slice(from: "(", to: ")") else { return }
        let myStringArr = rgba.components(separatedBy: ",")
        //        layer.cornerRadius = 6
        
        self.headerViewOne.backgroundColor = UIColor(red: CGFloat((myStringArr[0] as NSString).doubleValue/255.0), green: CGFloat((myStringArr[1] as NSString).doubleValue/255.0), blue: CGFloat((myStringArr[2] as NSString).doubleValue/255.0), alpha: CGFloat((myStringArr[3] as NSString).doubleValue))
        self.headerViewTwo.backgroundColor = UIColor(red: CGFloat((myStringArr[0] as NSString).doubleValue/255.0), green: CGFloat((myStringArr[1] as NSString).doubleValue/255.0), blue: CGFloat((myStringArr[2] as NSString).doubleValue/255.0), alpha: CGFloat((myStringArr[3] as NSString).doubleValue))
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func configCountryCodePicker(){
        self.countryPickerView = CountryPickerView()
        self.countryPickerView?.delegate = self
        self.countryPickerView?.dataSource = self
        
        let locale = Locale.current
        let code = ((locale as NSLocale).object(forKey: NSLocale.Key.countryCode) as! String?)!
        self.countryPickerView?.setCountryByCode(code)
    }
    
    func addAddressAPI() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:Any] = [ "metaData": self.finalItemDic]
            print(self.finalItemDic)
            ServerClass.sharedInstance.postRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.USER_ADD_ADDRESS, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    AnalyticsUtil.instance.trackEvent(AnalyticsEvents.kAddressAdded)
                    //save data in userdefault..
                    self.view.makeToast("Address saved Successfully.")
                    UserDefaults.standard.set(self.mailTxt.text!, forKey: USER_DEFAULTS_KEYS.LOGIN_EMAIL)
                    UserDefaults.standard.set("yes", forKey: "isEmailSaved")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.navigationController?.popViewController(animated: true)
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
    
    func updateAddressAPI() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
              
//            self.paramsDic.setValue(self.firstNameTxt.text!, forKey: "firstName")
//            self.paramsDic.setValue(self.lastNameTxt.text!, forKey: "lastName")
//            self.paramsDic.setValue(self.mobileTxt.text!, forKey: "phone")
//            self.paramsDic.setValue(self.addressTxt.text!, forKey: "streetAddress")
//            self.paramsDic.setValue(self.countryTxt.text!, forKey: "country")
//            self.paramsDic.setValue(self.stateTxt.text!, forKey: "state")
//            self.paramsDic.setValue(self.cityTxt.text!, forKey: "city")
//            self.paramsDic.setValue(self.zipcodeTxt.text!, forKey: "zipcode")
//            self.paramsDic.setValue(self.landmarkTxt.text!, forKey: "landmark")
//            self.paramsDic.setValue(self.addressType, forKey: "addressType")
            
            let param:[String:Any] = [ "metaData": self.finalItemDic]
            
            var apiUrl = BASE_URL + PROJECT_URL.USER_UPDATE_ADDRESS
            apiUrl = apiUrl + "\(self.addressInfo.id)"
            
            ServerClass.sharedInstance.putRequestWithUrlParameters(param, path: apiUrl, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                
                if success == "true"
                {
                    AnalyticsUtil.instance.trackEvent(AnalyticsEvents.kAddressUpdated)
                    self.view.makeToast(json["message"].stringValue)
                    UserDefaults.standard.set(self.mailTxt.text!, forKey: USER_DEFAULTS_KEYS.LOGIN_EMAIL)
                    UserDefaults.standard.set("yes", forKey: "isEmailSaved")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.navigationController?.popViewController(animated: true)
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
    
    @IBAction func onClickAddressType(_ sender: UIButton) {
        
        if sender.tag == 101 {
            self.addressType = "Home"
            activateHome()
        } else {
            self.addressType = "Work"
            activateWork()
        }
    }
    
    func activateHome() {
        self.homeImg.image = UIImage(named: "Home_select")
        self.homeView.borderColor = UIColor(red: 0/255.0, green: 125/255.0, blue: 67/255.0, alpha: 1.0)
        self.workView.borderColor = .lightGray
        self.officeImg.image = UIImage(named: "office")
        self.addressType = "home"
    }
    
    func activateWork() {
        self.officeImg.image = UIImage(named: "office_active")
        self.workView.borderColor = UIColor(red: 0/255.0, green: 125/255.0, blue: 67/255.0, alpha: 1.0)
        self.homeView.borderColor = .lightGray
        self.homeImg.image = UIImage(named: "home")
        self.addressType = "work"
    }
    
    
    @IBAction func saveAction(_ sender: UIButton) {
        if self.firstNameTxt.text!.isEmpty {
            self.view.makeToast("Please enter First Name.")
            return
        } else if self.lastNameTxt.text!.isEmpty {
            self.view.makeToast("Please enter Last Name.")
            return
        } else if self.mailTxt.text!.isEmpty {
            self.view.makeToast("Please enter Email.")
            return
        } else if self.mobileTxt.text!.isEmpty {
            self.view.makeToast("Please enter Mobile.")
            return
        } else if self.mobileTxt.text!.count > 11 {
            self.view.makeToast("Please enter correct Mobile No.")
            return
        } else if self.addressTxt.text!.isEmpty {
            self.view.makeToast("Please enter Street Address.")
            return
        } else if self.cityTxt.text!.isEmpty {
            self.view.makeToast("Please enter City.")
            return
        } else if self.stateTxt.text!.isEmpty {
            self.view.makeToast("Please enter State.")
            return
        } else if self.countryTxt.text!.isEmpty {
            self.view.makeToast("Please enter Country.")
            return
        } else if self.addressType == "" {
            self.view.makeToast("Please select Address Type.")
            return
        }
//        else if !checkZipCode() {
//           self.view.makeToast("Service not available at \(self.zipcodeTxt.text!).")
//           return
//       }
        self.finalItemDic.setValue(self.firstNameTxt.text!, forKey: "firstName")
        self.finalItemDic.setValue(self.lastNameTxt.text!, forKey: "lastName")
        self.finalItemDic.setValue(self.mobileTxt.text!, forKey: "phone")
        self.finalItemDic.setValue(self.addressTxt.text!, forKey: "streetAddress")
        self.finalItemDic.setValue(self.countryTxt.text!, forKey: "country")
        self.finalItemDic.setValue(self.stateTxt.text!, forKey: "state")
        self.finalItemDic.setValue(self.cityTxt.text!, forKey: "city")
        self.finalItemDic.setValue(self.zipcodeTxt.text!, forKey: "zipcode")
        self.finalItemDic.setValue(self.landmarkTxt.text!, forKey: "landmark")
        self.finalItemDic.setValue(self.addressType, forKey: "addressType")
        self.finalItemDic.setValue(self.phoneCode, forKey: "phoneCode")
        self.finalItemDic.setValue(self.mailTxt.text!, forKey: "email")

        isEdit ? self.updateAddressAPI() : self.addAddressAPI()
        
    }
    
    func checkZipCode() -> Bool {
        var contains = false
        if self.oyoCodeArr.contains(self.zipcodeTxt.text!) {
            contains = true
        }
        return contains
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == countryTxt {
            self.isFrom = "CountryName"
            self.countryPickerView?.showCountriesList(from: self)
            return false
        } else if textField == txtCountryCode {
            self.isFrom = "CountryCode"
            self.countryPickerView?.showCountriesList(from: self)
            return false
        } else if textField == addressTxt {
            // Present the Autocomplete view controller when the button is pressed.
            
            let autocompleteController = GMSAutocompleteViewController()
            autocompleteController.delegate = self
            
            // Specify the place data types to return.
            let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt64(UInt(GMSPlaceField.name.rawValue) |
                                                                       UInt(GMSPlaceField.placeID.rawValue)))
            autocompleteController.placeFields = fields
            
            // Specify a filter.
            let filter = GMSAutocompleteFilter()
            filter.type = .address
            filter.country = "NG"
            autocompleteController.autocompleteFilter = filter
            
            // Display the autocomplete view controller.
            present(autocompleteController, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    @IBAction func onClickChooseState(_ sender: UIButton) {
        
        let sellerStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = sellerStoryboard.instantiateViewController(withIdentifier: "showListVC") as! showListVC
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func onClickChooseCity(_ sender: UIButton) {
        if self.stateTxt.text!.isEmpty {
            self.view.makeToast("Please select your State first.")
            return
        }
       
        let sellerStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = sellerStoryboard.instantiateViewController(withIdentifier: "showListVC") as! showListVC
        vc.isFrom = "City"
        vc.state = self.stateTxt.text!
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    
}

extension AddAddressVC: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
//        print("Place name: \(place.name)")
//        print("Place ID: \(place.placeID)")
//        print("Place attributions: \(place.attributions)")
//        print("Place coordinates:\(place.coordinate)")
        self.addressTxt.text = place.name
//        lat = String(place.coordinate.latitude)
//        long = String(place.coordinate.longitude)
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}

//MARK:- CountryPickerDelegate
extension AddAddressVC: CountryPickerViewDelegate, CountryPickerViewDataSource{
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        if self.isFrom == "CountryName" {
            self.countryTxt.text = country.name
            self.phoneCode = country.phoneCode
        } else if self.isFrom == "CountryCode" {
            self.txtCountryCode.text = country.phoneCode
            self.phoneCode = country.phoneCode
        }
        
        
    }
    
    func navigationTitle(in countryPickerView: CountryPickerView) -> String? {
        return "Select your country"
    }
    
}

extension AddAddressVC: ChooseListNamesDelegate{
    func onSelectListNames(country: String, isFrom: String) {
        if isFrom == "City" {
            self.cityTxt.text = country
        } else {
            self.stateTxt.text = country
            self.cityTxt.text = ""
        }
    }
    
    
}
