//
//  ViewController.swift
//  OnYourHeart-Pod
//
//  Created by Curt McCune on 6/20/22.
//

import UIKit
import AVKit
import FirebaseAuth
import FirebaseCore

class ViewController: UIViewController {
    
    //MARK: - Properties
    var handle: AuthStateDidChangeListenerHandle?
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var copyrightLabel: UILabel!
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setUpElements()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                setUpVideo()
    }
    
    //MARK: - Helper Functions
    func setUpElements() {
        
        LoginUtilities.styleFilledButton(signUpButton)
        LoginUtilities.styleHollowButton(loginButton)
    }
    
    
    //MARK: - Video Player Section
    
    
        var videoPlayer: AVPlayer?
    
        var videoPlayerLayer: AVPlayerLayer?
    
    
        func setUpVideo() {
         
            //Get the path to the resource in the bundle
            guard let bundlePath = Bundle.main.path(forResource: Constants.Storyboard.videoName, ofType: Constants.Storyboard.videoType) else {
               print("nope")
                return
            }
    
            //Create a URL from it
            let url = URL(fileURLWithPath: bundlePath)
    
            //Create Video Player Item
            let item = AVPlayerItem(url: url)
    
            //Create the Player
            videoPlayer = AVPlayer(playerItem: item)
    
            //Create the layer
            videoPlayerLayer = AVPlayerLayer(player: videoPlayer!)
    
            //Adjust the size and frame
            videoPlayerLayer?.frame = CGRect(x: -self.view.frame.width*1.5, y: 0, width: self.view.frame.size.width*4, height: self.view.frame.size.height)
    
            view.layer.insertSublayer(videoPlayerLayer!, at: 0)
    
            //Add it to the view and play it
    
            videoPlayer?.playImmediately(atRate: 1.0)
            
            //Adds observer for when it ends
            NotificationCenter.default
                .addObserver(self,
                selector: #selector(playerDidFinishPlaying),
                name: .AVPlayerItemDidPlayToEndTime,
                object: videoPlayer?.currentItem
            )
    
        }
    
    @objc func playerDidFinishPlaying() {
        copyrightLabel.isHidden = false
    }
    
    
}

