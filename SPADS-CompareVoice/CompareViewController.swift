//
//  CompareViewController.swift
//  SPADS-CompareVoice
//
//  Created by BBaoBao on 6/29/15.
//  Copyright (c) 2015 buingocbao. All rights reserved.
//

import UIKit

class CompareViewController: UIViewController, FDWaveformViewDelegate {
    
    var audioPath:NSURL = NSURL()
    var startRendering:NSDate!
    var endRendering:NSDate!
    var startLoading:NSDate!
    var endLoading:NSDate!
    var word:String = ""
    var backButton:MKButton = MKButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var bounds = UIScreen.mainScreen().bounds
        var dvWidth = bounds.size.width
        var dvHeight = bounds.size.height
        
        var assetUser:AVURLAsset = AVURLAsset(URL: audioPath, options: nil)
        
        var playerSoundView:SYWaveformPlayerView = SYWaveformPlayerView(frame: CGRectMake(0, dvHeight/4, dvWidth, dvHeight/4), asset: assetUser, color: UIColor.MKColor.Grey, progressColor: UIColor.MKColor.Green)
        self.view.addSubview(playerSoundView)
        
        // We need just to get the documents folder url
        let documentsUrl =  NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0] as! NSURL
        
        // now lets get the directory contents (including folders)
        if let directoryContents =  NSFileManager.defaultManager().contentsOfDirectoryAtPath(documentsUrl.path!, error: nil) {
            //println(directoryContents)
        }
        // if you want to filter the directory contents you can do like this:
        if let directoryUrls =  NSFileManager.defaultManager().contentsOfDirectoryAtURL(documentsUrl, includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions.SkipsSubdirectoryDescendants, error: nil) {
            let wavFilesName = directoryUrls.map(){ $0 }.filter(){ $0.lastPathComponent == "\(self.word).mp3"}
            for index in wavFilesName {
                var soundURL:NSURL = (index as! NSURL)
                var assetSystem:AVURLAsset = AVURLAsset(URL: soundURL, options: nil)
                var systemSoundView:SYWaveformPlayerView = SYWaveformPlayerView(frame: CGRectMake(0, dvHeight/2 + 100, dvWidth, dvHeight/4), asset: assetSystem, color: UIColor.MKColor.Grey, progressColor: UIColor.MKColor.Blue)
                self.view.addSubview(systemSoundView)
            }
        }
        
        // Config label
        var labelUser:UILabel = UILabel(frame: CGRectMake(0, dvHeight/4-50, dvWidth, 50))
        labelUser.text = "Your pronounciation"
        labelUser.textColor = UIColor.MKColor.Brown
        labelUser.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        self.view.addSubview(labelUser)
        
        var labelSystem:UILabel = UILabel(frame: CGRectMake(0, dvHeight/2+50, dvWidth, 50))
        labelSystem.text = "System pronounciation"
        labelSystem.textColor = UIColor.MKColor.Brown
        labelSystem.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        self.view.addSubview(labelSystem)
        
        // Config navigation
        addBackButton()

    }
    
    // MARK: Add Back Button
    func addBackButton() {
        self.navigationItem.backBarButtonItem = nil;
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.hidesBackButton = true;
        self.navigationItem.title = ""
        
        backButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        backButton.backgroundColor = UIColor.MKColor.Red
        backButton.cornerRadius = 20.0
        backButton.backgroundLayerCornerRadius = 20.0
        backButton.maskEnabled = false
        backButton.circleGrowRatioMax = 1.75
        backButton.rippleLocation = .Center
        backButton.aniDuration = 0.85
        backButton.layer.shadowOpacity = 0.75
        backButton.layer.shadowRadius = 3.5
        backButton.layer.shadowColor = UIColor.blackColor().CGColor
        backButton.layer.shadowOffset = CGSize(width: 1.0, height: 5.5)
        backButton.setTitle("<", forState: UIControlState.Normal)
        backButton.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 20)
        backButton.addTarget(self, action: "backButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        
        var leftBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.setLeftBarButtonItem(leftBarButtonItem, animated: false)
    }
    
    func backButtonClick(button:UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
