//
//  MoveDetailViewController.h
//  Bring It
//
//  Created by Michael Bordelon on 4/23/10.
//  Copyright 2010 Bordelon iPhone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BIUtility.h"
#import "MoveDetail.h"
#import "Bring_ItAppDelegate.h"
#import "UACellBackgroundView.h"

@class BIUtility;

@interface MoveDetailViewController : UITableViewController {
	NSArray *detailListForMove;
	NSInteger woInstanceID;
	//NSInteger moveDetailID;
	NSInteger moveID;
	NSString *moveName;
	NSInteger repsCount;
	NSInteger puChairCount;
	NSInteger puNoChairCount;
	NSInteger time;
	NSInteger height;
	
	NSInteger weightCount;
	NSInteger effortID;
	MoveDetail *tmpMoveDetail;
	NSMutableArray * previousDetails;
	NSArray * moveList;
		BOOL editMode;
	NSString * passedDate;	
	NSString * currentDate;
}
@property (nonatomic, readwrite) BOOL editMode;
@property (nonatomic, readwrite) NSInteger woInstanceID;
//@property (nonatomic, readwrite) NSInteger moveDetailID;
@property (nonatomic, readwrite) NSInteger moveID;
@property (nonatomic, retain) NSArray *detailListForMove;
@property (nonatomic, retain) NSArray *moveList;
@property (nonatomic, copy) NSString *moveName;
@property (nonatomic, readwrite) NSInteger weightCount;
@property (nonatomic, readwrite) NSInteger repsCount;
@property (nonatomic, readwrite) NSInteger puChairCount;
@property (nonatomic, readwrite) NSInteger puNoChairCount;
@property (nonatomic, readwrite) NSInteger effortID;
@property (nonatomic, readwrite) NSInteger time;
@property (nonatomic, readwrite) NSInteger height;
@property (nonatomic, retain) MoveDetail *tmpMoveDetail;
@property (nonatomic, retain) NSMutableArray * previousDetails;
@property (nonatomic, retain) NSString *passedDate;
@property (nonatomic, retain) NSString *currentDate;
- (void) handleBack:(id)sender;
- (void)saveMoveDetail;
//-(NSString *)detailStringForType:(NSString *)type andDetail:(NSString *)detail;
@end
