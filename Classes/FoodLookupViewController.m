//
//  FoodLookupViewController.m
//  bring-it
//
//  Created by Michael Bordelon on 8/24/10.
//  Copyright 2010 bordeloniphone. All rights reserved.
//

#import "FoodLookupViewController.h"


@implementation FoodLookupViewController
@synthesize foodList, portionTypeID, currentDate, selectedSection, selectedRow;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"Foods";
	
	
}



#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    if (portionTypeID > 0) {
		return 1;
	} else {
		return 10;
	}
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (portionTypeID > 0) {
		return [[BIUtility foodsForPortionType:portionTypeID] count];
	} else {
		
		return [[BIUtility foodsForPortionType:(section+1)] count];
	}
	
	
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	NSInteger pID;
    if (portionTypeID > 0) {
		pID = portionTypeID;
	} else {
		pID = indexPath.section + 1;
	}
    foodList = [[BIUtility foodsForPortionType:pID] retain];
	
    NSString *CellIdentifier = [NSString stringWithFormat:@"f%d%d",indexPath.row,indexPath.section];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[[GradientTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		NSString * foodDesc = [[foodList objectAtIndex:indexPath.row] description];
		//NSLog(@"Food For Row:%d, %@ ", indexPath.row, foodDesc);
		[cell.textLabel setText:foodDesc];
		NSString * c = [NSString stringWithFormat:@"Calories: %d", [[foodList objectAtIndex:indexPath.row] calories]];
		[cell.detailTextLabel setText:c];
	}	
	[foodList release];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSInteger pID;
	if (portionTypeID > 0) {
		pID = portionTypeID;
	} else {
		pID = section+1;
	}
	
	NSString * ret = [NSString stringWithFormat:@"%@", [[BIUtility portionList] objectAtIndex:(pID-1)]];
	return ret;
	
}



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSInteger pID;
    if (portionTypeID > 0) {
		pID = portionTypeID;
	} else {
		pID = indexPath.section + 1;
	}
    foodList = [[BIUtility foodsForPortionType:pID] retain];
	NSString * foodDesc = [[foodList objectAtIndex:indexPath.row] description];
	UIActionSheet *actionSheet = [[UIActionSheet alloc]
								  initWithTitle:foodDesc 
								  delegate:self
								  cancelButtonTitle:@"Cancel" 
								  destructiveButtonTitle:nil
								  otherButtonTitles:@"\u00BD Serving",@"1 Serving",@"2 Servings",@"3 Servings", nil];
	[actionSheet showInView:self.view];
	[actionSheet release];
	selectedRow = indexPath.row;
	selectedSection = indexPath.section;
	
}
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger) buttonIndex {
	
	if (!(buttonIndex == [actionSheet cancelButtonIndex])) {
		NSInteger pID;
		if (portionTypeID > 0) {
			pID = portionTypeID;
		} else {
			pID = selectedSection + 1;
		}
		foodList = [[BIUtility foodsForPortionType:pID] retain];
		Food * f = [foodList objectAtIndex:selectedRow];
		float servings = 0.0f;
		NSString *servingText;
		NSInteger portionServing;
		if (buttonIndex == 0) {
			servings = 0.5f;
			portionServing = 1;
			servingText = @"\u00BD";
		} else {
			servings = buttonIndex;
			portionServing = servings;
			servingText = [NSString stringWithFormat:@"%0.0f", servings];
		}

		
		Nutrition * nut = [[BIUtility nutritionForDate:[BIUtility dateFromString:currentDate]] retain];
		NSInteger totalCals = f.calories * servings;
		if ([nut.foodLog length] == 0) {
			nut.foodLog = [NSString stringWithFormat:@"%@ X %@ | %d cals",servingText, f.description, totalCals];
		} else {
			nut.foodLog = [NSString stringWithFormat:@"%@\n%@ X %@ | %d cals",nut.foodLog, servingText, f.description, totalCals];
			
		}
		nut.calories = nut.calories + totalCals;
		NSInteger currentPortionValue = [[nut.portionValues objectAtIndex:pID-1] integerValue];
		NSInteger newPortionValue = currentPortionValue + portionServing;
		//for (NSNumber * tempNum in nut.portionValues) {
		//	NSLog(@"before portionVals: %d", [tempNum integerValue]);
		//}
		
		[nut.portionValues replaceObjectAtIndex:pID-1 withObject:[NSNumber numberWithInteger:newPortionValue]];
		
		//for (NSNumber * tempNum in nut.portionValues) {
		//	NSLog(@"after portionVals: %d", [tempNum integerValue]);
		//}
		
		nut.level = [BIUtility currentPhase];
		nut.phase = [BIUtility currentLevel];
		nut.logDate = [BIUtility dateFromString:currentDate];
		[BIUtility saveNutrition:nut forDate:currentDate];
		[nut release];	
		[self.navigationController popViewControllerAnimated:YES];
		
	}
	
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
    //[foodList release];
	[super dealloc];
}


@end

