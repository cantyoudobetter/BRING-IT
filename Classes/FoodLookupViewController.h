//
//  FoodLookupViewController.h
//  bring-it
//
//  Created by Michael Bordelon on 8/24/10.
//  Copyright 2010 bordeloniphone. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "GradientButton.h"
#import "BIUtility.h"
#import "Profile.h"
#import "GradientTableViewCell.h"
#import "TextViewController.h"

@interface FoodLookupViewController : UITableViewController <UINavigationControllerDelegate, UIActionSheetDelegate> {

	NSArray * foodList;
	NSInteger portionTypeID;
	NSInteger selectedRow;
	NSInteger selectedSection;
	NSString * currentDate;
}
@property (nonatomic, retain) NSArray * foodList;
@property (nonatomic, readwrite) NSInteger portionTypeID;
@property (nonatomic, readwrite) NSInteger selectedRow;
@property (nonatomic, readwrite) NSInteger selectedSection;
@property (nonatomic, retain) NSString * currentDate;

@end
