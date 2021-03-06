//
//  WorkoutViewController.m
//  Bring It
//
//  Created by Michael Bordelon on 4/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WorkoutViewController.h"
#import "MoveListViewController.h"
#import "Profile.h"

#define SectionHeaderHeight 40
#define TableViewTag 999
#define ViewTag 222



@implementation WorkoutViewController
@synthesize todaysWorkouts;
@synthesize woNoteCell, woIndex;
@synthesize editMode, passedDate, currentDate, removeEnabled;


-(IBAction)toggleEdit:(id)sender {

	[self.tableView setEditing:!self.tableView.editing animated:YES];
	if (self.tableView.editing) {
		[self.navigationItem.leftBarButtonItem setTitle:@"Done"];
	} else {
		
		[self.navigationItem.leftBarButtonItem setTitle:@"Remove"];
	}
	
}
-(IBAction)donePressed:(id)sender {
	toolbar.hidden = YES;
	[self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
	toolbar.hidden = YES;
	
}
-(IBAction)buttonAddWorkout:(id)sender {
	NSArray * list = [[BIUtility allWorkouts] retain];
	SinglePickerViewController *singlePickerViewController = [[SinglePickerViewController alloc] 
															  initWithNibName:@"SinglePickerViewController" 
															  bundle:nil];	
	singlePickerViewController.initialRow = 0;	
	singlePickerViewController.viewTitle = [NSString stringWithFormat:@"Pick Workout"];
	singlePickerViewController.delegate = self;
	singlePickerViewController.pickerData = list;
	[self presentModalViewController:singlePickerViewController animated:YES];
	
	[singlePickerViewController release];
	[list release];
	
}

- (void)handleTextViewChange:(NSString *)passedText {
	
	Workout *wo = [todaysWorkouts objectAtIndex:self.woIndex];
	wo.woNote = passedText;
	[BIUtility updateWorkout:wo];
	[todaysWorkouts release];
	todaysWorkouts = [[[NSArray alloc] initWithArray:[BIUtility todaysScheduledWorkouts]] retain];
	
	[self.tableView reloadData];	
	[self dismissModalViewControllerAnimated:YES];
	
}

- (void)handlePickerChange:(NSInteger)index{
	
	
	Workout *wo = [[Workout alloc] init];
	wo.workoutID = index + 1;
	[BIUtility addInitialWorkout:wo forDate:currentDate];
	[todaysWorkouts release];
	todaysWorkouts = [[[NSArray alloc] initWithArray:[BIUtility todaysScheduledWorkouts]] retain];

	[self.tableView reloadData];
	[self dismissModalViewControllerAnimated:YES];
	[wo release];
	if (self.navigationItem.leftBarButtonItem == nil && [todaysWorkouts count] > 0) {
		UIBarButtonItem *editButton = [[UIBarButtonItem alloc]
									   initWithTitle:@"Remove" 
									   style:UIBarButtonItemStyleBordered
									   target:self
									   action:@selector(toggleEdit:)];
		self.navigationItem.leftBarButtonItem = editButton;
		[editButton release];
	}
}

//@synthesize woSwitchCell;
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	NSInteger rowsRet = [BIUtility numberOfScheduledWorkoutsForDate:currentDate];
	//If there are none, add them here from the config table.
	if (rowsRet == 0 && !editMode) {
		NSArray *woConfigList = [BIUtility workoutsConfiguredForToday];
		for (Workout *wo in woConfigList)  
			[BIUtility addInitialWorkout:wo];
		//[woConfigList release];
		
	}
	[todaysWorkouts release];
	todaysWorkouts = [[[NSArray alloc] initWithArray:[BIUtility scheduledWorkoutsForDate:currentDate]] retain];
	[self.tableView reloadData];
	[self.tableView setEditing:NO animated:YES];
	if (editMode) {
		toolbar.hidden = NO;
	}
	if (self.navigationItem.leftBarButtonItem == nil && [todaysWorkouts count] > 0) {
		UIBarButtonItem *editButton = [[UIBarButtonItem alloc]
									   initWithTitle:@"Remove" 
									   style:UIBarButtonItemStyleBordered
									   target:self
									   action:@selector(toggleEdit:)];
		self.navigationItem.leftBarButtonItem = editButton;
		[editButton release];
	} else if (self.navigationItem.leftBarButtonItem != nil && [todaysWorkouts count] > 0) {
		[self.navigationItem.leftBarButtonItem setTitle:@"Remove"];
	}
	

}

