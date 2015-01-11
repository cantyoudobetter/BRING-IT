//
//  GraphController.m
//  Created by Devin Ross on 7/17/09.
//
/*
 
 tapku.com || http://github.com/tapku/tapkulibrary/tree/master
 
 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:
 
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
 
 */
#import "MoveGraphController.h"


@implementation MoveGraphController
@synthesize moveType, moveName;

- (void)viewDidLoad{
	[super viewDidLoad];
	
	Profile * p = [[Profile alloc] init];
	[graph setPointDistance:15];
	
	
	NSMutableArray * dateList = [[NSMutableArray alloc] init];
	
	NSArray *dateStringList = [[BIUtility MoveDateListForMoveID:self.moveName andMoveType:self.moveType] retain];
	if ([dateStringList count] > 0) {
			for (NSString * dt in dateStringList) {
				[dateList addObject:[BIUtility dateFromString:dt]];
			}
			[dateList sortUsingSelector:@selector(compare:)];
	
			NSInteger item = 0;
			data = [[NSMutableArray alloc] init];	
			for (NSDate * d in dateList) {
		
				NSString * dtString = [BIUtility dateStringForDate:d];
				NSArray * currentVals = [[BIUtility moveDetailValueForMoveID:self.moveName Type:self.moveType Date:dtString] retain];
				
				for (NSNumber * n in currentVals) {
					GraphPoint *gp = [[GraphPoint alloc] initWithID:item value:n label:@""];
					[data addObject:gp];
					[gp release];
					item++;
				}
				[currentVals release];
			}
		graph.title.text = [NSString stringWithFormat:@"%@ | %@", self.moveName, [BIUtility moveDetailForCode:self.moveType]];
			[self.graph setGraphWithDataPoints:data];
			self.graph.goalShown = NO;
			[self.graph showIndicatorForPoint:0];
			
	}else {
		graph.title.text = @"No MOVE Data Recorded Yet";
	}
	
	
	[dateStringList release];
	[dateList release];
	[p release];
}




- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}
- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}
- (void)dealloc {
	[data release];
	[indicator release];
    [super dealloc];
}


@end
