//
//  Nutrition.m
//  Bring It
//
//  Created by Michael Bordelon on 5/16/10.
//  Copyright 2010 Bordelon iPhone. All rights reserved.
//

#import "Nutrition.h"


@implementation Nutrition
@synthesize foodLog, logDate, calories, portionValues, level, phase;

- (void) dealloc {
	[foodLog release];
	[logDate release];
	[portionValues release];
	[level release];
	[phase release];
	[super dealloc];
	
}

- (id) init {
	
	[super init];
	return self;
}

@end