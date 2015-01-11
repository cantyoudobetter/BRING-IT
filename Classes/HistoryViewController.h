//
//  HistoryViewController.h
//  Bring It
//
//  Created by Michael Bordelon on 4/17/10.
//  Copyright 2010 Bordelon iPhone. All rights reserved.
//



#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "BIUtility.h"
#import "History.h"
#import "Profile.h"
#import "UACellBackgroundView.h"
#import "GradientTableViewCell.h"
#import "MoveHistoryViewController.h"
#import "Bring_ItAppDelegate.h"
#import "PortionHistoryViewController.h"
#import <MessageUI/MessageUI.h>


@interface HistoryViewController : UITableViewController <UINavigationControllerDelegate, MFMailComposeViewControllerDelegate> {
	//MoveDetailViewController *childController;
	NSArray * dateList;
	NSMutableArray * historyList;
	NSMutableArray * tableIndex;
	Profile * p;
	
}
@property (nonatomic, retain) NSArray * dateList;
@property (nonatomic, retain) NSMutableArray * historyList;
@property (nonatomic, retain) NSMutableArray * tableIndex;

@end