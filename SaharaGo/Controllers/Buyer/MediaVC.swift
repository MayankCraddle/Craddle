//
//  MediaVC.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 05/09/22.
//

import UIKit

class MediaVC: UIViewController {
    
    var homeSectionList = [homeSectionDataStruct]()
    var contentList = [contentStruct]()
//    var colourSetArr = []()
    
    @IBOutlet weak var mediaContentTableView: UITableView!
    @IBOutlet weak var mediaCatCollView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.getContentWithSection(UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.SELECTED_COUNTRY) as! String)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getContentWithSection(_ country: String) {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = [:]
            
            let apiUrl = BASE_URL + PROJECT_URL.GET_CONTENT_WITH_SECTIONS + "?country=\(country)"
            let url : NSString = apiUrl as NSString
            let urlStr : NSString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! as NSString
            
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: urlStr as String, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    self.homeSectionList.removeAll()
                    for (key,value) in json["detail"] {
                        print("\(key) = \(value)")
                        self.contentList.removeAll()
                        for i in 0..<value["content"].count {
                            self.contentList.append(contentStruct.init(createdOn: value["content"][i]["createdOn"].stringValue, country: value["content"][i]["country"].stringValue, shortDescription: value["content"][i]["shortDescription"].stringValue, body: value["content"][i]["body"].stringValue, subject: value["content"][i]["subject"].stringValue, type: value["content"][i]["type"].stringValue, files: value["content"][i]["files"].arrayObject!, id: value["content"][i]["id"].intValue))
                        }
                        self.homeSectionList.append(homeSectionDataStruct.init(sectionName: "\(key)", content: self.contentList, priority: value["priority"].intValue, sectionId: value["sectionId"].intValue))
                        
                    }
                    
                    self.homeSectionList = self.homeSectionList.sorted(by: { $0.priority < $1.priority })
                    
                    DispatchQueue.main.async {
                        self.mediaCatCollView.delegate = self
                        self.mediaCatCollView.dataSource = self
                        self.mediaCatCollView.reloadData()
                        
                        self.mediaContentTableView.delegate = self
                        self.mediaContentTableView.dataSource = self
                        self.mediaContentTableView.reloadData()
                        
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

extension MediaVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.homeSectionList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MediaCategoryCell", for: indexPath) as! MediaCategoryCell
        
        cell.cellLbl.text = self.homeSectionList[indexPath.row].sectionName
//        cell.cellLbl.font = UIFont(name: "Poppins-SemiBold", size: 13)
        cell.cellView.roundCorners(corners: [.topLeft, .topRight], cornerRadius: 10)
        
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        
        let collectionWidth = collectionView.bounds.width
        //          return CGSize(width: collectionWidth / 2 - 10, height: collectionWidth / 2 + 80)
        return CGSize(width: collectionWidth / 3, height: collectionView.bounds.height - 10)
        
    }
    
}

extension MediaVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.homeSectionList.count > 0 {
            return self.homeSectionList[0].content.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MediaContentCell", for: indexPath) as! MediaContentCell
        
        let info = self.homeSectionList[0].content[indexPath.row]
        
        cell.cellTitleLbl.text = info.subject
        cell.cellSubTitleLbl.text = info.shortDescription
        //        cell.cellTitleLbl.font = UIFont(name: "Poppins-SemiBold", size: 11)
        let imageArr = info.files
        cell.cellImg.sd_setImage(with: URL(string: FILE_BASE_URL + "\(imageArr[0])"), placeholderImage: UIImage(named: "loading"))
        
        return cell
    }
    
}
