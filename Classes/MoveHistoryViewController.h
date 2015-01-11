//
//  MoveHistoryViewController.h
//  bring-it
//
//  Created by Michael Bordelon on 7/19/10.
//  Copyright 2010 bordeloniphone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "BIUtility.h"
#import "History.h"
#import "MoveDetail.h"
#import "Move.h"
#import "Profile.h"
#import "UACellBackgroundView.h"
#import "GradientTableViewCell.h"
#import <MessageUI/MessageUI.h>

@interface MoveHistoryViewController : UITableViewController 
	<UITableViewDelegate, UITableViewDataSource> {
		NSArray * moveList;
		Profile * p;
		NSInteger woID;
		NSString * headerTitle;
		
	}
	@property (nonatomic, retain) NSArray * moveList;
	@property (nonatomic, readwrite) NSInteger woID;
	@property (nonatomic, retain) NSString * headerTitle;
	-(NSString *)detailStringForType:(NSString *)type andDetail:(NSString *)detail;
@end
