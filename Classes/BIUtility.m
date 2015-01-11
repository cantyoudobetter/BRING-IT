//
//  BIUtility.m
//  Bring It
//
//  Created by Michael Bordelon on 4/18/10.
//  Copyright 2010 Bordelon iPhone. All rights reserved.
//

#import "BIUtility.h"


static sqlite3 *database = nil;
static sqlite3 *database2 = nil;
//static sqlite3_stmt *deleteStmt = nil;
//static sqlite3_stmt *addStmt = nil;

@implementation BIUtility

- (id) init {
	[super init];
	return self;
}

+ (BOOL) connectedToInternet
{
    NSString *URLString = [[[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://www.google.com"]] autorelease];
    return ( URLString != NULL ) ? YES : NO;
}


+ (void) copyDatabaseForced {
	
	//Using NSFileManager we can perform many file system operations.
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	NSString *dbPath = [BIUtility getDBPath];
	BOOL success = [fileManager fileExistsAtPath:dbPath];
	
	if(success) {
		success = [fileManager removeItemAtPath:dbPath error:&error];
		if (!success)
			NSAssert1(0, @"Failed to DELETE database file with message '%@'.", [error localizedDescription]);
	}
	
	
	NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"BRINGIT.sqlite"];
	success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
		
	if (!success)
		NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
		
	[BIUtility setInitialData];
	[BIUtility updateDataIfNeeded];		
	//}
	
}


+ (void) copyDatabaseIfNeeded {
	
	//Using NSFileManager we can perform many file system operations.
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	NSString *dbPath = [BIUtility getDBPath];
	BOOL success = [fileManager fileExistsAtPath:dbPath];
	
	if(!success) {
		
		NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"BRINGIT.sqlite"];
		success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
		
		if (!success)
			NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
		
		[BIUtility setInitialData];
	}
	//[BIUtility updateDataIfNeeded];

}

+ (void) updateDB:(NSString *)data {
	NSArray  *lineArray = [data componentsSeparatedByString:@"\n"];
	//BOOL error = NO;
	if (sqlite3_open([[BIUtility getDBPath] UTF8String], &database2) != SQLITE_OK) {
		sqlite3_close(database2);
		NSLog(@"Failed to opendatabase in updateDB");
	}
	//NSLog(@"HERE1");
	//NSLog(@"Line Array Count: %d", [lineArray count]);
	char *errorMsg;
	sqlite3_exec(database2, "BEGIN TRANSACTION", NULL, NULL, &errorMsg);
	//sqlite3_busy_timeout(database, 5000);
	for(int k = 0; k < [lineArray count]; k++){
		NSString *loadSQLi = [lineArray objectAtIndex:k];
		
		//NSLog(@"HEREk:%d:  SQL: %@",k, loadSQLi);
		if (sqlite3_exec(database2, [loadSQLi UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
			NSLog(@"DB Error. '%s'", sqlite3_errmsg(database2));
		}
		
		//NSLog(@"HEREB-K:%d",k);

	}
	sqlite3_exec(database2, "END TRANSACTION", NULL, NULL, &errorMsg);

	//NSLog(@"HERE2");
	
	//if (!error) {
	
	sqlite3_stmt * nstatement = nil;	
	if(nstatement == nil) {
		const char *sql = "INSERT INTO LOOKUP(LOOKUPNAME, ITEM) Values(?,?)";
		if(sqlite3_prepare_v2(database2, sql, -1, &nstatement, NULL) != SQLITE_OK)
			//NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
			NSLog(@"Error Updating Lookup: %s", sqlite3_errmsg(database2));
	}
	sqlite3_bind_text(nstatement, 1, [@"BILATESTUPDATE" UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(nstatement, 2, [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"] UTF8String], -1, SQLITE_TRANSIENT);
	//NSLog(@"HERE3");
	
	if(SQLITE_DONE != sqlite3_step(nstatement))
		NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database2));
	//NSLog(@"HERE4");
	
	sqlite3_finalize(nstatement);
	//NSLog(@"HERE5");
	//}
	if(database2) sqlite3_close(database2);
	//NSLog(@"HERE6");
	
}


+ (void) updateDataFromWeb {
	NSString* updateURL = @"http://www.bordeloniphone.com/db/update.sql";
	NSLog(@"Checking update at : %@", updateURL);
	NSData* updateData = [NSData dataWithContentsOfURL: [NSURL URLWithString: updateURL] ];
	NSString * strData = [[NSString alloc] initWithData:updateData encoding:NSASCIIStringEncoding];
	NSLog(@"%@",strData);
	[BIUtility updateDB:strData];
	[strData release];
	//test change
	
}

+ (void) updateDataIfNeeded {
	
	if ([BIUtility updateNeeded]) {
		NSString* path = [[NSBundle mainBundle] pathForResource:@"update" 
														 ofType:@"sql"];
		NSString* content = [NSString stringWithContentsOfFile:path
													  encoding:NSUTF8StringEncoding
														 error:NULL];
		
		[BIUtility updateDB:content];					
		
		
	}
		
		
	
}

+ (BOOL) updateNeeded {

	
	NSString * version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
	BOOL found = NO;
	if (sqlite3_open([[BIUtility getDBPath] UTF8String], &database) != SQLITE_OK) {
		sqlite3_close(database);
		NSAssert(0, @"Failed to opendatabase");
	}
	
	NSString *query = [NSString stringWithFormat:@"SELECT ITEM FROM LOOKUP WHERE LOOKUPNAME = 'BILATESTUPDATE' and ITEM = '%@'", version];
	sqlite3_stmt *statement;
	if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
		while (sqlite3_step(statement) == SQLITE_ROW) {
			found = YES;
		}

		
	} 
	sqlite3_finalize(statement);	
	if(database) sqlite3_close(database);
	return !found;	
	
}



+ (void) setInitialData {
	if (sqlite3_open([[BIUtility getDBPath] UTF8String], &database) != SQLITE_OK) {
		sqlite3_close(database);
		NSLog(@"Failed to opendatabase");
	}
	char *errMsg;
	
	NSString *query = [NSString stringWithFormat:@"UPDATE PROFILE SET STARTDATE = '%@' WHERE PROFILEID = %d", [BIUtility todayDateString], 1];
	if (sqlite3_exec(database, [query UTF8String], NULL, NULL, &errMsg) != SQLITE_OK) {
		NSAssert1(0, @"DB Error. '%s'", sqlite3_errmsg(database));
		
	}
	
	if(database) sqlite3_close(database);
	
}

+ (NSString *) getDBPath {
	
	//Search for standard documents using NSSearchPathForDirectoriesInDomains
	//First Param = Searching the documents directory
	//Second Param = Searching the Users directory and not the System
	//Expand any tildes and identify home directories.
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths objectAtIndex:0];
	return [documentsDir stringByAppendingPathComponent:@"BRINGIT.sqlite"];
}


+ (NSInteger)age {
	Profile* p = [[Profile alloc] init];
	NSDate *today = [NSDate dateWithTimeIntervalSinceNow:0];	
	NSTimeInterval interval = [today timeIntervalSinceDate:[BIUtility dateFromString:p.birthDate]];
	NSInteger years = (interval/(60*60*24*365));
	[p release];
	return years;
}

//Returns the Day on the Schedule for Today
+ (NSString *)addToStart:(NSInteger)days startDate:(NSDate *)start {
	
	NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormat setDateFormat:@"EEEE', ' MMMM d"];
	
	NSDateComponents *components = [[[NSDateComponents alloc] init] autorelease];
	[components setDay:(days-1)];
	
	NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
	
	NSDate *newDate = [gregorian dateByAddingComponents:components toDate:start options:0];
	NSString * ret = [NSString stringWithFormat:@"Day: %d - %@", days, [dateFormat stringFromDate:newDate]];	
	
	return ret;
}
+ (NSDate *)addToDate:(NSInteger)days date:(NSDate *)start {
	
	NSDateComponents *components = [[[NSDateComponents alloc] init] autorelease];
	[components setDay:(days)];
	
	// create a calendar
	NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
	
	NSDate *newDate = [gregorian dateByAddingComponents:components toDate:start options:0];
	
	return newDate;
	
}


+ (NSInteger)scheduleDay {
	Profile* p = [[Profile alloc] init];
	//NSLog(@"Start Date From Profile: %@", p.startDate);
	NSDate *today = [NSDate dateWithTimeIntervalSinceNow:0];
	NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormat setDateStyle:NSDateFormatterShortStyle];
	
	//NSString *dateString = [self todayDateString];
	//NSLog(@"Today Date: %@", dateString);
	//dateString = [dateFormat stringFromDate:p.startDate];
	//dateString = p.startDate;
	//NSLog(@"Start Date: %@", dateString);
	
	NSTimeInterval interval = [today timeIntervalSinceDate:[BIUtility dateFromString:p.startDate]];
	NSInteger days = (interval/(60*60*24)+1);
	NSLog(@"Schedule Day: %d", days);
	[p release];
	//[dateFormat release];
	//NEED TO SET TO 1 FOR NOW UNTIL THE DB IS FULL LOADED
	return days;
	//return 1;
}

//Returns Today in a simple Text String
+ (NSString *)todayDateString {
	NSDate *today = [NSDate dateWithTimeIntervalSinceNow:0];
	NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormat setDateStyle:NSDateFormatterShortStyle];
	NSString *dateString = [dateFormat stringFromDate:today];
	return dateString;
}

+ (NSString *)dateStringForDate:(NSDate *)date {
	NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormat setDateStyle:NSDateFormatterShortStyle];
	NSString *dateString = [dateFormat stringFromDate:date];
	return dateString;
}
+ (NSDate *)dateFromString:(NSString *)date {
	NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormat setDateStyle:NSDateFormatterShortStyle];
	
	NSDate *dateFromString = [dateFormat dateFromString:date];
	return dateFromString;
}

+ (NSString *)formattedDateFromString:(NSString *)date {
	NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormat setDateStyle:NSDateFormatterShortStyle];
	
	NSDate *dateFromString = [dateFormat dateFromString:date];
	[dateFormat setDateStyle:NSDateFormatterMediumStyle];
	NSString * ret = [dateFormat stringFromDate:dateFromString];
	
	return ret;
}


//This is used if you change today's workouts or if you change the start date

+ (void)flushTodaysWorkouts {
	NSArray * woList = [[[NSArray alloc] initWithArray:[BIUtility todaysScheduledWorkouts]] retain];
	
	for (Workout *wo in woList) [BIUtility deleteWorkoutInstance:wo.woInstanceID];
	[woList release];
}

