//
//  ViewController.swift
//  viewManipulation
//
//  Created by roi mulia on 14/02/2016.
//  Copyright © 2016 com.roimulia. All rights reserved.
//

import UIKit
import AVFoundation
import AssetsLibrary

class ViewController: UIViewController {
    var documentsURL : NSURL!
    var player : AVPlayer!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("hey")
        let paths = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        documentsURL = paths[0]
        documentsURL = documentsURL.URLByAppendingPathComponent("mov.MOV")
        var error:NSError?
        let folderExists = documentsURL.checkResourceIsReachableAndReturnError(&error)
        print(folderExists)
        if folderExists
        {
            let fileManager = NSFileManager.defaultManager()
            
            do {
                try fileManager.removeItemAtURL(documentsURL)
                
            }
            catch let error as NSError {
                print("Ooops! Something went wrong: \(error)")
            }
            
        }
        
        
        
        
        
        let aLayer = CALayer()
        aLayer.contents = UIImage(named: "check.png")?.CGImage
        aLayer.frame = CGRectMake(50, 50, 160, 160)
        
        let path = NSBundle.mainBundle().pathForResource("vid", ofType:"mp4")
        let file = NSURL(fileURLWithPath: path!)
        let playerItem = AVPlayerItem(asset: AVAsset(URL: file))
        
        //Set Player
        player = AVPlayer(URL: file)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = CGRectMake(0, 0, 320, 320)
        self.view.layer.addSublayer(playerLayer)
        let synchronizedLayer = AVSynchronizedLayer(playerItem: playerItem)
        synchronizedLayer.frame = playerLayer.frame
        playerLayer.addSublayer(synchronizedLayer)
        
        //Add Image
        
        synchronizedLayer.addSublayer(aLayer)
        player.play()
        
        //Replay
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "playerItemDidReachEnd:",
            name: AVPlayerItemDidPlayToEndTimeNotification,
            object: self.player.currentItem)
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func playerItemDidReachEnd(notification: NSNotification) {
        self.player.seekToTime(kCMTimeZero)
        self.player.play()
    }
    
    
    //   let videoComposition = AVMutableVideoComposition(asset: <#T##AVAsset#>, applyingCIFiltersWithHandler: <#T##(AVAsynchronousCIImageFilteringRequest) -> Void#>)
    func exportVideo()
    {
        let aLayer = CALayer()
        aLayer.contents = UIImage(named: "check.png")?.CGImage
        aLayer.frame = CGRectMake(59, 50, 10, 10)
        
        let path = NSBundle.mainBundle().pathForResource("vid", ofType:"mp4")
        let file = NSURL(fileURLWithPath: path!)
        let asset = AVAsset(URL: file)
        var clipVideoTrack = asset.tracksWithMediaType(AVMediaTypeVideo)[0] as! AVAssetTrack
        let videoSize = clipVideoTrack.naturalSize
        let videoComposition = AVMutableVideoComposition(propertiesOfAsset: asset)
        
        
        let parentLayer = CALayer()
        let videoLayer = CALayer()
        let animLayer = CALayer()
        parentLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height)
        videoLayer.frame = parentLayer.frame
        animLayer.frame =  parentLayer.frame
        parentLayer.geometryFlipped = true
        parentLayer.addSublayer(videoLayer)
        parentLayer.addSublayer(animLayer)
        animLayer.addSublayer(aLayer)
        
        
        videoComposition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, inLayer: parentLayer)
        
        let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality)
        exportSession!.videoComposition = videoComposition
        exportSession!.outputFileType = AVFileTypeQuickTimeMovie
        exportSession!.outputURL =  documentsURL
        
        
        exportSession!.exportAsynchronouslyWithCompletionHandler({ () -> Void in
            print("finished")
            ALAssetsLibrary().writeVideoAtPathToSavedPhotosAlbum(self.documentsURL, completionBlock: nil)
            
        })
        
        
        
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        exportVideo()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

enum AppError : ErrorType {
    case InvalidResource(String, String)
}