- (void)viewDidLoad {
	currentDate = [[BIUtility todayDateString] retain];
	
	if (editMode) {
		currentDate = passedDate;
		self.title = [NSString stringWithFormat:@"%@ Workout(s)", currentDate];
		
		toolbar = [[UIToolbar alloc] init];
		toolbar.barStyle = UIBarStyleBlack;
		
		//Set the toolbar to fit the width of the app.
		[toolbar sizeToFit];
		
		//Caclulate the height of the toolbar
		CGFloat toolbarHeight = [toolbar frame].size.height;
		
		//Get the bounds of the parent view
		CGRect rootViewBounds = self.parentViewController.view.bounds;
		
		//Get the height of the parent view.
		CGFloat rootViewHeight = CGRectGetHeight(rootViewBounds);
		
		//Get the width of the parent view,
		CGFloat rootViewWidth = CGRectGetWidth(rootViewBounds);
		
		//Create a rectangle for the toolbar
		CGRect rectArea = CGRectMake(0, rootViewHeight - toolbarHeight, rootViewWidth, toolbarHeight);
		
		//Reposition and resize the receiver
		[toolbar setFrame:rectArea];
		
		//Create a button
		UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
									  initWithTitle:@"Done Editing Workouts" 
									  style:UIBarButtonItemStyleBordered
									  target:self
									  action:@selector(donePressed:)];
		[toolbar setItems:[NSArray arrayWithObjects:doneButton,nil]];
		
		//Add the toolbar as a subview to the navigation controller.
		[self.navigationController.view addSubview:toolbar];
		[doneButton release];
	} else {
		self.title = @"Workout";
	}

	
		
	NSInteger rowsRet = [BIUtility numberOfScheduledWorkoutsForDate:currentDate];
	//If there are none, add them here from the config table.
	if (rowsRet == 0 && !editMode) {
		NSArray *woConfigList = [BIUtility workoutsConfiguredForToday];
		for (Workout *wo in woConfigList)  
			[BIUtility addInitialWorkout:wo];
		//[woConfigList release];


			
	}
	
	self.view.backgroundColor = [UIColor blackColor];
	todaysWorkouts = [[[NSArray alloc] initWithArray:[BIUtility scheduledWorkoutsForDate:currentDate]] retain];

	UIBarButtonItem *editButton = [[UIBarButtonItem alloc]
					initWithTitle:@"Remove" 
							style:UIBarButtonItemStyleBordered
						   target:self
								   action:@selector(toggleEdit:)];
	self.navigationItem.leftBarButtonItem = editButton;
	[editButton release];
	
	UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
								   initWithTitle:@"Add" 
								   style:UIBarButtonItemStyleBordered
								   target:self
								   action:@selector(buttonAddWorkout:)];
	self.navigationItem.rightBarButtonItem = addButton;
	[addButton release];	
	
    [super viewDidLoad];
}



