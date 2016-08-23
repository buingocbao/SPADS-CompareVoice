//
//  WordDictViewController.swift
//  SPADS-CompareVoice
//
//  Created by BBaoBao on 6/8/15.
//  Copyright (c) 2015 buingocbao. All rights reserved.
//

import UIKit

class WordDictViewController: UIViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    @IBOutlet weak var alphabetCollectionView: UICollectionView!
    @IBOutlet weak var alphabetContentTableView: UITableView!
    
    var backButton:MKButton = MKButton()
    var countryCode:String = String()
    var letter:String = "A"
    var word:String = ""
    var filteredTableData = [String]()
    var resultSearchController = UISearchController()
    var tableData:NSMutableArray = NSMutableArray()
    
    var enAlphabet = ["A", "B", "C" , "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y" , "Z"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //

        // Do any additional setup after loading the view.
        
        alphabetCollectionView.delegate = self
        alphabetCollectionView.dataSource = self
        alphabetContentTableView.delegate = self
        alphabetContentTableView.dataSource = self
        
        addBackButton()
        println(countryCode)
        
        self.resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            
            self.alphabetContentTableView.tableHeaderView = controller.searchBar
            //self.resultSearchController.searchBar.hidden = false
            return controller
        })()
        
        // Reload
        alphabetContentTableView.reloadData()
        
    }

    func addTestData(){
        if tableData.count > 0 {
            tableData.removeAllObjects()
        }
        for index in 0...1000 {
            self.tableData.addObject("\(letter)"+"\(index)")
        }
    }
    
    // MARK: Add back button
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
    
    func textFieldShouldReturn(userText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true;
    }
    
    // MARK: Config collectionview
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return enAlphabet.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("AlphabetCell", forIndexPath: indexPath) as! AlphabetCollectionViewCell
        
        // Config cell
        cell.alphabetTitle.text = enAlphabet[indexPath.row]
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // TODO: select collectionview cell
        letter = enAlphabet[indexPath.row]
        // ADD TEST DATA
        addTestData()
        alphabetContentTableView.reloadData()
        //println(letter)
    }
    
    // MARK: Table view config
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.resultSearchController.active) {
            return self.filteredTableData.count
        }
        else {
            return tableData.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AlphabetContentCell", forIndexPath: indexPath) as! UITableViewCell
        
        if (self.resultSearchController.active) {
            cell.textLabel?.text = filteredTableData[indexPath.row]
            return cell
        }
        else {
            cell.textLabel?.text = "\(letter)"+"\(indexPath.row)"
            return cell
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.separatorInset = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = UIEdgeInsetsZero
    }
    

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (self.resultSearchController.active) {
            word = filteredTableData[indexPath.row]
        }
        else {
            word = tableData[indexPath.row] as! String
        }
        resultSearchController.active = false
        self.performSegueWithIdentifier("CompareSegue", sender: nil)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        filteredTableData.removeAll(keepCapacity: false)
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text)
        let array = (tableData as NSArray).filteredArrayUsingPredicate(searchPredicate)
        filteredTableData = array as! [String]
        
        self.alphabetContentTableView.reloadData()
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "CompareSegue") {
            var infoView:InformationViewController = segue.destinationViewController as! InformationViewController
            infoView.navigationItem.backBarButtonItem = nil
            infoView.navigationItem.hidesBackButton = true
            infoView.navigationItem.leftBarButtonItem = nil
            infoView.navigationItem.title = ""
            infoView.letter = letter
            infoView.word = word
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
