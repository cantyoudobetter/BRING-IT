//
//  MoveDetailListViewController.h
//  bring-it
//
//  Created by Michael Bordelon on 9/2/10.
//  Copyright 2010 bordeloniphone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "BIUtility.h"
#import "MoveDetail.h"
#import "Move.h"
#import "Profile.h"
#import "GradientTableViewCell.h"
#import "MoveGraphController.h"
#import "CKSparkline.h"

//@interface MoveDetailListViewController : UITableViewController {
@interface MoveDetailListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	//NSInteger moveID;
	NSString * moveName;
	NSMutableArray * detailList;
	NSMutableArray * dateList;
	NSMutableArray * exerciseList;
	IBOutlet UILabel *maxLabel;
	IBOutlet UILabel *minLabel;
	
}
@property (nonatomic, retain) NSString * moveName;
@property (nonatomic, retain) NSMutableArray * detailList;
@property (nonatomic, retain) NSMutableArray * dateList;
@property (nonatomic, retain) NSMutableArray * exerciseList;

@end
