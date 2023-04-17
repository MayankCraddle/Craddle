//
//  ChooseCountryVC.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 08/08/22.
//

import UIKit

protocol ChooseCountryDelegate {
    func onSelectCountry(country: Select_Country_List_Struct, isFrom: String)
}

class ChooseCountryVC: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: ChooseCountryDelegate?
    var CountryList = [Select_Country_List_Struct]()
    var isFrom = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        searchBar.delegate = self
        searchBar.backgroundImage = UIImage()
        self.getCountryList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        self.navigationController?.navigationBar.isHidden = true
    }
    
    func getCountryList() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = [:]
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.VENDOR_COUNTY_LIST_COLOR_CODE, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                //success == "true"
                if success == "true"
                {
                    self.CountryList.removeAll()
                    for i in 0..<json["countryColorCodeList"].count
                    {
                        let countryName =  json["countryColorCodeList"][i]["countryName"].stringValue
                        let countryColor =  json["countryColorCodeList"][i]["colorCode"].stringValue
                        let flagName = json["countryColorCodeList"][i]["flag"].stringValue
                        let active = json["countryColorCodeList"][i]["active"].boolValue
                        
                        
                        self.CountryList.append(Select_Country_List_Struct.init(countryName: countryName, colorCode: countryColor, flagName: flagName, active: active))
                    }
                    self.CountryList.sort { $0.active && !$1.active}
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
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

    
}

extension ChooseCountryVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CountryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath) as! CountryCell
        let info = self.CountryList[indexPath.row]
        cell.cellLbl.text = info.countryName
        //var apiUrl = FLAG_BASE_URL + "/\(info.flagName)"
        cell.cellImg.sd_setImage(with: URL(string: FLAG_BASE_URL + "/\(info.flagName)"), completed: nil)
        
        cell.cellLbl.textColor = info.active ? .black : .lightGray
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let info = self.CountryList[indexPath.row]
        UserDefaults.standard.set(info.colorCode, forKey: USER_DEFAULTS_KEYS.COUNTRY_COLOR_CODE)
        UserDefaults.standard.set(info.countryName, forKey: USER_DEFAULTS_KEYS.SELECTED_COUNTRY)
        UserDefaults.standard.set(info.flagName, forKey: USER_DEFAULTS_KEYS.SELECTED_FLAG)
        
        countryColorCode = info.colorCode
        feedColor()
        country = info.countryName
        
        let countryColorStr = UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.COUNTRY_COLOR_CODE) as! String
        guard let rgba = countryColorStr.slice(from: "(", to: ")") else { return }
        let myStringArr = rgba.components(separatedBy: ",")
        countryColor = UIColor(red: CGFloat((myStringArr[0] as NSString).doubleValue/255.0), green: CGFloat((myStringArr[1] as NSString).doubleValue/255.0), blue: CGFloat((myStringArr[2] as NSString).doubleValue/255.0), alpha: CGFloat((myStringArr[3] as NSString).doubleValue))
        
        if info.active && (UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.IS_LOGIN) == nil){
            delegate?.onSelectCountry(country: info, isFrom: self.isFrom)
            self.dismiss(animated: true, completion: nil)
        } else if info.active && (UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.IS_LOGIN) != nil) {
            APP_DELEGATE.showBuyerHomeTab(self)
            UserDefaults.standard.set(nil, forKey: USER_DEFAULTS_KEYS.IS_LOGIN)
        } else {
            self.view.makeToast("We will be soon serving in \(country). Be in touch !")
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

extension ChooseCountryVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            self.getCountryList()
        } else {
            
            self.CountryList = self.CountryList.sorted(by: { (i1, i2) -> Bool in
                return i1.countryName.contains(searchText.capitalized)
            })
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        print("searchText \(searchText)")
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchText \(String(describing: searchBar.text))")
    }
}
