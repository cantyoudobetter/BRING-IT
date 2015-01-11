//
//  History.m
//  Bring It
//
//  Created by Michael Bordelon on 5/31/10.
//  Copyright 2010 Bordelon iPhone. All rights reserved.
//

#import "History.h"


@implementation History
@synthesize title, type, detail, histID;

- (void) dealloc {
	//[moveName dealloc];
	[super dealloc];
	
}

- (id) init {
	
	[super init];
	return self;
}
@end
