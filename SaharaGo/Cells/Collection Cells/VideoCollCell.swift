//
//  VideoCollCell.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 26/09/22.
//

import UIKit
import youtube_ios_player_helper

class VideoCollCell: UICollectionViewCell, YTPlayerViewDelegate {

    @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var playBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.playerView.delegate = self
        self.playerView.load(withVideoId: "JoilZgbppC8", playerVars: ["playsinline": 1])
    }

    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        //playerView.playVideo()
    }
    
    @IBAction func playAction(_ sender: Any) {
        playerView.playVideo()
    }
    
    
}
