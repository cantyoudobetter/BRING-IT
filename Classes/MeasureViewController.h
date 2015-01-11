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
#import "CKSparkline.h"

@class BIUtility;
@class Profile;
@class DatePickerViewController;
@class SinglePickerViewController;

@interface MeasureViewController : UIViewController <UINavigationControllerDelegate, PickerDelegate>	//<DatePickerDelegate> 
{
	IBOutlet UINavigationBar * viewNavigationBar;
	//IBOutlet UITextField *startDate;
	IBOutlet UINavigationBar *navBar;
	IBOutlet UILabel *navTitle;
	Profile *p;
	NSString* startDate;
	NSString* birthDate;
	
	UIDatePicker *selectedDatePicker;
	NSInteger pickerType;
	IBOutlet UIButton *weightButton;
	IBOutlet UIButton *neckButton;
	IBOutlet UIButton *waistButton;
	IBOutlet UIButton *hipButton;
	IBOutlet UIButton *heightButton;
	IBOutlet UITextView *dataField;
	IBOutlet UIImageView *humanImage;
	NSString * passedDate;
	NSString * currentDate;
	BOOL editMode;
	
}

@property (retain, nonatomic) NSString *startDate;
@property (retain, nonatomic) NSString *birthDate;
@property (retain, nonatomic) Profile *p;
@property (retain, nonatomic) UIDatePicker *selectedDatePicker;
@property (readwrite, nonatomic) NSInteger pickerType;
@property (retain, nonatomic) UINavigationBar *navBar;
@property (retain, nonatomic) UIButton *weightButton;
@property (retain, nonatomic) UIButton *neckButton;
@property (retain, nonatomic) UIButton *waistButton;
@property (retain, nonatomic) UIButton *hipButton;
@property (retain, nonatomic) UIButton *heightButton;
@property (retain, nonatomic) UIImageView * humanImage;
@property (retain, nonatomic) NSString * passedDate;
@property (retain, nonatomic) NSString * currentDate;
@property (readwrite, nonatomic) BOOL editMode;


-(IBAction)weightButtonPressed:(id)sender;
-(IBAction)heightButtonPressed:(id)sender;
-(IBAction)neckButtonPressed:(id)sender;
-(IBAction)hipButtonPressed:(id)sender;
-(IBAction)waistButtonPressed:(id)sender;
-(NSString *)measureData;
-(void)updateUI;

@end
