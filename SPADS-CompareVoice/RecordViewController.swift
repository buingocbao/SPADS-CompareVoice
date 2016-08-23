//
//  RecordViewController.swift
//  
//
//  Created by BBaoBao on 6/15/15.
//
//

import UIKit

class RecordedAudio:NSObject
{
    var title:String!
    var filePathURL:NSURL!
}

class RecordViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var SCSiriWareformView: SiriWaveformView!
    
    var recorder:AVAudioRecorder!
    var audioPlayer:AVAudioPlayer!
    var filePath:NSURL!
    var recordingName:String!
    var word:String = ""
    var percent:String!
    var recordedAudio:RecordedAudio!
    var isRecord:Bool = false
    var displayLink:CADisplayLink!
    
    let speechSynthesizer = AVSpeechSynthesizer()
    
    var backButton:MKButton = MKButton()
    
    @IBOutlet weak var btPause: MKButton!
    @IBOutlet weak var btRecord: MKButton!
    @IBOutlet weak var btRefresh: MKButton!
    @IBOutlet weak var btOk: MKButton!
    @IBOutlet weak var btCancel: MKButton!
    @IBOutlet weak var btPlay: MKButton!
    
    var settings : [NSString : NSNumber ] = [AVSampleRateKey : 44100.0,
        AVFormatIDKey : kAudioFormatAppleLossless,
        AVNumberOfChannelsKey : 2,
        AVEncoderAudioQualityKey : AVAudioQuality.Min.rawValue];
    
    var settings2 : [NSString : NSNumber] = [AVFormatIDKey: kAudioFormatLinearPCM,
        AVSampleRateKey: 44100.0,
        AVNumberOfChannelsKey: 2,
        AVLinearPCMBitDepthKey: 8,
        AVLinearPCMIsBigEndianKey: false,
        AVLinearPCMIsFloatKey: false,
        AVEncoderAudioQualityKey: AVAudioQuality.High.rawValue,
        AVEncoderBitRateKey: 96,
        AVEncoderBitDepthHintKey: 16,
        AVSampleRateConverterAudioQualityKey: AVAudioQuality.High.rawValue]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Test data
        percent = "0"
        
        // Record config
        btRecord.maskEnabled = false
        btRecord.backgroundAniEnabled = false
        btRecord.rippleLocation = .Center
        
        // Play config
        btPlay.enabled = false
        btPlay.alpha = 0
        btPlay.maskEnabled = false
        btPlay.backgroundAniEnabled = false
        btPlay.rippleLocation = .Center
        
        // Pause config
        btPause.enabled = false
        btPause.alpha = 0
        btPause.maskEnabled = false
        btPause.backgroundAniEnabled = false
        btPause.rippleLocation = .Center

        // Refresh config
        btRefresh.enabled = false
        btRefresh.alpha = 0
        btRefresh.maskEnabled = false
        btRefresh.backgroundAniEnabled = false
        btRefresh.rippleLocation = .Center
        
        // Ok config
        btOk.enabled = false
        btOk.alpha = 0
        btOk.maskEnabled = false
        btOk.backgroundAniEnabled = false
        btOk.rippleLocation = .Center
        
        // Cancel config
        btCancel.enabled = false
        btCancel.alpha = 0
        btCancel.maskEnabled = false
        btCancel.backgroundAniEnabled = false
        btCancel.rippleLocation = .Center
        
        // Add back button
        addBackButton()
        
        // Tut voice
        let speechUtterance = AVSpeechUtterance(string: "Hello, please hold Record button to starting Record your word, then release it to save")
        let voice = AVSpeechSynthesisVoice(language: "en-us")
        speechUtterance.voice = voice
        speechUtterance.rate = 0.1
        speechUtterance.pitchMultiplier = 1
        speechUtterance.volume = 1
        speechSynthesizer.speakUtterance(speechUtterance)
        
        displayLink = CADisplayLink(target: self, selector: Selector("updateMeters"))
        displayLink.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
        
        self.SCSiriWareformView.waveColor = UIColor.MKColor.Red
        self.SCSiriWareformView.primaryWaveLineWidth = 5.0
        self.SCSiriWareformView.secondaryWaveLineWidth = 1.0
    }
    
    // MARK: Add Back Button
    func addBackButton() {
        self.navigationItem.backBarButtonItem = nil;
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.hidesBackButton = true;
        
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
        speechSynthesizer.stopSpeakingAtBoundary(AVSpeechBoundary.Immediate)
        // Stop player
        if audioPlayer != nil {
            if audioPlayer.playing == true {
                audioPlayer.stop()
            }
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func updateMeters() {
        var normalizedValue:CGFloat = 0
        if isRecord {
            self.recorder.updateMeters()
            normalizedValue = CGFloat(pow(10, self.recorder.averagePowerForChannel(0)/20))
        } else {
            if self.audioPlayer != nil {
                self.audioPlayer.updateMeters()
                normalizedValue = CGFloat(pow(10, self.audioPlayer.averagePowerForChannel(0)/20))
            }
        }
        self.SCSiriWareformView.updateWithLevel(normalizedValue)
    }

    @IBAction func btRecord(sender: AnyObject) {
        //Get the place to store the recorded file in the app's memory
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask,true)[0] as! String
        
        //Name the file with date/time to be unique
        var currentDateTime=NSDate();
        var formatter = NSDateFormatter();
        formatter.dateFormat = "ddMMyyyy-HHmmss";
        recordingName = word+"-"+formatter.stringFromDate(currentDateTime)+"-"+percent+".wav"
        var pathArray = [dirPath, recordingName]
        filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        //Create a session
        var session=AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord,error:nil)
        
        //Create a new audio recorder
        recorder = AVAudioRecorder(URL: filePath, settings:nil, error:nil)
        isRecord = true
        speechSynthesizer.stopSpeakingAtBoundary(AVSpeechBoundary.Immediate)
        recorder.delegate = self
        recorder.meteringEnabled=true
        recorder.prepareToRecord()
        recorder.record()
    }
    
    @IBAction func btRecordRelease(sender: AnyObject) {
        isRecord = false
        // Stop record
        recorder.stop()
        
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
        
        UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.ShowHideTransitionViews, animations: {
            // Hide Record button
            self.btRecord.enabled = false
            self.btRecord.alpha = 0
            }, completion: { finished in
                // Show play button
                self.btPlay.enabled = true
                self.btPlay.alpha = 1
                // Show 3 bottom buttons
                self.btRefresh.enabled = true
                self.btRefresh.alpha = 1
                self.btCancel.enabled = true
                self.btCancel.alpha = 1
                self.btOk.enabled = true
                self.btOk.alpha = 1
        })
    }
    
    @IBAction func btPlayEvent(sender: AnyObject) {
        //Create a session
        var session=AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayback,error:nil)
        
        if let fileUrl = filePath {
            var alertSound = fileUrl
            println(fileUrl)
            
            var error:NSError?
            audioPlayer = AVAudioPlayer(contentsOfURL: alertSound, error: &error)
            audioPlayer.prepareToPlay()
            audioPlayer.meteringEnabled = true
            audioPlayer.play()
            audioPlayer.numberOfLoops = -1
        } else {
            println("file path is incorrect");
        }
        
        UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.ShowHideTransitionViews, animations: {
            // Hide play button
            self.btPlay.enabled = false
            self.btPlay.alpha = 0
            }, completion: { finished in
                // Show pause button
                self.btPause.enabled = true
                self.btPause.alpha = 1
        })
    }
    
    @IBAction func btPauseEvent(sender: AnyObject) {
        
        if audioPlayer.playing == true {
            audioPlayer.pause()
        }
        
        UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.ShowHideTransitionViews, animations: {
            // Hide pause button
            self.btPause.enabled = false
            self.btPause.alpha = 0
            }, completion: { finished in
                // Show play button
                self.btPlay.enabled = true
                self.btPlay.alpha = 1
        })
    }
    
    @IBAction func btRefreshEvent(sender: AnyObject) {
        isRecord = false
        // Stop player
        if audioPlayer != nil {
            if audioPlayer.playing == true {
                audioPlayer.stop()
            }
        }
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
        recorder = nil
        audioPlayer = nil
        // remove the deleted item from the model
        NSFileManager.defaultManager().removeItemAtURL(filePath, error: nil)
        
        UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.ShowHideTransitionViews, animations: {
            // Hide all buttons
            self.btPause.enabled = false
            self.btPause.alpha = 0
            self.btPlay.enabled = false
            self.btPlay.alpha = 0
            self.btRefresh.enabled = false
            self.btRefresh.alpha = 0
            self.btOk.enabled = false
            self.btOk.alpha = 0
            self.btCancel.enabled = false
            self.btCancel.alpha = 0
            }, completion: { finished in
                // Show pause button
                self.btRecord.enabled = true
                self.btRecord.alpha = 1
        })
    }
    
    @IBAction func btCheckEvent(sender: AnyObject) {
        // Stop player
        if audioPlayer != nil {
            if audioPlayer.playing == true {
                audioPlayer.stop()
            }
        }
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
        recorder = nil
        audioPlayer = nil
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func btCancelEvent(sender: AnyObject) {
        // Stop player
        if audioPlayer != nil {
            if audioPlayer.playing == true {
                audioPlayer.stop()
            }
        }
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
        recorder = nil
        audioPlayer = nil
        NSFileManager.defaultManager().removeItemAtURL(filePath, error: nil)
        println("Deleted")
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if flag {
            //Store in Model
            recordedAudio = RecordedAudio()
            recordedAudio.filePathURL = recorder.url
            recordedAudio.title = recorder.url.lastPathComponent
        } else {
            println("Recording not successful")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "VoiceSegue") {
            var infoView:InformationViewController = segue.destinationViewController as! InformationViewController
            infoView.navigationItem.backBarButtonItem = nil
            infoView.navigationItem.hidesBackButton = true
            infoView.navigationItem.leftBarButtonItem = nil
            infoView.navigationItem.title = ""
        }
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
        
        // Stop player
        if audioPlayer.playing == true {
            audioPlayer.stop()
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
