////
////  MediaContentCell.swift
////  SaharaGo
////
////  Created by ChawTech Solutions on 05/09/22.
////
//
//import UIKit
//
//class MediaContentCell: UITableViewCell {
//
//    @IBOutlet weak var cellSubTitleLbl: UILabel!
//    @IBOutlet weak var cellTitleLbl: UILabel!
//    @IBOutlet weak var cellImg: UIImageView!
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
//
//}


// MARK: >>

//
//  MediaContentCell.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 05/09/22.
//

import UIKit
import youtube_ios_player_helper

class MediaContentCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, YTPlayerViewDelegate {

    @IBOutlet weak var cellFlagImg: UIImageView!
    @IBOutlet weak var cellSubTitleLbl: UILabel!
    @IBOutlet weak var cellTitleLbl: UILabel!
    @IBOutlet weak var cellImg: UIImageView!
    
    @IBOutlet weak var cellShareBtn: UIButton!
    @IBOutlet weak var cellViewCountLbl: UILabel!
    @IBOutlet weak var cellReadMoreBtn: UIButton!
    
    @IBOutlet weak var firstCommentBackView: UIView!
    @IBOutlet weak var firstUserCommentLbl: UILabel!
    @IBOutlet weak var firstUserNameLbl: UILabel!
    @IBOutlet weak var typeCommentBackView: UIView!
    
    
    
    @IBOutlet weak var secondCommentBackView: UIView!
    
    @IBOutlet weak var secondUserCommentLbl: UILabel!
    @IBOutlet weak var secondUserNameLbl: UILabel!
    
    @IBOutlet weak var commentTxtView: UITextView!
    @IBOutlet weak var sendCommentBtn: UIButton!
    
    @IBOutlet weak var bannerCollView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    @IBOutlet weak var cellViewAllCommentBtn: UIButton!
    
    var didselectClosure: DidSelectClosure?
    var section: Int?
    var row: Int?
    
//    var mediaInfo = mediaContentListStruct()
    var mediaInfo: mediaContentListStruct! {
        didSet {
            self.cellTitleLbl.text = mediaInfo.subject
            self.cellSubTitleLbl.text = mediaInfo.shortDescription
            self.cellViewCountLbl.text = mediaInfo.readCount
            let desLineCount = self.countLabelLines(label: self.cellSubTitleLbl)
            print(desLineCount)
            if (desLineCount == 1) || (desLineCount == 2)
            {
                self.cellReadMoreBtn.isHidden = true
            }
            else
            {
                self.cellReadMoreBtn.isHidden = false
            }
            self.commentTxtView.placeholder = "Type your comment"
            if mediaInfo.commentCount == "1"
            {
                self.cellViewAllCommentBtn.setTitle("\(mediaInfo.commentCount) comment", for: .normal)
            }
            else
            {
                self.cellViewAllCommentBtn.setTitle("\(mediaInfo.commentCount) comments", for: .normal)
            }
            let flag = UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.SELECTED_FLAG) as! String
            let imageUrl = FLAG_BASE_URL + "/" + flag
            self.cellFlagImg.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "loading"))
            
            if mediaInfo.videoUrl == "" {
                self.pageControl.numberOfPages = mediaInfo.files.count
            } else {
                self.pageControl.numberOfPages = mediaInfo.files.count + 1
            }

            self.pageControl.currentPage = 0
            
            if mediaInfo.comments.count == 1 {
                self.firstUserNameLbl.text = mediaInfo.comments[0].createdBy
                self.firstUserCommentLbl.text = mediaInfo.comments[0].comment
                self.secondCommentBackView.isHidden = true
                self.firstCommentBackView.isHidden = false
                self.cellViewAllCommentBtn.isHidden = false
            } else if mediaInfo.comments.count == 2 {
                self.firstCommentBackView.isHidden = false
                self.secondCommentBackView.isHidden = false
                self.firstUserNameLbl.text = mediaInfo.comments[0].createdBy
                self.firstUserCommentLbl.text = mediaInfo.comments[0].comment
                self.secondUserNameLbl.text = mediaInfo.comments[1].createdBy
                self.secondUserCommentLbl.text = mediaInfo.comments[1].comment
                self.cellViewAllCommentBtn.isHidden = false
            } else {
                self.cellViewAllCommentBtn.isHidden = true
                self.firstCommentBackView.isHidden = true
                self.secondCommentBackView.isHidden = true
            }
            
            
            
           //self.commentTxtView.
            bannerCollView.reloadData()
        }
    }
    
    func countLabelLines(label: UILabel) -> Int {
           // Call self.layoutIfNeeded() if your view uses auto layout
           let myText = label.text! as NSString

           let rect = CGSize(width: label.bounds.width, height: CGFloat.greatestFiniteMagnitude)
           let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: label.font], context: nil)

           return Int(ceil(CGFloat(labelSize.height) / label.font.lineHeight))
       }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        print(self.mediaInfo)
        self.bannerCollView.register(UINib(nibName: "VideoCollCell", bundle: nil), forCellWithReuseIdentifier: "VideoCollCell")
        self.bannerCollView.delegate = self
        self.bannerCollView.dataSource = self
        
//        if self.mediaInfo.videoUrl == "" {
//            self.pageControl.numberOfPages = self.mediaInfo.files.count
//        } else {
//            self.pageControl.numberOfPages = self.mediaInfo.files.count + 1
//        }
//
//        self.pageControl.currentPage = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.mediaInfo.videoUrl == "" {
            return mediaInfo.files.count
        } else {
            return mediaInfo.files.count + 1
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.mediaInfo.videoUrl == "" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCollCell", for: indexPath) as! BannerCollCell
            let imgArr = self.mediaInfo.files
            cell.cellDateLbl.text = getFormattedDateStr(dateStr: self.mediaInfo.createdOn, dateFormat: "MMM dd, yyyy")
            if indexPath.row <= imgArr.count - 1 {
                
                cell.cellImg.sd_setImage(with: URL(string: FILE_BASE_URL + "/\(imgArr[indexPath.row])"), placeholderImage: UIImage(named: "loading"))
            }
            
            return cell
        } else {
            
            if indexPath.row == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCollCell", for: indexPath) as! VideoCollCell
                

//                let info = self.contentDetailDic.videoId
//                cell.playerView.delegate = self
                cell.playerView.load(withVideoId: self.mediaInfo.videoId, playerVars: ["playsinline": 1])
                
                return cell
                
                
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCollCell", for: indexPath) as! BannerCollCell
        //        let imageStr = self.contentDetailDic.files
                

                cell.cellImg.sd_setImage(with: URL(string: FILE_BASE_URL + "\(self.mediaInfo.files[indexPath.row - 1])" ), placeholderImage: UIImage(named: "loading"))
                cell.layer.shouldRasterize = true
                cell.layer.rasterizationScale = UIScreen.main.scale
                
                return cell
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didselectClosure?(section, row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let collectionWidth = bannerCollView.bounds.width
        let collectionHeight = bannerCollView.bounds.height
        return CGSize(width: UIScreen.main.bounds.size.width, height: collectionHeight)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        self.pageControl.currentPage = Int(pageNumber)
    }

}

