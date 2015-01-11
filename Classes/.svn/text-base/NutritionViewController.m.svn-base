//
//  SetupViewController.m
//  Bring It
//
//  Created by Michael Bordelon on 4/17/10.
//  Copyright 2010 Bordelon iPhone. All rights reserved.
//

#import "NutritionViewController.h"



@implementation NutritionViewController

@synthesize  p,  foodLog,  calTarget, calLabel, calTargetLabel, searchTextField, cals, editMode, passedDate, currentDate, viewNavigationBar;







-(IBAction)textFieldDoneEditing:(id)sender {
	[searchTextField resignFirstResponder];
	[foodLog resignFirstResponder];
}
-(IBAction)upButtonPressed:(id)sender {
	cals = cals + 50;
	if (cals > 5000) cals = 5000;
	calLabel.text = [NSString stringWithFormat:@"%d Calories",cals];
	if (cals < (calTarget-150)) {
		calLabel.textColor = [UIColor greenColor];
	} else if (cals > (calTarget+150)) {
		calLabel.textColor = [UIColor redColor];
	} else {
		calLabel.textColor = [UIColor yellowColor];
	}
	
}
-(IBAction)downButtonPressed:(id)sender {

	
	cals = cals - 50;
	if (cals < 0) cals = 0;
	calLabel.text = [NSString stringWithFormat:@"%d Calories",cals];
	if (cals < (calTarget-150)) {
		calLabel.textColor = [UIColor greenColor];
	} else if (cals > (calTarget+150)) {
		calLabel.textColor = [UIColor redColor];
	} else {
		calLabel.textColor = [UIColor yellowColor];
	}	
	
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[p release];
	p = [[Profile alloc] init];
	calTarget = [BIUtility caloricTarget];
	calTargetLabel.text = [NSString stringWithFormat:@"Target %d calories to drop %@ lbs per week.",calTarget, p.lossRate];
	Nutrition * n = [BIUtility nutritionForDate:[BIUtility dateFromString:currentDate]];
	if (n == nil) {
		cals = 0;
		self.foodLog.text = @"";
	} else {
		cals = n.calories;
		self.foodLog.text = n.foodLog;
	}
	self.calLabel.text = [NSString stringWithFormat:@"%d Calories",cals];
	
	
}
- (void)viewDidLoad {
    [super viewDidLoad];
	
	p = [[Profile alloc] init];
	currentDate = [[BIUtility todayDateString] retain];
	if (!editMode) {
		UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]
										 initWithTitle:@"Save" 
										 style:UIBarButtonItemStyleBordered
										 target:self
										 action:@selector(saveButtonPressed:)];
		//viewNavigationBar.navigationItem.leftBarButtonItem = cancelButton;
		UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"Today's Nutrition"];
		item.rightBarButtonItem = saveButton;
		item.hidesBackButton = YES;
		[viewNavigationBar pushNavigationItem:item animated:NO];
		[item release];
		[saveButton release];
	} else {
		currentDate = passedDate;
		
		UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]
									   initWithTitle:@"Save" 
									   style:UIBarButtonItemStyleBordered
									   target:self
									   action:@selector(saveButtonPressed:)];
		UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]
										 initWithTitle:@"Done" 
										 style:UIBarButtonItemStyleBordered
										 target:self
										 action:@selector(cancelButtonPressed:)];
		
		//viewNavigationBar.navigationItem.rightBarButtonItem = saveButton;
		UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:[NSString stringWithFormat:@"%@ Nutrition",currentDate]];
		item.rightBarButtonItem = saveButton;
		item.leftBarButtonItem = cancelButton;
		item.hidesBackButton = YES;
		[viewNavigationBar pushNavigationItem:item animated:NO];
		[item release];
		[saveButton release];
		[cancelButton release];
	}

	

	
	NSLog(@"currentDate: %@", currentDate);
	
	self.view.backgroundColor = [UIColor blackColor];
	foodLog.layer.borderWidth = 1;
	foodLog.layer.borderColor = [[UIColor grayColor] CGColor];
	foodLog.layer.cornerRadius = 5;
	foodLog.clipsToBounds = YES;
	calTarget = [BIUtility caloricTarget];
	calLabel.textColor = [UIColor greenColor];
	calTargetLabel.text = [NSString stringWithFormat:@"Target %d calories to drop %@ lbs per week.",calTarget, p.lossRate];
	Nutrition * n = [BIUtility nutritionForDate:[BIUtility dateFromString:currentDate]];
	if (n == nil) {
		cals = 0;
		self.foodLog.text = @"";
	} else {
		cals = n.calories;
		self.foodLog.text = n.foodLog;
	}
	self.calLabel.text = [NSString stringWithFormat:@"%d Calories",cals];
	[nutButton setTitle:@"" forState:UIControlStateNormal]; 
	[nutButton setTitle:@"\u2713" forState:UIControlStateSelected]; 
	[nutButton.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
}
-(IBAction)nutButtonPressed:(id)sender {
	//[UIView beginAnimations:nil context:NULL];
	//[UIView setAnimationDuration:0.5f];
	//if (((UIButton*)sender).selected == YES){
		
	//	[((UIButton*)sender) setSelected:NO];
	//} else {
	//	[((UIButton*)sender) setSelected:YES];
	//}
	//[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:((UIButton*)sender) cache:YES];
	//[UIView commitAnimations];
	NutritionComponentViewController *nutCompViewController = [[NutritionComponentViewController alloc] 
													initWithNibName:@"NutritionComponentViewController" 
													bundle:nil];
	[self presentModalViewController:nutCompViewController animated:YES];
	[nutCompViewController release];
	
	
	
}
-(IBAction)cancelButtonPressed:(id)sender {

	
	Nutrition * nut = [[Nutrition alloc] init];
	
	nut.foodLog = self.foodLog.text;
	
	NSLog(@"n.foodLog %@", nut.foodLog);
	NSLog(@"cuurentDat: %@", currentDate);
	nut.calories = cals;
	nut.logDate = [BIUtility dateFromString:currentDate];
	[BIUtility saveNutrition:nut forDate:currentDate];
	[nut release];
	
	[self dismissModalViewControllerAnimated:YES];
	
}
-(IBAction)saveButtonPressed:(id)sender {
	[searchTextField resignFirstResponder];
	[foodLog resignFirstResponder];
	//NSLog(self.foodLog.text);
	//NSString * tst = self.foodLog.text;
	
	Nutrition * nut = [[Nutrition alloc] init];
	
	nut.foodLog = self.foodLog.text;
	
	NSLog(@"n.foodLog %@", nut.foodLog);
	NSLog(@"cuurentDat: %@", currentDate);
	nut.calories = cals;
	nut.logDate = [BIUtility dateFromString:currentDate];
	[BIUtility saveNutrition:nut forDate:currentDate];
	[nut release];

}

-(IBAction)searchButtonPressed:(id)sender {
	[searchTextField resignFirstResponder];
	[foodLog resignFirstResponder];
	
	FoodWebLookupViewController *foodViewController = [[FoodWebLookupViewController alloc] 
														  initWithNibName:@"FoodWebLookupViewController" 
														  bundle:nil];
	
	NSString* escapedUrl = [self.searchTextField.text  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	//NSLog(self.searchTextField.text);
	[foodViewController setSearchValue:escapedUrl];
	
	[self presentModalViewController:foodViewController animated:YES];
	
	[foodViewController release];
	
	
}
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
- (void)viewDidDisappear:(BOOL)animated {
	Nutrition * nut = [[Nutrition alloc] init];
	
	nut.foodLog = self.foodLog.text;
	
	NSLog(@"n.foodLog %@", nut.foodLog);
	
	nut.calories = cals;
	nut.logDate = [NSDate dateWithTimeIntervalSinceNow:0];
	[BIUtility saveNutrition:nut];
	[nut release];	
}
- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    
	//[datePickerViewController release];
    //[singlePicker release];
	//[n release];
	[p release];
	[currentDate release];
	[super dealloc];
}



@end