- (void)tableView:(UITableView *)tableView
		commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
		forRowAtIndexPath:(NSIndexPath *)indexPath {
	NSUInteger sID = [indexPath section];
	
	Workout *wo = [todaysWorkouts objectAtIndex:sID];
	[BIUtility deleteWorkoutInstance:wo.woInstanceID];
	[todaysWorkouts release];
	todaysWorkouts = [[[NSArray alloc] initWithArray:[BIUtility scheduledWorkoutsForDate:currentDate]] retain];

	//[self.tableView reloadData];
	[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sID]
				  withRowAnimation:UITableViewRowAnimationFade];
	
	if ([todaysWorkouts count] == 0) {
		//[self.navigationItem.leftBarButtonItem setTitle:@"Remove"];
		self.navigationItem.leftBarButtonItem = nil;
	}
}

	


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
	{
		
		if(indexPath.row == 0)
		{
			return UITableViewCellEditingStyleDelete;
		} else {
			return UITableViewCellEditingStyleNone;
		}
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	//static NSString *noteCellIdentifier = @"NoteCellIdentifier";
	
	UITableViewCell *cell;
	UACellBackgroundView *bv = [[UACellBackgroundView alloc] initWithFrame:CGRectZero];

	Workout *wo = [todaysWorkouts objectAtIndex:indexPath.section];	
	NSArray * moves = [[BIUtility movesForWorkout:wo.workoutID]retain];
	if (indexPath.row == 0) {
		bv.position = UACellBackgroundViewPositionTop;
		cell = [tableView dequeueReusableCellWithIdentifier:@"WorkoutCell"];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier: @"WorkoutCell"] autorelease];
			if ([moves count] > 0) {
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			} else {
				cell.accessoryType = UITableViewCellAccessoryNone;
			}
		}	
			
		[cell.textLabel setText:wo.workoutName];
		//cell.textLabel.textAlignment = UITextAlignmentCenter;
		[cell.textLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
	} else if (indexPath.row == 1){
		bv.position = UACellBackgroundViewPositionMiddle;
		cell = [tableView dequeueReusableCellWithIdentifier:@"CompleteCell"];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier: @"CompleteCell"] autorelease];
			
		}
		if (wo.woComplete == 0) {
			[cell.textLabel setText:@"Touch to Mark Completed"];
			cell.imageView.image = [UIImage imageNamed:@"workoutnotcomplete.png"];
			[cell.textLabel setTextColor:[UIColor blueColor]];
		}
		else { 
			[cell.textLabel setText:@"Workout Completed"];
			cell.imageView.image = [UIImage imageNamed:@"workoutcomplete.png"];
		}

		[cell.textLabel setFont:[UIFont fontWithName:@"Helvetica" size:18]];
		
	} else {
		bv.position = UACellBackgroundViewPositionBottom;
		cell = [tableView dequeueReusableCellWithIdentifier:@"WoNoteCell"];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier: @"WoNoteCell"] autorelease];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}	
		NSString * note;
		note = [NSString stringWithFormat:@"Note: %@", wo.woNote];
		
		[cell.textLabel setText:note];
		cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        cell.textLabel.numberOfLines = 0;
		[cell.textLabel setFont:[UIFont fontWithName:@"Helvetica" size:16]];
		cell.imageView.image = [UIImage imageNamed:@"1note.png"];
	}

	
	cell.textLabel.backgroundColor = [UIColor clearColor];
	cell.backgroundView = bv;
	[bv release];
	[moves release];
	return cell;	
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSUInteger row = [indexPath row];
	
	Workout *wo = [todaysWorkouts objectAtIndex:indexPath.section];
	NSArray * moves = [[BIUtility movesForWorkout:wo.workoutID]retain];

	if (row == 0) {
		if ([moves count] > 0) {
		
			MoveListViewController *moveListController = [[MoveListViewController alloc] initWithStyle:UITableViewStylePlain];
			moveListController.workoutID = wo.workoutID;
			moveListController.workoutName = wo.workoutName;
			moveListController.woInstanceID = wo.woInstanceID;
			moveListController.editMode = self.editMode;
			moveListController.passedDate = self.passedDate;
			Bring_ItAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
			if (!editMode) {
				[delegate.workoutNavController pushViewController:moveListController animated:YES];
			}else {
				[delegate.historyNavController pushViewController:moveListController animated:YES];
			}

			[moveListController release];
		}	
	} else if (row == 1) {
			if (wo.woComplete == 0) {
				wo.woComplete = 1;
				[BIUtility updateWorkout:wo];
				
			}
			else {
				wo.woComplete = 0;
				[BIUtility updateWorkout:wo];
			}
		[tableView reloadData];
	} else if (row == 2) {
		TextViewController *textViewController = [[TextViewController alloc] 
												initWithNibName:@"TextViewController" 
												bundle:nil];
		
		textViewController.delegate = self;
		textViewController.viewTitle = @"Workout Note";
		textViewController.initialText = wo.woNote;
		self.woIndex = indexPath.section;
		
		[self presentModalViewController:textViewController animated:YES];
		
		[textViewController release];
		
		
	}
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	[moves release];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSUInteger row = [indexPath row];
	NSInteger h;
	if (row < 2) {
		h = 45;
	} else {
		Workout *wo = [todaysWorkouts objectAtIndex:indexPath.section];
		NSString * note;
		//if (wo.woNote == nil || wo.woNote == @"") note = @"HOLDER";
		note = [NSString stringWithFormat:@"Note: %@", wo.woNote];
		NSString *cellText = note;
		UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:16];
		CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
		CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
		h =  labelSize.height + 25;
	}
	
	return h;
	
		
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return ([todaysWorkouts count]);

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
		return 3;
	
	
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

	
		return nil;
	
	
}


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
    [todaysWorkouts release];
	[super dealloc];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([self tableView:tableView titleForHeaderInSection:section] != nil) {
        return SectionHeaderHeight;
    }
    else {
        // If no section header title, no section header needed
        return 0;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return nil;
    }
	
    // Create label with section title
    UILabel *label = [[[UILabel alloc] init] autorelease];
    label.frame = CGRectMake(20, 6, 300, 30);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
					   
    label.shadowColor = [UIColor clearColor];
    label.shadowOffset = CGSizeMake(0.0, 1.0);
    label.font = [UIFont boldSystemFontOfSize:16];
    label.text = sectionTitle;
	
    // Create header view and add label as a subview
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, SectionHeaderHeight)];
    [view autorelease];
    [view addSubview:label];
	
    return view;
}



@end
