//
//  BlogDetailVC.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 22/09/22.
//

import UIKit
import FacebookShare
import FacebookCore
import FBSDKShareKit
import youtube_ios_player_helper
import Social

class BlogDetailVC: UIViewController, UIScrollViewDelegate, UITextViewDelegate, YTPlayerViewDelegate {
    
    @IBOutlet weak var sectionNameLbl: UILabel!
    @IBOutlet weak var commentFooterView: UIView!
    @IBOutlet weak var blogCollView: UICollectionView!
    @IBOutlet weak var commentCountLbl: UILabel!
    @IBOutlet weak var commentTextViewHeight: NSLayoutConstraint!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var fullArticleUrlLbl: UILabel!
    @IBOutlet weak var headerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var commentTblHeight: NSLayoutConstraint!
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var subjectLbl: UILabel!
    @IBOutlet weak var longDescriptionLbl: UILabel!
    @IBOutlet weak var shortDescriptionLbl: UILabel!
    @IBOutlet weak var postedDateLbl: UILabel!
    @IBOutlet weak var readCountLbl: UILabel!
    @IBOutlet weak var postedByLbl: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var blogView: UIView!
    
    @IBOutlet weak var viewAllCommentsBtn: UIButton!
    
    var contentDetailDic = contentDetailStruct()
    var blogId: Int = 0
    var commentArr = [commentStruct]()
    var isCommentViewOpened = false
    let maxLength = 150
    var activityViewController:UIActivityViewController?
    var sectionId = ""
    var mediaContentList = [mediaContentListStruct]()
    var filesArr = [Any]()
    var isFromHome = false
    
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var viewCountLbl: UILabel!
    var timer : Timer?
    var imageWithBaseUrl = [URL]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        AnalyticsUtil.instance.trackEvent(AnalyticsEvents.kBlogDetailScreen)
        self.collView.register(UINib(nibName: "VideoCollCell", bundle: nil), forCellWithReuseIdentifier: "VideoCollCell")
        self.blogCollView.register(UINib(nibName: "BlogCollCell", bundle: nil), forCellWithReuseIdentifier: "BlogCollCell")
        
