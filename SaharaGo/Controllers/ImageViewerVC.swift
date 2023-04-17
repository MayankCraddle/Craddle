//
//  ImageViewerVC.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 10/11/22.
//

import UIKit

class ImageViewerVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collView: UICollectionView!
    
    var imagesArr = [URL]()
    var contentDetailDic = contentDetailStruct()
    var isFromMultimedia = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imagesArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageViewerCell", for: indexPath) as! ImageViewerCell
        cell.cellImg.sd_setImage(with: imagesArr[indexPath.row], placeholderImage: UIImage(named: "loading"))
        cell.cellDescView.isHidden = !isFromMultimedia
        cell.subjectLbl.text = self.contentDetailDic.subject
        cell.descLbl.text = self.contentDetailDic.shortDescription
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let collectionWidth = UIScreen.main.bounds.size.width
        let collectionHeight = UIScreen.main.bounds.size.height
        return CGSize(width: UIScreen.main.bounds.size.width, height: collectionHeight)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}
