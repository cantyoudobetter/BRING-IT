//
//  PortionHistoryViewController.h
//  bring-it
//
//  Created by Michael Bordelon on 9/5/10.
//  Copyright 2010 bordeloniphone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BIUtility.h"

@interface PortionHistoryViewController : UITableViewController {
	NSArray * portionList;
	Nutrition * n;
	NSString * passedDate;
}

@property (nonatomic, retain) NSArray * portionList;
@property (nonatomic, retain) Nutrition * n;
@property (nonatomic,retain) NSString * passedDate;

@end
