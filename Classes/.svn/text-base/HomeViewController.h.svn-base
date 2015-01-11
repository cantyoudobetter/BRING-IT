//
//  HomeViewController.h
//  Bring It
//
//  Created by Michael Bordelon on 4/17/10.
//  Copyright 2010 Bordelon iPhone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@class BIUtility;
@class Profile;

@interface HomeViewController : UIViewController {
	IBOutlet UILabel *dayLabel;
	
	sqlite3 *database;
	BIUtility *bi;
}

@property (nonatomic, retain) UILabel *dayLabel;
@property (nonatomic, retain) BIUtility *bi;

- (void)applicationWillTerminate:(NSNotification *)notification;
@end
