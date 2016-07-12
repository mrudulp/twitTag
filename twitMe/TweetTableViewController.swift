//
//  TweetTableViewController.swift
//  twitMe
//
//  Created by Mrudul Pendharkar on 10/07/16.
//  Copyright © 2016 ShreeVed. All rights reserved.
//

import UIKit

class TweetTableViewController: UITableViewController, UITextFieldDelegate {

    var tweets = [[Tweet]]()
    @IBOutlet weak var fetchText: UITextField!{
        didSet{
            fetchText.delegate = self
            fetchText.text = searchText
        }
    }
    
    var searchText:String? = "#winter"{
        didSet{
            self.lastReq = nil
            //self.fetchText.text = searchText
            tweets.removeAll()
            tableView.reloadData()
            refresh()
        }
    }
    var lastReq:TwitterRequest?
    
    var nextSuccessfulReq:TwitterRequest?{
        if lastReq == nil{
            if searchText != nil {
                return TwitterRequest(search:searchText!,count:100)
            } else{
                return nil
            }
        } else {
           return lastReq!.requestForNewer
        }
    }
    
    @IBAction func refresh(sender:UIRefreshControl?){
        if searchText != nil{
            if let request = nextSuccessfulReq{
                request.fetchTweets({ (newTweets) -> Void in
                    //Successful Fetch, dispatch to main thread for rendering
                    dispatch_async(dispatch_get_main_queue(), { 
                        if newTweets.count > 0 {
                            self.lastReq = request
                            self.tweets.insert(newTweets, atIndex: 0)
                            self.tableView.reloadData()
                        }
                        sender?.endRefreshing()
                    })
                })

            }
        } else {
            sender?.endRefreshing()
        }
    }
    
    func refresh(){
        if refreshControl != nil{
            refreshControl?.beginRefreshing()
        }
        refresh(refreshControl)
    }
    private struct Storyboard{
        static let TweetCellIWithoutImage = "tweetCellIWithoutImage"
        static let TweetCellIWithImage = "tweetCellIWithImage"
    }
    // MARK: - View Controller LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Change status bar of navigation controller
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        //To automatically resize the row when image is present and not present
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        refresh()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return tweets.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweets[section].count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Configure the cell...
        let tweet = tweets[indexPath.section][indexPath.row]
        if tweet.media.first?.url != nil{
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.TweetCellIWithImage, forIndexPath: indexPath) as! TweetTableViewCell
            cell.tweet = tweet
            cell.setNeedsDisplay()
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.TweetCellIWithoutImage, forIndexPath: indexPath) as! TweetTableViewCell
            cell.tweet = tweet
            return cell
        }
    }
    
    //MARK: SearchField Delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == fetchText{
            textField.resignFirstResponder()
            searchText = textField.text
        }
        return true
    }
 

  }
