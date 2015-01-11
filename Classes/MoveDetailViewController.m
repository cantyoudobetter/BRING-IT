    //
//  MoveDetailViewController.m
//  Bring It
//
//  Created by Michael Bordelon on 4/23/10.
//  Copyright 2010 Bordelon iPhone. All rights reserved.
//

#import "MoveDetailViewController.h"
#import "RepsCell.h"
#import "WeightCell.h"
#import "EffortCell.h"

#define TableViewTag 333
#define SectionHeaderHeight 40

@implementation MoveDetailViewController
@synthesize woInstanceID, moveID, detailListForMove, moveName, weightCount, effortID, tmpMoveDetail, previousDetails;
@synthesize repsCount, puChairCount, puNoChairCount, height, time, moveList, editMode, currentDate, passedDate;


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSInteger h = 60;
	return h;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString *mt = [[detailListForMove objectAtIndex:indexPath.section] moveType];
		
	UACellBackgroundView *bv = [[UACellBackgroundView alloc] initWithFrame:CGRectZero];	
	bv.position = UACellBackgroundViewPositionSingle;
	

	
	
	if ([mt isEqualToString:@"R"]) {
		//repsCount = [detailValue integerValue];
		static NSString *repsCellIdentifier = @"repsCellIdentifier";
		RepsCell *cell = (RepsCell *)[tableView dequeueReusableCellWithIdentifier: repsCellIdentifier];
		
		if (cell == nil) {
			NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RepsCell" owner:self options:nil];
			cell = [nib objectAtIndex:0];
		
			[[cell upButton]   addTarget:self action:@selector(repsUpButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
			[[cell downButton] addTarget:self action:@selector(repsDownButtonPressed:) forControlEvents:UIControlEventTouchUpInside];		
			[[cell upButton10]   addTarget:self action:@selector(repsUpButton10Pressed:) forControlEvents:UIControlEventTouchUpInside];
			[[cell downButton10] addTarget:self action:@selector(repsDownButton10Pressed:) forControlEvents:UIControlEventTouchUpInside];		
		}	
		[cell.repsLabel setText:[NSString stringWithFormat:@"%d",  repsCount]];
		
		cell.backgroundView = bv;
		
		cell.textLabel.backgroundColor = [UIColor clearColor];
		return cell;
		
	} else if ([mt isEqualToString:@"RC"]) {
			//repsCount = [detailValue integerValue];
			static NSString *repsCellIdentifier = @"repsChairCellIdentifier";
			RepsCell *cell = (RepsCell *)[tableView dequeueReusableCellWithIdentifier: repsCellIdentifier];
			
			if (cell == nil) {
				NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RepsCell" owner:self options:nil];
				cell = [nib objectAtIndex:0];
				
				[[cell upButton]   addTarget:self action:@selector(repsChairUpButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
				[[cell downButton] addTarget:self action:@selector(repsChairDownButtonPressed:) forControlEvents:UIControlEventTouchUpInside];		
				[[cell upButton10]   addTarget:self action:@selector(repsChairUpButton10Pressed:) forControlEvents:UIControlEventTouchUpInside];
				[[cell downButton10] addTarget:self action:@selector(repsChairDownButton10Pressed:) forControlEvents:UIControlEventTouchUpInside];		
			}	
			[cell.repsLabel setText:[NSString stringWithFormat:@"%d",  puChairCount]];
			
			cell.backgroundView = bv;
			
			cell.textLabel.backgroundColor = [UIColor clearColor];
			return cell;
	} else if ([mt isEqualToString:@"H"]) {
		//repsCount = [detailValue integerValue];
		static NSString *repsCellIdentifier = @"heightCellIdentifier";
		RepsCell *cell = (RepsCell *)[tableView dequeueReusableCellWithIdentifier: repsCellIdentifier];
		
		if (cell == nil) {
			NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RepsCell" owner:self options:nil];
			cell = [nib objectAtIndex:0];
			
			[[cell upButton]   addTarget:self action:@selector(heightUpButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
			[[cell downButton] addTarget:self action:@selector(heightDownButtonPressed:) forControlEvents:UIControlEventTouchUpInside];		
			[[cell upButton10]   addTarget:self action:@selector(heightUpButton10Pressed:) forControlEvents:UIControlEventTouchUpInside];
			[[cell downButton10] addTarget:self action:@selector(heightDownButton10Pressed:) forControlEvents:UIControlEventTouchUpInside];		
		}	
		[cell.repsLabel setText:[NSString stringWithFormat:@"%d",  height]];
		
		cell.backgroundView = bv;
		
		cell.textLabel.backgroundColor = [UIColor clearColor];
		return cell;
	} else if ([mt isEqualToString:@"T"]) {
		//repsCount = [detailValue integerValue];
		static NSString *repsCellIdentifier = @"timeCellIdentifier";
		RepsCell *cell = (RepsCell *)[tableView dequeueReusableCellWithIdentifier: repsCellIdentifier];
		
		if (cell == nil) {
			NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RepsCell" owner:self options:nil];
			cell = [nib objectAtIndex:0];
			
			[[cell upButton]   addTarget:self action:@selector(timeUpButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
			[[cell downButton] addTarget:self action:@selector(timeDownButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
			[[cell upButton10]   addTarget:self action:@selector(timeUpButton10Pressed:) forControlEvents:UIControlEventTouchUpInside];
			[[cell downButton10] addTarget:self action:@selector(timeDownButton10Pressed:) forControlEvents:UIControlEventTouchUpInside];
			
		}	
		[cell.repsLabel setText:[NSString stringWithFormat:@"%d",  time]];
		
		cell.backgroundView = bv;
		
		cell.textLabel.backgroundColor = [UIColor clearColor];
		return cell;
		
		
		
			
		
	} else if ([mt isEqualToString:@"RF"]) {
		//repsCount = [detailValue integerValue];
		static NSString *repsCellIdentifier = @"repsNoChairCellIdentifier";
		RepsCell *cell = (RepsCell *)[tableView dequeueReusableCellWithIdentifier: repsCellIdentifier];
		
		if (cell == nil) {
			NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RepsCell" owner:self options:nil];
			cell = [nib objectAtIndex:0];
			
			[[cell upButton]   addTarget:self action:@selector(repsNoChairUpButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
			[[cell downButton] addTarget:self action:@selector(repsNoChairDownButtonPressed:) forControlEvents:UIControlEventTouchUpInside];		
			[[cell upButton10]   addTarget:self action:@selector(repsNoChairUpButton10Pressed:) forControlEvents:UIControlEventTouchUpInside];
			[[cell downButton10] addTarget:self action:@selector(repsNoChairDownButton10Pressed:) forControlEvents:UIControlEventTouchUpInside];		
		}	
		[cell.repsLabel setText:[NSString stringWithFormat:@"%d",  puNoChairCount]];
		
		cell.backgroundView = bv;
		
		cell.textLabel.backgroundColor = [UIColor clearColor];
		return cell;
		
		
		
	} else if ([mt isEqualToString:@"W"]) {
		//weightCount = [detailValue integerValue];
		static NSString *weightCellIdentifier = @"weightCellIdentifier";
		WeightCell *cell = (WeightCell *)[tableView dequeueReusableCellWithIdentifier: weightCellIdentifier];
		if (cell == nil) {
			NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"WeightCell" owner:self options:nil];
			cell = [nib objectAtIndex:0];
			
			[[cell upButton]   addTarget:self action:@selector(weightUpButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
			[[cell downButton] addTarget:self action:@selector(weightDownButtonPressed:) forControlEvents:UIControlEventTouchUpInside];		
			[[cell upButton5]   addTarget:self action:@selector(weightUpButton5Pressed:) forControlEvents:UIControlEventTouchUpInside];
			[[cell downButton5] addTarget:self action:@selector(weightDownButton5Pressed:) forControlEvents:UIControlEventTouchUpInside];		
		}	
		[cell.weightLabel setText:[NSString stringWithFormat:@"%d",  weightCount]];
		cell.backgroundView = bv;
		cell.textLabel.backgroundColor = [UIColor clearColor];
		return cell;
		
	}  else if ([mt isEqualToString:@"E"]) {
		//effortID = [detailValue integerValue]; 
		static NSString *effortCellIdentifier = @"effortCellIdentifier";
		EffortCell *cell = (EffortCell *)[tableView dequeueReusableCellWithIdentifier: effortCellIdentifier];
		if (cell == nil) {
			NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EffortCell" owner:self options:nil];
			cell = [nib objectAtIndex:0];
			
			[[cell effortButton]   addTarget:self action:@selector(effortButtonPressed:) forControlEvents:UIControlEventValueChanged];
			[cell.effortButton setSelectedSegmentIndex:effortID];
			
		}	
		cell.backgroundView = bv;
		cell.textLabel.backgroundColor = [UIColor clearColor];
		return cell;
		
	}  
	[bv release];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
		return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [detailListForMove count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSString *mt = [[detailListForMove objectAtIndex:section] moveType];
	NSString *retHeader;
	NSString * pd = [previousDetails objectAtIndex:section];
	if ([mt isEqualToString:@"R"]) {
		if ([pd length] == 0) retHeader =  @"Repititions";
		else retHeader = [NSString stringWithFormat:@"Repititions (previous: %@)", pd];
	} else if ([mt isEqualToString:@"RC"]) {
			if ([pd length] == 0) retHeader =  @"WITH Chair";
			else retHeader = [NSString stringWithFormat:@"WITH Chair (previous: %@)", pd];
	} else if ([mt isEqualToString:@"RF"]) {
		if ([pd length] == 0) retHeader =  @"NO Chair";
		else retHeader = [NSString stringWithFormat:@"NO Chair (previous: %@)", pd];
	} else if ([mt isEqualToString:@"H"]) {
		if ([pd length] == 0) retHeader =  @"Height (inches)";
		else retHeader = [NSString stringWithFormat:@"Height (inches) (previous: %@)", pd];
	} else if ([mt isEqualToString:@"T"]) {
		if ([pd length] == 0) retHeader =  @"Time (seconds)";
		else retHeader = [NSString stringWithFormat:@"Time (seconds) (previous: %@)", pd];
	} else if ([mt isEqualToString:@"W"]) {
		if ([pd length] == 0) retHeader =  @"Weight/Bands";
		else retHeader = [NSString stringWithFormat:@"Weight/Bands (previous: %@)", pd];

	} else if ([mt isEqualToString:@"E"]) {
		NSString * effortVal;
		if ([pd isEqualToString:@"0"]) effortVal = @"Too Easy";
		else if ([pd isEqualToString:@"1"]) effortVal = @"Perfect";
		else effortVal = @"Too Hard";

		
		if ([pd length] == 0) retHeader =  @"Effort";
		else retHeader = [NSString stringWithFormat:@"Effort (previous: %@)", effortVal];

	} else {
		retHeader = @"Record Data";
	}

	return retHeader;
	
	
			
}

- (void)effortButtonPressed:(id)sender
{
	
	
	EffortCell *cell=(EffortCell *)[[sender superview] superview];
	
	UITableView *table=(UITableView*)[cell superview];
	NSIndexPath *path=[table indexPathForCell:cell];
	
	if (path.section > 0) {
		UISegmentedControl *effortSC = (UISegmentedControl *)sender;
		//NSLog(@"Effort Button been pressed %d si %d",path.section, path.row);
		//NSLog(@"Effort Button been pressed value: %d", effortSC.selectedSegmentIndex);
		effortID = effortSC.selectedSegmentIndex;
	
		//[cell.effortButton setSelectedSegmentIndex:effortID];
	
		
		//tmpMoveDetail.moveDetailID = [BIUtility moveDetailIDForMove:self.moveID
		//													   Type:@"E"];
		//tmpMoveDetail.moveID = self.moveID;
		//tmpMoveDetail.workoutID = self.woInstanceID;
		//tmpMoveDetail.moveType = @"E";
		//[tmpMoveDetail setDetailValue:[NSString stringWithFormat:@"%d", effortID]];     
		//[BIUtility saveMoveDetailRecord:tmpMoveDetail];
	
		[table reloadData];	
	}
	
	
}

- (void)repsUpButtonPressed:(id)sender
{
	UITableViewCell *cell=(UITableViewCell*)[[sender superview] superview];
	
	UITableView *table=(UITableView*)[cell superview];
	NSIndexPath *path=[table indexPathForCell:cell];
	
	NSLog(@"Up rep been pressed %d si %d",path.section, path.row);
	
	repsCount ++;
	
	if (repsCount > 500) repsCount = 500;
	
	[table reloadData];
	
	
}

- (void)repsDownButtonPressed:(id)sender
{
	UITableViewCell *cell=(UITableViewCell*)[[sender superview] superview];
	
	UITableView *table=(UITableView*)[cell superview];
	//NSIndexPath *path=[table indexPathForCell:cell];
	
	repsCount --;
	
	if (repsCount < 0) repsCount = 0;
	
	
	[table reloadData];
	
}
- (void)repsUpButton10Pressed:(id)sender
{
	UITableViewCell *cell=(UITableViewCell*)[[sender superview] superview];
	
	UITableView *table=(UITableView*)[cell superview];
	NSIndexPath *path=[table indexPathForCell:cell];
	
	NSLog(@"Up rep been pressed %d si %d",path.section, path.row);
	
	repsCount = repsCount + 10;
	
	if (repsCount > 500) repsCount = 500;
	
	[table reloadData];
	
	
}

- (void)repsDownButton10Pressed:(id)sender
{
	UITableViewCell *cell=(UITableViewCell*)[[sender superview] superview];
	
	UITableView *table=(UITableView*)[cell superview];
	//NSIndexPath *path=[table indexPathForCell:cell];
	
	repsCount = repsCount - 10;
	
	if (repsCount < 0) repsCount = 0;
	
	
	[table reloadData];
	
}

- (void)repsChairUpButtonPressed:(id)sender
{
	UITableViewCell *cell=(UITableViewCell*)[[sender superview] superview];
	
	UITableView *table=(UITableView*)[cell superview];
	puChairCount ++;
	if (puChairCount > 500) puChairCount = 500;
	[table reloadData];
}

- (void)repsChairDownButtonPressed:(id)sender
{
	UITableViewCell *cell=(UITableViewCell*)[[sender superview] superview];
	
	UITableView *table=(UITableView*)[cell superview];
	puChairCount --;
	if (puChairCount < 0) puChairCount = 0;
	[table reloadData];
}
- (void)repsChairUpButton10Pressed:(id)sender
{
	UITableViewCell *cell=(UITableViewCell*)[[sender superview] superview];
	
	UITableView *table=(UITableView*)[cell superview];
	puChairCount = puChairCount + 10;
	if (puChairCount > 500) puChairCount = 500;
	[table reloadData];
}

- (void)repsChairDownButton10Pressed:(id)sender
{
	UITableViewCell *cell=(UITableViewCell*)[[sender superview] superview];
	
	UITableView *table=(UITableView*)[cell superview];
	puChairCount = puChairCount - 10;
	if (puChairCount < 0) puChairCount = 0;
	[table reloadData];
}

- (void)repsNoChairUpButtonPressed:(id)sender
	{
		UITableViewCell *cell=(UITableViewCell*)[[sender superview] superview];
		UITableView *table=(UITableView*)[cell superview];
		puNoChairCount ++;
		if (puNoChairCount > 500) puNoChairCount = 500;		
		[table reloadData];
	}
		 
- (void)repsNoChairDownButtonPressed:(id)sender
	{
		UITableViewCell *cell=(UITableViewCell*)[[sender superview] superview];
		UITableView *table=(UITableView*)[cell superview];
		puNoChairCount --;
		if (puNoChairCount < 0) puNoChairCount = 0;
		[table reloadData];
	}
- (void)repsNoChairUpButton10Pressed:(id)sender
{
	UITableViewCell *cell=(UITableViewCell*)[[sender superview] superview];
	UITableView *table=(UITableView*)[cell superview];
	puNoChairCount = puNoChairCount + 10;
	if (puNoChairCount > 500) puNoChairCount = 500;		
	[table reloadData];
}

- (void)repsNoChairDownButton10Pressed:(id)sender
{
	UITableViewCell *cell=(UITableViewCell*)[[sender superview] superview];
	UITableView *table=(UITableView*)[cell superview];
	puNoChairCount = puNoChairCount - 10;
	if (puNoChairCount < 0) puNoChairCount = 0;
	[table reloadData];
}

- (void)timeUpButtonPressed:(id)sender
{
	UITableViewCell *cell=(UITableViewCell*)[[sender superview] superview];
	UITableView *table=(UITableView*)[cell superview];
	time = time + 1;
	if (time > 900) time = 900;		
	[table reloadData];
}

- (void)timeDownButtonPressed:(id)sender
{
	UITableViewCell *cell=(UITableViewCell*)[[sender superview] superview];
	UITableView *table=(UITableView*)[cell superview];
	time = time - 1;
	if (time < 0) time = 0;
	[table reloadData];
}
- (void)timeUpButton10Pressed:(id)sender
{
	UITableViewCell *cell=(UITableViewCell*)[[sender superview] superview];
	UITableView *table=(UITableView*)[cell superview];
	time = time + 10;
	if (time > 900) time = 900;		
	[table reloadData];
}

- (void)timeDownButton10Pressed:(id)sender
{
	UITableViewCell *cell=(UITableViewCell*)[[sender superview] superview];
	UITableView *table=(UITableView*)[cell superview];
	time = time - 10;
	if (time < 0) time = 0;
	[table reloadData];
}
- (void)heightUpButtonPressed:(id)sender
{
	UITableViewCell *cell=(UITableViewCell*)[[sender superview] superview];
	UITableView *table=(UITableView*)[cell superview];
	height ++;
	if (height > 900) height = 900;		
	[table reloadData];
}

- (void)heightDownButtonPressed:(id)sender
{
	UITableViewCell *cell=(UITableViewCell*)[[sender superview] superview];
	UITableView *table=(UITableView*)[cell superview];
	height --;
	if (height < 0) height = 0;
	[table reloadData];
}
- (void)heightUpButton10Pressed:(id)sender
{
	UITableViewCell *cell=(UITableViewCell*)[[sender superview] superview];
	UITableView *table=(UITableView*)[cell superview];
	height = height + 10;
	if (height > 900) height = 900;		
	[table reloadData];
}

- (void)heightDownButton10Pressed:(id)sender
{
	UITableViewCell *cell=(UITableViewCell*)[[sender superview] superview];
	UITableView *table=(UITableView*)[cell superview];
	height = height - 10;
	if (height < 0) height = 0;
	[table reloadData];
}


- (void)weightUpButtonPressed:(id)sender
{
	UITableViewCell *cell=(UITableViewCell*)[[sender superview] superview];
	
	UITableView *table=(UITableView*)[cell superview];
	//NSIndexPath *path=[table indexPathForCell:cell];
	//if (weightCount < 15) weightCount = weightCount ++;
	//else if (weightCount >= 15) weightCount = weightCount +5;
	
	weightCount ++;
	if (weightCount > 300) weightCount = 300;	
	[table reloadData];
}

- (void)weightDownButtonPressed:(id)sender
{
	UITableViewCell *cell=(UITableViewCell*)[[sender superview] superview];
	
	UITableView *table=(UITableView*)[cell superview];
	//NSIndexPath *path=[table indexPathForCell:cell];
	//if (weightCount <= 15) weightCount = weightCount --;
	//else if (weightCount > 15) weightCount = weightCount -5;
	
	weightCount --;
	if (weightCount < 0) weightCount = 0;
	
	[table reloadData];
}
- (void)weightUpButton5Pressed:(id)sender
{
	UITableViewCell *cell=(UITableViewCell*)[[sender superview] superview];
	
	UITableView *table=(UITableView*)[cell superview];
	//NSIndexPath *path=[table indexPathForCell:cell];
	//if (weightCount < 15) weightCount = weightCount ++;
	//else if (weightCount >= 15) weightCount = weightCount +5;
	
	weightCount = weightCount + 5;
	if (weightCount > 300) weightCount = 300;	
	[table reloadData];
}

- (void)weightDownButton5Pressed:(id)sender
{
	UITableViewCell *cell=(UITableViewCell*)[[sender superview] superview];
	
	UITableView *table=(UITableView*)[cell superview];
	//NSIndexPath *path=[table indexPathForCell:cell];
	//if (weightCount <= 15) weightCount = weightCount --;
	//else if (weightCount > 15) weightCount = weightCount -5;
	weightCount = weightCount - 5;

	if (weightCount < 0) weightCount = 0;
	
	[table reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
	NSLog(@"moveID: %d", self.moveID);
	[super viewWillAppear:animated];
	
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	currentDate = [[BIUtility todayDateString] retain];
	
	if (editMode) {
		currentDate = passedDate;
	} 
	detailListForMove = [[BIUtility detailsForMove:moveID] retain];

	self.title = moveName;

	self.view.backgroundColor = [UIColor blackColor];
	
	previousDetails = [[NSMutableArray alloc] init];
	
	if (!editMode)  {
		for (MoveDetail *md in detailListForMove) {
			[previousDetails addObject:[BIUtility lastRecordForMoveDetail:md.moveDetailID]];
		}
	} else {
		for (MoveDetail *md in detailListForMove) {
			[previousDetails addObject:[BIUtility recordForMoveDetail:md.moveDetailID date:currentDate]];
		}
	}

	//load up initial counts
	int i = 0;
	for (MoveDetail *md in detailListForMove) {
		//NSString * previousDetail = [BIUtility lastRecordForMoveDetail:md.moveDetailID];
		NSString * previousDetail = [previousDetails objectAtIndex:i];
		if ([previousDetail length] == 0) { 
			if ([md.moveType isEqualToString:@"R"]) repsCount = 10;
			if ([md.moveType isEqualToString:@"T"]) time = 0;
			if ([md.moveType isEqualToString:@"H"]) height = 0;
			if ([md.moveType isEqualToString:@"RC"]) puChairCount = 0;
			if ([md.moveType isEqualToString:@"RF"]) puNoChairCount = 10;
			if ([md.moveType isEqualToString:@"W"]) weightCount = 15;
			if ([md.moveType isEqualToString:@"E"]) effortID = 1;
		} else {
			if ([md.moveType isEqualToString:@"R"]) repsCount = [previousDetail integerValue];
			if ([md.moveType isEqualToString:@"RC"]) puChairCount = [previousDetail integerValue];
			if ([md.moveType isEqualToString:@"RF"]) puNoChairCount = [previousDetail integerValue];
			if ([md.moveType isEqualToString:@"T"]) time = [previousDetail integerValue];
			if ([md.moveType isEqualToString:@"H"]) height = [previousDetail integerValue];
			if ([md.moveType isEqualToString:@"W"]) weightCount = [previousDetail integerValue];
			if ([md.moveType isEqualToString:@"E"]) effortID = [previousDetail integerValue];
		}
		i++;
	}
	
	if (!editMode) {
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] 
								   initWithTitle:@"Next"
								   style:UIBarButtonItemStyleBordered
								target:self
								action:@selector(handleBack:)];
	
	self.navigationItem.rightBarButtonItem = backButton;
	[backButton release];
	}
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] 
								   initWithTitle:@"Done"
								   style:UIBarButtonItemStyleBordered
								   target:self
								   action:@selector(handleCancel:)];
	
	self.navigationItem.leftBarButtonItem = cancelButton;
	[cancelButton release];
	

}
- (void) handleBack:(id)sender
{
	[self saveMoveDetail];
	// pop the controller – the default action
	
	
	int i = 0;
	for (Move * m in moveList) {
		i++;
		if (m.moveID == self.moveID) break;
	}
	//NSInteger moveCount = [moveList count];
	if (i < [moveList count] && !editMode) {	
		MoveDetailViewController *moveDetailController = [[MoveDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
		
		moveDetailController.moveID = [[moveList objectAtIndex:i] moveID];
		moveDetailController.moveName = [[moveList objectAtIndex:i] moveName];
		moveDetailController.woInstanceID = [self woInstanceID];
		moveDetailController.moveList = self.moveList;
		moveDetailController.editMode = editMode;
		
		Bring_ItAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
		[delegate.workoutNavController pushViewController:moveDetailController animated:YES];
		[moveDetailController release];

		NSMutableArray *allControllers = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
		NSLog(@"Controller Count:%d", [allControllers count]);
		NSInteger backCount = 2;
		[allControllers removeObjectAtIndex:[allControllers count] - backCount];
		[self.navigationController setViewControllers:allControllers animated:NO];
		[allControllers release];
		
		
	} else {
		[self.navigationController popViewControllerAnimated:YES];
		
	}
	//[details release];
	
} 
	

- (void) handleCancel:(id)sender
{
	[self saveMoveDetail];
	// pop the controller – the default action
	[self.navigationController popViewControllerAnimated:YES];
	
}

- (void)saveMoveDetail {
	for (MoveDetail *md in detailListForMove) {
		MoveDetail * tmpMD = [[MoveDetail alloc] init];
		tmpMD.moveDetailID = [BIUtility moveDetailIDForMove:self.moveID
													   Type:md.moveType];
		tmpMD.moveID = self.moveID;
		tmpMD.workoutID = self.woInstanceID;
		tmpMD.moveType = md.moveType;
		NSInteger r;
		if ([md.moveType isEqualToString:@"R"]) r = repsCount;
		else if ([md.moveType isEqualToString:@"RC"]) r = puChairCount;
		else if ([md.moveType isEqualToString:@"T"]) r = time;
		else if ([md.moveType isEqualToString:@"H"]) r = height;
		else if ([md.moveType isEqualToString:@"RF"]) r = puNoChairCount;
		else if ([md.moveType isEqualToString:@"W"]) r = weightCount;
		else r = effortID;
		tmpMD.detailValue = [NSString stringWithFormat:@"%d", r];     
		
		[BIUtility saveMoveDetailRecord:tmpMD];
		[tmpMD release];
	}	
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
	[previousDetails release];
	[detailListForMove release];
	//[moveDetail release];
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
