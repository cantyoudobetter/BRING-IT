//
//  RecordedMovesListViewController.h
//  bring-it
//
//  Created by Michael Bordelon on 9/1/10.
//  Copyright 2010 bordeloniphone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "BIUtility.h"
#import "MoveDetail.h"
#import "Move.h"
#import "Profile.h"
#import "GradientTableViewCell.h"
#import "MoveDetailListViewController.h"
#import "Bring_ItAppDelegate.h"

@interface RecordedMovesListViewController : UITableViewController {
	NSArray * moveList;

	
}
@property (nonatomic, retain) NSArray * moveList;
@end