+ (void)deleteWorkoutInstance:(NSInteger)woInstanceID {

		if (sqlite3_open([[BIUtility getDBPath] UTF8String], &database) != SQLITE_OK) {
			sqlite3_close(database);
			NSLog(@"Failed to opendatabase");
		}
		char *errMsg;
		NSString *query;		
		query = [NSString stringWithFormat:@"DELETE FROM IWORKOUT WHERE WOINSTANCEID = %d", woInstanceID];

		if (sqlite3_exec(database, [query UTF8String], NULL, NULL, &errMsg) != SQLITE_OK) {
			NSAssert1(0, @"DB Error. '%s'", sqlite3_errmsg(database));
		
		}

		query = [NSString stringWithFormat:@"DELETE FROM IMOVEDETAIL WHERE WOINSTANCEID = %d", woInstanceID];
	
		if (sqlite3_exec(database, [query UTF8String], NULL, NULL, &errMsg) != SQLITE_OK) {
			NSAssert1(0, @"DB Error. '%s'", sqlite3_errmsg(database));
		
		}
	
		if(database) sqlite3_close(database);
	

}
+ (void)savePhase:(NSString *)phase andLevel:(NSString *)level {

	if (sqlite3_open([[BIUtility getDBPath] UTF8String], &database) != SQLITE_OK) {
		sqlite3_close(database);
		NSLog(@"Failed to opendatabase");
	}
	
	//DELETE ANY PREVIOUS PHASES AND LEVELS FOR THIS TYPE FROM TODAY	
	char *errMsg;
	NSString *query;		
	
	query = [NSString stringWithFormat:@"DELETE FROM LOOKUP WHERE LOOKUPNAME like 'PHASE' or LOOKUPNAME like 'LEVEL'"];
	
	if (sqlite3_exec(database, [query UTF8String], NULL, NULL, &errMsg) != SQLITE_OK) {
		//NSLog([NSString stringWithFormat:@"Failed to execute delect on IMEASURE.  Error: %s", sqlite3_errmsg(database)]);	
		NSAssert1(0, @"DB Error. '%s'", sqlite3_errmsg(database));
		
	}
	
	sqlite3_stmt *statement = nil;
	
	//INSERT NEW PHASE RECORD	
	if(statement == nil) {
		const char *sql = "INSERT INTO LOOKUP(LOOKUPNAME, ITEM) Values(?,?)";
		if(sqlite3_prepare_v2(database, sql, -1, &statement, NULL) != SQLITE_OK)
			NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
	}
	sqlite3_bind_text(statement, 1, [@"PHASE" UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(statement, 2, [phase UTF8String], -1, SQLITE_TRANSIENT);
	if(SQLITE_DONE != sqlite3_step(statement))
		NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
	sqlite3_finalize(statement);

	statement = nil;
	
	//INSERT NEW LEVEL RECORD	
	if(statement == nil) {
		const char *sql = "INSERT INTO LOOKUP(LOOKUPNAME, ITEM) Values(?,?)";
		if(sqlite3_prepare_v2(database, sql, -1, &statement, NULL) != SQLITE_OK)
			NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
	}
	sqlite3_bind_text(statement, 1, [@"LEVEL" UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(statement, 2, [level UTF8String], -1, SQLITE_TRANSIENT);
	if(SQLITE_DONE != sqlite3_step(statement))
		NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
	sqlite3_finalize(statement);
	
	if(database) sqlite3_close(database);
	
	
	
	
}

+ (NSString *)currentPhase {
	if (sqlite3_open([[BIUtility getDBPath] UTF8String], &database) != SQLITE_OK) {
		sqlite3_close(database);
		NSAssert(0, @"Failed to opendatabase");
	}
	
	NSString * ret = @"";
	
	NSString *query = @"SELECT ITEM FROM LOOKUP WHERE LOOKUPNAME like 'PHASE'";
	sqlite3_stmt *statement;
	
	if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
		while (sqlite3_step(statement) == SQLITE_ROW) {
			ret = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
		} 	
	} 
	
	sqlite3_finalize(statement);
	if(database) sqlite3_close(database);
	
	if ([ret length] == 0) {
		ret = @"1";
	}
	
	return ret;
	
}
+ (NSString *)currentLevel {
	if (sqlite3_open([[BIUtility getDBPath] UTF8String], &database) != SQLITE_OK) {
		sqlite3_close(database);
		NSAssert(0, @"Failed to opendatabase");
	}
	
	NSString * ret = @"";
	
	NSString *query = @"SELECT ITEM FROM LOOKUP WHERE LOOKUPNAME like 'LEVEL'";
	sqlite3_stmt *statement;
	
	if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
		while (sqlite3_step(statement) == SQLITE_ROW) {
			ret = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
		} 	
	} 
	
	sqlite3_finalize(statement);
	if(database) sqlite3_close(database);
	
	if ([ret length] == 0) {
		ret = @"1";
	}
	
	return ret;
	
}
+ (NSString *)levelForDate:(NSString *)date {
	if (sqlite3_open([[BIUtility getDBPath] UTF8String], &database) != SQLITE_OK) {
		sqlite3_close(database);
		NSAssert(0, @"Failed to opendatabase");
	}
	
	NSString * ret = @"";
	
	NSString *query = [NSString stringWithFormat:@"SELECT LEVEL FROM INUTRITION WHERE DATE like '%@'", date];
	sqlite3_stmt *statement;
	
	if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
		while (sqlite3_step(statement) == SQLITE_ROW) {
			ret = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
		} 	
	} 
	
	sqlite3_finalize(statement);
	if(database) sqlite3_close(database);
	
	if ([ret length] == 0) {
		ret = @"1";
	}
	
	return ret;
	
}
+ (NSString *)phaseForDate:(NSString *)date {
	if (sqlite3_open([[BIUtility getDBPath] UTF8String], &database) != SQLITE_OK) {
		sqlite3_close(database);
		NSAssert(0, @"Failed to opendatabase");
	}
	
	NSString * ret = @"";
	
	NSString *query = [NSString stringWithFormat:@"SELECT PHASE FROM INUTRITION WHERE DATE like '%@'", date];
	sqlite3_stmt *statement;
	
	if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
		while (sqlite3_step(statement) == SQLITE_ROW) {
			ret = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
		} 	
	} 
	
	sqlite3_finalize(statement);
	if(database) sqlite3_close(database);
	
	if ([ret length] == 0) {
		ret = @"1";
	}
	
	return ret;
	
}
+ (float)caloricFactor {
	if (sqlite3_open([[BIUtility getDBPath] UTF8String], &database) != SQLITE_OK) {
		sqlite3_close(database);
		NSAssert(0, @"Failed to opendatabase");
	}
	Profile* p = [[Profile alloc] init];
	float f=0;
	
	NSString *query = [NSString stringWithFormat:@"SELECT CALORICFACTOR FROM CWORKOUTCALENDAR WHERE SCHEDULEID = %d", p.scheduleID];
	sqlite3_stmt *statement;
	if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
		while (sqlite3_step(statement) == SQLITE_ROW) {
			NSString *caloricFactor = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
			f = [caloricFactor floatValue];
		}
		sqlite3_finalize(statement);
		
	} 
	
	[p release];
	if(database) sqlite3_close(database);
	return f;	
}

//Configuration Details For MoveID
+ (NSArray *)detailsForMove:(NSInteger)moveID {
	//open the database
	if (sqlite3_open([[BIUtility getDBPath] UTF8String], &database) != SQLITE_OK) {
		sqlite3_close(database);
		NSAssert(0, @"Failed to opendatabase");
	}
	
	//this is our detaillist array with all of the details for each move
	
	NSMutableArray *detailListForMove = [[NSMutableArray alloc] init];
	
	//char *errMsg;
	//reminder: replace this with a query to pull the right workout for the day	
	//NSString *query = [NSString stringWithFormat:@"SELECT MOVEDETAILID, MOVEID, MOVETYPECODE FROM CMOVEDETAIL WHERE MOVEID = %d", moveID];
	NSString *query = [NSString stringWithFormat:@"SELECT MOVEID, MOVEDETAILID, MOVETYPECODE FROM CMOVEDETAIL WHERE MOVEID = %d ORDER BY MOVEDETAILSEQNUM", moveID];
	sqlite3_stmt *statement;
	if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
		while (sqlite3_step(statement) == SQLITE_ROW) {
			MoveDetail  *md = [[[MoveDetail alloc] init]autorelease];
			md.moveID = sqlite3_column_int(statement, 0);
			md.moveDetailID = sqlite3_column_int(statement, 1);
			md.moveType = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
			[detailListForMove addObject:md];				
			//[md release];				
		}
		sqlite3_finalize(statement);
		
	} 
	if(database) sqlite3_close(database);
	//[moveListForWorkout release];
	
	return [detailListForMove autorelease];	
	

}





+ (NSArray *)allWorkouts {
	//open the database
	if (sqlite3_open([[BIUtility getDBPath] UTF8String], &database) != SQLITE_OK) {
		sqlite3_close(database);
		NSAssert(0, @"Failed to opendatabase");
	}
	
	//this is our workoutlist array with all of todays workouts
	NSMutableArray *woList = [[NSMutableArray alloc] init];
	
	//reminder: replace this with a query to pull the right workout for the day	
	NSString *query = [NSString stringWithFormat:@"SELECT WORKOUTNAME FROM CWORKOUTS"];
	sqlite3_stmt *statement;
	if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
		while (sqlite3_step(statement) == SQLITE_ROW) {
			NSString * wo = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
			[woList addObject:wo];				
		}
		sqlite3_finalize(statement);
		
	}
	if(database) sqlite3_close(database);
	
	return [woList autorelease];	

}

