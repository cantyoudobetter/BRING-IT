//
//  PortionHistoryViewController.m
//  bring-it
//
//  Created by Michael Bordelon on 9/5/10.
//  Copyright 2010 bordeloniphone. All rights reserved.
//

#import "PortionHistoryViewController.h"


@implementation PortionHistoryViewController
@synthesize portionList, passedDate, n;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	portionList = [[BIUtility portionList] retain];
	n = [[BIUtility nutritionForDate:[BIUtility dateFromString:passedDate]] retain];
	self.title = [NSString stringWithFormat:@"%@ Portions", passedDate];
}




#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [portionList count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    //NSInteger tmp = [[n.portionValues objectAtIndex:indexPath.row] integerValue];
	NSString * cellData = [NSString stringWithFormat:@"%d/%d %@s", 
						   [[n.portionValues objectAtIndex:indexPath.row] integerValue],
						   [BIUtility portionTypeCount:(indexPath.row + 1) level:[BIUtility levelForDate:passedDate] phase:[BIUtility phaseForDate:passedDate]],
						   [portionList objectAtIndex:indexPath.row]  ];
	[cell.textLabel setText:cellData];
	
    // Configure the cell...
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

	return 35;
	
}


#pragma mark -
#pragma mark Table view delegate




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
    [n release];
	[portionList release];
	[super dealloc];
}


@end

