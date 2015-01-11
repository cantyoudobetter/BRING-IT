//
//  WorkoutViewController.h
//  Bring It
//
//  Created by Michael Bordelon on 4/17/10.
//  Copyright 2010 Bordelon iPhone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "NoteCell.h"
#import "BIUtility.h"
#import "Bring_ItAppDelegate.h"
#import "MoveListViewController.h"
#import "SinglePickerViewController.h"
#import "UACellBackgroundView.h"
#import "TextViewController.h"


@class MoveListViewController;
@class BIUtility;

@interface WorkoutViewController : UITableViewController <TextDelegate, PickerDelegate>{
	NSMutableArray *todaysWorkouts;
	IBOutlet NoteCell *woNoteCell;
	MoveListViewController *childController;
	NSInteger scheduleDay;
	NSInteger woIndex;
	IBOutlet UITableView *tableViewIB;
	BOOL editMode;
	NSString * passedDate;
	NSString * currentDate;
	UIToolbar * toolbar;
	BOOL removeEnabled;
	
	}

@property (nonatomic, retain) NSMutableArray *todaysWorkouts;
@property (nonatomic, retain) NoteCell *woNoteCell;
@property (nonatomic, readwrite) NSInteger woIndex;
@property (nonatomic, readwrite) BOOL editMode;
@property (nonatomic, readwrite) BOOL removeEnabled;
@property (nonatomic, retain) NSString * passedDate;
@property (nonatomic, retain) NSString * currentDate;

-(IBAction)toggleEdit:(id)sender;
-(IBAction)buttonAddWorkout:(id)sender;
-(IBAction)donePressed:(id)sender;

@end