+ (NSInteger)moveDetailIDForMove:(NSInteger)moveID Type:(NSString *)moveTypeCode {
	if (sqlite3_open([[BIUtility getDBPath] UTF8String], &database) != SQLITE_OK) {
		sqlite3_close(database);
		NSAssert(0, @"Failed to opendatabase");
	}
	
	//Get MoveDetail Instance ID if it exists
	
	NSInteger moveDetailID=0;
	NSString *query = [NSString stringWithFormat:@"SELECT MOVEDETAILID FROM CMOVEDETAIL WHERE MOVEID = %d AND MOVETYPECODE = '%@' ", moveID, moveTypeCode];
	sqlite3_stmt *statement;
	if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
		while (sqlite3_step(statement) == SQLITE_ROW) {
			moveDetailID = sqlite3_column_int(statement, 0);
		}
		sqlite3_finalize(statement);
		
	}
	return moveDetailID;
	
}
+ (NSArray *)moveDetailValueForMoveID:(NSString *)moveName Type:(NSString *)moveTypeCode Date:(NSString *)date {
	if (sqlite3_open([[BIUtility getDBPath] UTF8String], &database) != SQLITE_OK) {
		sqlite3_close(database);
		NSAssert(0, @"Failed to opendatabase");
	}
	
	//Get MoveDetail Instance ID if it exists
	
	NSInteger value=0;
	NSMutableArray * ret = [[NSMutableArray alloc] init];
	NSString *query = [NSString stringWithFormat:@"SELECT DISTINCT imd.DETAILVALUE "
					   @"FROM IWORKOUT w, IMOVEDETAIL imd, CMOVEDETAIL cmd " 
					   @"WHERE w.WOINSTANCEID = imd.WOINSTANCEID and " 
					   @"w.DATE like '%@' and "
					   @"imd.MOVEDETAILID = cmd.MOVEDETAILID and "
					   @"cmd.MOVEID in (select MOVEID from CWORKOUTMOVES WHERE MOVENAME like '%@' and MOVETYPECODE like '%@') "
					   @"order by cmd.MOVEDETAILSEQNUM ",
					   date, moveName, moveTypeCode];
	
	sqlite3_stmt *statement;
	if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
		while (sqlite3_step(statement) == SQLITE_ROW) {
			value = sqlite3_column_int(statement, 0);
			[ret addObject:[NSNumber numberWithInteger:value]];
		}
		sqlite3_finalize(statement);
		
	}
	return [ret autorelease];
	
}

//This deletes the old detail record and creates a new move detail record.
+ (NSInteger)saveMoveDetailRecord:(MoveDetail *)md {
	
	if (sqlite3_open([[BIUtility getDBPath] UTF8String], &database) != SQLITE_OK) {
		sqlite3_close(database);
		NSAssert(0, @"Failed to opendatabase");
	}
	
	//Get MoveDetail Instance ID if it exists
	
	BOOL existingRecord = FALSE;
	NSInteger moveDetailInstanceID;
	NSString *query = [NSString stringWithFormat:@"SELECT ID FROM IMOVEDETAIL WHERE WOINSTANCEID = %d AND MOVEDETAILID = %d ", md.workoutID, md.moveDetailID];
	sqlite3_stmt *statement;
	if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
		while (sqlite3_step(statement) == SQLITE_ROW) {
			moveDetailInstanceID = sqlite3_column_int(statement, 0);
			existingRecord = TRUE;
		}
		sqlite3_finalize(statement);
		
	}
	
	//Delete the existing MoveDetail Record
	sqlite3_stmt *deleteStmt = nil;
	
	if (existingRecord) {
	
		if(deleteStmt == nil) {
			const char *sql = "DELETE FROM IMOVEDETAIL WHERE ID = ?";
			if(sqlite3_prepare_v2(database, sql, -1, &deleteStmt, NULL) != SQLITE_OK)
				NSAssert1(0, @"Error while creating delete statement. '%s'", sqlite3_errmsg(database));
		}
		
		//When binding parameters, index starts from 1 and not zero.
		sqlite3_bind_int(deleteStmt, 1, moveDetailInstanceID);
		
		if (SQLITE_DONE != sqlite3_step(deleteStmt))
			NSAssert1(0, @"Error while deleting. '%s'", sqlite3_errmsg(database));
		
		sqlite3_finalize(deleteStmt);
	}
	
	
	
	//Finally, add new move detail record 
	sqlite3_stmt *addStmt = nil;
	
	NSInteger newMoveDetailInstanceID;
	const char *sql = "INSERT INTO IMOVEDETAIL(MOVEDETAILID, WOINSTANCEID, DETAILVALUE) Values(?,?,?)";
	if(sqlite3_prepare_v2(database, sql, -1, &addStmt, NULL) == SQLITE_OK)
			//NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
	{
	sqlite3_bind_int(addStmt, 1, (int)md.moveDetailID);
	sqlite3_bind_int(addStmt, 2, (int)md.workoutID);
	//sqlite3_bind_text(addStmt, 3, [md.detailValue UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(addStmt, 3, [md.detailValue UTF8String], -1, SQLITE_TRANSIENT);
	}
	if(SQLITE_DONE != sqlite3_step(addStmt))
		NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
	else
		newMoveDetailInstanceID = sqlite3_last_insert_rowid(database);		

	
	//Reset the add statement.
	sqlite3_finalize(addStmt);
	

	if(database) sqlite3_close(database);
	
	return newMoveDetailInstanceID;
}

//RETURNS LIST OF WORKOUTS CONFIGURED FOR TODAY
+ (NSInteger)workoutCountInProgram {
	sqlite3_stmt *statement;
	
	//open the database
	if (sqlite3_open([[BIUtility getDBPath] UTF8String], &database) != SQLITE_OK) {
		sqlite3_close(database);
		NSAssert(0, @"Failed to opendatabase");
	}
	NSInteger woCount=0;
	Profile* p = [[Profile alloc] init];
	NSString * query = [NSString stringWithFormat:@"SELECT MAX(WORKOUTSEQUENCENUMBER) FROM CWORKOUTSEQUENCE WHERE SCHEDULEID = %d", p.scheduleID];
	[p release];
	if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
		while (sqlite3_step(statement) == SQLITE_ROW) {
			woCount = 	(sqlite3_column_int(statement, 0));
		}
		sqlite3_finalize(statement);
	} 
	if(database) sqlite3_close(database);
	//[scheduledWorkoutList release];
	return woCount;
	
}

+ (NSArray *)workoutsConfiguredForToday {
	
	NSMutableArray *scheduledWorkoutList = [[NSMutableArray alloc] init];
	NSString *query;
	
	sqlite3_stmt *statement;
	
	//open the database
	if (sqlite3_open([[BIUtility getDBPath] UTF8String], &database) != SQLITE_OK) {
		sqlite3_close(database);
		NSAssert(0, @"Failed to opendatabase");
	}
	
	Profile* p = [[Profile alloc] init];
	query = [NSString stringWithFormat:@"SELECT WORKOUTID FROM CWORKOUTSEQUENCE WHERE SCHEDULEID = %d AND WORKOUTSEQUENCENUMBER = %d", p.scheduleID, [BIUtility scheduleDay]];
	[p release];
	if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
		while (sqlite3_step(statement) == SQLITE_ROW) {
			Workout *wo = [[Workout alloc] init];
			wo.workoutID = 	(sqlite3_column_int(statement, 0));
			[scheduledWorkoutList addObject:wo];
			[wo release];
		}
		sqlite3_finalize(statement);
	} 
	if(database) sqlite3_close(database);
	//[scheduledWorkoutList release];
	//[query release];
	return [scheduledWorkoutList autorelease];
}



//RETURNS THE NUMBER OF WORKOUTS SCHEDULED FOR TODAY IN IWORKOUTS

+ (NSInteger)numberOfScheduledWorkouts {
	
	return [BIUtility numberOfScheduledWorkoutsForDate:[BIUtility todayDateString]];		
}

+ (NSInteger)numberOfScheduledWorkoutsForDate:(NSString *)date {
	NSString *query;
	NSInteger retRecords = 0;	
	sqlite3_stmt *statement;
	
	//open the database
	if (sqlite3_open([[BIUtility getDBPath] UTF8String], &database) != SQLITE_OK) {
		sqlite3_close(database);
		NSAssert(0, @"Failed to opendatabase");
	}
	
	query = [NSString stringWithFormat:@"SELECT IWORKOUT.WOINSTANCEID, IWORKOUT.WORKOUTID, CWORKOUTS.WORKOUTNAME FROM CWORKOUTS JOIN IWORKOUT ON IWORKOUT.WORKOUTID = CWORKOUTS.WORKOUTID AND DATE = '%@'", date];
	if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
		while (sqlite3_step(statement) == SQLITE_ROW) {
			retRecords++;
		}
		sqlite3_finalize(statement);
		
	} 
	if(database) sqlite3_close(database);
	
	//[query release];
	
	return retRecords;		
}

//+ (NSInteger)numberOfScheduledWorkouts {
//	return 99;
//}
+ (NSArray *)movesForWorkout:(NSInteger)woID {
	//open the database
	if (sqlite3_open([[BIUtility getDBPath] UTF8String], &database) != SQLITE_OK) {
		sqlite3_close(database);
		NSAssert(0, @"Failed to opendatabase");
	}
	
	//this is our workoutlist array with all of todays workouts
	
	NSMutableArray *moveListForWorkout = [[NSMutableArray alloc] init];
	
	
	//reminder: replace this with a query to pull the right workout for the day	
	NSString *query = [NSString stringWithFormat:@"SELECT MOVEID, WORKOUTID, MOVENAME FROM CWORKOUTMOVES WHERE WORKOUTID = %d ORDER BY MOVESEQUENCENUMBER", woID];
	sqlite3_stmt *statement;
	if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
		while (sqlite3_step(statement) == SQLITE_ROW) {
			Move  *move = [[[Move alloc] init] autorelease];
			move.moveID = sqlite3_column_int(statement, 0);
			move.workoutID = sqlite3_column_int(statement, 1);
			move.moveName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
			[moveListForWorkout addObject:move];				
			//[move release];				
		}
		sqlite3_finalize(statement);
		
	}
	if(database) sqlite3_close(database);
	//[moveListForWorkout release];
	
	return [moveListForWorkout autorelease];	
	
}


//RETURNS THE LIST OF WORKOUTS SCHEDULED FOR TODAY
+ (NSArray *)todaysScheduledWorkouts {

	return [BIUtility scheduledWorkoutsForDate:[BIUtility todayDateString]];		
	
	
}
+ (NSArray *)scheduledWorkoutsForDate:(NSString *)date {
	
	NSString *query;
	NSMutableArray *todaysWorkoutList = [[NSMutableArray alloc] init];	
	sqlite3_stmt *statement;
	
	//open the database
	if (sqlite3_open([[BIUtility getDBPath] UTF8String], &database) != SQLITE_OK) {
		sqlite3_close(database);
		NSAssert(0, @"Failed to opendatabase");
	}
	
	query = [NSString stringWithFormat:@"SELECT IWORKOUT.WOINSTANCEID, IWORKOUT.WORKOUTID, CWORKOUTS.WORKOUTNAME, IWORKOUT.NOTE, IWORKOUT.COMPLETE FROM CWORKOUTS JOIN IWORKOUT ON IWORKOUT.WORKOUTID = CWORKOUTS.WORKOUTID AND DATE = '%@'", date];
	if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
		while (sqlite3_step(statement) == SQLITE_ROW) {
			Workout *wo = [[[Workout alloc] init] autorelease];
			wo.woInstanceID = sqlite3_column_int(statement, 0);
			wo.workoutID = sqlite3_column_int(statement, 1);
			wo.workoutName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
			wo.woNote = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
			wo.woComplete = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)] integerValue];
			[todaysWorkoutList addObject:wo];				
			//[wo release];				
		}
		sqlite3_finalize(statement);
		
	} 
	if(database) sqlite3_close(database);
	
	
	return [todaysWorkoutList autorelease];		
	
	
}


