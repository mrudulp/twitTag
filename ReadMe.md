# README.md

## Introduction:

* This project fetches tweeter data for given word/tag/user

![](./twitMe.gif)

## Learning Objective:

* Here the objective is primarily to demonstrate use of Table View for more complex use cases

## How to use:

* Open "twitMe" application

## Technical Highlights:

* Custom TableViewCell
* AutoLayout
* Asynchronous Programming for fetching data from internet
* NSDateFormatter
* TextField Delegate
* Pull To Refresh
* UITextView in a TableViewCell

## Top Tips discovered during implementation:

* Disabling ScrollViewEnabled helps UITextView to calculate its intrinsic contentsize.
* UITextLabels are not helpful for enabling link clicks. One needs to Use UITextView along with AttributedString
* One needs to set Image Height for making UIImageView to not expand infinitely
* Set a dummy Image to UIImageView in storyboard to make sure new image would be updated at runtime.

## Status:

* Complete.

## Desired Further Enhancement:

* Connect the app to download realtime twitter stream

## Notes:
* Icon downloaded from (http://www.myiconfinder.com/uploads/iconsets/624dc72b6deef6abddf29031c1ac7224.png)
* Gif created with (http://www.ezgif.com)

# Reference
* [UITextView & TableViews](http://candycode.io/self-sizing-uitextview-in-a-uitableview-using-auto-layout-like-reminders-app/)
* [Clickable URL](http://stackoverflow.com/questions/21629784/how-to-make-a-clickable-link-in-an-nsattributedstring-for-a)