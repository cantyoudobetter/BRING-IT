//
//  NutritionComponentViewController.m
//  bring-it
//
//  Created by Michael Bordelon on 8/16/10.
//  Copyright 2010 bordeloniphone. All rights reserved.
//

#import "NutritionComponentViewController.h"


@implementation NutritionComponentViewController
@synthesize colorList, portionList, portionValues;
@synthesize  p,  foodLog,  calTarget, cals, editMode, passedDate, currentDate, n, rowSelected, phase, level;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	[self.tableView setBackgroundColor:[UIColor blackColor]];
	colorList = [[NSMutableArray alloc] init];
	[colorList addObject:[UIColor redColor]];
	[colorList addObject:[UIColor darkGrayColor]];
	[colorList addObject:[UIColor purpleColor]];
	[colorList addObject:[UIColor greenColor]];
	[colorList addObject:[UIColor orangeColor]];
	[colorList addObject:[UIColor brownColor]];
	[colorList addObject:[UIColor magentaColor]];
	[colorList addObject:[UIColor cyanColor]];
	[colorList addObject:[UIColor yellowColor]];
	[colorList addObject:[UIColor blueColor]];
	[colorList addObject:[UIColor lightGrayColor]];
	portionList = [[BIUtility portionList] retain];
	
	
	
	p = [[Profile alloc] init];
	currentDate = [[BIUtility todayDateString] retain];
	
	if (!editMode) {
		phase = [[BIUtility currentPhase] retain];
		level = [[BIUtility currentLevel] retain];
	} else {
		currentDate = passedDate;
		self.title = currentDate;
		phase = [[BIUtility phaseForDate:currentDate] retain];
		level = [[BIUtility levelForDate:currentDate] retain];
		
		
	}
	calTarget = [BIUtility caloricTarget];
	
	if (!editMode) {
	
		UIBarButtonItem *phaseLevelButton = [[UIBarButtonItem alloc]
								  initWithTitle:[NSString stringWithFormat:@"Phase %@, Level %@", phase, level] 
								  style:UIBarButtonItemStyleBordered
								  target:self
								  action:@selector(phaseLevel:)];
		self.navigationItem.rightBarButtonItem = phaseLevelButton;
	
		[phaseLevelButton release];	
	} else {
		
		if (!navTitle ) {
			UINavigationBar *bar = [self.navigationController navigationBar];
			navTitle = [[UILabel alloc] initWithFrame:CGRectMake(217, 8, 100, 25)];
		
			navTitle.backgroundColor = [UIColor clearColor];
			navTitle.font = [UIFont systemFontOfSize:15];
			navTitle.adjustsFontSizeToFitWidth = YES;
			navTitle.textAlignment = UITextAlignmentRight;
			navTitle.textColor = [UIColor whiteColor];
			navTitle.text = [NSString stringWithFormat:@"Phase %@, Level %@", phase, level];
			[bar addSubview:navTitle];
		} else {
			navTitle.text = [NSString stringWithFormat:@"Phase %@, Level %@", phase, level];
		}

		
	}


}

	
	
- (void)viewWillDisappear:(BOOL)animated {
	Nutrition * nut = [[Nutrition alloc] init];
	
	nut.foodLog = foodLog;
	nut.calories = cals;
	nut.level = level;
	nut.phase = phase;
	nut.portionValues = self.portionValues;
	nut.logDate = [BIUtility dateFromString:currentDate];
	[BIUtility saveNutrition:nut forDate:currentDate];
	[nut release];	
	navTitle.hidden = YES;
}


