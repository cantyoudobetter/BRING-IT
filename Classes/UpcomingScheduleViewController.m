//
//  UpcomingScheduleViewController.m
//  Bring It
//
//  Created by Michael Bordelon on 6/6/10.
//  Copyright 2010 Bordelon iPhone. All rights reserved.
//

#import "UpcomingScheduleViewController.h"


@implementation UpcomingScheduleViewController
@synthesize scheduleDay, dateList, woCount;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

	p = [[Profile alloc] init];
	dateList = [[NSMutableArray alloc] init];
	scheduleDay = [BIUtility scheduleDay];
	self.title = @"Upcoming Schedule";
	woCount = [BIUtility workoutCountInProgram];
		for (int i = 0; i <= (woCount - scheduleDay); i++) {

			NSInteger sectionDay = (i + scheduleDay);
		 
			NSString * scheduleDate = [BIUtility addToStart:sectionDay startDate:[BIUtility dateFromString:p.startDate]];
			//NSLog(scheduleDate);
		
			[dateList addObject:scheduleDate];    
		
		}
	UINavigationBar *bar = [self.navigationController navigationBar];
	bar.barStyle = UIBarStyleBlack;
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back"
									 style:UIBarButtonItemStyleBordered
									target:self
									action:@selector(handleBack:)] autorelease];
}

- (void) handleBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

	return (woCount - scheduleDay + 1);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSInteger sectionDay = (section + scheduleDay);
	NSArray * woForSection = [[BIUtility workoutForDate:sectionDay Schedule:p.scheduleID] retain];

	NSInteger rowsForSection = [woForSection count];
	[woForSection release];
	return rowsForSection ;
	
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger sectionDay = (indexPath.section + scheduleDay);
	NSArray * woForSection = [[BIUtility workoutForDate:sectionDay Schedule:p.scheduleID] retain];
	NSString * woTitle = [woForSection objectAtIndex:indexPath.row];
	
	
	UITableViewCell *cell;
	
	cell = [tableView dequeueReusableCellWithIdentifier:@"ScheduleCell"];
	if (cell == nil) {
		cell = [[[GradientTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ScheduleCell"] autorelease];
	}	
			
	[cell.textLabel setText:woTitle];
	cell.accessoryType = UITableViewCellAccessoryNone;
			
	[woForSection release];
	return cell;	
	
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	//NSLog([dateList objectAtIndex:section]);

	return [dateList objectAtIndex:section];
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
    [p release];
	[dateList release];
	[super dealloc];
}


@end

