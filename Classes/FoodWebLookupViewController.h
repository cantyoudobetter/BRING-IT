//
//  FoodWebLookupViewController.h
//  Bring It
//
//  Created by Michael Bordelon on 5/15/10.
//  Copyright 2010 Bordelon iPhone. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FoodWebLookupViewController : UIViewController {

	IBOutlet UIWebView * webView;
	NSString * searchValue;
	
}
@property (nonatomic, retain) UIWebView * webView;
@property (nonatomic, retain) NSString * searchValue;
- (IBAction)doneButtonPressed:(id)sender;

@end
