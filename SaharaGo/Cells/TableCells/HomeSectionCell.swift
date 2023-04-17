//
//  HomeSectionCell.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 16/08/22.
//

import UIKit

typealias ViewAllClosure = ((_ index: Int?) -> Void)
typealias DidSelectClosure = ((_ tableIndex: Int?, _ collectionIndex: Int?) -> Void)

class HomeSectionCell: UITableViewCell {

    @IBOutlet weak var cellHeaderView: UIView!
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var sectionNameLbl: UILabel!
    
    private let itemsPerRow: CGFloat = 3
    private let sectionInsets = UIEdgeInsets(
      top: 15.0,
      left: 20.0,
      bottom: 50.0,
      right: 20.0)
    
    var homeList: homeSectionDataStruct? {
        didSet {
            sectionNameLbl.text = homeList?.sectionName
            sectionNameLbl.font = UIFont(name: "Poppins-SemiBold", size: 13)
            collView.reloadData()
        }
    }
    
    var index: Int?
    var onClickViewAllClosure: ViewAllClosure?
    var didselectClosure: DidSelectClosure?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collView.delegate = self
        collView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onClickViewAll(_ sender: UIButton) {
        onClickViewAllClosure?(index)
    }
    

}

extension HomeSectionCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeList?.content.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContentCollCell", for: indexPath) as? ContentCollCell else {
            return UICollectionViewCell()
        }
        
        cell.cellLbl.text = homeList?.content[indexPath.row].subject
        cell.cellLbl.font = UIFont(name: "Poppins-SemiBold", size: 11)
        let imageArr = homeList?.content[indexPath.row].files
        if imageArr!.count > 0 {
            cell.cellImage.sd_setImage(with: URL(string: FILE_BASE_URL + "\(imageArr![0])"), placeholderImage: UIImage(named: "loading"))
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didselectClosure?(index, indexPath.row)
    }
    
}

// MARK: - Collection View Flow Layout Delegate
//extension HomeSectionCell: UICollectionViewDelegateFlowLayout {
//    // 1
//    func collectionView(
//        _ collectionView: UICollectionView,
//        layout collectionViewLayout: UICollectionViewLayout,
//        sizeForItemAt indexPath: IndexPath
//    ) -> CGSize {
//        // 2
//        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
//        let availableWidth = collectionView.frame.width - paddingSpace
//        let widthPerItem = availableWidth / itemsPerRow
//
//        return CGSize(width: widthPerItem, height: widthPerItem)
//    }
//
//    // 3
//    func collectionView(
//        _ collectionView: UICollectionView,
//        layout collectionViewLayout: UICollectionViewLayout,
//        insetForSectionAt section: Int
//    ) -> UIEdgeInsets {
//        return sectionInsets
//    }
//
//    // 4
//    func collectionView(
//        _ collectionView: UICollectionView,
//        layout collectionViewLayout: UICollectionViewLayout,
//        minimumLineSpacingForSectionAt section: Int
//    ) -> CGFloat {
//        return sectionInsets.left
//    }
//}
