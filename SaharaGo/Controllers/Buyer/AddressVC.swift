//
//  AddressVC.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 05/09/22.
//

import UIKit

class AddressVC: UIViewController {
    
    var addressArr = [address_Struct]()
    

    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var addressTableView: UITableView!
    @IBOutlet weak var headerViewOne: MyCustomHeaderView!
    @IBOutlet weak var headerViewTwo: MyCustomHeaderView!
    
    var completionHandlerCallback:((address_Struct?) ->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let countryColorStr = UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.COUNTRY_COLOR_CODE) as? String else {return}
        guard let rgba = countryColorStr.slice(from: "(", to: ")") else { return }
        let myStringArr = rgba.components(separatedBy: ",")
        //        layer.cornerRadius = 6
        
        self.headerViewOne.backgroundColor = UIColor(red: CGFloat((myStringArr[0] as NSString).doubleValue/255.0), green: CGFloat((myStringArr[1] as NSString).doubleValue/255.0), blue: CGFloat((myStringArr[2] as NSString).doubleValue/255.0), alpha: CGFloat((myStringArr[3] as NSString).doubleValue))
        self.headerViewTwo.backgroundColor = UIColor(red: CGFloat((myStringArr[0] as NSString).doubleValue/255.0), green: CGFloat((myStringArr[1] as NSString).doubleValue/255.0), blue: CGFloat((myStringArr[2] as NSString).doubleValue/255.0), alpha: CGFloat((myStringArr[3] as NSString).doubleValue))
        
        self.getAddressAPI()
    }
    
    
    func getAddressAPI() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = [:]
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.USER_GET_ADDRESSES, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                //success == "true"
                if success == "true"
                {
                    self.addressArr.removeAll()
                    defaultAddressArr.removeAll()
                    for i in 0..<json["addressList"].count {
                        let firstName =  json["addressList"][i]["metaData"]["firstName"].stringValue
                        let lastName =  json["addressList"][i]["metaData"]["lastName"].stringValue
                        let phone =  json["addressList"][i]["metaData"]["phone"].stringValue
                        let streetAddress =  json["addressList"][i]["metaData"]["streetAddress"].stringValue
                        let landmark =  json["addressList"][i]["metaData"]["landmark"].stringValue
                        let city =  json["addressList"][i]["metaData"]["city"].stringValue
                        let state =  json["addressList"][i]["metaData"]["state"].stringValue
                        let zipcode =  json["addressList"][i]["metaData"]["zipcode"].stringValue
                        let phoneCode = json["addressList"][i]["metaData"]["phoneCode"].stringValue
                        let country =  json["addressList"][i]["metaData"]["country"].stringValue
                        let isDefault =  json["addressList"][i]["isDefault"].boolValue
                        let id =  json["addressList"][i]["id"].stringValue
                        let addressType =  json["addressList"][i]["metaData"]["addressType"].stringValue
                        
                        if isDefault {
                            defaultAddressArr.append(address_Struct.init(id: id, firstName: firstName, lastName: lastName, phone: phone, streetAddress: streetAddress, country: country, state: state, city: city, zipcode: zipcode, landmark: landmark, isDefault: isDefault, addressType: addressType, phoneCode: phoneCode))
                        }
                        self.addressArr.append(address_Struct.init(id: id, firstName: firstName, lastName: lastName, phone: phone, streetAddress: streetAddress, country: country, state: state, city: city, zipcode: zipcode, landmark: landmark, isDefault: isDefault, addressType: addressType, phoneCode: phoneCode))
                        
                    }
                    
                    if self.addressArr.count > 0 {
                        self.addressTableView.isHidden = false
                        self.emptyView.isHidden = true
                    } else {
                        self.addressTableView.isHidden = true
                        self.emptyView.isHidden = false
                    }
                    
                    DispatchQueue.main.async {
                        self.addressTableView.reloadData()
                    }
                    
                } else {
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

    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cellDeleteAction(_ sender: UIButton) {
        
        let indexPath: IndexPath? = self.addressTableView.indexPathForRow(at: sender.convert(CGPoint.zero, to: self.addressTableView))
        var info = address_Struct()
        info = self.addressArr[indexPath!.row]
        
        let alert = UIAlertController(title: "Title", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Make Default", style: .default , handler:{ (UIAlertAction)in
            self.defaultAddressAPI(info.id)
        }))
        
        alert.addAction(UIAlertAction(title: "Edit", style: .default , handler:{ (UIAlertAction)in
            let addAddressVC = DIConfigurator.shared.getAddAddressVC()
            addAddressVC.addressInfo = info
            addAddressVC.isEdit = true
            self.navigationController?.pushViewController(addAddressVC, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive , handler:{ (UIAlertAction)in
            self.showAlertWithActions("Are you sure you want to delete this address ?", titles: ["Yes", "No"]) { (value) in
                if value == 1{
                    
                    
            //        if indexPath?.section == 0 {
            //            info = self.defaultAddressArr[indexPath!.row]
            //        } else {
            //            info = self.addressArr[indexPath!.row]
            //        }
                    self.deleteAddressAPI(info.id, rowId: indexPath!.row)

                }
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
        
    }
    
    @IBAction func addAddressAction(_ sender: UIButton) {
        let addAddressVC = DIConfigurator.shared.getAddAddressVC()
        self.navigationController?.pushViewController(addAddressVC, animated: true)
    }
    
    func deleteAddressAPI(_ id: String, rowId: Int) {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let fullUrl = BASE_URL + PROJECT_URL.USER_DELETE_ADDRESS + id
            let param:[String:String] = [:]
            
            ServerClass.sharedInstance.deleteRequestWithUrlParameters(param, path: fullUrl, successBlock: {  (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                
                if success  == "true"
                {
                    self.view.makeToast(json["message"].stringValue)
                    self.getAddressAPI()
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
    
    func defaultAddressAPI(_ id: String) {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:Any] = [:]
            
            var apiUrl = BASE_URL + PROJECT_URL.USER_MARK_DEFAULT_ADDRESS
            apiUrl = apiUrl + "\(id)"
            
            ServerClass.sharedInstance.putRequestWithUrlParameters(param, path: apiUrl, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                
                if success == "true"
                {
                    
                    self.view.makeToast(json["message"].stringValue)
                    self.getAddressAPI()
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                        self.navigationController?.popViewController(animated: true)
//                    }
                    
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
    
}

extension AddressVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
//        return 110
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.addressArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressCell", for: indexPath) as! AddressCell
        let info = self.addressArr[indexPath.row]
        cell.cellTitleLbl.text = "\(info.firstName) \(info.lastName)"
        cell.cellSubTitleLbl.text = "\(info.streetAddress),\nMobile: \(info.phone), \n\(info.state), \(info.city),\n\(info.country)"
        cell.addressTypeLbl.text = info.addressType
        cell.defaultImg.isHidden = !info.isDefault
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.completionHandlerCallback != nil {
            self.completionHandlerCallback!(self.addressArr[indexPath.row])
            self.navigationController?.popViewController(animated: true)
        }
    }
}
