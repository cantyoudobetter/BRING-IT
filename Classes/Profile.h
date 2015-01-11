//
//  Profile.h
//  Bring It
//
//  Created by Michael Bordelon on 4/18/10.
//  Copyright 2010 Bordelon iPhone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface Profile : NSObject {

	NSInteger profileID;
	NSString *sex;
	NSInteger sexInt;
	NSInteger weightGoal;
	//NSDate *startDate;
	//NSDate *birthDate;
	NSString *startDate;
	NSString *birthDate;
	NSInteger scheduleID;
	NSString *scheduleName;
	sqlite3 *database;
	NSDateFormatter *dateFormat;
	NSString *userName;
	NSString *lossRate;
	NSString *bloggerUsername;
	NSString *bloggerPassword;
	NSString *bloggerAddress;
	NSString *bloggerLastUpdate;
	
	
}

@property (nonatomic, readwrite) NSInteger profileID;
@property (nonatomic, retain) NSString *sex;
@property (nonatomic, readwrite) NSInteger sexInt;
@property (nonatomic, readwrite) NSInteger weightGoal;
@property (nonatomic, readwrite) NSInteger scheduleID;
@property (nonatomic, retain) NSString *startDate;
@property (nonatomic, retain) NSString *birthDate;
@property (nonatomic, retain) NSString *scheduleName;
@property (nonatomic, retain) NSString *userName;
@property (nonatomic, retain) NSString *lossRate;
@property (nonatomic, retain) NSString *bloggerUsername;
@property (nonatomic, retain) NSString *bloggerPassword;
@property (nonatomic, retain) NSString *bloggerAddress;
@property (nonatomic, retain) NSString *bloggerLastUpdate;

- (void) updateProfile;

@end
