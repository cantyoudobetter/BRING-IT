//
//  Profile.h
//  Bring It
//
//  Created by Michael Bordelon on 4/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.histedit.h>



@interface Profile : NSObject {

	NSInteger profileID;
	NSString *lastName;
	NSString *firstName;
	NSInteger dailyCaloricGoal;
//	NSDate startDate;
	BOOL autoUpload;
	
}

@property (nonatomic, readonly) NSInteger profileID;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSInteger dailyCaloricGoal;
//@property (nonatomic, copy) NSDate startDate;
@property (nonatomic, readwrite) BOOL autoUpload;

+ (void) getInitialDataToDisplay:(NSString *)dbPath;
+ (void) finalizeStatements;

- (id) initWithPrimaryKey:(NSInteger)pk;


@end
