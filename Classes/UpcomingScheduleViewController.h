//
//  UpcomingScheduleViewController.h
//  Bring It
//
//  Created by Michael Bordelon on 6/6/10.
//  Copyright 2010 Bordelon iPhone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Bring_ItAppDelegate.h"
#import "UACellBackgroundView.h"
#import "GradientTableViewCell.h"
#import "BIUtility.h"
#import "Profile.h"


@interface UpcomingScheduleViewController : UITableViewController 
<UITableViewDelegate, UITableViewDataSource>
{

	Profile * p;
	NSInteger scheduleDay;
	NSInteger woCount;
	NSMutableArray * dateList;
	
}
@property (nonatomic,readwrite) NSInteger scheduleDay;
@property (nonatomic,readwrite) NSInteger woCount;
@property (nonatomic,retain) NSMutableArray * dateList;

@end
