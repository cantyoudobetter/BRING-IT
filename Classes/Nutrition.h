//
//  Nutrition.h
//  Bring It
//
//  Created by Michael Bordelon on 5/16/10.
//  Copyright 2010 Bordelon iPhone. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Nutrition : NSObject {

	NSString * foodLog;
	NSInteger calories;
	NSDate * logDate;
	NSString * level;
	NSString * phase;
	
	NSMutableArray * portionValues;
}

@property (nonatomic, retain) NSString * foodLog;
@property (nonatomic, retain) NSString * level;
@property (nonatomic, retain) NSString * phase;
@property (nonatomic, retain) NSDate * logDate;
@property (nonatomic, readwrite) NSInteger calories;
@property (nonatomic, retain) NSMutableArray * portionValues;

@end