//
//  GraphPoint.m
//  bring-it
//
//  Created by Michael Bordelon on 9/1/10.
//  Copyright 2010 bordeloniphone. All rights reserved.
//

#import "GraphPoint.h"

@implementation GraphPoint
@synthesize label;
- (id) initWithID:(int)pkv value:(NSNumber*)number label:(NSString*)passedLabel{
	if(self = [super init]){
		pk = pkv;
		value = [number retain];
		self.label = passedLabel;
	}
	return self;
	
}

- (NSNumber*) yValue{
	return value;
}
- (NSString*) xLabel{
	return [NSString stringWithFormat:@"%d",pk];
}
- (NSString*) yLabel{
	return [NSString stringWithFormat:@"%d%@",[value intValue], label];
}


@end