        self.collView.automaticallyAdjustsScrollIndicatorInsets = false
        self.collView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
        
        
        self.getCommentsAPI(self.blogId, limit: 2)
        self.getBlogListBySectionId(self.sectionId, countryy: self.isFromHome ? "" : UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.SELECTED_COUNTRY) as? String ?? "")
        
        self.collView.delegate = nil
        self.collView.dataSource = nil
        
        self.commentTextView.delegate = self
        
        self.blogCollView.delegate = nil
        self.blogCollView.dataSource = nil
        
        self.startTimer()
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        if !view.isFirstResponder {
//            self.commentLbl.isHidden = true
            self.commentTextView.isHidden = true
            self.commentCountLbl.isHidden = true
            self.commentTextViewHeight.constant = 0
            let myNormalAttributedTitle = NSAttributedString(string: "Add Comment",
                                                             attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
            self.commentBtn.setAttributedTitle(myNormalAttributedTitle,for:.normal)
            self.headerViewHeight.constant = 100
            self.commentTextView.text = ""
            self.commentCountLbl.text = "0 / 150"
            self.view.layoutIfNeeded()
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        blogView.roundCorners(corners: [.topLeft, .topRight], cornerRadius: 12)
        headerView.roundCorners(corners: [.topLeft, .topRight], cornerRadius: 25)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
        let underlineAttributedString = NSAttributedString(string: "Tap to Read Full Article ", attributes: underlineAttribute)
        fullArticleUrlLbl.attributedText = underlineAttributedString
        
        self.navigationController?.navigationBar.isHidden = true
        self.getContentDetailById(self.blogId)
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
                    var filesArr = [Any]()
                    self.imageWithBaseUrl.removeAll()
                    for i in 0..<json["files"].count {
                        filesArr.append(json["files"][i].stringValue)
                        self.imageWithBaseUrl.append(URL(string: FILE_BASE_URL + json["files"][i].stringValue )!)
                    }
                    
                    print(filesArr)
                    
                    self.contentDetailDic = contentDetailStruct.init(sectionName: json["sectionName"].stringValue, country: json["country"].stringValue, featuredImage: json["featuredImage"].stringValue, body: json["body"].stringValue, subject: json["subject"].stringValue, author: json["author"].stringValue, files: filesArr, id: json["id"].intValue, shortDescription: json["shortDescription"].stringValue, readCount: json["readCount"].intValue, createdOn: json["createdOn"].stringValue, shareURl: json["shareURl"].stringValue, videoUrl: json["videoUrl"].stringValue, videoId: json["videoId"].stringValue, commentCount: json["commentCount"].intValue, link: json["link"].stringValue)
                    
                    
                    
                    DispatchQueue.main.async {
                        hideAllProgressOnView(appDelegateInstance.window!)
                        if self.contentDetailDic.videoUrl == "" {
                            self.pageControl.numberOfPages = self.contentDetailDic.files.count
                        } else {
                            self.pageControl.numberOfPages = self.contentDetailDic.files.count + 1
                        }
                        self.viewCountLbl.text = "\(self.contentDetailDic.readCount)"
                        self.pageControl.currentPage = 0
                        self.setDetails()
                        self.collView.delegate = self
                        self.collView.dataSource = self
                        self.collView.reloadData()
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
    
    func getBlogListBySectionId(_ sectionId: String, countryy: String) {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            let apiUrl = BASE_URL + PROJECT_URL.GET_CONTENT_LIST_BY_SECTION + "\(sectionId)" + "/\(1)" + "/\(50)" + "?searchText=" + "&country=\(countryy)"
            let url : NSString = apiUrl as NSString
            let urlStr : NSString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! as NSString
            
            let param:[String:String] = [:]
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: urlStr as String, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    self.mediaContentList.removeAll()
                    for i in 0..<json["contentList"].count
                    {
                        let subject = json["contentList"][i]["subject"].stringValue
                        let shortDescription = json["contentList"][i]["shortDescription"].stringValue
                        let id = json["contentList"][i]["id"].intValue
                        
                        self.filesArr.removeAll()
                        for j in 0..<json["contentList"][i]["files"].count {
                            
                            self.filesArr.append(json["contentList"][i]["files"][j].stringValue)
                        }
                        
                        if id != self.blogId {
                            self.mediaContentList.append(mediaContentListStruct.init(subject: subject, id: id, shortDescription: shortDescription, files: self.filesArr))
                        }
                    }
                    
                    DispatchQueue.main.async {
                        if self.mediaContentList.count > 0 {
                            self.blogCollView.isHidden = false
                            self.blogCollView.delegate = self
                            self.blogCollView.dataSource = self
                            self.blogCollView.reloadData()
                        } else {
                            self.blogCollView.isHidden = true
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
    
    func getCommentsAPI(_ id: Int, limit: Int) {
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
                        } else {
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
    
    func postCommentAPI() {
        
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:Any] = [ "id": self.blogId,"comment":self.commentTextView.text!]
            ServerClass.sharedInstance.postRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.ADD_COMMENT, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    self.view.resignFirstResponder()
                    self.view.makeToast("Comment added successfully.")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                        self.commentLbl.isHidden = true
                        self.commentTextView.isHidden = true
                        self.commentCountLbl.isHidden = true
                        self.commentTextViewHeight.constant = 0
                        let myNormalAttributedTitle = NSAttributedString(string: "Add Comment",
                                                                         attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
                        self.commentBtn.setAttributedTitle(myNormalAttributedTitle,for:.normal)
                        self.headerViewHeight.constant = 100
                        self.commentTextView.text = ""
                        self.commentCountLbl.text = "0 / 150"
                        self.view.layoutIfNeeded()
                        self.getCommentsAPI(self.blogId, limit: 2)
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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        self.pageControl.currentPage = Int(pageNumber)
    }
    
    func setDetails() {
        self.longDescriptionLbl.text = self.contentDetailDic.body.html2String
        self.readCountLbl.text = "\(self.contentDetailDic.readCount)"
        self.shortDescriptionLbl.text = self.contentDetailDic.shortDescription
        self.subjectLbl.text = self.contentDetailDic.subject
        self.postedByLbl.text = self.contentDetailDic.author
        self.postedDateLbl.text = self.contentDetailDic.createdOn
        self.sectionNameLbl.text = self.contentDetailDic.sectionName
        if self.contentDetailDic.commentCount == 1 {
            self.viewAllCommentsBtn.setTitle("\(self.contentDetailDic.commentCount) comment", for: .normal)
            self.viewAllCommentsBtn.isHidden = false
        } else if self.contentDetailDic.commentCount == 0 {
            self.viewAllCommentsBtn.isHidden = true
        } else {
            self.viewAllCommentsBtn.setTitle("\(self.contentDetailDic.commentCount) comments", for: .normal)
            self.viewAllCommentsBtn.isHidden = false
        }

        self.fullArticleUrlLbl.isHidden = self.contentDetailDic.link.isEmpty
    }
    
    @IBAction func onClickaddComment(_ sender: UIButton) {
        if UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.VENDOR_SIGNUP_TOKEN) != nil {
            if sender.titleLabel?.text == "Add Comment" {
                let viewAllVC = DIConfigurator.shared.getViewCommentsVC()
                viewAllVC.blogId = self.contentDetailDic.id
                viewAllVC.shortDesc = self.contentDetailDic.shortDescription
                viewAllVC.isFrom = "Multimedia"
                self.navigationController?.pushViewController(viewAllVC, animated: true)
            } else {
                if self.commentTextView.text!.isEmpty {
                    self.view.makeToast("Please write your comment.")
                    return
                }
                self.postCommentAPI()
            }
            
        } else {
            let vc = DIConfigurator.shared.getLoginVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }
       
        
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        commentCountLbl.text = "\(maxLength - textView.text.count) / \(self.maxLength)"
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return textView.text.count + (text.count - range.length) <= self.maxLength
    }
    
    
    @IBAction func wishlistAction(_ sender: Any) {
        
        
    }
    
    @IBAction func fbShare(_ sender: UIButton) {
        let fbUrl = self.contentDetailDic.shareURl
        
        let shareString = "https://www.facebook.com/sharer/sharer.php?u=\(fbUrl)"
        
        let escapedShareString = shareString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        let url = URL(string: escapedShareString)
        
        UIApplication.shared.openURL(url!)
    }
    
    @IBAction func twitterShare(_ sender: UIButton) {
        //        let tweetText = "your text"
        let tweetUrl = self.contentDetailDic.shareURl
        
        let shareString = "https://twitter.com/intent/tweet?text=&url=\(tweetUrl)"
        
        // encode a space to %20 for example
        let escapedShareString = shareString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        // cast to an url
        let url = URL(string: escapedShareString)
        
        // open in safari
        UIApplication.shared.openURL(url!)
    }
    
    @IBAction func viewMoreCommentAction(_ sender: UIButton) {
        self.getCommentsAPI(self.blogId, limit: 20)
    }
    
    
    //      Scroll to Next Cell
    @objc func scrollToNextCell(){
        //get cell size
        let cellSize = view.frame.size
        //get current content Offset of the Collection view
        let contentOffset = self.collView.contentOffset
        
        if self.collView.contentSize.width <= self.collView.contentOffset.x + cellSize.width
        {
            let r = CGRect(x: 0, y: contentOffset.y, width: cellSize.width, height: cellSize.height)
            self.collView.scrollRectToVisible(r, animated: true)
            
        }
        else
        {
            let r = CGRect(x: contentOffset.x + cellSize.width, y: contentOffset.y, width: cellSize.width, height: cellSize.height)
            self.collView.scrollRectToVisible(r, animated: true);
        }
        
        
        
        if pageControl.currentPage == pageControl.numberOfPages - 1 {
            pageControl.currentPage = 0
        }
        else
        {
            pageControl.currentPage += 1
        }
    }
    func startTimer() {
        guard timer == nil else { return }
        timer = Timer.scheduledTimer(timeInterval: 3, target: self , selector:
                                        #selector(scrollToNextCell), userInfo: nil, repeats: true)
    }
    
    @IBAction func shareBtnClicked(sender: UIButton)
    {
        let imageUrl = self.contentDetailDic.shareURl
        self.shareButton(Url: imageUrl)
    }
    
    func shareButton(Url: String) {
        let text = Url
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func onClickViewAllCommentsBtn(_ sender: Any) {
        let viewAllVC = DIConfigurator.shared.getViewCommentsVC()
        viewAllVC.blogId = self.contentDetailDic.id
        viewAllVC.shortDesc = self.contentDetailDic.shortDescription
        viewAllVC.isFromProduct = false
        self.navigationController?.pushViewController(viewAllVC, animated: true)
       
    }
    
    @IBAction func onClickReadFullArticle(_ sender: UIButton) {
        let str = self.contentDetailDic.link
        if let url = URL(string: str) {
            UIApplication.shared.open(url)
        }
    }
    
}

extension BlogDetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.blogCollView {
            return self.mediaContentList.count
        } else {
            if contentDetailDic.videoId == "" {
                return self.contentDetailDic.files.count
            } else {
                return self.contentDetailDic.files.count + 1
            }
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.blogCollView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BlogCollCell", for: indexPath) as! BlogCollCell
            let info = self.mediaContentList[indexPath.row]
            
            cell.cellLbl.text = info.subject
            cell.cellLbl.font = UIFont(name: "Poppins-SemiBold", size: 11)
            let imageArr = info.files
            if imageArr.count > 0 {
                cell.cellImg.sd_setImage(with: URL(string: FILE_BASE_URL + "\(imageArr[0])"), placeholderImage: UIImage(named: "loading"))
            }
            
            return cell
        } else {
            if contentDetailDic.videoId != "" {
                //self.contentDetailDic.files.count - 1
                if indexPath.row <= 0 {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCollCell", for: indexPath) as! VideoCollCell
                    cell.playerView.load(withVideoId: self.contentDetailDic.videoId, playerVars: ["playsinline": 1])
                    
                    
                    
                    return cell
                } else  {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BlogDeatilCollCell", for: indexPath) as! BlogDeatilCollCell
                    if contentDetailDic.files.count > 0 {
                        cell.cellImg.sd_setImage(with: URL(string: FILE_BASE_URL + "\(self.contentDetailDic.files[indexPath.row - 1])" ), placeholderImage: UIImage(named: "loading"))
                    }
                    
                    cell.layer.shouldRasterize = true
                    cell.layer.rasterizationScale = UIScreen.main.scale
                    
                    if indexPath.row == self.contentDetailDic.files.count {
                        timer?.invalidate()
                        timer = nil
                    }
                    
                    return cell
                    
                }

            } else {
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BlogDeatilCollCell", for: indexPath) as! BlogDeatilCollCell
                cell.cellImg.sd_setImage(with: URL(string: FILE_BASE_URL + "\(self.contentDetailDic.files[indexPath.row])" ), placeholderImage: UIImage(named: "loading"))
                cell.layer.shouldRasterize = true
                cell.layer.rasterizationScale = UIScreen.main.scale
                
                return cell
            }
            
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.blogCollView {
            let contentDetailVC = DIConfigurator.shared.getContentDetailVC()
            contentDetailVC.blogId = self.mediaContentList[indexPath.row].id
            contentDetailVC.sectionId = self.sectionId
            contentDetailVC.isFromHome = self.isFromHome
            self.navigationController?.pushViewController(contentDetailVC, animated: true)
        }else {
            let contentDetailVC = DIConfigurator.shared.getImageViewerVC()
            contentDetailVC.imagesArr = self.imageWithBaseUrl
            contentDetailVC.contentDetailDic = self.contentDetailDic
            contentDetailVC.isFromMultimedia = true
            self.navigationController?.pushViewController(contentDetailVC, animated: true)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.blogCollView {
            let collectionWidth = self.blogCollView.bounds.width
            
            return CGSize(width: (collectionWidth - 10) / 2, height: 170)
        } else {
            let collectionWidth = collectionView.bounds.width
            let collectionHeight = collectionView.bounds.height
            return CGSize(width: UIScreen.main.bounds.size.width, height: collectionHeight)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

extension BlogDetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.commentArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentListTableCell", for: indexPath) as! CommentListTableCell
        
        let info = self.commentArr[indexPath.row]
        cell.cellNameLbl.text = info.createdBy
        cell.cellDateLbl.text = info.createdOn
        cell.cellCommentLbl.text = info.comment
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //        self.commentTblHeight.constant = commentTableView.contentSize.height
        self.commentTblHeight.constant = 0
        
    }
}
