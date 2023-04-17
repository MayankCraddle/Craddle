//
//  ViewCommentsVC.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 01/11/22.
//

import UIKit

class ViewCommentsVC: UIViewController {

    @IBOutlet weak var textboxView: UIView!
    @IBOutlet weak var subjectLbl: UILabel!
    @IBOutlet weak var commentsTableView: UITableView!
    @IBOutlet weak var commentTxtView: UITextView!
    
    var commentArr = [commentStruct]()
    var blogId: Int = 0
    var shortDesc = ""
    
    var isFromProduct = false
    var itemId: String = ""
    var isFrom: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.subjectLbl.text = self.shortDesc
        self.commentTxtView.placeholder = "Type your comment"
        if isFromProduct {
//            self.getCommentsAPI(itemId, limit: 100)
            self.getRatings(itemId)
        } else {
            self.getCommentsAPI(String(self.blogId), limit: 100)
        }
        
        if self.isFrom == "Multimedia" {
            self.textboxView.isHidden = false
        }
        
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func getCommentsAPI(_ id: String, limit: Int) {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = [:]
            
            let apiUrl = BASE_URL + PROJECT_URL.GET_COMMENTS + "\(id)" + "?pageNumber=\(1)" + "&limit=\(limit)"
            let url : NSString = apiUrl as NSString
            let urlStr : NSString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! as NSString
            
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: urlStr as String, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    self.commentArr.removeAll()
                    for i in 0..<json["comments"].count {
                        let comment = json["comments"][i]["comment"].stringValue
                        let createdOn = json["comments"][i]["createdOn"].stringValue
                        let image = json["comments"][i]["image"].stringValue
                        let createdBy = json["comments"][i]["createdBy"].stringValue
                        
                        self.commentArr.append(commentStruct.init(createdBy: createdBy, createdOn: createdOn, comment: comment, image: image))
                    }

                    DispatchQueue.main.async {
                        hideAllProgressOnView(appDelegateInstance.window!)
                        if self.commentArr.count > 0 {
                            self.commentsTableView.isHidden = false
                            self.commentsTableView.delegate = self
                            self.commentsTableView.dataSource = self
                            self.commentsTableView.reloadData()
                        } else {
                            self.commentsTableView.isHidden = true
                        }
                        
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
    
    func postCommentAPI(_ id: String, comment: String) {
        
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:Any] = [ "id": id,"comment": comment]
            ServerClass.sharedInstance.postRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.ADD_COMMENT, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    self.view.resignFirstResponder()
                    self.view.makeToast("Comment added successfully.")
                    if self.isFromProduct {
                        self.getCommentsAPI(self.itemId, limit: 100)
                    } else {
                        self.getCommentsAPI(String(self.blogId), limit: 100)
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
    
    func getRatings(_ id: String) {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = [:]
            
            let apiUrl = BASE_URL + PROJECT_URL.USER_GET_RATING_DETAILS + id
            let url : NSString = apiUrl as NSString
            let urlStr : NSString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! as NSString
            
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: urlStr as String, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    
                    self.commentArr.removeAll()
                    for i in 0..<json["ratingList"].count {
                        let comment = json["ratingList"][i]["review"].stringValue
                        let createdOn = json["ratingList"][i]["date"].stringValue
                        let image = json["ratingList"][i]["image"].stringValue
                        let createdBy = json["ratingList"][i]["title"].stringValue
                        let rating = json["ratingList"][i]["rating"].doubleValue
                        let id = json["ratingList"][i]["id"].intValue
                        
                        self.commentArr.append(commentStruct.init(createdBy: createdBy, createdOn: createdOn, comment: comment, image: image, rating: rating, id: id))
                    }
                    
                    
                    
                    DispatchQueue.main.async {
                        hideAllProgressOnView(appDelegateInstance.window!)
                        if self.commentArr.count > 0 {
                            self.commentsTableView.isHidden = false
                            self.commentsTableView.delegate = self
                            self.commentsTableView.dataSource = self
                            self.commentsTableView.reloadData()
                        } else {
                            self.commentsTableView.isHidden = true
                        }
                        
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
    
//    func giveRatingAPI() {
//        if Reachability.isConnectedToNetwork() {
//            showProgressOnView(appDelegateInstance.window!)
//            if let objFcmKey = UserDefaults.standard.object(forKey: "fcm_key") as? String
//            {
//                fcmKey = objFcmKey
//            }
//            else
//            {
//                //                fcmKey = ""
//                fcmKey = "abcdef"
//            }
//            
//            let param:[String:Any] = [ "fromId": self.mailtxt.text!,"toId":self.passwordTxt.text!, "rating": fcmKey,"review":"iOS"]
//            ServerClass.sharedInstance.postRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.VENDOR_LOGIN_API, successBlock: { (json) in
//                print(json)
//                hideAllProgressOnView(appDelegateInstance.window!)
//                let success = json["success"].stringValue
//                if success == "true"
//                {
//                    //save data in userdefault..
//                    UserDefaults.standard.setValue(json["token"].stringValue, forKey: USER_DEFAULTS_KEYS.VENDOR_SIGNUP_TOKEN)
//                    UserDefaults.standard.setValue(json["type"].stringValue, forKey: USER_DEFAULTS_KEYS.USER_TYPE)
//                    APP_DELEGATE.showSellerHomeTab(self)
//                    
//                }
//                else {
//                    self.view.makeToast("\(json["message"].stringValue)")
//                    //UIAlertController.showInfoAlertWithTitle("Message", message: json["message"].stringValue, buttonTitle: "Okay")
//                }
//            }, errorBlock: { (NSError) in
//                UIAlertController.showInfoAlertWithTitle("Alert", message: kUnexpectedErrorAlertString, buttonTitle: "Okay")
//                hideAllProgressOnView(appDelegateInstance.window!)
//            })
//            
//        }else{
//            hideAllProgressOnView(appDelegateInstance.window!)
//            UIAlertController.showInfoAlertWithTitle("Alert", message: "Please Check internet connection", buttonTitle: "Okay")
//        }
//    }

    @IBAction func onClickSendComment(_ sender: UIButton) {
        if self.commentTxtView.text == "" {
            self.view.makeToast("Please write your comment.")
        } else {
            self.postCommentAPI("\(self.blogId)", comment: self.commentTxtView.text)
            
            DispatchQueue.main.async {
                self.commentTxtView.text = ""
            }
        }
    }
    

}

extension ViewCommentsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.commentArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentsTableCell", for: indexPath) as! commentsTableCell
        
        let info = self.commentArr[indexPath.row]
        cell.cellMainLbl.text = info.createdBy
//        cell.cellDateLbl.text = info.createdOn
        cell.cellSubLbl.text = info.comment
        cell.cellDateLbl.text = getFormattedDateStr(dateStr: info.createdOn, dateFormat: "MMM dd, yyyy h:mm a")
//        if info.createdOn != nil {
//        let timeStamp = Date(timeIntervalSince1970: TimeInterval(info.createdOn)! / 1000)
//            cell.cellDateLbl.text = timeStamp.convertTimeInterval(format: "MMM d, yyyy")
////        self.lblTime.text = timeStamp.convertTimeInterval()
////        self.lblDate.text = timeStamp.convertTimeInterval(format: "MMM d, yyyy")
//        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        self.commentTblHeight.constant = commentTableView.contentSize.height
//    }
}
