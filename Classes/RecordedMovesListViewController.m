//
//  RecordedMovesListViewController.m
//  bring-it
//
//  Created by Michael Bordelon on 9/1/10.
//  Copyright 2010 bordeloniphone. All rights reserved.
//

#import "RecordedMovesListViewController.h"


@implementation RecordedMovesListViewController
@synthesize moveList;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

	moveList = [[NSMutableArray alloc] initWithArray:[BIUtility recordedMoves]];
	self.title = @"Select Exercise";
	
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [moveList count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[GradientTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	[cell.textLabel setText:[moveList objectAtIndex:indexPath.row]];
	//cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}




#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
		MoveDetailListViewController *moveDetailListViewController = [[MoveDetailListViewController alloc] 
													initWithNibName:@"MoveDetailListViewController" 
													bundle:nil];
	
		//moveDetailListViewController.hidesBottomBarWhenPushed = YES;
		moveDetailListViewController.moveName = [moveList objectAtIndex:indexPath.row];
		Bring_ItAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
		[delegate.historyNavController pushViewController:moveDetailListViewController animated:YES];
		[moveDetailListViewController release];
	

	
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

