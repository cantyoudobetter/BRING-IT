//
//  SetupViewController.h
//  Bring It
//
//  Created by Michael Bordelon on 4/17/10.
//  Copyright 2010 Bordelon iPhone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Profile.h"
#import "BIUtility.h"
#import "DatePickerViewController.h"
#import "SinglePickerViewController.h"
#import "TextFieldViewController.h"
#import "UACellBackgroundView.h"
#import "TextViewController.h"
//#import "BloggerViewController.h"
//#import "BloggerUpdateListViewController.h"
#import "UpcomingScheduleViewController.h"
#import "AboutViewController.h"
#import "MBProgressHUD.h"


@interface SetupViewController : UITableViewController 
<UINavigationControllerDelegate, TextDelegate, TextFieldDelegate, PickerDelegate, DatePickerDelegate> 
{
	
	//IBOutlet UITextField *startDate;
	//IBOutlet UINavigationBar *navBar;
	UILabel *navTitle;
	IBOutlet UITableView * tv;
	Profile *p;
	NSString* startDate;
	NSString* birthDate;
	UIDatePicker *selectedDatePicker;
	NSInteger pickerType;
		MBProgressHUD *HUD;
}

@property (retain, nonatomic) NSString *startDate;
@property (retain, nonatomic) NSString *birthDate;
@property (retain, nonatomic) Profile *p;
@property (retain, nonatomic) UIDatePicker *selectedDatePicker;
@property (readwrite, nonatomic) NSInteger pickerType;
//@property (retain, nonatomic) UINavigationBar *navBar;

-(void)update;


@end
