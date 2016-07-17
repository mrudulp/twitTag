//
//  TweetWithoutImgTableViewCell.swift
//  twitMe
//
//  Created by Mrudul Pendharkar on 11/07/16.
//  Copyright © 2016 ShreeVed. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var tweetUserName: UILabel!
    
    @IBOutlet weak var tweetCreatedAt: UILabel!
    
    @IBOutlet weak var tweetDetailText: UITextView!
    
    @IBOutlet weak var tweetImage: UIImageView!
    
    var tweet:Tweet!{
        didSet{
            self.updateUI()
        }
    }
    
    private func updateUI(){
        self.resetUI()
       // addTapRecogniser()
        if let tweet = self.tweet{
            var tweetText:String = tweet.text
            if self.tweetDetailText?.text != nil {
                for _ in tweet.media{
                    tweetText += "📷"
                }
            }
            
            let attributedTweetText = NSMutableAttributedString(string: tweetText)
            attributedTweetText.changeKeywordsColor(tweet.hashtags,color: indexedKeywordColor)
            attributedTweetText.changeKeywordsColor(tweet.urls, color: indexedKeywordColor)
            attributedTweetText.mutateKeywordsToHyperlinks(tweet.urls)
            attributedTweetText.changeKeywordsColor(tweet.userMentions, color: indexedKeywordColor)
            
            self.tweetDetailText.attributedText = attributedTweetText
            
            self.tweetUserName.text = "\(tweet.user)"
        
        fetchProfileImage()
        formatDateString()
        fetchMediaImage()
        }
        
    }
    
    func fetchMediaImage(){
        if let mediaUrl = tweet!.media.first?.url{
            let qos = QOS_CLASS_USER_INTERACTIVE
            let backgroundQ = dispatch_get_global_queue(qos, 0)
            dispatch_async(backgroundQ,{
                if let imageData = NSData(contentsOfURL: mediaUrl){
                    dispatch_async(dispatch_get_main_queue()){
                        if let image = UIImage(data:imageData){
                            self.tweetImage?.image = image
                        }
                    }
                }
            })
        }
    }
    
    func fetchProfileImage(){
        if let profileImageUrl = tweet!.user.profileImageURL{
            let qos = QOS_CLASS_USER_INTERACTIVE
            let backgroundQ = dispatch_get_global_queue(qos,0)
            dispatch_async(backgroundQ,{
                if let imageData = NSData(contentsOfURL: profileImageUrl)
                {
                    dispatch_async(dispatch_get_main_queue()){
                        if let image = UIImage(data:imageData){
                            self.userImage?.image = image
                        }
                    }
                }
            })
        }
    }
    
    func formatDateString(){
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.ShortStyle
        self.tweetCreatedAt?.text = formatter.stringFromDate(tweet!.created)
    }
    private func resetUI(){
        self.userImage?.image = nil
        self.tweetUserName?.text = nil
        self.tweetCreatedAt?.text = nil
        self.tweetDetailText?.text = nil
    }
    
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}

public var indexedKeywordColor = UIColor(red:85/255.0, green:172/255.0, blue:238/255.0,alpha:1)

private extension NSMutableAttributedString
{
    func changeKeywordsColor(keywords:[Tweet.IndexedKeyword],color:UIColor)
    {
        for keyword in keywords{
            addAttribute(NSForegroundColorAttributeName, value: color, range: keyword.nsrange)
        }
    }
    
    func mutateKeywordsToHyperlinks(keywords:[Tweet.IndexedKeyword])
    {
        for keyword in keywords{
            if let url:NSURL = NSURL.init(string: keyword.keyword){
            addAttribute(NSLinkAttributeName,value: url, range: keyword.nsrange)
            }
        }
    }
    
}