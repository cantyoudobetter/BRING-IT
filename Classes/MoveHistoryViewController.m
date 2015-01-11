//
//  MoveHistoryViewController.m
//  bring-it
//
//  Created by Michael Bordelon on 7/19/10.
//  Copyright 2010 bordeloniphone. All rights reserved.
//

#import "MoveHistoryViewController.h"


@implementation MoveHistoryViewController
@synthesize moveList, woID, headerTitle;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	moveList = [[BIUtility moveHistoryForWO:woID] retain];
	self.title = headerTitle;
	p = [[Profile alloc] init];
	UINavigationBar *bar = [self.navigationController navigationBar];
	bar.barStyle = UIBarStyleBlack;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [moveList count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    Move * move = [moveList objectAtIndex:section];
	NSArray * detailList = [BIUtility moveHistoryDetailForMove:move.moveID andWorkout:woID];
	return [detailList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

	return 20;
	
}

-(NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell;
		Move * move = [moveList objectAtIndex:indexPath.section];
		NSArray * detailList = [[BIUtility moveHistoryDetailForMove:move.moveID andWorkout:woID] retain];
		
		MoveDetail * md = [detailList objectAtIndex:(indexPath.row)];
			[tableView dequeueReusableCellWithIdentifier:@"DetailCell"];
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
												 reuseIdentifier:@"DetailCell"] autorelease];
		//NSString * moveTitle = [NSString stringWithFormat:@"%@: %@", md.moveType, md.detailValue];		
		NSString * moveTitle = [self detailStringForType:md.moveType andDetail:md.detailValue];		
	
		[cell.textLabel setText:moveTitle];
		[cell.textLabel setFont:[UIFont fontWithName:@"Helvetica" size:15]];
		cell.textLabel.backgroundColor = [UIColor clearColor];
		cell.accessoryType = UITableViewCellAccessoryNone;
		[detailList release];
	
	return cell;		
}

-(NSString *)detailStringForType:(NSString *)type andDetail:(NSString *)detail {
	NSString * ret;
	if ([type isEqualToString:@"R"]) {
		ret = [NSString stringWithFormat:@"Reps: %@", detail]; 

	} else if ([type isEqualToString:@"RC"]) {
		ret = [NSString stringWithFormat:@"Reps WITH Chair: %@", detail]; 

	} else if ([type isEqualToString:@"RF"]) {
		ret = [NSString stringWithFormat:@"Reps NO Chair: %@", detail]; 
		
	} else if ([type isEqualToString:@"H"]) {
		ret = [NSString stringWithFormat:@"Height (inches): %@", detail]; 
		
	} else if ([type isEqualToString:@"T"]) {
		ret = [NSString stringWithFormat:@"Time (seconds): %@", detail]; 
		
	} else if ([type isEqualToString:@"W"]) {
		ret = [NSString stringWithFormat:@"Weight/Bands: %@", detail]; 
		
	} else if ([type isEqualToString:@"E"]) {
		NSString * effortVal;
		if ([detail isEqualToString:@"0"]) effortVal = @"Too Easy";
		else if ([detail isEqualToString:@"1"]) effortVal = @"Perfect";
		else effortVal = @"Too Hard";
		ret = [NSString stringWithFormat:@"Effort: %@", effortVal]; 
		
		
	}
	return ret;
	
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	Move * m = [moveList objectAtIndex:section];
	NSString * moveString = m.moveName;
	 
	
	return moveString;
	
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
    [moveList release];
	[super dealloc];
}


@end

