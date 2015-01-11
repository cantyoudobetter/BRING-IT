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
#import "WeightGraphController.h"




@implementation WeightGraphController


- (void)viewDidLoad{
	[super viewDidLoad];
	
	Profile * p = [[Profile alloc] init];
	[graph setPointDistance:15];
	
	
	NSMutableArray * dateList = [[NSMutableArray alloc] init];
	
	NSArray *dateStringList = [[BIUtility MeasureDateListForType:@"Weight"] retain];
	if ([dateStringList count] > 0) {
	for (NSString * dt in dateStringList) {
		[dateList addObject:[BIUtility dateFromString:dt]];
	}
	[dateList sortUsingSelector:@selector(compare:)];
	NSDate * start = [dateList objectAtIndex:0];
	NSDate * end = [dateList objectAtIndex:[dateList count]-1];
	
	NSTimeInterval interval = [end timeIntervalSinceDate: start];
	int days = interval/86400 + 1; //seconds in a day
	
	
	data = [[NSMutableArray alloc] init];
	
	float high = 0;
	//float low = 0;
		float startVal = 0;
	int item = 0;
	float currentVal = 0;
	for (int i=0; i < days; i++) {
	//for(NSDate * date in dateList){
		//int no = rand() % 100 + i;
		
		NSDate * current = [start addTimeInterval:60*60*24*i];
		if ([[BIUtility dateStringForDate:current] isEqual:[BIUtility dateStringForDate:[dateList objectAtIndex:item]]]) {
			NSString * dtString = [BIUtility dateStringForDate:[dateList objectAtIndex:item]];
			currentVal = [[BIUtility latestMeasurement:@"Weight" forDate:dtString latest:YES] floatValue];
			item++;
			if (currentVal > high) high = currentVal;
			//if (i == (days - 1)) low = currentVal;
		}	
		
		GraphPoint *gp = [[GraphPoint alloc] initWithID:i value:[NSNumber numberWithFloat:currentVal] label:@" lbs"];
		[data addObject:gp];
		[gp release];
	}
	startVal = [[BIUtility latestMeasurement:@"Weight" forDate:[BIUtility dateStringForDate:start] latest:YES] floatValue];
	float valDiff = startVal - currentVal;
	if (valDiff > 0) {
		graph.title.text = [NSString stringWithFormat:@"Weight Loss - %0.0f lbs", valDiff];
	} else {
		graph.title.text = [NSString stringWithFormat:@"Weight Gain - %0.0f lbs", valDiff*-1];
							
	}
	[self.graph setGraphWithDataPoints:data];
	self.graph.goalValue = [NSNumber numberWithFloat:p.weightGoal];
	self.graph.goalShown = YES;
	[self.graph scrollToPoint:days animated:YES];
	[self.graph showIndicatorForPoint:0];
	self.graph.goalTitle = [NSString stringWithFormat:@"%d lbs", p.weightGoal];;
		
	}else {
		graph.title.text = @"No Weight Data Recorded Yet";
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
