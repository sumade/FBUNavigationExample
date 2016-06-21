//
//  LikeViewController.swift
//  NavigationExamples
//
//  Created by Sumeet Shendrikar on 6/20/16.
//  Copyright © 2016 Sumeet Shendrikar. All rights reserved.
//

import UIKit

class LikeViewController: UIViewController {

    // MARK: Properties
    
    // a label that we can use to display the callback type
    @IBOutlet weak var callbackTypeLabel: UILabel!

    // used to determine which callback type to use (delegate, closure, or notification)
    var callbackType: LikeSegueIdentifierEnum!
    
    // delegate
    weak var delegate : LikeDelegate?
    
    // closure handler: the type is "a function that takes an integer as argument and returns void"
    //      also, it's an optional property
    var closureHandler : ( (Int) -> Void)?
    
    // MARK: UIViewController events
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        callbackTypeLabel.text = callbackType.rawValue
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: Buttion Actions
    
    // function called when the user taps the like button
    @IBAction func didTapLike(sender: AnyObject) {
        // call the appropriate handler depending on which property is configured
        switch(callbackType){
            case .Delegate?:
                if let delly = delegate {
                    delly.addLikes(1)
                }
            case .Closure?:
                if let handler = closureHandler {
                    handler(1)
                }
            case .Notification?:
                // we post a notification event, but first configure a dictionary of data to pass to the notification event
                var selectionInfo: [NSObject : AnyObject] = [ : ]
                selectionInfo[LikeNotificationEventKey] = 1
                NSNotificationCenter.defaultCenter().postNotificationName(LikeNotificationEvent, object: self, userInfo: selectionInfo)
            default:
                print("!unknown callback type")
        }
        
    }
    
    // function called when the user taps the dismiss button
    @IBAction func didTapDismiss(sender: AnyObject) {
        // we dismiss this ViewController and return to whatever ViewController is at the top of the view stack
        dismissViewControllerAnimated(true, completion:nil)
    }

}