//ADDS workout to IWORKOUT table for today if there is none

+ (void)addInitialWorkout:(Workout *)wo {
	
	[BIUtility addInitialWorkout:wo forDate:[BIUtility todayDateString]];
	
	
}

+ (void)addInitialWorkout:(Workout *)wo forDate:(NSString *)date {
	
	
	//NSInteger newID = 0;
	
	sqlite3_stmt *addStmt = nil;
	
	
	if (sqlite3_open([[BIUtility getDBPath] UTF8String], &database) != SQLITE_OK) {
		sqlite3_close(database);
		NSAssert(0, @"Failed to opendatabase");
	}
	
	if(addStmt == nil) {
		const char *sql = "INSERT INTO IWORKOUT(WORKOUTID, DATE, COMPLETE, NOTE) Values(?,?,?,?)";
		if(sqlite3_prepare_v2(database, sql, -1, &addStmt, NULL) != SQLITE_OK)
			NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
	}
	
	//sqlite3_bind_double(addStmt, 2, [price doubleValue]);
	sqlite3_bind_int(addStmt, 1, (int)wo.workoutID);
	sqlite3_bind_text(addStmt, 2, [date UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(addStmt, 3, [@"0" UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(addStmt, 4, [@"" UTF8String], -1, SQLITE_TRANSIENT);
	
	if(SQLITE_DONE != sqlite3_step(addStmt))
		NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
	
	//Reset the add statement.
	sqlite3_finalize(addStmt);
	if(database) sqlite3_close(database);
	
	
}




+ (BOOL)detailsRecordedForMove:(NSInteger)moveID forDate:(NSString *)woDate{
	
	//NSString *detailRecord = @"";
	NSString *query;
	sqlite3_stmt *statement;
	BOOL ret = NO;
	
	//open the database
	if (sqlite3_open([[BIUtility getDBPath] UTF8String], &database) != SQLITE_OK) {
		sqlite3_close(database);
		NSAssert(0, @"Failed to opendatabase");
	}
	
	query = [NSString stringWithFormat:@"SELECT DETAILVALUE, MOVETYPECODE " 
										"FROM IMOVEDETAIL imd, IWORKOUT w, CMOVEDETAIL cmd WHERE "
										"w.DATE = '%@' AND "
										"w.WOINSTANCEID = imd.WOINSTANCEID AND "
										"imd.MOVEDETAILID = cmd.MOVEDETAILID AND "
										"cmd.MOVEID = %d" , woDate, moveID];
	if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
		while (sqlite3_step(statement) == SQLITE_ROW) {
			ret = YES;
			//NSString * tmpValue = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
			//NSString * tmpType = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
			
			//detailRecord = [NSString stringWithFormat:@"%@%@:%@ ", detailRecord, tmpType, tmpValue];
		}
		sqlite3_finalize(statement);
		
	} 
	
	
	
	
	if(database) sqlite3_close(database);
	
	
	return ret;	
	
	
}

+ (NSInteger)moveIDForMoveName:(NSString *)moveName {
	NSString *query;
	NSInteger ret;
	sqlite3_stmt *statement;
	
	//open the database
	if (sqlite3_open([[BIUtility getDBPath] UTF8String], &database) != SQLITE_OK) {
		sqlite3_close(database);
		NSAssert(0, @"Failed to opendatabase");
	}
	
	query = [NSString stringWithFormat:@"SELECT MOVEID FROM CWORKOUTMOVES WHERE MOVENAME like '%@'", moveName];
	if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
		while (sqlite3_step(statement) == SQLITE_ROW) {
			ret = sqlite3_column_int(statement, 0);
		}
		sqlite3_finalize(statement);
		
	} 
	if(database) sqlite3_close(database);
	
	//[query release];
	
	return ret;		
}



+ (NSArray *)recordedMoves {
	NSString *query;
	NSMutableArray *moveList = [[NSMutableArray alloc] init];	
	sqlite3_stmt *statement;
	
	//open the database
	if (sqlite3_open([[BIUtility getDBPath] UTF8String], &database) != SQLITE_OK) {
		sqlite3_close(database);
		NSAssert(0, @"Failed to opendatabase");
	}
	
	query = @"SELECT DISTINCT cwm.MOVENAME "
				@"FROM IMOVEDETAIL imd, IWORKOUT w, CMOVEDETAIL cmd, CWORKOUTMOVES cwm WHERE " 
				@"imd.MOVEDETAILID = cmd.MOVEDETAILID AND " 
				@"cmd.MOVEID = cwm.MOVEID AND "
				@"cwm.WORKOUTID = w.WORKOUTID "
				@"ORDER BY cwm.MOVENAME";
	
	if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
		while (sqlite3_step(statement) == SQLITE_ROW) {
			[moveList addObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];				
		}
		sqlite3_finalize(statement);		
	} 
	if(database) sqlite3_close(database);
	
	
	return [moveList autorelease];	
}

// FIGURE OUT THE DETAIL VALUE FOR THE LAST WORKOUT.  IF THERE IS NOT ONE, USE A DEFAULT.
+ (NSString *)lastRecordForMoveDetail:(NSInteger)moveDetailID {

	NSString *detailRecord;
	NSString *query;
	sqlite3_stmt *statement;
	NSInteger rows = 0;
	
	
	//open the database
	if (sqlite3_open([[BIUtility getDBPath] UTF8String], &database) != SQLITE_OK) {
		sqlite3_close(database);
		NSAssert(0, @"Failed to opendatabase");
	}
	
	query = [NSString stringWithFormat:@"SELECT DETAILVALUE FROM IMOVEDETAIL WHERE MOVEDETAILID = %d "
										@"AND WOINSTANCEID = (SELECT MAX(WOINSTANCEID) "
										@"FROM IMOVEDETAIL WHERE MOVEDETAILID = %d)", moveDetailID, moveDetailID];
	if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
		while (sqlite3_step(statement) == SQLITE_ROW) {
			rows++;
			detailRecord = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
		}
		sqlite3_finalize(statement);
		
	} 
	
	
	if (rows == 0) {
		detailRecord = @"";
		
		
	}
	
	
	
	if(database) sqlite3_close(database);
	
	
	return detailRecord;	

}
+ (NSString *)recordForMoveDetail:(NSInteger)moveDetailID date:(NSString *)d {
	
	NSString *detailRecord;
	NSString *query;
	sqlite3_stmt *statement;
	NSInteger rows = 0;
	
	
	//open the database
	if (sqlite3_open([[BIUtility getDBPath] UTF8String], &database) != SQLITE_OK) {
		sqlite3_close(database);
		NSAssert(0, @"Failed to opendatabase");
	}
	
	query = [NSString stringWithFormat:@"SELECT DETAILVALUE FROM IMOVEDETAIL m, IWORKOUT w "
			 @"WHERE m.MOVEDETAILID = %d "
			 @"AND w.WOINSTANCEID = m.WOINSTANCEID "
			 @"AND w.DATE like '%@' ", moveDetailID, d];
	if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
		while (sqlite3_step(statement) == SQLITE_ROW) {
			rows++;
			detailRecord = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
		}
		sqlite3_finalize(statement);
		
	} 
	
	
	if (rows == 0) {
		detailRecord = @"";
		
		
	}
	
	
	
	if(database) sqlite3_close(database);
	
	
	return detailRecord;	
	
}

+ (NSArray *)configuredPrograms {
	NSString *query;
	NSMutableArray *programList = [[NSMutableArray alloc] init];	
	sqlite3_stmt *statement;
	
	//open the database
	if (sqlite3_open([[BIUtility getDBPath] UTF8String], &database) != SQLITE_OK) {
		sqlite3_close(database);
		NSAssert(0, @"Failed to opendatabase");
	}
	
	query = @"SELECT SCHEDULEID, SCHEDULENAME FROM CWORKOUTCALENDAR ORDER BY SCHEDULEID";
	if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
		while (sqlite3_step(statement) == SQLITE_ROW) {
			[programList addObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)]];				
		}
		sqlite3_finalize(statement);		
	} 
	if(database) sqlite3_close(database);
	
	
	return [programList autorelease];	
}

+ (NSArray *)MeasureDateListForType:(NSString *)type {
	NSString *query;
	NSMutableArray *dateList = [[NSMutableArray alloc] init];	
	sqlite3_stmt *statement;
	
	//open the database
	if (sqlite3_open([[BIUtility getDBPath] UTF8String], &database) != SQLITE_OK) {
		sqlite3_close(database);
		NSAssert(0, @"Failed to opendatabase");
	}
	
	query = [NSString stringWithFormat:@"SELECT DISTINCT DATE FROM IMEASURE WHERE TYPE = '%@'", type];
	if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
		while (sqlite3_step(statement) == SQLITE_ROW) {
			[dateList addObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];				
		}
		sqlite3_finalize(statement);		
	} 
	if(database) sqlite3_close(database);
	
	
	return [dateList autorelease];	
	
}
+ (NSArray *)MeasureDateList {
	NSString *query;
	NSMutableArray *dateList = [[NSMutableArray alloc] init];	
	sqlite3_stmt *statement;
	
	//open the database
	if (sqlite3_open([[BIUtility getDBPath] UTF8String], &database) != SQLITE_OK) {
		sqlite3_close(database);
		NSAssert(0, @"Failed to opendatabase");
	}
	
	query = @"SELECT DISTINCT DATE FROM IMEASURE";
	if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
		while (sqlite3_step(statement) == SQLITE_ROW) {
			[dateList addObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];				
		}
		sqlite3_finalize(statement);		
	} 
	if(database) sqlite3_close(database);
	
	
	return [dateList autorelease];	
	
}
+ (NSArray *)MoveDateListForMoveID:(NSString *)moveName andMoveType:(NSString *)moveType {
	NSString *query;
	NSMutableArray *dateList = [[NSMutableArray alloc] init];	
	sqlite3_stmt *statement;
	
	//open the database
	if (sqlite3_open([[BIUtility getDBPath] UTF8String], &database) != SQLITE_OK) {
		sqlite3_close(database);
		NSAssert(0, @"Failed to opendatabase");
	}
	query = [NSString stringWithFormat:@"SELECT distinct w.DATE "
			 @"FROM IWORKOUT w, CMOVEDETAIL cmd, IMOVEDETAIL imd "
			 @"WHERE w.WOINSTANCEID = imd.WOINSTANCEID and "
			 @"imd.MOVEDETAILID = cmd.MOVEDETAILID and "
			 @"cmd.MOVEID in (select MOVEID from CWORKOUTMOVES WHERE MOVENAME like '%@' and MOVETYPECODE like '%@') "
			 , moveName, moveType];
	
	
	if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
		while (sqlite3_step(statement) == SQLITE_ROW) {
			NSString * dt = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
			[dateList addObject:dt];				
		}
		sqlite3_finalize(statement);		
	} 
	if(database) sqlite3_close(database);
	
	
	return [dateList autorelease];	
	
}


