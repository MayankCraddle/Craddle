//
//  ContentDetailVC.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 18/08/22.
//

import UIKit

class ContentDetailVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var flagImg: UIImageView!
    
    var contentDetailDic = contentDetailStruct()
    var id: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.getContentDetailById(self.id)
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickFlagSelection(_ sender: UIButton) {
    }
    
    func getContentDetailById(_ id: Int) {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = [:]
            
            let apiUrl = BASE_URL + PROJECT_URL.GET_CONTENT_DETAILS + "\(id)"
            let url : NSString = apiUrl as NSString
            let urlStr : NSString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! as NSString
            
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: urlStr as String, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    self.contentDetailDic = contentDetailStruct.init(sectionName: json["sectionName"].stringValue, country: json["country"].stringValue, featuredImage: json["featuredImage"].stringValue, body: json["body"].stringValue, subject: json["subject"].stringValue, author: json["author"].stringValue, files: json["files"].arrayObject!, id: json["id"].intValue)

                    DispatchQueue.main.async {
                        hideAllProgressOnView(appDelegateInstance.window!)
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

extension ContentDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContentDetailCell", for: indexPath) as! ContentDetailCell
        cell.cellImg.sd_setImage(with: URL(string: FILE_BASE_URL + self.contentDetailDic.featuredImage), placeholderImage: UIImage(named: "loading"))
        cell.cellImg.contentMode = .scaleAspectFill
        cell.cellLbl.text = self.contentDetailDic.body.html2String
        return cell
    }
    
    
}