- (void)viewWillAppear:(BOOL)animated {

	[super viewWillAppear:animated];
	
	if (!editMode) {
		[phase release];
		[level release];

		phase = [[BIUtility currentPhase] retain];
		level = [[BIUtility currentLevel] retain];
		self.navigationItem.rightBarButtonItem.title = [NSString stringWithFormat:@"Phase %@, Level %@", phase, level];
		
	}	
	
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

	[p release];
	p = [[Profile alloc] init];
	calTarget = [BIUtility caloricTarget];
	[n release];
	n = [[BIUtility nutritionForDate:[BIUtility dateFromString:currentDate]] retain];
	if (n == nil) {
		cals = 0;
		foodLog = @"";
	} else {
		cals = n.calories;
		foodLog = n.foodLog;
	}
	[portionValues release];


	if ([n.portionValues count] > 0) {
		portionValues = [[NSMutableArray alloc] initWithArray:n.portionValues];
	} else {
		portionValues = [[NSMutableArray alloc] init];
		NSNumber * num = [NSNumber numberWithInteger:0];
		for (int i = 0 ; i < 10 ; i++) {
			[portionValues addObject:num];
		}
	}

	
	[super.tableView reloadData];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 12;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  	UITableViewCell *cell;  	
	NSInteger row = indexPath.row;
	
	if (row == 0) {//FOOD LOG
		cell = [tableView dequeueReusableCellWithIdentifier:@"LogCell"];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"LogCell"] autorelease];
			[cell.textLabel setText:@" "];
			cell.textLabel.textAlignment = UITextAlignmentCenter; 
			cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
			cell.detailTextLabel.numberOfLines = 0;
			[cell.detailTextLabel setTextColor:[UIColor whiteColor]];
			[cell.detailTextLabel setFont:[UIFont systemFontOfSize:15]];

			UILabel *foodLabel = [[UILabel alloc] initWithFrame:CGRectMake (0.0f, 2.0f, 320.0f, 20.0f)];
			foodLabel.textAlignment = UITextAlignmentRight;
			foodLabel.backgroundColor = [UIColor clearColor];
			foodLabel.text = @"- Food Log -";
			foodLabel.tag = 3000;
			foodLabel.textAlignment = UITextAlignmentCenter;
			foodLabel.textColor = [UIColor whiteColor];
			[foodLabel setFont:[UIFont systemFontOfSize:18]];
			[cell.contentView addSubview:foodLabel];
			[foodLabel release];

			UILabel *touchLabel = [[UILabel alloc] initWithFrame:CGRectMake (0.0f, 30.0f, 320.0f, 20.0f)];
			touchLabel.textAlignment = UITextAlignmentRight;
			touchLabel.backgroundColor = [UIColor clearColor];
			touchLabel.text = @"touch to manually add items";
			touchLabel.tag = 4000;
			touchLabel.textAlignment = UITextAlignmentCenter;
			touchLabel.textColor = [UIColor whiteColor];
			[touchLabel setFont:[UIFont italicSystemFontOfSize:15]];
			[cell.contentView addSubview:touchLabel];
			[touchLabel release];
			
		}
		if ([foodLog length] < 1) {
			UILabel *touchLabel = (UILabel *)[cell viewWithTag:4000];
			touchLabel.text = @"touch here to add items";
			[cell.detailTextLabel setText:@""];
		} else {
			UILabel *touchLabel = (UILabel *)[cell viewWithTag:4000];
			[touchLabel setText:@""];
			[cell.detailTextLabel setText:foodLog];
		}	
	}
	if (row == 1) { //CALORIES

		
		
		cell = [tableView dequeueReusableCellWithIdentifier:@"CalorieCell"];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CalorieCell"] autorelease];
		
			UIButton *upButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		
			upButton.frame = CGRectMake(260.0, 10.0, 50.0, 50.0);
			upButton.backgroundColor = [UIColor clearColor];
			UIImage *upButtonImageNormal = [UIImage imageNamed:@"uparrowblue.png"];
			[upButton setBackgroundImage:upButtonImageNormal forState:UIControlStateNormal];
			UIImage *upButtonImagePressed = [UIImage imageNamed:@"uparrowselected.png"];
			[upButton setBackgroundImage:upButtonImagePressed forState:UIControlStateHighlighted];
			[upButton addTarget:self action:@selector(upPressed:) forControlEvents:UIControlEventTouchUpInside];
			[cell addSubview:upButton];
			[upButton release];
			UIButton *dnButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
			dnButton.frame = CGRectMake(10.0, 10.0, 50.0, 50.0);
			dnButton.backgroundColor = [UIColor clearColor];
			UIImage *dnButtonImageNormal = [UIImage imageNamed:@"downarrowblue.png"];
			[dnButton setBackgroundImage:dnButtonImageNormal forState:UIControlStateNormal];
			UIImage *dnButtonImagePressed = [UIImage imageNamed:@"downarrowhighlighted.png"];
			[dnButton setBackgroundImage:dnButtonImagePressed forState:UIControlStateHighlighted];
			[dnButton addTarget:self action:@selector(downPressed:) forControlEvents:UIControlEventTouchUpInside];
			[cell addSubview:dnButton];
			[dnButton release];
			UILabel *calLabel = [[UILabel alloc] initWithFrame:CGRectMake (80.0f, 20.0f, 160.0f, 20.0f)];
			calLabel.textAlignment = UITextAlignmentRight;
			calLabel.backgroundColor = [UIColor clearColor];
			calLabel.text = [NSString stringWithFormat:@"%d Calories",cals];
			calLabel.tag = 1000;
			if (cals < (calTarget-150)) {
				calLabel.textColor = [UIColor greenColor];
			} else if (cals > (calTarget+150)) {
				calLabel.textColor = [UIColor redColor];
			} else {
				calLabel.textColor = [UIColor yellowColor];
			}
			calLabel.textAlignment = UITextAlignmentCenter;
			[calLabel setFont:[UIFont fontWithName:@"Helvetica" size:25]];
			[cell.contentView addSubview:calLabel];
			[calLabel release];
			
			UILabel *calInfoLabel; 
			calInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake (40.0f, 50.0f, 240.0f, 20.0f)];
			calInfoLabel.textAlignment = UITextAlignmentRight;
			calInfoLabel.backgroundColor = [UIColor clearColor];
			calInfoLabel.tag = 2000;
			calInfoLabel.textColor = [UIColor grayColor];
			calInfoLabel.textAlignment = UITextAlignmentCenter;
			[calInfoLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
			[cell.contentView addSubview:calInfoLabel];
			[calInfoLabel release];
			//[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
			[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
			cell.accessoryType = UITableViewCellAccessoryNone;
			
		}	
		
		UILabel *calTemp1 = (UILabel *)[cell viewWithTag:1000];
		[calTemp1 setText:[NSString stringWithFormat:@"%d Calories",cals]];
		UILabel *calTemp2 = (UILabel *)[cell viewWithTag:2000];
		[calTemp2 setText:[NSString stringWithFormat:@"target %d calories to drop %@ lbs/week",calTarget, p.lossRate]];
			
				
		
		
	}
	
	if (row > 1) {
		NSString * identifier = [NSString stringWithFormat:@"ProtionCell%d",(indexPath.row - 2)];

		//NSInteger count = [BIUtility portionTypeCount:(indexPath.row + 1 - 2) level:[BIUtility levelForDate:currentDate] phase:[BIUtility phaseForDate:currentDate]];//using row is a hack.  need to do this with ids.
		NSInteger count = [BIUtility portionTypeCount:(indexPath.row + 1 - 2) level:level phase:phase];//using row is a hack.  need to do this with ids.
		NSInteger numSelected = [[portionValues objectAtIndex:row - 2] integerValue];
		NSString * portionName = [NSString stringWithFormat:@"%@", [portionList objectAtIndex:(indexPath.row - 2)]];
		cell = [tableView dequeueReusableCellWithIdentifier:identifier];
		if (cell != nil) {
			[cell removeFromSuperview];
		}

			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
			
			[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
			UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake (320.0f-120.0f, 15.0f, 80.0f, 14.0f)];
			tempLabel.textAlignment = UITextAlignmentRight;
			tempLabel.backgroundColor = [UIColor clearColor];
			tempLabel.textColor = [UIColor whiteColor];
			[tempLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
			[cell.contentView addSubview:tempLabel];

			tempLabel.text = portionName;
			[tempLabel release];
			for (int i = 0; i < count; i++) {
				GradientButton * protienButton = [[GradientButton alloc] initWithFrame:CGRectMake(5.0f+i*30.0f, 10.0f, 25.0f, 25.0f)];
				[protienButton setTitle:@"" forState:UIControlStateNormal]; 
				[protienButton setTitle:@"X" forState:UIControlStateSelected]; 
				[protienButton.titleLabel setFont:[UIFont boldSystemFontOfSize:29]];
				[protienButton addTarget:self action:@selector(portionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
				[protienButton setBackgroundColor:[colorList objectAtIndex:(indexPath.row - 2)]];
				[protienButton setTag:i];
				[cell addSubview:protienButton];
				[protienButton release];
				if (i < numSelected) { 
					[protienButton setSelected:YES];
				} else {
					[protienButton setSelected:NO];
				}

			}


	}
    return cell;
}
						  
-(IBAction)portionButtonPressed:(id)sender {
	//NSLog(@"TAG: %d", ((UIButton*)sender).tag);
	UITableViewCell *cell = (UITableViewCell *)[sender superview];

	NSIndexPath *ip = [self.tableView indexPathForCell:cell];
	NSInteger row = ip.row;
	//NSLog(@"ROW:%d", row);
	//NSLog(@"TAG:%d", ((UIButton*)sender).tag);
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5f];
	NSInteger i  = [[portionValues objectAtIndex:(row - 2)] integerValue];
		
	
	if (((UIButton*)sender).selected == YES){
		i--;
		[((UIButton*)sender) setSelected:NO];
	} else {
		i++;
		[((UIButton*)sender) setSelected:YES];
	}
	 NSNumber * temp = [NSNumber numberWithInteger:i];
	 [portionValues replaceObjectAtIndex:(row - 2) withObject:temp];

	 [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:((UIButton*)sender) cache:YES];
	[UIView commitAnimations];
	 
	 //for (NSNumber * tempNum in portionValues) {
		// NSLog(@"portionVals: %d", [tempNum integerValue]);
	 //}
	
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	
	NSInteger h;
	if (indexPath.row == 0) {
		NSString *cellText = foodLog;
		UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:15];
		CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
		CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
		h =  labelSize.height + 45;
		if (h<65) h=65;
	} else if (indexPath.row == 1 ) {
		
		h = 75;
		
		
	} else {
		h = 50;
	}
	
	return h;
	
}


