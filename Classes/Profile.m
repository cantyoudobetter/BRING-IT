//
//  Profile.m
//  Bring It
//
//  Created by Michael Bordelon on 4/18/10.
//  Copyright 2010 Bordelon iPhone. All rights reserved.
//

#import "Profile.h"
#import "BIUtility.h"

@implementation Profile

@synthesize profileID, sex, weightGoal,  startDate, birthDate, scheduleID, scheduleName, sexInt, userName, lossRate, bloggerUsername, bloggerPassword, bloggerAddress, bloggerLastUpdate;

- (void) dealloc {
	
	[sex release];
	[startDate release];
	[birthDate release];
	[scheduleName release];
	[userName release];
	[lossRate release];
	[bloggerUsername release];
	[bloggerPassword release];
	[bloggerAddress release];
	[bloggerLastUpdate release];
	[super dealloc];
	
}

- (id) init {
	[super init];
	dateFormat = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormat setDateStyle:NSDateFormatterShortStyle];
	//test
	
	if (sqlite3_open([[BIUtility getDBPath] UTF8String], &database) != SQLITE_OK) {
		sqlite3_close(database);
		NSAssert(0, @"Failed to opendatabase");
	}
	
	
	
	NSString *query = @"SELECT PROFILEID, SEX, WEIGHTGOAL, STARTDATE, BIRTHDATE, SCHEDULEID, USERNAME, LOSSRATE, BLOGGERLOGIN, BLOGGERPASSWORD, BLOGGERADDRESS, BLOGGERLASTUPDATE FROM PROFILE WHERE PROFILEID = 1";
	sqlite3_stmt *statement;
	
	if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
		while (sqlite3_step(statement) == SQLITE_ROW) {
			self.profileID = sqlite3_column_int(statement, 0);
			//char *rowData = (char *)sqlite3_column_text(statement, 1);
			//self.sex = [[NSString alloc] initWithUTF8String:rowData];
			sexInt = sqlite3_column_int(statement, 1);
			if (sexInt == 1) {
				self.sex = @"Male";
			} else {
				self.sex = @"Female";
			}
			self.weightGoal = sqlite3_column_int(statement, 2);
			self.startDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
			//NSString *TempStr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
			//[self setStartDate:[dateFormat dateFromString:TempStr]];
			//TempStr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
			self.birthDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
			//[self setBirthDate:[dateFormat dateFromString:TempStr]];
			self.scheduleID = sqlite3_column_int(statement, 5);
			self.userName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
			self.lossRate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
			self.bloggerUsername = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
			self.bloggerPassword = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
			self.bloggerAddress = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];;
			self.bloggerLastUpdate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];;
		} 	
		} 
	
	query = [NSString stringWithFormat:@"SELECT SCHEDULENAME FROM CWORKOUTCALENDAR WHERE SCHEDULEID = %d", self.scheduleID];
	sqlite3_reset(statement);
	
	if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
		while (sqlite3_step(statement) == SQLITE_ROW) {
			NSString *tempStr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
			self.scheduleName = tempStr;
			
		} 	
	} 
	
	
	
	sqlite3_finalize(statement);
		
	
	
	if(database) sqlite3_close(database);
	
	return self;

}
- (void) updateName:(NSString *)name {
	if (sqlite3_open([[BIUtility getDBPath] UTF8String], &database) != SQLITE_OK) {
		sqlite3_close(database);
		NSLog(@"Failed to opendatabase");
	}
	
	sqlite3_stmt *updateStmt;
	const char *sql = "UPDATE PROFILE SET USERNAME = ? WHERE PROFILEID = ?";
	if(sqlite3_prepare_v2(database, sql, -1, &updateStmt, NULL) != SQLITE_OK)
		NSAssert1(0, @"Error while creating update statement. '%s'", sqlite3_errmsg(database));
	sqlite3_bind_text(updateStmt, 1, [name UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_int(updateStmt, 2, self.profileID);
	
	if(SQLITE_DONE != sqlite3_step(updateStmt))
		NSAssert1(0, @"Error while updating. '%s'", sqlite3_errmsg(database));
	
	sqlite3_reset(updateStmt);
	
	if(database) sqlite3_close(database);
	
	
	
}

- (void) updateProfile {
	if (sqlite3_open([[BIUtility getDBPath] UTF8String], &database) != SQLITE_OK) {
		sqlite3_close(database);
		NSLog(@"Failed to opendatabase");
	}
	char *errMsg;

	NSDateFormatter *dF = [[[NSDateFormatter alloc] init] autorelease];
	[dF setDateStyle:NSDateFormatterShortStyle];
	
	//UPDATE STARTDATE
	//NSString *stDate = [dF stringFromDate:self.startDate];
	NSString *stDate = self.startDate;
	NSString *query = [NSString stringWithFormat:@"UPDATE PROFILE SET STARTDATE = '%@' WHERE PROFILEID = %d", stDate, self.profileID];
	if (sqlite3_exec(database, [query UTF8String], NULL, NULL, &errMsg) != SQLITE_OK) {
		NSAssert1(0, @"DB Error. '%s'", sqlite3_errmsg(database));
	}

	//UPDATE BIRTHDATE
	//stDate = [dF stringFromDate:self.birthDate];
	stDate = self.birthDate;
	
	query = [NSString stringWithFormat:@"UPDATE PROFILE SET BIRTHDATE = '%@' WHERE PROFILEID = %d", stDate, self.profileID];
	if (sqlite3_exec(database, [query UTF8String], NULL, NULL, &errMsg) != SQLITE_OK) {
		NSAssert1(0, @"DB Error. '%s'", sqlite3_errmsg(database));
	}

	//UPDATE SEX
	query = [NSString stringWithFormat:@"UPDATE PROFILE SET SCHEDULEID = %d WHERE PROFILEID = %d", self.scheduleID, self.profileID];
	if (sqlite3_exec(database, [query UTF8String], NULL, NULL, &errMsg) != SQLITE_OK) {
		NSAssert1(0, @"DB Error. '%s'", sqlite3_errmsg(database));
	}

	//UPDATE SCHEDULEID
	query = [NSString stringWithFormat:@"UPDATE PROFILE SET SEX = %d WHERE PROFILEID = %d", self.sexInt, self.profileID];
	if (sqlite3_exec(database, [query UTF8String], NULL, NULL, &errMsg) != SQLITE_OK) {
		NSAssert1(0, @"DB Error. '%s'", sqlite3_errmsg(database));
	}
	
	//UPDATE NAME
	//query = [NSString stringWithFormat:@"UPDATE PROFILE SET USERNAME = '%@' WHERE PROFILEID = %d", [self.userName UTF8String], self.profileID];
	//if (sqlite3_exec(database, [query UTF8String], NULL, NULL, &errMsg) != SQLITE_OK) {
	//	NSAssert1(0, @"DB Error. '%s'", sqlite3_errmsg(database));
	//}
	
	//UPDATE LOSSRATE
	query = [NSString stringWithFormat:@"UPDATE PROFILE SET LOSSRATE = '%@' WHERE PROFILEID = %d", self.lossRate, self.profileID];
	if (sqlite3_exec(database, [query UTF8String], NULL, NULL, &errMsg) != SQLITE_OK) {
		NSAssert1(0, @"DB Error. '%s'", sqlite3_errmsg(database));
	}
	//UPDATE BLOGGER USERNAME
	query = [NSString stringWithFormat:@"UPDATE PROFILE SET BLOGGERLOGIN = '%@' WHERE PROFILEID = %d", self.bloggerUsername, self.profileID];
	if (sqlite3_exec(database, [query UTF8String], NULL, NULL, &errMsg) != SQLITE_OK) {
		NSAssert1(0, @"DB Error. '%s'", sqlite3_errmsg(database));
	}
	
	//UPDATE BLOGGER PASSWORD
	query = [NSString stringWithFormat:@"UPDATE PROFILE SET BLOGGERPASSWORD = '%@' WHERE PROFILEID = %d",self.bloggerPassword, self.profileID];
	if (sqlite3_exec(database, [query UTF8String], NULL, NULL, &errMsg) != SQLITE_OK) {
		NSAssert1(0, @"DB Error. '%s'", sqlite3_errmsg(database));
	}
	
	//UPDATE BLOGGER Address
	query = [NSString stringWithFormat:@"UPDATE PROFILE SET BLOGGERADDRESS = '%@' WHERE PROFILEID = %d",self.bloggerAddress, self.profileID];
	if (sqlite3_exec(database, [query UTF8String], NULL, NULL, &errMsg) != SQLITE_OK) {
		NSAssert1(0, @"DB Error. '%s'", sqlite3_errmsg(database));
	}
	
	//UPDATE BLOGGER Last Update
	query = [NSString stringWithFormat:@"UPDATE PROFILE SET BLOGGERLASTUPDATE = '%@' WHERE PROFILEID = %d",self.bloggerLastUpdate, self.profileID];
	if (sqlite3_exec(database, [query UTF8String], NULL, NULL, &errMsg) != SQLITE_OK) {
		NSAssert1(0, @"DB Error. '%s'", sqlite3_errmsg(database));
	}
	//UPDATE Weight Goal Last Update
	query = [NSString stringWithFormat:@"UPDATE PROFILE SET WEIGHTGOAL = '%d' WHERE PROFILEID = %d",self.weightGoal, self.profileID];
	if (sqlite3_exec(database, [query UTF8String], NULL, NULL, &errMsg) != SQLITE_OK) {
		NSAssert1(0, @"DB Error. '%s'", sqlite3_errmsg(database));
	}
	
	if(database) sqlite3_close(database);

	[self updateName:self.userName];
	
}


@end