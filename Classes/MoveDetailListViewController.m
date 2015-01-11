//
//  MoveDetailListViewController.m
//  bring-it
//
//  Created by Michael Bordelon on 9/2/10.
//  Copyright 2010 bordeloniphone. All rights reserved.
//

#import "MoveDetailListViewController.h"


@implementation MoveDetailListViewController
@synthesize moveName, detailList, exerciseList, dateList;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	detailList = [[NSMutableArray alloc] init];
	exerciseList = [[NSMutableArray alloc] init];
	dateList = [[NSMutableArray alloc] init];
	detailList = [[BIUtility detailsForMove:[BIUtility moveIDForMoveName:moveName]] retain];
	NSMutableArray * sparklineData = [[NSMutableArray alloc] init];
	int i = 0; 
	BOOL combine = NO;
	BOOL useWeight = NO;	
	NSString * primaryType = [[detailList objectAtIndex:0] moveType];
	for (MoveDetail * md in detailList) {
		NSString * type = [md moveType];
		if ([type isEqual:@"E"]) {
			[detailList removeObjectAtIndex:i];
		} else {
			if ([type isEqual:@"W"]) {
				useWeight = YES;
			}
			if ([type isEqual:@"RC"]) {
				combine = YES;
			}
		}
			
			
		i++;							   
	}
	self.title = moveName;
	
	NSArray *dateStringList = [[BIUtility MoveDateListForMoveID:self.moveName andMoveType:primaryType] retain];
	if ([dateStringList count] > 0) {
		for (NSString * dt in dateStringList) {
			[dateList addObject:[BIUtility dateFromString:dt]];
		}
		[dateList sortUsingSelector:@selector(compare:)];
		
		//NSInteger item = 0;
		NSInteger min = 9999;
		NSString * minString;
		NSInteger max = 0;
		NSString * maxString;
		NSInteger current = 0;
		for (NSDate * d in dateList) {
			NSString * exValue = @"";
			int i = 0;
			for (MoveDetail * md in detailList) {
				
			
				NSString * dtString = [BIUtility dateStringForDate:d];
				NSArray * currentVals = [[BIUtility moveDetailValueForMoveID:self.moveName Type:[md moveType] Date:dtString] retain];
				
				//for (NSNumber * n in currentVals) {
					NSNumber * n = [currentVals objectAtIndex:0];
					NSString * mt = [md moveType];
					NSString * sep = @"";
					if ([[md moveType] isEqual:@"R"]) mt = @"Reps";
					if ([[md moveType] isEqual:@"W"]) mt = @"Lbs";
					if ([[md moveType] isEqual:@"RF"]) mt = @"No Chair";
					if ([[md moveType] isEqual:@"RC"]) mt = @"With Chair";
					if ([[md moveType] isEqual:@"T"]) mt = @"Secs";
					if ([[md moveType] isEqual:@"H"]) mt = @"In";
					
					if (combine) {
						current = current + [n intValue];
					} else if (useWeight && [mt isEqual:@"W"]) {
						current = [n intValue];
					} else {
						current = [n intValue];
					}
					
					
					if (i > 0) sep = @" | ";
					exValue = [NSString stringWithFormat:@"%@%@%d%@ ", exValue, sep, [n integerValue], mt];

				//}
				[currentVals release];
				i++;
			}
			if (current  > max){
				maxString = exValue;
				max = current;
			}
			if (current <= min) {
				minString = exValue;
				min = current;
			}
			[exerciseList addObject:exValue];
			[sparklineData addObject:[NSNumber numberWithInt:current]];
		}
		
		maxLabel.text = maxString;
		minLabel.text = minString;

	}
	
	[dateStringList release];
	[detailList release];
	
	if ([sparklineData count] > 1) {
		CKSparkline *sparkline = [[CKSparkline alloc]
							  initWithFrame:CGRectMake(150.0, 135.0, 140.0, 35.0)];
	
		sparkline.lineColor = [UIColor whiteColor];
		sparkline.data = sparklineData;
	
		[self.view addSubview:sparkline];
		[sparkline release];
	}
	[sparklineData release];
}



#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [dateList count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    //MoveDetail * m = [detailList objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[GradientTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    [cell.textLabel setText:[exerciseList objectAtIndex:indexPath.row]];
	[cell.detailTextLabel setText:[BIUtility dateStringForDate:[dateList objectAtIndex:indexPath.row]]];
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [dateList release];
	[exerciseList release];
	[super dealloc];
	
}


@end

