//
//  ImageViewerCell.swift
//  SaharaGo
//
//  Creaed by ChawTech Solutions on 10/11/22.
//

import UIKit

class ImageViewerCell: UICollectionViewCell {
    
    @IBOutlet weak var cellDescView: UIView!
    @IBOutlet weak var subjectLbl: UILabel!
    @IBOutlet weak var cellImg: UIImageView!
    @IBOutlet weak var descLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(self.pinch(sender:)))
        cellImg.addGestureRecognizer(pinch)
    }
    
    @objc func pinch(sender:UIPinchGestureRecognizer) {
        if sender.state == .began || sender.state == .changed {
            let currentScale = self.cellImg.frame.size.width / self.cellImg.bounds.size.width
            let newScale = currentScale*sender.scale
            let transform = CGAffineTransform(scaleX: newScale, y: newScale)
            self.cellImg.transform = transform
            sender.scale = 1
        }
    }
    
}
