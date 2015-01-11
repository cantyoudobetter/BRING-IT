    //
//  MoveListViewController.m
//  Bring It
//
//  Created by Michael Bordelon on 4/22/10.
//  Copyright 2010 Bordelon iPhone. All rights reserved.
//

#import "MoveListViewController.h"



@implementation MoveListViewController
@synthesize workoutID, moveListForWorkout, workoutName, woInstanceID, cellView, editMode, passedDate, currentDate;



- (void)viewDidLoad {
    [super viewDidLoad];
	moveListForWorkout = [[BIUtility movesForWorkout:workoutID] retain];
	self.title = workoutName;
	UINavigationBar *bar = [self.navigationController navigationBar];
	bar.barStyle = UIBarStyleBlack;
	currentDate = [[BIUtility todayDateString] retain];
	
	if (editMode) {
		currentDate = passedDate;
	} 
}

- (void)viewDidAppear:(BOOL)animated {
	NSLog(@"workoutID: %d", self.workoutID);
	[super viewWillAppear:animated];
	[self.tableView reloadData];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.moveListForWorkout count];

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSInteger h = 45;
	return h;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
		
	UITableViewCell *cell;
	Move *move = [moveListForWorkout objectAtIndex:indexPath.row];
	NSArray * details = [[BIUtility detailsForMove:move.moveID] retain];
	if ([details count] > 0) {
		cell = [tableView dequeueReusableCellWithIdentifier:@"MoveCellDisclose"];
		if (cell == nil) {
			cell = [[[GradientTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MoveCellDisclose"] autorelease];
			
			cell.accessoryType = UITableViewCellAccessoryNone;
		}	
		
		if ( [BIUtility detailsRecordedForMove:move.moveID forDate:currentDate]) {
			cell.imageView.image = [UIImage imageNamed:@"workoutcomplete.png"];
		} else {
			cell.imageView.image = [UIImage imageNamed:@"workoutnotcomplete.png"];
		}
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
		
	} else {
		cell = [tableView dequeueReusableCellWithIdentifier:@"MoveCell"];
		if (cell == nil) {
			cell = [[[GradientTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MoveCell"] autorelease];
			
			cell.accessoryType = UITableViewCellAccessoryNone;
		}	
		cell.imageView.image = [UIImage imageNamed:@"nothing.png"];
	}		
	[cell.textLabel setText:move.moveName];
	[details release];
	return cell;	
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	Move *move = [moveListForWorkout objectAtIndex:indexPath.row];			
	NSArray * details = [[BIUtility detailsForMove:move.moveID] retain];

	if ([details count] > 0) {	
		MoveDetailViewController *moveDetailController = [[MoveDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
		
		moveDetailController.moveID = [[moveListForWorkout objectAtIndex:indexPath.row] moveID];
		moveDetailController.moveName = [[moveListForWorkout objectAtIndex:indexPath.row] moveName];
		moveDetailController.woInstanceID = [self woInstanceID];
		moveDetailController.moveList = [self moveListForWorkout];
		moveDetailController.editMode = self.editMode;
		moveDetailController.passedDate = currentDate;
		
		Bring_ItAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
		if (editMode) {
			[delegate.historyNavController pushViewController:moveDetailController animated:YES];
				
		} else {
			[delegate.workoutNavController pushViewController:moveDetailController animated:YES];
		}

		[moveDetailController release];
	}
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	[details release];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [moveListForWorkout release];
	[currentDate release];
	[super dealloc];
}


@end