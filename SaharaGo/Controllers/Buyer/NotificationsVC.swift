//
//  NotificationsVC.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 24/02/23.
//

import UIKit

class NotificationsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var countryNameLbl: UILabel!
    @IBOutlet weak var flagImg: UIImageView!
    @IBOutlet weak var headerViewTwo: MyCustomHeaderView!
    @IBOutlet weak var headerViewOne: MyCustomHeaderView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var notificationsArr = [notification_Struct]()
    var pageNo = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        AnalyticsUtil.instance.trackEvent(AnalyticsEvents.kNotificationsScreen)
        self.tableView.delegate = nil
        self.tableView.dataSource = nil
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.navigationBar.isHidden = true
        if UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.VENDOR_SIGNUP_TOKEN) != nil {
            let flag = UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.SELECTED_FLAG) as! String
            let imageUrl = FLAG_BASE_URL + "/" + flag
            if let data = try? Data(contentsOf: URL(string: imageUrl)!) {
                    flagImg.image = UIImage(data: data)
                }
            
            guard let countryColorStr = UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.COUNTRY_COLOR_CODE) as? String else {return}
            guard let rgba = countryColorStr.slice(from: "(", to: ")") else { return }
            let myStringArr = rgba.components(separatedBy: ",")
            //        layer.cornerRadius = 6
            
            self.countryNameLbl.text = "\(UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.SELECTED_COUNTRY) as! String)"
            
            self.headerViewOne.backgroundColor = UIColor(red: CGFloat((myStringArr[0] as NSString).doubleValue/255.0), green: CGFloat((myStringArr[1] as NSString).doubleValue/255.0), blue: CGFloat((myStringArr[2] as NSString).doubleValue/255.0), alpha: CGFloat((myStringArr[3] as NSString).doubleValue))
            self.headerViewTwo.backgroundColor = UIColor(red: CGFloat((myStringArr[0] as NSString).doubleValue/255.0), green: CGFloat((myStringArr[1] as NSString).doubleValue/255.0), blue: CGFloat((myStringArr[2] as NSString).doubleValue/255.0), alpha: CGFloat((myStringArr[3] as NSString).doubleValue))
            
            self.getNotifications()
        } else {
            let vc = DIConfigurator.shared.getLoginVC()
            vc.sendTo = "Home"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.pageNo = 1
    }
    
    @IBAction func onClickBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onTapBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getNotifications() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = [:]
            let apiUrl = BASE_URL + PROJECT_URL.GET_NOTIFICATIONS + "?pageNumber=\(self.pageNo)" + "&limit=10"
            let url : NSString = apiUrl as NSString
            let urlStr : NSString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! as NSString
            
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: urlStr as String, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                //success == "true"
                if success == "true"
                {
                    if self.pageNo == 1 {
                        self.notificationsArr.removeAll()
                    }
                    let totalSize = json["totalCount"].intValue
                    for i in 0..<json["notificationList"].count {

                        let title = json["notificationList"][i]["title"].stringValue
                        let body = json["notificationList"][i]["body"].stringValue
                        let date = json["notificationList"][i]["date"].stringValue
                        
                        self.notificationsArr.append(notification_Struct.init(body: body, date: date, title: title, totalSize: totalSize))
                    }
                    
                    if self.notificationsArr.count > 0 {
                        self.emptyView.isHidden = true
                        self.tableView.isHidden = false
                        DispatchQueue.main.async {
                            self.tableView.delegate = self
                            self.tableView.dataSource = self
                            self.tableView.reloadData()
                        }
                        
                    } else {
                        self.emptyView.isHidden = false
                        self.tableView.isHidden = true
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return notificationsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationsCell", for: indexPath) as! NotificationsCell
        let info = self.notificationsArr[indexPath.row]
        cell.cellMainLbl.text = info.title
        cell.cellSubLbl.text = info.body
        cell.cellDateLbl.text = getFormattedDateStr(dateStr: info.date, dateFormat: "MMM dd, yyyy")
        
        if indexPath.row == self.notificationsArr.count - 1 { // last cell
            if info.totalSize > self.notificationsArr.count { // more items to fetch
                self.pageNo += 1
                self.getNotifications()
            }
        }
        
        return cell
    }

}