- (UITableViewCellAccessoryType) tableView:(UITableView *)tableView 
		  accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0) {
		return UITableViewCellAccessoryDetailDisclosureButton;
	} 
	if (indexPath.row >= 11) {
		return UITableViewCellAccessoryNone;
	} 	
	if (indexPath.row > 1) {
		return UITableViewCellAccessoryDetailDisclosureButton;
	} 
	

	

	
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {

	if (indexPath.row == 0) {
		FoodLookupViewController *foodLookupController = [[FoodLookupViewController alloc] 
														  initWithNibName:@"FoodLookupViewController" 
														  bundle:nil];
		foodLookupController.portionTypeID = 0;//get all foods
		foodLookupController.currentDate = currentDate;
		//NSLog(@"Protion Type Selected: %d", foodLookupController.portionTypeID);
		
		Bring_ItAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
		if (editMode) {
			[delegate.historyNavController pushViewController:foodLookupController animated:YES];
		} else {
			[delegate.nutritionNavController pushViewController:foodLookupController animated:YES];
	
		}
		
		[foodLookupController release];
	} 
	
	
	
	
	if (indexPath.row > 1) {
		FoodLookupViewController *foodLookupController = [[FoodLookupViewController alloc] 
																	  initWithNibName:@"FoodLookupViewController" 
																	  bundle:nil];
		foodLookupController.portionTypeID = indexPath.row - 1;
		foodLookupController.currentDate = currentDate;
		//NSLog(@"Protion Type Selected: %d", foodLookupController.portionTypeID);
	
		Bring_ItAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
		if (editMode) {
			[delegate.historyNavController pushViewController:foodLookupController animated:YES];
		} else {
			[delegate.nutritionNavController pushViewController:foodLookupController animated:YES];
			
		}
		[foodLookupController release];
	}
	
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	//NSUInteger row = [indexPath row];
	if (indexPath.row == 0) {
		TextViewController *textViewController = [[TextViewController alloc] 
												  initWithNibName:@"TextViewController" 
												  bundle:nil];
		
		textViewController.delegate = self;
		textViewController.viewTitle = @"Food Log";
		textViewController.initialText = foodLog;
		
		[self presentModalViewController:textViewController animated:YES];
		
		[textViewController release];
		
	}
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(IBAction)phaseLevel:(id)sender{  
		
		PhaseLevelViewController *plViewController = [[PhaseLevelViewController alloc] 
												initWithNibName:@"PhaseLevelViewController" 
												bundle:nil];
		plViewController.delegate = self;
		[self presentModalViewController:plViewController animated:YES];
		[plViewController release];
	
}  
- (void)handlePickerChangeForPhase:(NSInteger)phase andLevel:(NSInteger)level {
	
}

- (void)handleTextViewChange:(NSString *)passedText {
	
	Nutrition * nut = [[Nutrition alloc] init];
	
	nut.foodLog = passedText;
	nut.calories = cals;
	nut.level = level;
	nut.phase = phase;
	nut.portionValues = portionValues;
	nut.logDate = [BIUtility dateFromString:currentDate];
	[BIUtility saveNutrition:nut forDate:currentDate];
	[nut release];
	
	[self.tableView reloadData];	
	[self dismissModalViewControllerAnimated:YES];
	
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
    [colorList release];
	[portionList release];
	[portionValues release];
	[p release];
	[n release];
	[currentDate release];
	[phase release];
	[level release];
	[navTitle release];
	[super dealloc];
}
-(IBAction)upPressed:(id)sender {
	UITableViewCell *cell=(UITableViewCell*)[[sender superview] superview];
	UILabel *calLabel = (UILabel *)[cell viewWithTag:1000];
	//UITableView *table=(UITableView*)[cell superview];
	cals = cals + 50;
	if (cals < (calTarget-150)) {
		calLabel.textColor = [UIColor greenColor];
	} else if (cals > (calTarget+150)) {
		calLabel.textColor = [UIColor redColor];
	} else {
		calLabel.textColor = [UIColor yellowColor];
	}
	if (cals > 5000) cals = 5000;
	[calLabel setText:[NSString stringWithFormat:@"%d Calories",cals]];
}
-(IBAction)downPressed:(id)sender {
	UITableViewCell *cell=(UITableViewCell*)[[sender superview] superview];
	
	UILabel *calLabel = (UILabel *)[cell viewWithTag:1000];
	cals = cals - 50;
	if (cals < (calTarget-150)) {
		calLabel.textColor = [UIColor greenColor];
	} else if (cals > (calTarget+150)) {
		calLabel.textColor = [UIColor redColor];
	} else {
		calLabel.textColor = [UIColor yellowColor];
	}
	
	if (cals < 0) cals = 0;
	[calLabel setText:[NSString stringWithFormat:@"%d Calories",cals]];

	
}


@end