+ (NSString *)latestMeasurement:(NSString *)measureType;
{
	NSString *detailRecord;
	NSString *query;
	sqlite3_stmt *statement;
	NSInteger rows = 0;
	
	
	//open the database
	if (sqlite3_open([[BIUtility getDBPath] UTF8String], &database) != SQLITE_OK) {
		sqlite3_close(database);
		NSAssert(0, @"Failed to opendatabase");
	}
	
	query = [NSString stringWithFormat:@"SELECT VALUE FROM IMEASURE WHERE TYPE = '%@' AND ID = (SELECT MAX(ID) FROM IMEASURE WHERE TYPE = '%@')", measureType, measureType];
	if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
		while (sqlite3_step(statement) == SQLITE_ROW) {
			rows++;
			detailRecord = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
		}
		sqlite3_finalize(statement);
		
	} 
	
	
	if (rows == 0) {
			detailRecord = nil;		
	}
	
	
	
	if(database) sqlite3_close(database);
	
	
	return detailRecord;		
	
}
+ (NSString *)latestMeasurement:(NSString *)measureType forDate:(NSString *)date latest:(BOOL)latest;
{
	NSString *detailRecord = @"";
	NSString *query;
	sqlite3_stmt *statement;
	NSInteger rows = 0;
	
	
	//open the database
	if (sqlite3_open([[BIUtility getDBPath] UTF8String], &database) != SQLITE_OK) {
		sqlite3_close(database);
		NSAssert(0, @"Failed to opendatabase");
	}
	if (!latest) {
		query = [NSString stringWithFormat:@"SELECT VALUE FROM IMEASURE WHERE TYPE = '%@' AND ID = (SELECT MAX(ID) FROM IMEASURE WHERE TYPE = '%@')", measureType, measureType];
	} else {
		query = [NSString stringWithFormat:@"SELECT VALUE FROM IMEASURE WHERE TYPE = '%@' AND DATE = '%@'", measureType, date];
	}

	if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
		while (sqlite3_step(statement) == SQLITE_ROW) {
			rows++;
			detailRecord = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
		}
		sqlite3_finalize(statement);
		
	} 
	
	
	if (rows == 0) {
		detailRecord = nil;		
	}
	
	
	
	if(database) sqlite3_close(database);
	
	
	return detailRecord;		
	
}



