//
//  HistoryMenuController.h
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
#import "HistoryViewController.h"
#import "HistoryCalendarEditController.h"
#import "BloggerUpdateListViewController.h"
#import "Bring_ItAppDelegate.h"
#import "WeightGraphController.h"
#import "BFGraphController.h"
#import "RecordedMovesListViewController.h"
#import <MessageUI/MessageUI.h>


@interface HistoryMenuController : UIViewController <UINavigationControllerDelegate> {
	//MoveDetailViewController *childController;
	
}
-(IBAction)historyListPressed:(id)sender;
-(IBAction)historyEditPressed:(id)sender;
-(IBAction)historyWeightChartPressed:(id)sender;
-(IBAction)historyBFChartPressed:(id)sender;
-(IBAction)moveChartPressed:(id)sender;
@end