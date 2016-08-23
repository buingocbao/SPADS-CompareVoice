//
//  LanguagePickViewController.swift
//  SPADS-CompareVoice
//
//  Created by BBaoBao on 6/4/15.
//  Copyright (c) 2015 buingocbao. All rights reserved.
//

import UIKit

class LanguagePickViewController: UIViewController , UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, BWWalkthroughViewControllerDelegate {

    @IBOutlet weak var languageCollectionView: UICollectionView!
    
    var addButton:MKButton = MKButton()
    var tutorialButton:MKButton = MKButton()
    
    var continents = [1 : "Africa", 2: "Europe", 3: "Asia", 4: "America", 5: "Antarctica", 6 : "Australia"]
    
    var nationFlags = [
        "vn" : ["Viet Nam" : 1],
        "jp" : ["Japan" : 1],
        "us" : ["United State" : 4]
    ]
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if !userDefaults.boolForKey("walkthroughPresented") {
            
            showWalkthrough()
            
            userDefaults.setBool(true, forKey: "walkthroughPresented")
            userDefaults.synchronize()
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        languageCollectionView.dataSource = self
        languageCollectionView.delegate = self
        
        // MARK: Config button
        addButtonMethod()
        addTutorialButton()
        
    }
    
    func addTutorialButton() {

        tutorialButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        tutorialButton.backgroundColor = UIColor.MKColor.Blue
        tutorialButton.cornerRadius = 20.0
        tutorialButton.backgroundLayerCornerRadius = 20.0
        tutorialButton.maskEnabled = false
        tutorialButton.circleGrowRatioMax = 1.75
        tutorialButton.rippleLocation = .Center
        tutorialButton.aniDuration = 0.85
        tutorialButton.layer.shadowOpacity = 0.75
        tutorialButton.layer.shadowRadius = 3.5
        tutorialButton.layer.shadowColor = UIColor.blackColor().CGColor
        tutorialButton.layer.shadowOffset = CGSize(width: 1.0, height: 5.5)
        tutorialButton.setTitle("T", forState: UIControlState.Normal)
        tutorialButton.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 20)
        tutorialButton.addTarget(self, action: "showWalkthrough", forControlEvents: UIControlEvents.TouchUpInside)
        
        var leftBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: tutorialButton)
        self.navigationItem.setLeftBarButtonItem(leftBarButtonItem, animated: false)
    }
    
    func showWalkthrough() {
        // Get view controllers and build the walkthrough
        let stb = UIStoryboard(name: "Walkthrough", bundle: nil)
        let walkthrough = stb.instantiateViewControllerWithIdentifier("walk") as! BWWalkthroughViewController
        let page_zero = stb.instantiateViewControllerWithIdentifier("walk0") as! UIViewController
        let page_one = stb.instantiateViewControllerWithIdentifier("walk1") as! UIViewController
        let page_two = stb.instantiateViewControllerWithIdentifier("walk2")as! UIViewController
        let page_three = stb.instantiateViewControllerWithIdentifier("walk3") as! UIViewController
        
        // Attach the pages to the master
        walkthrough.delegate = self
        walkthrough.addViewController(page_one)
        walkthrough.addViewController(page_two)
        walkthrough.addViewController(page_three)
        walkthrough.addViewController(page_zero)
        
        self.presentViewController(walkthrough, animated: true, completion: nil)

    }
    
    func addButtonMethod() {
        self.navigationItem.backBarButtonItem = nil;
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.hidesBackButton = true;
        
        addButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        addButton.backgroundColor = UIColor.MKColor.Green
        addButton.cornerRadius = 20.0
        addButton.backgroundLayerCornerRadius = 20.0
        addButton.maskEnabled = false
        addButton.circleGrowRatioMax = 1.75
        addButton.rippleLocation = .Center
        addButton.aniDuration = 0.85
        addButton.layer.shadowOpacity = 0.75
        addButton.layer.shadowRadius = 3.5
        addButton.layer.shadowColor = UIColor.blackColor().CGColor
        addButton.layer.shadowOffset = CGSize(width: 1.0, height: 5.5)
        addButton.setTitle("+", forState: UIControlState.Normal)
        addButton.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 20)
        addButton.addTarget(self, action: "backButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        
        var rightBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: addButton)
        self.navigationItem.setRightBarButtonItem(rightBarButtonItem, animated: false)
    }
    
    func backButtonClick(button: UIButton) {
        //TODO: add button event
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Walkthrough delegate -
    
    func walkthroughPageDidChange(pageNumber: Int) {
        print("Current Page \(pageNumber)")
    }
    
    func walkthroughCloseButtonPressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
    // MARK: Config collectionview
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nationFlags.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("FlagsCell", forIndexPath: indexPath) as! FlagsCollectionViewCell
        
        // Config cell
        cell.flagImage.image = UIImage(named: String(Array(nationFlags.keys)[indexPath.row]))
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 202, height: 150)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("WordPickSegue", sender: indexPath)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "WordPickSegue" {
            var wordDictView:WordDictViewController = segue.destinationViewController as! WordDictViewController
            wordDictView.countryCode = String(Array(nationFlags.keys)[sender!.row])
            wordDictView.navigationItem.backBarButtonItem = nil
            wordDictView.navigationItem.hidesBackButton = true
            wordDictView.navigationItem.leftBarButtonItem = nil
            wordDictView.navigationItem.title = ""
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
