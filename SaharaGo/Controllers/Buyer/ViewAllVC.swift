//
//  ViewAllVC.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 26/08/22.
//

import UIKit

class ViewAllVC: UIViewController {
    
    var sectioId = 0
    var contentList = [contentStruct]()
    var isFromHome = false
    
    @IBOutlet weak var headerViewTwo: MyCustomHeaderView!
    @IBOutlet weak var headerViewOne: MyCustomHeaderView!
    @IBOutlet weak var mediaTableView: UITableView!
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var headerTxt: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.getContentWithSectionId(self.isFromHome ? "" : UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.SELECTED_COUNTRY) as? String ?? "", id: self.sectioId, searchText: "", pageNo: 1, limit: 10)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
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
    
    func getContentWithSectionId(_ country: String, id: Int, searchText: String, pageNo: Int, limit: Int) {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = [:]
            
            let apiUrl = BASE_URL + PROJECT_URL.GET_CONTENT_WITH_SECTION_ID + "\(self.sectioId)" + "/\(pageNo)" + "/\(limit)" + "?searchText=\(searchText)" + "&country=\(country)"
            let url : NSString = apiUrl as NSString
            let urlStr : NSString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! as NSString
            
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: urlStr as String, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    self.contentList.removeAll()
                    for i in 0..<json["contentList"].count {
                        self.contentList.append(contentStruct.init(createdOn: json["contentList"][i]["createdOn"].stringValue, country: json["contentList"][i]["country"].stringValue, shortDescription: json["contentList"][i]["shortDescription"].stringValue, body: json["contentList"][i]["body"].stringValue, subject: json["contentList"][i]["subject"].stringValue, type: json["contentList"][i]["type"].stringValue, files: json["contentList"][i]["files"].arrayObject!, id: json["contentList"][i]["id"].intValue, sectionName: json["sectionName"].stringValue))
                    }
                    
                    DispatchQueue.main.async {
                        if self.contentList.count > 0 {
                            self.headerTxt.text = self.contentList[0].sectionName
                        }
                        self.mediaTableView.delegate = self
                        self.mediaTableView.dataSource = self
                        self.mediaTableView.reloadData()
                        hideAllProgressOnView(appDelegateInstance.window!)
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

}

extension ViewAllVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.contentList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ViewAllCollCell", for: indexPath) as? ViewAllCollCell else {
            return UICollectionViewCell()
        }
        
        let info = self.contentList[indexPath.row]
        let imageArr = self.contentList[indexPath.row].files
        
        if imageArr.count > 0 {
            cell.cellImg.sd_setImage(with: URL(string: FILE_BASE_URL + "\(imageArr[0])"), placeholderImage: UIImage(named: "loading"))
        }
        
        cell.cellTitleLbl.text = self.contentList[indexPath.row].subject
        
        cell.cellSubTitleLbl.text = info.shortDescription
        cell.cellDateLbl.text = info.createdOn
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewAllVC = DIConfigurator.shared.getContentDetailVC()
        viewAllVC.blogId = self.contentList[indexPath.row].id
        viewAllVC.sectionId = "\(self.sectioId)"
        viewAllVC.isFromHome = self.isFromHome
        self.navigationController?.pushViewController(viewAllVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = collectionView.bounds.width
        //        return CGSize(width: (UIScreen.main.bounds.size.width - 30) / 2.0, height: (UIScreen.main.bounds.size.height))
        return CGSize(width: ((collectionWidth - 45)/2), height: 270)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    
}

extension ViewAllVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MediaContentCell", for: indexPath) as! MediaContentCell
        
        let info = self.contentList[indexPath.row]
        
        cell.cellTitleLbl.text = info.subject
        cell.cellSubTitleLbl.text = info.shortDescription
        let imageArr = info.files
        if imageArr.count > 0 {
            cell.cellImg.sd_setImage(with: URL(string: FILE_BASE_URL + "\(imageArr[0])"), placeholderImage: UIImage(named: "loading"))
        }
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewAllVC = DIConfigurator.shared.getContentDetailVC()
        viewAllVC.blogId = self.contentList[indexPath.row].id
        viewAllVC.sectionId = "\(self.sectioId)"
        viewAllVC.isFromHome = self.isFromHome
        self.navigationController?.pushViewController(viewAllVC, animated: true)
    }
    
    
}