+ (void)saveMeasurement:(NSString *)measureType withValue:(NSString *)measureValue forDate:(NSString *)date;
{
	if (sqlite3_open([[BIUtility getDBPath] UTF8String], &database) != SQLITE_OK) {
		sqlite3_close(database);
		NSLog(@"Failed to opendatabase");
	}
	
//DELETE ANY PREVIOUS MEASURES FOR THIS TYPE FROM TODAY	
	char *errMsg;
	NSString *query;		
	
	query = [NSString stringWithFormat:@"DELETE FROM IMEASURE WHERE DATE = '%@' and TYPE = '%@'", date, measureType];
	
	if (sqlite3_exec(database, [query UTF8String], NULL, NULL, &errMsg) != SQLITE_OK) {
		//NSLog([NSString stringWithFormat:@"Failed to execute delect on IMEASURE.  Error: %s", sqlite3_errmsg(database)]);	
		NSAssert1(0, @"DB Error. '%s'", sqlite3_errmsg(database));

	}

	sqlite3_stmt *statement = nil;
	
//INSERT NEW MEASURE RECORD	
	if(statement == nil) {
		const char *sql = "INSERT INTO IMEASURE(TYPE, VALUE, DATE) Values(?,?,?)";
		if(sqlite3_prepare_v2(database, sql, -1, &statement, NULL) != SQLITE_OK)
			NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
	}
	
	//sqlite3_bind_double(addStmt, 2, [price doubleValue]);
	sqlite3_bind_text(statement, 1, [measureType UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(statement, 2, [measureValue UTF8String], -1, SQLITE_TRANSIENT);
	NSString *today = date;
	sqlite3_bind_text(statement, 3, [today UTF8String], -1, SQLITE_TRANSIENT);
	
	if(SQLITE_DONE != sqlite3_step(statement))
		NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
	
	//Reset the add statement.
	sqlite3_finalize(statement);
	
	if(database) sqlite3_close(database);

	
}

+ (NSInteger)caloricTarget {
	Profile * p = [[Profile alloc] init]; 
	int WEIGHT = [[BIUtility latestMeasurement:@"Weight"] intValue];
	int HEIGHT = [[BIUtility latestMeasurement:@"Height"] intValue];	
	float BMRf;
	if (p.sexInt == 2) {
		//Female Calc
		BMRf = 655 +	(4.35 * WEIGHT) +
		(4.7 * HEIGHT) -
		(4.7 * [BIUtility age]);
	} else {
		//Male Calc
		BMRf = 66 +	(6.23 * WEIGHT) +
		(12.7 * HEIGHT) -
		(6.8 * [BIUtility age]);
	}

	int BMR = (int)(BMRf * [BIUtility caloricFactor]);
	int lossRate = [p.lossRate intValue];
	NSInteger caloricTarget = (BMR - (lossRate * 500));
	[p release];
	return caloricTarget;
	
}

+ (void)saveNutrition:(Nutrition *)nutrition {
	[BIUtility saveNutrition:nutrition forDate:[BIUtility todayDateString]];
}

+ (void)saveNutrition:(Nutrition *)nutrition forDate:(NSString *)date {
	if (sqlite3_open([[BIUtility getDBPath] UTF8String], &database) != SQLITE_OK) {
		sqlite3_close(database);
		NSLog(@"Failed to opendatabase");
	}
	NSString *today = date;	
	//DELETE ANY PREVIOUS ENTRIES FOR THIS TYPE FROM TODAY	
	char *errMsg;
	NSString *query;		
	
	query = [NSString stringWithFormat:@"DELETE FROM INUTRITION WHERE DATE = '%@'", date];

	if (sqlite3_exec(database, [query UTF8String], NULL, NULL, &errMsg) != SQLITE_OK) {
		NSAssert1(0, @"DB Error. '%s'", sqlite3_errmsg(database));
		
	}
	NSString * log = nutrition.foodLog;
	if ([nutrition.foodLog length] == 0 || nutrition.foodLog == NULL) {
		log = @"";
	}
	NSLog(@"log: %@",log);
	sqlite3_stmt * nstatement = nil;	
		const char *sql = "INSERT INTO INUTRITION(LOG, CALORIES, DATE, LEVEL, PHASE) Values(?,?,?,?,?)";
		if(sqlite3_prepare_v2(database, sql, -1, &nstatement, NULL) != SQLITE_OK)
				NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
		sqlite3_bind_text(nstatement, 1, [log UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_int(nstatement, 2, (int)nutrition.calories);

		sqlite3_bind_text(nstatement, 3, [today UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(nstatement, 4, [nutrition.level UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(nstatement, 5, [nutrition.phase UTF8String], -1, SQLITE_TRANSIENT);
	
		if(SQLITE_DONE != sqlite3_step(nstatement))
			NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
		sqlite3_finalize(nstatement);
	
	//delete previous portion data
	query = [NSString stringWithFormat:@"DELETE FROM INUTRITIONPORTIONS WHERE DATE = '%@'", date];
	
	if (sqlite3_exec(database, [query UTF8String], NULL, NULL, &errMsg) != SQLITE_OK) {
		NSAssert1(0, @"DB Error. '%s'", sqlite3_errmsg(database));
		
	}
	
	
	//insert portions
	
	int i = 0;
	for (NSNumber * num in nutrition.portionValues) {
		i++;
		sqlite3_stmt * nstatement = nil;	
		if(nstatement == nil) {
			const char *sql = "INSERT INTO INUTRITIONPORTIONS(TYPE, COUNT, DATE) Values(?,?,?)";
			if(sqlite3_prepare_v2(database, sql, -1, &nstatement, NULL) != SQLITE_OK)
				NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
		}
		//sqlite3_bind_text(nstatement, 1, [nutrition.foodLog UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_int(nstatement, 1, i);
		sqlite3_bind_int(nstatement, 2, [num intValue]);
		sqlite3_bind_text(nstatement, 3, [today UTF8String], -1, SQLITE_TRANSIENT);
		
		if(SQLITE_DONE != sqlite3_step(nstatement))
			NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
		sqlite3_finalize(nstatement);
		
	}
		
	if(database) sqlite3_close(database);
}


+ (Nutrition *)nutritionForDate:(NSDate *)nDate {

	sqlite3_stmt *statement;
	
	if (sqlite3_open([[BIUtility getDBPath] UTF8String], &database) != SQLITE_OK) {
		sqlite3_close(database);
		NSLog(@"Failed to opendatabase");
	}
	Nutrition * n = [[[Nutrition alloc] init] autorelease];
	int rows = 0;
	n.logDate = nDate;
	NSString * query = [NSString stringWithFormat:@"SELECT LOG, CALORIES, LEVEL, PHASE FROM INUTRITION WHERE DATE = '%@'", [BIUtility dateStringForDate:nDate]];
	if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
		while (sqlite3_step(statement) == SQLITE_ROW) {
			n.foodLog = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
			n.calories = sqlite3_column_int(statement, 1);
			n.level = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
			n.phase = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
			rows++;
		}
		sqlite3_finalize(statement);
		
	} 
	//NSMutableArray * portions = [[NSMutableArray alloc] init];
	NSMutableArray * portions = [[[NSMutableArray alloc] init] autorelease];
	NSString * query2 = [NSString stringWithFormat:@"SELECT COUNT FROM INUTRITIONPORTIONS WHERE DATE = '%@'", [BIUtility dateStringForDate:nDate]];
	if (sqlite3_prepare_v2(database, [query2 UTF8String], -1, &statement, nil) == SQLITE_OK) {
		while (sqlite3_step(statement) == SQLITE_ROW) {
			[portions addObject:[NSNumber numberWithInt:sqlite3_column_int(statement, 0)]];
			rows++;
		}
		sqlite3_finalize(statement);
	} 
	n.portionValues = portions;	
	if(database) sqlite3_close(database);
	if (rows == 0) n = nil;
	
	return n;		
}

+ (void) updateWorkout:(Workout *)wo {
	if (sqlite3_open([[BIUtility getDBPath] UTF8String], &database) != SQLITE_OK) {
		sqlite3_close(database);
		NSLog(@"Failed to opendatabase");
	}

	sqlite3_stmt *updateStmt;
		const char *sql = "UPDATE IWORKOUT SET NOTE = ?, COMPLETE = ? WHERE WOINSTANCEID = ?";
		if(sqlite3_prepare_v2(database, sql, -1, &updateStmt, NULL) != SQLITE_OK)
			NSAssert1(0, @"Error while creating update statement. '%s'", sqlite3_errmsg(database));
	NSString * c = [NSString stringWithFormat:@"%d", wo.woComplete];
	sqlite3_bind_text(updateStmt, 1, [wo.woNote UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(updateStmt, 2, [c UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_int(updateStmt, 3, wo.woInstanceID);
	
	if(SQLITE_DONE != sqlite3_step(updateStmt))
		NSAssert1(0, @"Error while updating. '%s'", sqlite3_errmsg(database));
	
	sqlite3_reset(updateStmt);

	if(database) sqlite3_close(database);
	
	
	 
}


+ (NSString *) todaysDailyNote {
	return [BIUtility dailyNoteForDate:[BIUtility todayDateString]];		
}

+ (NSString *) dailyNoteForDate:(NSString *)date {
	sqlite3_stmt *statement;
	
	if (sqlite3_open([[BIUtility getDBPath] UTF8String], &database) != SQLITE_OK) {
		sqlite3_close(database);
		NSLog(@"Failed to opendatabase");
	}
	NSString * ret;
	ret = nil;
	NSString * query = [NSString stringWithFormat:@"SELECT NOTE FROM IDAILYNOTE WHERE DATE = '%@'", date];
	if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
		while (sqlite3_step(statement) == SQLITE_ROW) {
			ret = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
		}
		sqlite3_finalize(statement);
		
	} 
	
	
	if(database) sqlite3_close(database);
	return ret;		
	//[ret release];
	
}


+ (void)saveBloggerConfig:(NSString *)username withPassword:(NSString *)password {
	if (sqlite3_open([[BIUtility getDBPath] UTF8String], &database) != SQLITE_OK) {
		sqlite3_close(database);
		NSLog(@"Failed to opendatabase");
	}
	char *errMsg;
	
	//UPDATE BLOGGER USERNAME
	NSString *query = [NSString stringWithFormat:@"UPDATE PROFILE SET BLOGGERLOGIN = '%@' WHERE PROFILEID = 1", username];
	if (sqlite3_exec(database, [query UTF8String], NULL, NULL, &errMsg) != SQLITE_OK) {
		NSAssert1(0, @"DB Error. '%s'", sqlite3_errmsg(database));
		
	}

	//UPDATE BLOGGER PASSWORD
	query = [NSString stringWithFormat:@"UPDATE PROFILE SET BLOGGERPASSWORD = '%@' WHERE PROFILEID = 1", password];
	if (sqlite3_exec(database, [query UTF8String], NULL, NULL, &errMsg) != SQLITE_OK) {
		NSAssert1(0, @"DB Error. '%s'", sqlite3_errmsg(database));
		
	}
	
	if(database) sqlite3_close(database);
}


+ (void) addDailyNote:(NSString *)note {
	[BIUtility addDailyNote:note forDate:[BIUtility todayDateString]];
	
}

+ (void) addDailyNote:(NSString *)note forDate:(NSString *)date {
	if (sqlite3_open([[BIUtility getDBPath] UTF8String], &database) != SQLITE_OK) {
		sqlite3_close(database);
		NSLog(@"Failed to opendatabase");
	}

	char *errMsg;
	NSString *query;		
	
	query = [NSString stringWithFormat:@"DELETE FROM IDAILYNOTE WHERE DATE = '%@'", date];
	
	if (sqlite3_exec(database, [query UTF8String], NULL, NULL, &errMsg) != SQLITE_OK) {
		NSAssert1(0, @"DB Error. '%s'", sqlite3_errmsg(database));
		
	}
	
	sqlite3_stmt * nstatement = nil;	

	if(nstatement == nil) {
		const char *sql = "INSERT INTO IDAILYNOTE(NOTE, DATE) Values(?,?)";
		if(sqlite3_prepare_v2(database, sql, -1, &nstatement, NULL) != SQLITE_OK)
			NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
	}

	sqlite3_bind_text(nstatement, 1, [note UTF8String], -1, SQLITE_TRANSIENT);
	NSString *today = date;
	sqlite3_bind_text(nstatement, 2, [today UTF8String], -1, SQLITE_TRANSIENT);
	
	if(SQLITE_DONE != sqlite3_step(nstatement))
		NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));

	sqlite3_finalize(nstatement);
	
	if(database) sqlite3_close(database);
	
}


+ (NSArray *) workoutForDate:(NSInteger)seqNumber Schedule:(NSInteger)sID{
	NSMutableArray * ret = [[NSMutableArray alloc] init];
	
	sqlite3_stmt *statement;
	//Profile * p = [[Profile alloc] init];
	if (sqlite3_open([[BIUtility getDBPath] UTF8String], &database) != SQLITE_OK) {
		sqlite3_close(database);
		NSLog(@"Failed to opendatabase");
	}
	NSString * query = [NSString stringWithFormat:@"SELECT CWORKOUTS.WORKOUTNAME "
			 @"FROM CWORKOUTSEQUENCE JOIN CWORKOUTS ON CWORKOUTSEQUENCE.WORKOUTID = CWORKOUTS.WORKOUTID "
			 @"AND SCHEDULEID = '%d' and WORKOUTSEQUENCENUMBER = %d", sID, seqNumber];
	if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
		while (sqlite3_step(statement) == SQLITE_ROW) {
			
			NSString * woName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
			[ret addObject:woName];
			//[woName release];
		}
		sqlite3_finalize(statement);
		
	} 
	//[p release];
	if(database) sqlite3_close(database);
	return [ret autorelease];	

}

+ (NSArray *) historyForDate:(NSString *)date {
	NSMutableArray * ret = [[NSMutableArray alloc] init];
	
	sqlite3_stmt *statement;
	
	if (sqlite3_open([[BIUtility getDBPath] UTF8String], &database) != SQLITE_OK) {
		sqlite3_close(database);
		NSLog(@"Failed to opendatabase");
	}
	
	NSString * query = [NSString stringWithFormat:@"SELECT NOTE, ID FROM IDAILYNOTE WHERE DATE = '%@'", date];
	if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
		while (sqlite3_step(statement) == SQLITE_ROW) {
			History * h = [[[History alloc] init] autorelease];
			h.title = @"Daily Note:";
			h.type = @"1note.png";
			h.detail = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
			h.histID = sqlite3_column_int(statement, 1);
			[ret addObject:h];
			//[h release];
		}
		sqlite3_finalize(statement);
		
	} 
	
	query = [NSString stringWithFormat:@"SELECT LOG, CALORIES, ID FROM INUTRITION WHERE DATE = '%@'", date];
	if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
		while (sqlite3_step(statement) == SQLITE_ROW) {
			History * h = [[[History alloc] init] autorelease];
			if (sqlite3_column_text(statement, 0) == NULL) h.detail = @"";
			else h.detail = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
			h.title = [NSString stringWithFormat:@"%d Calories", sqlite3_column_int(statement, 1)];
			h.type = @"nutrition.png";
			h.histID = sqlite3_column_int(statement, 2);
			[ret addObject:h];
			//[h release];
		}
		sqlite3_finalize(statement);
		
	} 

	query = [NSString stringWithFormat:@"SELECT IWORKOUT.NOTE, IWORKOUT.COMPLETE, CWORKOUTS.WORKOUTNAME, IWORKOUT.WOINSTANCEID "
			 @"FROM CWORKOUTS JOIN IWORKOUT ON IWORKOUT.WORKOUTID = CWORKOUTS.WORKOUTID "
			 @"AND DATE = '%@'", date];
	if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
		while (sqlite3_step(statement) == SQLITE_ROW) {
			History * h = [[[History alloc] init] autorelease];
			
			h.title = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
			h.type = @"workout.png";
			if ([[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)] integerValue] == 0) {
				h.detail = @"Status: Not Complete\n";
			} else {
				h.detail = @"Status: Completed\n";
			}
			NSString * woNote = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
				
			if (woNote.length > 0) {
				h.detail = [NSString stringWithFormat:@"%@%@",h.detail,woNote];
			}
			h.histID = sqlite3_column_int(statement, 3);
			[ret addObject:h];
			//[h release];
		}
		sqlite3_finalize(statement);
		
	} 
	
		query = [NSString stringWithFormat:@"SELECT TYPE, VALUE, ID FROM IMEASURE WHERE DATE = '%@'", date];
		if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
			while (sqlite3_step(statement) == SQLITE_ROW) {
				History * h = [[[History alloc] init] autorelease];
				NSString * type = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
				NSString * value = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
				NSString * unit;
				if ([type isEqual:@"Weight"]) {
					unit = @"lbs";
				} else {
					unit = @"in";
				}
				
				h.title = [NSString stringWithFormat:@"%@: %@ %@", type, value, unit];
				h.type = @"measure.png";
				h.detail = @"";
				h.histID = sqlite3_column_int(statement, 2);
				[ret addObject:h];
				//[h release];
			}
			sqlite3_finalize(statement);
			
		} 
	
	
	if(database) sqlite3_close(database);
	return [ret autorelease];		
	//[ret release];
	
	
}

+ (NSArray *) historyEditListForDate:(NSString *)date {
	NSMutableArray * ret = [[NSMutableArray alloc] init];
	
	sqlite3_stmt *statement;
	
	if (sqlite3_open([[BIUtility getDBPath] UTF8String], &database) != SQLITE_OK) {
		sqlite3_close(database);
		NSLog(@"Failed to opendatabase");
	}
	NSInteger count = 0;
	NSString * query = [NSString stringWithFormat:@"SELECT NOTE, ID FROM IDAILYNOTE WHERE DATE = '%@'", date];
	if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
		while (sqlite3_step(statement) == SQLITE_ROW) {
			History * h = [[[History alloc] init] autorelease];
			h.title = @"Daily Note:";
			h.type = @"1note.png";
			h.detail = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
			h.histID = sqlite3_column_int(statement, 1);
			count++;
			[ret addObject:h];
			//[h release];
		}
		
		if (count == 0) {
			History * h = [[[History alloc] init] autorelease];
			h.title = @"No Daily Note Recorded";
			h.type = @"1note.png";
			h.detail = @"(Touch To Record for Date)";
			h.histID = 0;
			[ret addObject:h];
		}
		
		sqlite3_finalize(statement);
		
	} 
	
	
	count = 0;
	query = [NSString stringWithFormat:@"SELECT LOG, CALORIES, ID FROM INUTRITION WHERE DATE = '%@'", date];
	if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
		while (sqlite3_step(statement) == SQLITE_ROW) {
			History * h = [[[History alloc] init] autorelease];
			h.title = @"Nutrition:";
			h.type = @"nutrition.png";
			h.detail = [NSString stringWithFormat:@"%@\n%@", [NSString stringWithFormat:@"%d Calories", sqlite3_column_int(statement, 1)],[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
			h.histID = sqlite3_column_int(statement, 2);
			count++;
			[ret addObject:h];
			//[h release];
		}
		if (count == 0) {
			History * h = [[[History alloc] init] autorelease];
			h.title = @"No Nutrition Recorded";
			h.type = @"nutrition.png";
			h.detail = @"(Touch To Record for Date)";
			h.histID = 0;
			[ret addObject:h];
		}
		
		
		
		sqlite3_finalize(statement);
		
	} 
	count = 0;
	query = [NSString stringWithFormat:@"SELECT IWORKOUT.NOTE, IWORKOUT.COMPLETE, CWORKOUTS.WORKOUTNAME, IWORKOUT.WOINSTANCEID "
			 @"FROM CWORKOUTS JOIN IWORKOUT ON IWORKOUT.WORKOUTID = CWORKOUTS.WORKOUTID "
			 @"AND DATE = '%@'", date];
	if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
		NSString * workoutDetail = @"";
		while (sqlite3_step(statement) == SQLITE_ROW) {
			workoutDetail = [NSString stringWithFormat:@"%@%@\n", workoutDetail, [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)]];

			count++;
			//[h release];
		}
		if (count == 0) {
			History * h = [[[History alloc] init] autorelease];
			h.title = @"No Workout Recorded";
			h.type = @"workout.png";
			h.detail = @"(Touch To Record for Date)";
			h.histID = 0;
			[ret addObject:h];
		} else {
			History * h = [[[History alloc] init] autorelease];
			
			h.title = @"Workout(s) Recorded:";
			h.type = @"workout.png";
			h.detail = workoutDetail;
			h.histID = 0;
			[ret addObject:h];
			
			
		}

		
		
		sqlite3_finalize(statement);
		
	} 
	count = 0;
	query = [NSString stringWithFormat:@"SELECT TYPE, VALUE, ID FROM IMEASURE WHERE DATE = '%@'", date];
	if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
		
		NSString * measureDetail = @"";
		while (sqlite3_step(statement) == SQLITE_ROW) {
			NSString * type = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
			NSString * value = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
			NSString * unit;
			if ([type isEqual:@"Weight"]) {
				unit = @"lbs";
			} else {
				unit = @"in";
			}
			
			measureDetail = [NSString stringWithFormat:@"%@%@: %@ %@\n", measureDetail,type, value, unit];
			count++;
		}
		if (count == 0) {
			History * h = [[[History alloc] init] autorelease];
			h.title = @"No Measurements";
			h.type = @"measure.png";
			h.detail = @"(Touch To Record for Date)";
			h.histID = 0;
			[ret addObject:h];
		} else {
			History * h = [[[History alloc] init] autorelease];
			h.type = @"measure.png";
			h.title = @"Measurements:";
			h.detail = measureDetail;
			h.histID = 0;
			count++;
			[ret addObject:h];
			
			
		}

		
		sqlite3_finalize(statement);
		
	} 
	
	
	if(database) sqlite3_close(database);
	return [ret autorelease];		
	//[ret release];
	
	
}


