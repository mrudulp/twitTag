//
//  TweetWithoutImgTableViewCell.swift
//  twitMe
//
//  Created by Mrudul Pendharkar on 11/07/16.
//  Copyright © 2016 ShreeVed. All rights reserved.
//

import UIKit

class TweetWithoutImgTableViewCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var tweetUserName: UILabel!
    
    @IBOutlet weak var tweetCreatedAt: UILabel!
    
    @IBOutlet weak var tweetDetailText: UILabel!
    
    @IBOutlet weak var tweetImage: UIImageView!
    
    var tweet:Tweet!{
        didSet{
            self.updateUI()
        }
    }
    
    private func updateUI(){
        self.resetUI()
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
            attributedTweetText.changeKeywordsColor(tweet.userMentions, color: indexedKeywordColor)
            
            self.tweetDetailText.attributedText = attributedTweetText
            
            self.tweetUserName.text = "\(tweet.user)"
        }
    }
    
    private func resetUI(){
        self.userImage = nil
        self.tweetUserName?.text = nil
        self.tweetCreatedAt?.text = nil
        self.tweetDetailText?.text = nil
        self.tweetImage = nil
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
}