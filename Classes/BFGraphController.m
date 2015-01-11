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
#import "BFGraphController.h"




@implementation BFGraphController


- (void)viewDidLoad{
	[super viewDidLoad];
	
	Profile * p = [[Profile alloc] init];
	[graph setPointDistance:15];
	
	NSMutableArray * weightList = [[NSMutableArray alloc] init];
	NSMutableArray * heightList = [[NSMutableArray alloc] init];
	NSMutableArray * waistList = [[NSMutableArray alloc] init];
	NSMutableArray * neckList = [[NSMutableArray alloc] init];
	NSMutableArray * hipList = [[NSMutableArray alloc] init];
	
	NSMutableArray * dateList = [[NSMutableArray alloc] init];
	
	NSArray *dateStringList = [[BIUtility MeasureDateList] retain];
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
	
	//float high = 0;
	//float low = 0;
	float startVal = 0;
	//int item = 0;
	NSInteger value = 0;		
	float currentVal = 0;
	
	for (int i=0; i < days; i++) {
		NSDate * current = [start addTimeInterval:60*60*24*i];
		NSString * newValue = [BIUtility latestMeasurement:@"Weight" forDate:[BIUtility dateStringForDate:current] latest:YES];
		if([newValue length] > 0) {
			value = [newValue integerValue];
		}
		[weightList addObject:[NSNumber numberWithInteger:value]];
		NSLog(@"WEIGHT|DT:%@ VALUE:%D", [BIUtility dateStringForDate:current], value);
	}
	value = 0;
	for (int i=0; i < days; i++) {
		NSDate * current = [start addTimeInterval:60*60*24*i];
		NSString * newValue = [BIUtility latestMeasurement:@"Height" forDate:[BIUtility dateStringForDate:current] latest:YES];
		if([newValue length] > 0) {
		   value = [newValue integerValue];
		}
		[heightList addObject:[NSNumber numberWithInteger:value]];
		NSLog(@"HEIGHT|DT:%@ VALUE:%D", [BIUtility dateStringForDate:current], value);

	}
	value = 0;
	for (int i=0; i < days; i++) {
		NSDate * current = [start addTimeInterval:60*60*24*i];
		NSString * newValue = [BIUtility latestMeasurement:@"Waist" forDate:[BIUtility dateStringForDate:current] latest:YES];
		if([newValue length] > 0) {
				value = [newValue integerValue];
		}
		[waistList addObject:[NSNumber numberWithInteger:value]];
		NSLog(@"WAIST|DT:%@ VALUE:%D", [BIUtility dateStringForDate:current], value);
	}
	value = 0;
		 
	for (int i=0; i < days; i++) {
		NSDate * current = [start addTimeInterval:60*60*24*i];
		NSString * newValue = [BIUtility latestMeasurement:@"Neck" forDate:[BIUtility dateStringForDate:current] latest:YES];
		if([newValue length] > 0) {
			value = [newValue integerValue];
		}
		[neckList addObject:[NSNumber numberWithInteger:value]];
		NSLog(@"NECK|DT:%@ VALUE:%D", [BIUtility dateStringForDate:current], value);
	}
	value = 0;
	for (int i=0; i < days; i++) {
		NSDate * current = [start addTimeInterval:60*60*24*i];
		NSString * newValue = [BIUtility latestMeasurement:@"Hip" forDate:[BIUtility dateStringForDate:current] latest:YES];
		if([newValue length] > 0) {
			value = [newValue integerValue];
		}
		[hipList addObject:[NSNumber numberWithInteger:value]];
		NSLog(@"HIP|DT:%@ VALUE:%D", [BIUtility dateStringForDate:current], value);
	}									
		
		
	for (int i=0; i < days; i++) {
		
		float BF = [BIUtility bodyFatForWeight:[[weightList objectAtIndex:i] floatValue] 
										height:[[heightList objectAtIndex:i] floatValue] 
										 waist:[[waistList objectAtIndex:i] floatValue]
										  neck:[[neckList objectAtIndex:i] floatValue]
										   hip:[[hipList objectAtIndex:i] floatValue]];
		NSLog(@"BF:%0.0f", BF);
		currentVal = BF;
		GraphPoint *gp = [[GraphPoint alloc] initWithID:i value:[NSNumber numberWithFloat:BF] label:@"%"];
		[data addObject:gp];
		[gp release];
	}
	startVal = [BIUtility bodyFatForWeight:[[weightList objectAtIndex:0] floatValue] 
										height:[[heightList objectAtIndex:0] floatValue] 
										 waist:[[waistList objectAtIndex:0] floatValue]
										  neck:[[neckList objectAtIndex:0] floatValue]
										   hip:[[hipList objectAtIndex:0] floatValue]];
	float valDiff = (int)startVal - (int)currentVal;
	if (valDiff > 0) {
		graph.title.text = [NSString stringWithFormat:@"Total Body Fat Loss - %0.0f%%", valDiff];
	} else {
		graph.title.text = [NSString stringWithFormat:@"Total Body Fat Gain - %0.0f%%", valDiff*-1];
							
	}
	[self.graph setGraphWithDataPoints:data];
	//self.graph.goalValue = [NSNumber numberWithFloat:p.weightGoal];
	//self.graph.goalShown = YES;
	[self.graph scrollToPoint:days animated:YES];
	[self.graph showIndicatorForPoint:0];
	//self.graph.goalTitle = [NSString stringWithFormat:@"%d %", p.weightGoal];;
		
	}else {
		graph.title.text = @"Not Enough Measurement Data Recorded Yet";
	}
	
	
	[dateStringList release];
	[dateList release];
	[p release];
	[weightList release];
	[heightList release];
	[hipList release];
	[waistList release];
	[neckList release];
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
