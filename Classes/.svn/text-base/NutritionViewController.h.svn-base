//
//  SetupViewController.h
//  Bring It
//
//  Created by Michael Bordelon on 4/17/10.
//  Copyright 2010 Bordelon iPhone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>  
#import "Profile.h"
#import "BIUtility.h"
#import "FoodWebLookupViewController.h"
#import "Nutrition.h"
#import "GradientButton.h"
#import "NutritionComponentViewController.h"

@class BIUtility;
@class Profile;
@class DatePickerViewController;
@class SinglePickerViewController;

@interface NutritionViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> //<DatePickerDelegate> 
{
	IBOutlet UINavigationBar * viewNavigationBar;
	IBOutlet UITextField *searchTextField;
	IBOutlet UITextView *foodLog;
	IBOutlet UISlider *calSlider;
	IBOutlet UILabel *calLabel;
	IBOutlet UILabel *calTargetLabel;
	IBOutlet UILabel *viewTitle;
	IBOutlet GradientButton * nutButton;
	//IBOutlet  Button *cancelButton;
	NSInteger calTarget;
	Profile *p;
	NSInteger cals;
	BOOL editMode;
	NSString * passedDate;
	NSString * currentDate;
	
	//Nutrition * n;

}

@property (nonatomic, retain) UINavigationBar * viewNavigationBar;
@property (readwrite, nonatomic) NSInteger calTarget;
@property (retain, nonatomic) Profile *p;
@property (retain, nonatomic) UITextField *searchTextField;
@property (retain, nonatomic) UITextView *foodLog;
@property (retain, nonatomic) UILabel *calLabel;
@property (retain, nonatomic) UILabel *calTargetLabel;
@property (nonatomic, readwrite) NSInteger cals;
@property (nonatomic, readwrite) BOOL editMode;
@property (retain, nonatomic) NSString *passedDate;
@property (retain, nonatomic) NSString *currentDate;
//@property (nonatomic, retain) UIButton * cancelButton;

-(IBAction)saveButtonPressed:(id)sender;
-(IBAction)searchButtonPressed:(id)sender;
-(IBAction)upButtonPressed:(id)sender;
-(IBAction)downButtonPressed:(id)sender;
-(IBAction)cancelButtonPressed:(id)sender;
-(IBAction)nutButtonPressed:(id)sender;



//-(IBAction)calSliderChanged:(id)sender;

@end
