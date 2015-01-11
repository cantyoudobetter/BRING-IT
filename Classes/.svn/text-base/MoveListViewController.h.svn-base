//
//  MoveListViewController.h
//  Bring It
//
//  Created by Michael Bordelon on 4/22/10.
//  Copyright 2010 Bordelon iPhone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "BIUtility.h"
#import "Move.h"
#import "Bring_ItAppDelegate.h"
#import "MoveDetailViewController.h"
#import "UACellBackgroundView.h"
#import "GradientTableViewCell.h"

@class BIUtility;
@class MoveDetailViewController;

@interface MoveListViewController : UITableViewController 
	<UITableViewDelegate, UITableViewDataSource> {
	NSArray *moveListForWorkout;
	NSInteger workoutID;
	NSInteger woInstanceID;
	NSString *workoutName;
	MoveDetailViewController *childController;
	UIView *cellView;
	BOOL editMode;
		NSString * passedDate;	
		NSString * currentDate;

}
@property (nonatomic, readwrite) BOOL editMode;

@property (nonatomic, readwrite) NSInteger woInstanceID;
@property (nonatomic, readwrite) NSInteger workoutID;
@property (nonatomic, retain) NSArray *moveListForWorkout;
@property (nonatomic, retain) NSString *workoutName;
@property (nonatomic, retain) NSString *passedDate;
@property (nonatomic, retain) NSString *currentDate;
@property (nonatomic, retain) UIView *cellView;

@end

