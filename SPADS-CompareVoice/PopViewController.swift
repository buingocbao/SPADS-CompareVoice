//
//  PopViewController.swift
//  SPADS-CompareVoice
//
//  Created by BBaoBao on 6/8/15.
//  Copyright (c) 2015 buingocbao. All rights reserved.
//

import UIKit

class PopViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var downloadTableView: UITableView!
    var indicator:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    var timer:NSTimer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        downloadTableView.delegate = self
        downloadTableView.dataSource = self
        
        // Config Tableview
        downloadTableView.separatorColor = UIColor.blackColor()
        // Add blur effect to background image
        if (!UIAccessibilityIsReduceTransparencyEnabled()) {
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.ExtraLight)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            var bgImage = UIImageView(image: UIImage(named: "Cappuccino.jpg"))
            blurEffectView.frame = bgImage.frame
            bgImage.addSubview(blurEffectView)
            downloadTableView.backgroundView = bgImage
            
            //if you want translucent vibrant table view separator lines
            downloadTableView.separatorEffect = UIVibrancyEffect(forBlurEffect: blurEffect)
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
        return 50
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DownloadCell", forIndexPath: indexPath) as! UITableViewCell
        // Configure the cell...
        //cell.backgroundColor = UIColor(hex: 0xE0E0E0)
        //cell.backgroundColor = UIColor.clearColor()
        cell.textLabel?.text = "Package " + String(indexPath.row)
        cell.textLabel?.textColor = UIColor.MKColor.DeepPurple
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.separatorInset = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = UIEdgeInsetsZero
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //println(wavArray[indexPath.row])
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView,
        commitEditingStyle editingStyle: UITableViewCellEditingStyle,
        forRowAtIndexPath indexPath: NSIndexPath) {
            switch editingStyle {
            case .Delete:
                // remove the deleted item from the `UITableView`
                self.downloadTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            default:
                return
            }
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        // 1
        var downloadAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Download" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in

            self.indicator.frame = CGRectMake(0, 0, 40, 40)
            self.indicator.center = self.view.center
            self.indicator.backgroundColor = UIColor(red: 66, green: 66, blue: 66, alpha: 0.5)
            self.view.addSubview(self.indicator)
            self.indicator.bringSubviewToFront(self.view)
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            self.indicator.startAnimating()
            self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("updateProgress"), userInfo: nil, repeats: false)
        })
        
        downloadAction.backgroundColor = UIColor.MKColor.Blue

        return [downloadAction]
    }
    
    func updateProgress(){
        self.indicator.stopAnimating()
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
        
        headerLabel.text = "Download Packages"
        return sectionHeaderView
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }


}