+ (NSArray *) moveHistoryForWO:(NSInteger) woID {
	NSMutableArray * ret = [[NSMutableArray alloc] init];
	
	sqlite3_stmt *statement;
	
	if (sqlite3_open([[BIUtility getDBPath] UTF8String], &database) != SQLITE_OK) {
		sqlite3_close(database);
		NSLog(@"Failed to opendatabase");
	}

	NSString *query = [NSString stringWithFormat:@"SELECT distinct CWORKOUTMOVES.MOVEID, CWORKOUTMOVES.MOVENAME "
					   @"FROM CWORKOUTMOVES, CMOVEDETAIL, IMOVEDETAIL "
					   @"WHERE "
					   @"CWORKOUTMOVES.MOVEID = CMOVEDETAIL.MOVEID "
					   @"and "
					   @"CMOVEDETAIL.MOVEDETAILID = IMOVEDETAIL.MOVEDETAILID "
					   @"and "
					   @"IMOVEDETAIL.WOINSTANCEID = %d", woID];
	if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
		while (sqlite3_step(statement) == SQLITE_ROW) {
			Move  *move = [[[Move alloc] init] autorelease];
			move.moveID = sqlite3_column_int(statement, 0);
			move.workoutID = woID;
			move.moveName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
			[ret addObject:move];				
			//[move release];				
		}
		sqlite3_finalize(statement);
		
	}
	
	if(database) sqlite3_close(database);
	return [ret autorelease];		
	
}

+ (NSInteger) moveHistoryDetailCountForWorkout:(NSInteger) woID {
	sqlite3_stmt *statement;
	
	if (sqlite3_open([[BIUtility getDBPath] UTF8String], &database) != SQLITE_OK) {
		sqlite3_close(database);
		NSLog(@"Failed to opendatabase");
	}

	NSInteger count = 0;
	NSString *query = [NSString stringWithFormat:
					   @"SELECT count (IMOVEDETAIL.WOINSTANCEID) as COUNT "
					   @"FROM IMOVEDETAIL "
					   @"WHERE "
					   @"IMOVEDETAIL.WOINSTANCEID = %d", woID];
	if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
		while (sqlite3_step(statement) == SQLITE_ROW) {
			count = sqlite3_column_int(statement, 0);
		}
		sqlite3_finalize(statement);
		
	}
	
	if(database) sqlite3_close(database);
	return count;		
}

+ (NSArray *) moveHistoryDetailForMove:(NSInteger) moveID andWorkout:(NSInteger)woID {
	NSMutableArray * ret = [[NSMutableArray alloc] init];
	
	sqlite3_stmt *statement;
	
	if (sqlite3_open([[BIUtility getDBPath] UTF8String], &database) != SQLITE_OK) {
		sqlite3_close(database);
		NSLog(@"Failed to opendatabase");
	}
	
	NSString *query = [NSString stringWithFormat:
					   @"SELECT CMOVEDETAIL.MOVETYPECODE, IMOVEDETAIL.DETAILVALUE "
					   @"FROM CWORKOUTMOVES, CMOVEDETAIL, IMOVEDETAIL "
					   @"WHERE "
					   @"CWORKOUTMOVES.MOVEID = CMOVEDETAIL.MOVEID "
					   @"and "
					   @"CMOVEDETAIL.MOVEDETAILID = IMOVEDETAIL.MOVEDETAILID "
					   @"and "
					   @"IMOVEDETAIL.WOINSTANCEID = %d "
					   @"and "
					   @"CMOVEDETAIL.MOVEID = %d ", woID, moveID];
	if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
		while (sqlite3_step(statement) == SQLITE_ROW) {
			MoveDetail  *md = [[[MoveDetail alloc] init] autorelease];
			md.moveType = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
			md.detailValue = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
			[ret addObject:md];				
		}
		sqlite3_finalize(statement);
		
	}
	
	if(database) sqlite3_close(database);
	return [ret autorelease];		
	
	
}

+ (NSArray *) historyDateList {
	sqlite3_stmt *statement;
 	NSMutableArray * dateStringList = [[NSMutableArray alloc] init];
	
	if (sqlite3_open([[BIUtility getDBPath] UTF8String], &database) != SQLITE_OK) {
		sqlite3_close(database);
		NSLog(@"Failed to opendatabase");
	}
	
	NSString * query = [NSString stringWithFormat:@"SELECT DATE FROM IDAILYNOTE"];
	if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
		while (sqlite3_step(statement) == SQLITE_ROW) {
			
			NSString * ret = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
			[dateStringList addObject:ret];
		}
		sqlite3_finalize(statement);
		
	} 
	
	query = [NSString stringWithFormat:@"SELECT DATE FROM INUTRITION"];
	if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
		while (sqlite3_step(statement) == SQLITE_ROW) {
			
			NSString * ret = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
			[dateStringList addObject:ret];
		}
		sqlite3_finalize(statement);
		
	} 
	
	query = [NSString stringWithFormat:@"SELECT DATE FROM IMEASURE"];
	if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
		while (sqlite3_step(statement) == SQLITE_ROW) {
			
			NSString * ret = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
			[dateStringList addObject:ret];
		}
		sqlite3_finalize(statement);
		
	} 
	
	query = [NSString stringWithFormat:@"SELECT DATE FROM IWORKOUT"];
	if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
		while (sqlite3_step(statement) == SQLITE_ROW) {
			
			NSString * ret = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
			[dateStringList addObject:ret];
		}
		sqlite3_finalize(statement);
		
	} 
	
	NSArray * uniqueDateList = [[NSSet setWithArray:dateStringList] allObjects];
	
	NSMutableArray * dateObjectList = [[NSMutableArray alloc] init];
	
	for (NSString * dateString in uniqueDateList) {
		[dateObjectList addObject:[self dateFromString:dateString]];
	}
	
	[dateObjectList sortUsingSelector:@selector(compare:)];
	
	NSMutableArray * finalSortedList = [[[NSMutableArray alloc] init] autorelease];
	NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormat setDateStyle:NSDateFormatterShortStyle];

	//for (NSDate * date in dateObjectList) {
	//	[finalSortedList addObject:[dateFormat stringFromDate:date]];
		
	//}
	int i = ([dateObjectList count] - 1);
	for (NSDate * date in dateObjectList) {
		NSString * date = [dateFormat stringFromDate:[dateObjectList objectAtIndex:i]];
		[finalSortedList addObject:date];
		i = i - 1;
	}
	
	
	if(database) sqlite3_close(database);
	
	[dateStringList release];
	[dateObjectList release];

	return finalSortedList;
	//[finalSortedList release];

}

