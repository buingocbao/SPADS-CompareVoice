//
//  SettingViewController.swift
//  SPADS-CompareVoice
//
//  Created by BBaoBao on 6/8/15.
//  Copyright (c) 2015 buingocbao. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var flagsCollectionView: UICollectionView!
    
    var popoverViewController : PopViewController?
    var backButton:MKButton = MKButton()
    
    var nationFlags = [
        "vn" : ["Viet Nam" : 1],
        "jp" : ["Japan" : 1],
        "us" : ["United State" : 4]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        flagsCollectionView.delegate = self
        flagsCollectionView.dataSource = self
        
        // Add back button
        addBackButton()

    }
    
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
        self.navigationController?.popViewControllerAnimated(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Config collectionview
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nationFlags.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SettingFlagsCell", forIndexPath: indexPath) as! SettingFlagsCollectionViewCell
        
        // Config cell
        cell.flagImage.image = UIImage(named: String(Array(nationFlags.keys)[indexPath.row]))
    return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        println("tapped")
        
        
        var bounds: CGRect = UIScreen.mainScreen().bounds
        var dvWidth:CGFloat = bounds.size.width
        var dvHeight:CGFloat = bounds.size.height
        
        var popoverContent = self.storyboard?.instantiateViewControllerWithIdentifier("PopViewController") as! UIViewController
        
        //self.popoverViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PopViewController") as? PopViewController
        //self.popoverViewController?.lbTest.text = String(indexPath.row)
        
        var cell = self.flagsCollectionView!.cellForItemAtIndexPath(indexPath) as! SettingFlagsCollectionViewCell
        
        var nav = UINavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = UIModalPresentationStyle.Popover
        var popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSizeMake(500 , 500)
        popover!.delegate = self
        popover!.sourceView = cell.flagImage
        popover!.sourceRect = CGRectMake(cell.frame.width/2, cell.frame.height - 35 ,1,1)

        self.presentViewController(nav, animated: true, completion: nil)
        
        // TODO: passing data
    }
    
    func adaptivePresentationStyleForPresentationController(
        controller: UIPresentationController) -> UIModalPresentationStyle {
            return .None
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
