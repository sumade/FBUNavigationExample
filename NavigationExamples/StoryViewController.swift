//
//  StoryViewController.swift
//  NavigationExamples
//
//  Created by Sumeet Shendrikar on 6/20/16.
//  Copyright © 2016 Sumeet Shendrikar. All rights reserved.
//

import UIKit

// enumeration of segue identifiers
enum LikeSegueIdentifierEnum: String {
    case Delegate = "likeDelegateSegue"
    case Closure = "likeClosureSegue"
    case Notification = "likeNotificationSegue"
}

// NSNotificationCenter events
let LikeNotificationEvent = "com.codepath.NavigationExamples.didLike"
let LikeNotificationEventKey = "com.codepath.NavigationExamples.likeCount"


// the protocol definition for our delegate
protocol LikeDelegate : class {
    func addLikes(numLikes: Int) -> Void
}

class StoryViewController: UIViewController {

    // MARK: Properties
    
    // the label that displays the number of likes
    @IBOutlet weak var likeNumberLabel: UILabel!

    // the number of likes for a story
    private var likeCount = 0 {
        // the didSet observer makes sure the label is always updated whenever the likeCount is updated
        didSet {
            likeNumberLabel.text = "\(likeCount)"
        }
    }
    
    // we need a property to store the notification subscription, so that we can
    //  remove it when the LikeViewController is dismissed. If we don't remove the subscription,
    //  we'll be registering a new subscription and our completion block will be called once for 
    //  each subscription registration. This means our completion block could be called multiple times.
    private var notificationObserver : NSObjectProtocol?
    
    // MARK: UIViewController events
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // since the view has appeared, let's use this opportunity to remove any existing subscription
        if let observer = self.notificationObserver {
            NSNotificationCenter.defaultCenter().removeObserver(observer)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let likeVC = segue.destinationViewController as? LikeViewController {
            if let id = LikeSegueIdentifierEnum(rawValue:segue.identifier!) {
                /*
                    each of the three buttons is tied to a different segue, so we have to determine which segue
                        was actually triggered. the logic here basically wraps the segue identifer in an enumeration,
                        which is just a reason for me to show off enumerations.
                    the important thing is that we determine which type of callback mechanism to use, and then configure
                        the destination view controller with the appropriate callback mechanism.
                */
                likeVC.callbackType = id
                switch(id) {
                    case .Delegate:
                        likeVC.delegate = self
                    case .Closure:
                        likeVC.closureHandler = {(numberOfLikes: Int) -> Void in
                            self.likeCount += numberOfLikes
                        }
                    case .Notification:
                        self.notificationObserver = NSNotificationCenter.defaultCenter().addObserverForName(LikeNotificationEvent, object:nil, queue: NSOperationQueue.mainQueue()) {
                            (notification: NSNotification!) -> Void in
                                // when the notification occurs, we pull the relevant data from the dictionary
                                if let userInfo = notification?.userInfo {
                                    if let likeCount = userInfo[LikeNotificationEventKey] as? Int {
                                        self.addLikes(likeCount)
                                    }
                            }
                        }
                }
            }
        }
    }

}

// MARK: LikeDelegate extension

extension StoryViewController : LikeDelegate {
    func addLikes(numLikes:Int) {
        likeCount += numLikes
    }
}