+ (NSArray *) weightList {
	sqlite3_stmt *statement;
 	NSMutableArray * weightList = [[NSMutableArray alloc] init];
	
	if (sqlite3_open([[BIUtility getDBPath] UTF8String], &database) != SQLITE_OK) {
		sqlite3_close(database);
		NSLog(@"Failed to opendatabase");
	}
	
	NSString * query = [NSString stringWithFormat:@"SELECT VALUE FROM IMEASURE WHERE TYPE = 'Weight'"];
	if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
		while (sqlite3_step(statement) == SQLITE_ROW) {
			
			NSString * ret = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
			NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
			[f setNumberStyle:NSNumberFormatterDecimalStyle];
			NSNumber * myNumber = [f numberFromString:ret];
			[f release];
							
							
			[weightList addObject:myNumber];
		}
		sqlite3_finalize(statement);
		
	} 
	
	
	
	if(database) sqlite3_close(database);
	

	
	return [weightList autorelease];
	//[finalSortedList release];
	
}

+ (NSString *) blogEntryForDate:(NSString *)date OmitMeasures:(BOOL)omitMeasure {
	NSArray * histList = [[self historyForDate:date] retain];
	
	NSString * entry = @"";
	
	for (History *h in histList) {
		NSString * image = @"";
		NSString * subtitle = @"";
		if ([h.type isEqual:@"1note.png"]) {
			image = @"Ks64e.png";
			subtitle = @"Log Entry";
		} else if ([h.type isEqual:@"workout.png"]) {
			image = @"eDOFW.png";
			subtitle = @"Workout";
		} else if ([h.type isEqual:@"nutrition.png"]) {
			image = @"zDFTC.png";
			subtitle = @"Nutrition";
		} else if ([h.type isEqual:@"measure.png"]) {
			image = @"g1r61.png";
			subtitle = @"Measure";
	    }
		
		if ([h.type isEqual:@"measure.png"] && omitMeasure) {
			
		} else {
			entry = [NSString stringWithFormat:@"%@<table style='width: 400px;' border='0' cellpadding='2' cellspacing='2'>"
				 @"<tbody><tr><td><hr style='width: 400px; height: 1px;'></td></tr></tbody></table>"
				 @"<table style='text-align: left; width: 350px;' border='0' cellpadding='2' cellspacing='2'>"
				 @"<tbody><tr><td style='width: 50px; text-align: center;'>"
				 @"<img style='border-style:none' src='http://imgur.com/%@'><small>%@</small></td>"
				 @"<td style='vertical-align: top; width: 350px'><span><big><b>%@</b></big><br>"
				 @"%@</span></td></tr></tbody></table>",entry, image, subtitle, [self textToHtml:h.title], [self textToHtml:h.detail]];
		}
	}
	
	
	[histList release];
	return entry;
	
	
	
}

+ (NSString *) todaysBlogEntry:(BOOL)omitMeasure {
	return [self blogEntryForDate:[self todayDateString] OmitMeasures:omitMeasure];
	
}



+ (NSInteger) portionTypeCount:(NSInteger)type level:(NSString *)level phase:(NSString *)phase {
	sqlite3_stmt *statement;
	
	if (sqlite3_open([[BIUtility getDBPath] UTF8String], &database) != SQLITE_OK) {
		sqlite3_close(database);
		NSLog(@"Failed to opendatabase");
	}
	
	NSInteger count = 0;
	NSString *query = [NSString stringWithFormat:
					   @"SELECT COUNT  "
					   @"FROM CNUTRITIONPORTIONS "
					   @"WHERE "
					   @"CNUTRITIONPORTIONS.TYPE = %d and "
					   @"CNUTRITIONPORTIONS.LEVEL = '%@' and "
					   @"CNUTRITIONPORTIONS.PHASE = '%@'", type, level, phase];
	//NSLog(@"%@", query);
	
	if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
		while (sqlite3_step(statement) == SQLITE_ROW) {
			count = sqlite3_column_int(statement, 0);
		}
		sqlite3_finalize(statement);
		
	}
	
	if(database) sqlite3_close(database);
	return count;		
}

+ (NSArray *) portionList {
	sqlite3_stmt *statement;
 	NSMutableArray * portionList = [[NSMutableArray alloc] init];
	
	if (sqlite3_open([[BIUtility getDBPath] UTF8String], &database) != SQLITE_OK) {
		sqlite3_close(database);
		NSLog(@"Failed to opendatabase");
	}
	
	NSString * query = [NSString stringWithFormat:@"SELECT DESCRIPTION FROM CNUTRITIONTYPE order by ID"];
	if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
		while (sqlite3_step(statement) == SQLITE_ROW) {
			
			NSString * description = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
			[portionList addObject:description];
			NSLog(@"portion: %@", description);
		}
		sqlite3_finalize(statement);
		
	} 
	if(database) sqlite3_close(database);
	return [portionList autorelease];
	
}

+ (NSString *) portionTypeForID:(NSInteger)typeID {
	sqlite3_stmt *statement;
 	NSString * ret;
	if (sqlite3_open([[BIUtility getDBPath] UTF8String], &database) != SQLITE_OK) {
		sqlite3_close(database);
		NSLog(@"Failed to opendatabase");
	}
	
	NSString * query = [NSString stringWithFormat:@"SELECT DESCRIPTION FROM CNUTRITIONTYPE WHERE ID = %d",typeID];
	if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
		while (sqlite3_step(statement) == SQLITE_ROW) {
			ret = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
		}
		sqlite3_finalize(statement);
		
	} 
	if(database) sqlite3_close(database);
	return ret;
	
}

+ (NSInteger) portionIDForType:(NSString *)type {
	sqlite3_stmt *statement;
 	NSInteger ret = 0;
	if (sqlite3_open([[BIUtility getDBPath] UTF8String], &database) != SQLITE_OK) {
		sqlite3_close(database);
		NSLog(@"Failed to opendatabase");
	}
	
	NSString * query = [NSString stringWithFormat:@"SELECT ID FROM CNUTRITIONTYPE WHERE DESCRIPTION LIKE '%@'",type];
	if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
		while (sqlite3_step(statement) == SQLITE_ROW) {
			ret = sqlite3_column_int(statement, 0);
		}
		sqlite3_finalize(statement);
		
	} 
	if(database) sqlite3_close(database);
	return ret;
	
}

+ (NSArray *) foodsForPortionType:(NSInteger)typeID {
	
	sqlite3_stmt *statement;
 	NSMutableArray * foodList = [[NSMutableArray alloc] init];
	
	if (sqlite3_open([[BIUtility getDBPath] UTF8String], &database) != SQLITE_OK) {
		sqlite3_close(database);
		NSLog(@"Failed to opendatabase");
	}
	NSString * query = [NSString stringWithFormat:
						@"SELECT CNUTRITIONFOODS.ID, CNUTRITIONFOODS.TYPE, CNUTRITIONFOODS.CALORIES, CNUTRITIONFOODS.DESCRIPTION as FOODDESCRIPTION, CNUTRITIONTYPE.DESCRIPTION as TYPEDESCRIPTION "
						@"FROM CNUTRITIONFOODS, CNUTRITIONTYPE "
						@"WHERE "
						@"CNUTRITIONFOODS.TYPE = CNUTRITIONTYPE.ID "
						@"and "
						@"CNUTRITIONFOODS.TYPE = %d ", typeID];
	
	if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
		while (sqlite3_step(statement) == SQLITE_ROW) {
			Food * f = [Food alloc];
			f.foodID = sqlite3_column_int(statement, 0);
			f.typeID = sqlite3_column_int(statement, 1);
			f.calories = sqlite3_column_int(statement, 2);
			f.description = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
			f.foodType = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
			[foodList addObject:f];
			[f release];
		}
		sqlite3_finalize(statement);
		
	} 
	if(database) sqlite3_close(database);
	return [foodList autorelease];
	
}
+ (NSString *)moveDetailForCode:(NSString *)code {
	
	
	if ([code isEqualToString:@"R"]) {
		return  @"Repititions";
	} else if ([code isEqualToString:@"RC"]) {
		return  @"WITH Chair";
	} else if ([code isEqualToString:@"RF"]) {
		return  @"NO Chair";
	} else if ([code isEqualToString:@"H"]) {
		return @"Height (inches)";
	} else if ([code isEqualToString:@"T"]) {
		return @"Time (seconds)";
	} else if ([code isEqualToString:@"W"]) {
		return @"Weight/Bands";
	} else if ([code isEqualToString:@"E"]) {
		return @"Effort";
	} else {
		return @"";
	}

	
}	

+ (float)bodyFatForWeight:(float)WEIGHT height:(float)HEIGHT waist:(float)WAIST neck:(float)NECK hip:(float)HIP {
	
	Profile * p = [[Profile alloc] init];
	//NSString * retData;
	BOOL maleCalcOk = YES;
	BOOL femaleCalcOK = YES;
	
	if (WEIGHT == 0) {
		maleCalcOk = NO;
		femaleCalcOK = NO;
	}
	
	if (HEIGHT == 0) {
		maleCalcOk = NO;
		femaleCalcOK = NO;
	}
	if (NECK == 0) {
		maleCalcOk = NO;
		femaleCalcOK = NO;
	}
	if (WAIST == 0) {
		maleCalcOk = NO;
		femaleCalcOK = NO;
	}
	if (HIP == 0 && p.sexInt == 2) {
		femaleCalcOK = NO;
	}
	
	
	float BMRf;
	if (p.sexInt == 2) {
		//Female Calc
		BMRf = 655 +	(4.35 * WEIGHT) +
		(4.7 * HEIGHT) -
		(4.7 * [BIUtility age]);
	} else {
		//Male Calc
		BMRf = 66 +	(6.23 * WEIGHT) +
		(12.7 * HEIGHT) -
		(6.8 * [BIUtility age]);
	}
	float BF;
	if (p.sexInt == 1) {
		//male Calc
		double WN = (WAIST) - (NECK);			
		
		//BF = ((495/(1.0324 - .19077 * log(WN) + .15456 * log(HEIGHT * 2.54))) - 450);
		float BF1 = 86.010*log10(WN) ;
		
		float BF2 = 70.041*log10(HEIGHT);
		BF = BF1 - BF2 + 36.76;

	} else {
		//female Calc
		//NAVY Calc
		double WHN = (WAIST) +
		(HIP) -
		(NECK);
		
		
		BF = 163.205*log10(WHN)-97.684*log10(HEIGHT) - 78.387;
		
	}
	[p release];
	
	return BF ;
	
}

+ (NSString*)textToHtml:(NSString*)htmlString {
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&"  withString:@"&amp;"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<"  withString:@"&lt;"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@">"  withString:@"&gt;"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"""" withString:@"&quot;"];    
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"'"  withString:@"&#039;"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
    return htmlString;
}
@end