//
//  NutritionComponentViewController.h
//  bring-it
//
//  Created by Michael Bordelon on 8/16/10.
//  Copyright 2010 bordeloniphone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GradientButton.h"
#import "BIUtility.h"
#import "Profile.h"
#import "GradientTableViewCell.h"
#import "TextViewController.h"
#import "FoodLookupViewController.h"
#import "Bring_ItAppDelegate.h"
#import "PhaseLevelViewController.h"

@interface NutritionComponentViewController : UITableViewController <UINavigationControllerDelegate, TextDelegate, PhasePickerDelegate> {

	NSMutableArray * colorList;
	NSMutableArray * portionValues;
	NSArray * portionList;
	
	NSInteger calTarget;
	Profile *p;
	NSInteger cals;
	BOOL editMode;
	NSString * passedDate;
	NSString * currentDate;
	NSString * foodLog;
	Nutrition * n;
	NSInteger rowSelected;
	NSString * phase;
	NSString * level;
	UILabel * navTitle;
}

@property (nonatomic, retain) NSMutableArray * colorList;
@property (nonatomic, retain) NSMutableArray * portionValues;
@property (nonatomic, retain) NSArray * portionList;
@property (nonatomic, readwrite) NSInteger cals;
@property (nonatomic, readwrite) NSInteger calTarget;
@property (nonatomic, readwrite) NSInteger rowSelected;

@property (nonatomic, readwrite) BOOL editMode;
@property (retain, nonatomic) NSString *passedDate;
@property (retain, nonatomic) NSString *currentDate;
@property (retain, nonatomic) NSString *foodLog;
@property (retain, nonatomic) NSString *phase;
@property (retain, nonatomic) NSString *level;
@property (retain, nonatomic) Profile *p;
@property (retain, nonatomic) Nutrition *n;



@end