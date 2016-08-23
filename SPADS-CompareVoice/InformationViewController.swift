//
//  InformationViewController.swift
//  SPADS-CompareVoice
//
//  Created by BBaoBao on 6/8/15.
//  Copyright (c) 2015 buingocbao. All rights reserved.
//

import UIKit

class InformationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var btVoice: MKButton!
    @IBOutlet weak var btSetting: MKButton!
    @IBOutlet weak var playButton: MKButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lbLetter: UILabel!
    
    var backButton:MKButton = MKButton()
    var wavArray:[AnyObject] = [AnyObject]()
    var audioPlayer = AVAudioPlayer()
    var letter:String = ""
    var word:String = ""
    var refreshControl: UIRefreshControl!
    let speechSynthesizer = AVSpeechSynthesizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Config button
        configButton()
        
        // Add Back Button
        addBackButton()
        
        // Get user voices
        getSoundFiles()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // Config label
        lbLetter.text = word
        
        // Config Refresh Control
        self.refreshControl = UIRefreshControl()
        //self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: Selector("tableViewRefresh"), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl.tintColor = UIColor.whiteColor()
        self.tableView.addSubview(refreshControl)
        
        startDownloadingUrls()
    }
    // imageRefresh function
    func tableViewRefresh() {
        self.wavArray.removeAll(keepCapacity: false)
        getSoundFiles()
        tableView.reloadData()
        self.refreshControl.endRefreshing()
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
    
    // MARK: Config button
    func configButton() {
        
        btVoice.layer.shadowOpacity = 0.55
        btVoice.layer.shadowRadius = 5.0
        btVoice.layer.shadowColor = UIColor.grayColor().CGColor
        btVoice.layer.shadowOffset = CGSize(width: 0, height: 2.5)
        
        btSetting.layer.shadowOpacity = 0.55
        btSetting.layer.shadowRadius = 5.0
        btSetting.layer.shadowColor = UIColor.grayColor().CGColor
        btSetting.layer.shadowOffset = CGSize(width: 0, height: 2.5)
        
        playButton.maskEnabled = false
        playButton.backgroundAniEnabled = false
        playButton.rippleLocation = .Center
    }
    
    func getSoundFiles() {
        // We need just to get the documents folder url
        let documentsUrl =  NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0] as! NSURL
        
        // now lets get the directory contents (including folders)
        if let directoryContents =  NSFileManager.defaultManager().contentsOfDirectoryAtPath(documentsUrl.path!, error: nil) {
            //println(directoryContents)
        }
        // if you want to filter the directory contents you can do like this:
        if let directoryUrls =  NSFileManager.defaultManager().contentsOfDirectoryAtURL(documentsUrl, includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions.SkipsSubdirectoryDescendants, error: nil) {
            //println(directoryUrls)
            //self.wavArray = directoryUrls
            println(self.wavArray)
            let wavFilesName = directoryUrls.map(){ $0 }.filter(){ $0.pathExtension == "wav"}
            for index in wavFilesName {
                let range = (index.absoluteString)!!.rangeOfString(self.word, options: .RegularExpressionSearch)
                if range != nil {
                    println(index)
                    self.wavArray.append(index)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Table View
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wavArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SoundCell", forIndexPath: indexPath) as! UITableViewCell
    
        let wavFiles = wavArray.map(){ $0.lastPathComponent }.filter(){ $0.pathExtension == "wav" }
        //println("WAV FILES:\n" + wavFiles.description)
        cell.backgroundColor = UIColor.clearColor()
        cell.textLabel?.text = String(wavFiles[indexPath.row])
        cell.textLabel?.textColor = UIColor.MKColor.BlueGrey
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.separatorInset = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = UIEdgeInsetsZero
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        playSound(wavArray, indexPath: indexPath)
        //println(wavArray[indexPath.row])
    }
    
    // called when a row deletion action is confirmed
    func tableView(tableView: UITableView,
        commitEditingStyle editingStyle: UITableViewCellEditingStyle,
        forRowAtIndexPath indexPath: NSIndexPath) {
            switch editingStyle {
            case .Delete:
                // remove the deleted item from the model
                NSFileManager.defaultManager().removeItemAtURL(wavArray[indexPath.row] as! NSURL, error: nil)
                wavArray.removeAtIndex(indexPath.row)
                //println(wavArray.count)
                //tableViewSound.reloadData()
                
                // remove the deleted item from the `UITableView`
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            default:
                return
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        // 1
        var compareAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Compare" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
                self.performSegueWithIdentifier("CompareSegue", sender: self.wavArray[indexPath.row] as! NSURL)
            })
        
        compareAction.backgroundColor = UIColor.MKColor.Blue
        
        var deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete", handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            // remove the deleted item from the model
            NSFileManager.defaultManager().removeItemAtURL(self.wavArray[indexPath.row] as! NSURL, error: nil)
            self.wavArray.removeAtIndex(indexPath.row)
            //println(wavArray.count)
            //tableViewSound.reloadData()
            
            // remove the deleted item from the `UITableView`
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)

        })
        
        return [deleteAction,compareAction]
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var sectionHeaderView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40))
        sectionHeaderView.backgroundColor = UIColor.MKColor.LightGreen
        
        var headerLabel:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: sectionHeaderView.frame.size.width, height: 20))
        headerLabel.backgroundColor = UIColor.clearColor()
        headerLabel.textAlignment = NSTextAlignment.Center
        headerLabel.textColor = UIColor.whiteColor()
        headerLabel.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        sectionHeaderView.addSubview(headerLabel)
        
        headerLabel.text = "Your Voice"
        return sectionHeaderView

    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    
    func playSound(array:[AnyObject], indexPath: NSIndexPath) {
        println(array[indexPath.row])
        //let substring = array[indexPath.row].stringByReplacingOccurrencesOfString(".wav", withString: "")
        //var alertSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(array[indexPath.row].description, ofType: "wav")!)
        //println(alertSound)
        var soundURL:NSURL = (array[indexPath.row] as! NSURL)
        var alertSound = soundURL
        //println(soundURL)
            
        var error:NSError?
        audioPlayer = AVAudioPlayer(contentsOfURL: alertSound, error: &error)
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "SettingSegue") {
            var settingView:SettingViewController = segue.destinationViewController as! SettingViewController
            settingView.navigationItem.backBarButtonItem = nil
            settingView.navigationItem.hidesBackButton = true
            settingView.navigationItem.leftBarButtonItem = nil
            settingView.navigationItem.title = ""
        }
        
        if (segue.identifier == "VoiceSegue") {
            var recordView:RecordViewController = segue.destinationViewController as! RecordViewController
            recordView.navigationItem.backBarButtonItem = nil
            recordView.navigationItem.hidesBackButton = true
            recordView.navigationItem.leftBarButtonItem = nil
            recordView.navigationItem.title = ""
            recordView.word = word
        }
        
        if (segue.identifier == "CompareSegue") {
            var compareView:CompareViewController = segue.destinationViewController as! CompareViewController
            compareView.audioPath = sender as! NSURL
            compareView.word = self.word
            compareView.navigationItem.backBarButtonItem = nil
            compareView.navigationItem.hidesBackButton = true
            compareView.navigationItem.leftBarButtonItem = nil
            compareView.navigationItem.title = ""
        }
    }

    // MARK: Play Sound Event
    @IBAction func btPlaySoundEvent(sender: AnyObject) {
        // Tut voice
        //let speechUtterance = AVSpeechUtterance(string: word)
        //let voice = AVSpeechSynthesisVoice(language: "en-us")
        //speechUtterance.voice = voice
        //speechUtterance.rate = 0.1
        //speechUtterance.pitchMultiplier = 1
        //speechUtterance.volume = 1
        //speechSynthesizer.speakUtterance(speechUtterance)
        
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
                var alertSound = soundURL
                //println(soundURL)
                
                var error:NSError?
                audioPlayer = AVAudioPlayer(contentsOfURL: alertSound, error: &error)
                audioPlayer.prepareToPlay()
                audioPlayer.play()
            }
        }
    }
    
    // create a function to start the audio data download
    func getAudioDataFromUrl(audioUrl:NSURL, completion: ((data: NSData?) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(audioUrl) { (data, response, error) in
            completion(data:  data)
            }.resume()
    }
    
    // create another function to save the audio data
    func saveAudioData(audio:NSData, destination:NSURL) -> Bool {
        if audio.writeToURL(destination, atomically: true) {
            println("The file \"\(destination.lastPathComponent!.stringByDeletingPathExtension)\" was successfully saved.")
            return true
        }
        return false
    }

    // create a loop to start downloading your urls
    func startDownloadingUrls(){
        //Test
        let documentsUrl =  NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first as! NSURL
        let musicArray:[String] = ["http://translate.google.com/translate_tts?tl=en&q=%22\(self.word)%22"]
        var musicUrls:[NSURL!]!

        musicUrls = musicArray
            .map() { NSURL(string: $0) }
            .filter() { $0 != nil }
        
        for url in musicUrls {
            let destinationUrl = documentsUrl.URLByAppendingPathComponent(self.word+".mp3")
            if NSFileManager().fileExistsAtPath(destinationUrl.path!) {
                println("The file \"\(self.word).mp3\" already exists at path.")
            } else {
                println("Started downloading \"\(self.word).mp3\".")
                getAudioDataFromUrl(url) { data in
                    dispatch_async(dispatch_get_main_queue()) {
                        println("Finished downloading \"\(self.word).mp3\".")
                        println("Started saving \"\(self.word).mp3\".")
                        
                        if self.saveAudioData(data!, destination: documentsUrl.URLByAppendingPathComponent(self.word+".mp3") ) {
                            // do what ever if writeToURL was successful
                        } else {
                            println("The File \"\(self.word).mp3\" was not saved.")
                        }
                    }
                }
            }
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
