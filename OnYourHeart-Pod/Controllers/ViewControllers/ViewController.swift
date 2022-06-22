//
//  ViewController.swift
//  OnYourHeart-Pod
//
//  Created by Curt McCune on 6/20/22.
//

import UIKit
import AVKit

class ViewController: UIViewController {
    
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let key = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String {
            print(key)
        }
        
        
        
        setUpElements()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        setUpVideo()
    }
    
    func setUpElements() {
        
        Utilities.styleFilledButton(signUpButton)
        Utilities.styleHollowButton(loginButton)
        
        
    }
    
    
    //MARK: - Video Player Section
    
    
    //    var videoPlayer: AVPlayer?
    //
    //    var videoPlayerLayer: AVPlayerLayer?
    
    
    //    func setUpVideo() {
    //        //Get the path to the resource in the bundle
    //        guard let bundlePath = Bundle.main.path(forResource: "loginbg", ofType: "mp4") else {return}
    //
    //        //Create a URL from it
    //        let url = URL(fileURLWithPath: bundlePath)
    //
    //        //Create Video Player Item
    //        let item = AVPlayerItem(url: url)
    //
    //        //Create the Player
    //        videoPlayer = AVPlayer(playerItem: item)
    //
    //        //Create the layer
    //        videoPlayerLayer = AVPlayerLayer(player: videoPlayer!)
    //
    //        //Adjust the size and frame
    //        videoPlayerLayer?.frame = CGRect(x: -self.view.frame.size.width*1.5, y: 0, width: self.view.frame.size.width*4, height: self.view.frame.size.height)
    //
    //        view.layer.insertSublayer(videoPlayerLayer!, at: 0)
    //
    //        //Add it to the view and play it
    //
    //        videoPlayer?.playImmediately(atRate: 0.3)
    //
    //    }
    
    
    
    
}

