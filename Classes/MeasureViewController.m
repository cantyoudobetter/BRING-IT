//
//  SetupViewController.m
//  Bring It
//
//  Created by Michael Bordelon on 4/17/10.
//  Copyright 2010 Bordelon iPhone. All rights reserved.
//

#import "MeasureViewController.h"



@implementation MeasureViewController
@synthesize currentDate, passedDate, editMode;
@synthesize  p, selectedDatePicker, startDate, birthDate, pickerType, navBar, humanImage;
@synthesize weightButton;
@synthesize neckButton;
@synthesize waistButton;
@synthesize hipButton;
@synthesize heightButton;



//- (void)handleTextChange:(NSString *)passedText {

//	p.userName = passedText;
//	[p updateProfile];
//	//[self.tableView reloadData];	
//	[self dismissModalViewControllerAnimated:YES];
//	
//}




- (void)handlePickerChange:(NSInteger)index{
	
	NSString * type = @"";
	NSString * value = @"";
	NSString * buttonTitle = @"";
	//Update Weight
	if (pickerType == 1) {
		value = [NSString stringWithFormat:@"%d",(index + 50)];
		type = @"Weight";
		buttonTitle = [NSString stringWithFormat:@"Weight %@lbs",value];
		[weightButton setTitle:buttonTitle forState:UIControlStateNormal];
		[weightButton setTitle:buttonTitle forState:UIControlStateHighlighted];
		[weightButton setTitle:buttonTitle forState:UIControlStateDisabled];
		[weightButton setTitle:buttonTitle forState:UIControlStateSelected];
	}	
	if (pickerType == 2) {
		//float i = [index floatValue];
		float v = ((index/2.0) + 36.0);
		value = [NSString stringWithFormat:@"%1.1f", v];
		type = @"Height";
		buttonTitle = [NSString stringWithFormat:@"Height %@in",value];
		[heightButton setTitle:buttonTitle forState:UIControlStateNormal];
		[heightButton setTitle:buttonTitle forState:UIControlStateHighlighted];
		[heightButton setTitle:buttonTitle forState:UIControlStateDisabled];
		[heightButton setTitle:buttonTitle forState:UIControlStateSelected];
	}	
	if (pickerType == 3) {
		float v = ((index/2.0) + 20.0);
		value = [NSString stringWithFormat:@"%1.1f", v];
		type = @"Waist";
		buttonTitle = [NSString stringWithFormat:@"Waist %@in",value];
		[waistButton setTitle:buttonTitle forState:UIControlStateNormal];
		[waistButton setTitle:buttonTitle forState:UIControlStateHighlighted];
		[waistButton setTitle:buttonTitle forState:UIControlStateDisabled];
		[waistButton setTitle:buttonTitle forState:UIControlStateSelected];
	}	
	if (pickerType == 4) {
		float v = ((index/2.0) + 20.0);
		value = [NSString stringWithFormat:@"%1.1f", v];
		type = @"Hip";
		buttonTitle = [NSString stringWithFormat:@"Hip %@in",value];
		[hipButton setTitle:buttonTitle forState:UIControlStateNormal];
		[hipButton setTitle:buttonTitle forState:UIControlStateHighlighted];
		[hipButton setTitle:buttonTitle forState:UIControlStateDisabled];
		[hipButton setTitle:buttonTitle forState:UIControlStateSelected];
	}	
	if (pickerType == 5) {
		float v = ((index/2.0) + 1.0);
		value = [NSString stringWithFormat:@"%1.1f", v];
		type = @"Neck";
		buttonTitle = [NSString stringWithFormat:@"Neck %@in",value];
		[neckButton setTitle:buttonTitle forState:UIControlStateNormal];
		[neckButton setTitle:buttonTitle forState:UIControlStateHighlighted];
		[neckButton setTitle:buttonTitle forState:UIControlStateDisabled];
		[neckButton setTitle:buttonTitle forState:UIControlStateSelected];
	}		
	

		[BIUtility saveMeasurement:type withValue:value forDate:currentDate];
	
		
	dataField.text = [self measureData];
	//[self.tableView reloadData];	
	[self dismissModalViewControllerAnimated:YES];
	
}

- (void)viewWillAppear:(BOOL)animated {
   [super viewWillAppear:animated];
	[p release];
	p = [[Profile alloc] init];
	[self updateUI];
	//[self.tableView reloadData];
}
-(IBAction)weightButtonPressed:(id)sender {
	SinglePickerViewController *singlePickerViewController = [[SinglePickerViewController alloc] 
															  initWithNibName:@"SinglePickerViewController" 
															  bundle:nil];
	
	NSMutableArray * list = [[NSMutableArray alloc] init];
	pickerType = 1; // 1 for Weight			
	NSString * type = @"Weight";
	for (int y = 50 ; y <= 400; y++) {
		NSString * yString = [NSString stringWithFormat:@"%d lbs",y];
		[list addObject:yString];
	}
	if ([BIUtility latestMeasurement:type] != nil) singlePickerViewController.initialRow = ([[BIUtility latestMeasurement:type] integerValue]-50);
	else singlePickerViewController.initialRow = 100;		singlePickerViewController.viewTitle = [NSString stringWithFormat:@"Current %@", type];
	singlePickerViewController.delegate = self;
	singlePickerViewController.pickerData = list;
	[self presentModalViewController:singlePickerViewController animated:YES];
	
	[singlePickerViewController release];
	
	
	[list release];
	
			
	
	
}


	


	

-(IBAction)heightButtonPressed:(id)sender {
	SinglePickerViewController *singlePickerViewController = [[SinglePickerViewController alloc] 
															  initWithNibName:@"SinglePickerViewController" 
															  bundle:nil];
	
	NSMutableArray * list = [[NSMutableArray alloc] init];
	pickerType = 2; // 1 for Weight			
	NSString * type = @"Height";
	for (float y = 36 ; y <= 96 ; y = y + .5) {
		NSString * yString = [NSString stringWithFormat:@"%1.1f inches",y];
		[list addObject:yString];
	}
	if ([BIUtility latestMeasurement:type] != nil) singlePickerViewController.initialRow = (([[BIUtility latestMeasurement:type] floatValue]*2)-(36*2));
	else singlePickerViewController.initialRow = ((71-36)*2);	
	singlePickerViewController.viewTitle = [NSString stringWithFormat:@"Current %@", type];
	singlePickerViewController.delegate = self;
	singlePickerViewController.pickerData = list;
	[self presentModalViewController:singlePickerViewController animated:YES];
	
	[singlePickerViewController release];
	
	
	[list release];
	
	
	
	
}
-(IBAction)neckButtonPressed:(id)sender {
	SinglePickerViewController *singlePickerViewController = [[SinglePickerViewController alloc] 
															  initWithNibName:@"SinglePickerViewController" 
															  bundle:nil];
	
	NSMutableArray * list = [[NSMutableArray alloc] init];
	pickerType = 5; 			
	NSString * type = @"Neck";
	for (float y = 1 ; y <= 30 ; y = y + .5) {
		NSString * yString = [NSString stringWithFormat:@"%1.1f inches",y];
		[list addObject:yString];
	}
	if ([BIUtility latestMeasurement:type] != nil) singlePickerViewController.initialRow = (([[BIUtility latestMeasurement:type] floatValue]*2)-2);
	else singlePickerViewController.initialRow = (15 - 1) * 2;
	singlePickerViewController.viewTitle = [NSString stringWithFormat:@"Current %@", type];
	singlePickerViewController.delegate = self;
	singlePickerViewController.pickerData = list;
	[self presentModalViewController:singlePickerViewController animated:YES];
	
	[singlePickerViewController release];
	
	
	[list release];
	
	
	
	
}
-(IBAction)hipButtonPressed:(id)sender {
	SinglePickerViewController *singlePickerViewController = [[SinglePickerViewController alloc] 
															  initWithNibName:@"SinglePickerViewController" 
															  bundle:nil];
	
	NSMutableArray * list = [[NSMutableArray alloc] init];
	pickerType = 4; 			
	NSString * type = @"Hip";
	for (float y = 20 ; y <= 80 ; y = y + .5) {
		NSString * yString = [NSString stringWithFormat:@"%1.1f inches",y];
		[list addObject:yString];
	}
	if ([BIUtility latestMeasurement:type] != nil) singlePickerViewController.initialRow = (([[BIUtility latestMeasurement:type] floatValue]*2)-(20*2));
	else singlePickerViewController.initialRow = (42-20) * 2;
	singlePickerViewController.viewTitle = [NSString stringWithFormat:@"Current %@", type];
	singlePickerViewController.delegate = self;
	singlePickerViewController.pickerData = list;
	[self presentModalViewController:singlePickerViewController animated:YES];
	
	[singlePickerViewController release];
	
	
	[list release];
	
	
	
	
}
-(IBAction)waistButtonPressed:(id)sender {
	SinglePickerViewController *singlePickerViewController = [[SinglePickerViewController alloc] 
															  initWithNibName:@"SinglePickerViewController" 
															  bundle:nil];
	
	NSMutableArray * list = [[NSMutableArray alloc] init];
	pickerType = 3; // 1 for Weight			
	NSString * type = @"Waist";
	for (float y = 20 ; y <= 70 ; y = y + .5) {
		NSString * yString = [NSString stringWithFormat:@"%1.1f inches",y];
		[list addObject:yString];
	}
	if ([BIUtility latestMeasurement:type] != nil) singlePickerViewController.initialRow = (([[BIUtility latestMeasurement:type] floatValue]*2)-(20*2));
	else singlePickerViewController.initialRow = (36-20)*2;
	singlePickerViewController.viewTitle = [NSString stringWithFormat:@"Current %@", type];
	singlePickerViewController.delegate = self;
	singlePickerViewController.pickerData = list;
	[self presentModalViewController:singlePickerViewController animated:YES];
	
	[singlePickerViewController release];
	
	
	[list release];
	
	
	
	
}

/**
-(void)weightChart{
	
	
	CKSparkline *sparkline = [[CKSparkline alloc]
							  initWithFrame:CGRectMake(185.0, 290.0, 130.0, 90.0)];
	
    // Sample data
    sparkline.data = [BIUtility weightList];
	sparkline.lineColor = [UIColor colorWithRed:0.4 green:0.65 blue:0.84 alpha:1];
	
    [self.view addSubview:sparkline];
    [sparkline release];
    
	
}
 **/
-(void)updateUI {
	NSString * imageName;
	
	NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormat setDateStyle:NSDateFormatterMediumStyle];
	self.startDate = p.startDate;
	self.birthDate = p.birthDate;
	if (p.sexInt == 1) {
		imageName = @"malemeasure.png";
		hipButton.hidden = YES;
		
	} else {
		imageName = @"femalemeasure.png";
		hipButton.hidden = NO;
	}
	
	UIImage *image = [UIImage imageNamed:imageName];
	[humanImage setImage:image];
	
	
	//UINavigationItem* item = [[UINavigationItem alloc] initWithTitle:@"title text"];
	
	//[navBar pushNavigationItem:item animated:YES];
	//[item release];
	
	NSString *value;
	

	
		if ([BIUtility latestMeasurement:@"Weight" forDate:currentDate latest:editMode] != nil)
			value = [NSString stringWithFormat:@"Weight %@lbs",[BIUtility latestMeasurement:@"Weight" forDate:currentDate latest:editMode]];
		else
			value = [NSString stringWithFormat:@"Weight"];
		[weightButton setTitle:value forState:UIControlStateNormal];
		[weightButton setTitle:value forState:UIControlStateHighlighted];
		[weightButton setTitle:value forState:UIControlStateDisabled];
		[weightButton setTitle:value forState:UIControlStateSelected];
		
		if ([BIUtility latestMeasurement:@"Height" forDate:currentDate latest:editMode] != nil)
			value = [NSString stringWithFormat:@"Height %@in",[BIUtility latestMeasurement:@"Height" forDate:currentDate latest:editMode]];
		else
			value = [NSString stringWithFormat:@"Height"];
		[heightButton setTitle:value forState:UIControlStateNormal];
		[heightButton setTitle:value forState:UIControlStateHighlighted];
		[heightButton setTitle:value forState:UIControlStateDisabled];
		[heightButton setTitle:value forState:UIControlStateSelected];
		
		if ([BIUtility latestMeasurement:@"Waist" forDate:currentDate latest:editMode] != nil)
			value = [NSString stringWithFormat:@"Waist %@in",[BIUtility latestMeasurement:@"Waist" forDate:currentDate latest:editMode]];
		else
			value = [NSString stringWithFormat:@"Waist"];
		[waistButton setTitle:value forState:UIControlStateNormal];
		[waistButton setTitle:value forState:UIControlStateHighlighted];
		[waistButton setTitle:value forState:UIControlStateDisabled];
		[waistButton setTitle:value forState:UIControlStateSelected];
		
		if ([BIUtility latestMeasurement:@"Neck" forDate:currentDate latest:editMode] != nil)
			value = [NSString stringWithFormat:@"Neck %@in",[BIUtility latestMeasurement:@"Neck" forDate:currentDate latest:editMode]];
		else
			value = [NSString stringWithFormat:@"Neck"];
		[neckButton setTitle:value forState:UIControlStateNormal];
		[neckButton setTitle:value forState:UIControlStateHighlighted];
		[neckButton setTitle:value forState:UIControlStateDisabled];
		[neckButton setTitle:value forState:UIControlStateSelected];
		
		if ([BIUtility latestMeasurement:@"Hip" forDate:currentDate latest:editMode] != nil)
			value = [NSString stringWithFormat:@"Hip %@in",[BIUtility latestMeasurement:@"Hip" forDate:currentDate latest:editMode]];
		else
			value = [NSString stringWithFormat:@"Hip"];
		[hipButton setTitle:value forState:UIControlStateNormal];
		[hipButton setTitle:value forState:UIControlStateHighlighted];
		[hipButton setTitle:value forState:UIControlStateDisabled];
		[hipButton setTitle:value forState:UIControlStateSelected];
		

		
	if (editMode) {
		dataField.text = @"";
	} else  {
		dataField.text = [self measureData];
	}
	[dataField setFont:[UIFont systemFontOfSize:13]];
	[dataField  setTextColor:[UIColor whiteColor]];
	dataField.backgroundColor = [UIColor clearColor];
	
}


-(IBAction)doneButtonPressed:(id)sender {

	
	[self dismissModalViewControllerAnimated:YES];
	
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	p = [[Profile alloc] init];

	//UIColor * bg = [[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Background.png"]] autorelease];
	self.view.backgroundColor = [UIColor blackColor];
	
	

	currentDate = [[BIUtility todayDateString] retain];
	if (!editMode) {
		UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"Today's Measurements"];
		item.hidesBackButton = YES;
		[viewNavigationBar pushNavigationItem:item animated:NO];
		[item release];
		
	} else {
		currentDate = passedDate;
		navTitle.text = [NSString stringWithFormat:@"%@ Measurements", currentDate];
		UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
									   initWithTitle:@"Done" 
									   style:UIBarButtonItemStyleBordered
									   target:self
									   action:@selector(doneButtonPressed:)];
		UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:[NSString stringWithFormat:@"%@ Measurements", currentDate]];
		item.leftBarButtonItem = doneButton;
		item.hidesBackButton = YES;
		[viewNavigationBar pushNavigationItem:item animated:NO];
		[item release];
		[doneButton release];
	}
	[self updateUI];
}

- (NSString *)measureData {
	
	NSString * retData;
	int WEIGHT = [[BIUtility latestMeasurement:@"Weight"] intValue];
	float HEIGHT = [[BIUtility latestMeasurement:@"Height"] floatValue];
	float NECK = [[BIUtility latestMeasurement:@"Neck"] floatValue];		
	float WAIST = [[BIUtility latestMeasurement:@"Waist"] floatValue];
	float HIP = [[BIUtility latestMeasurement:@"Hip"] floatValue];
	BOOL maleCalcOk = YES;
	BOOL femaleCalcOK = YES;
	
	if (WEIGHT == 0) {
		maleCalcOk = NO;
		femaleCalcOK = NO;
	}
	
	if (HEIGHT == 0) {
		maleCalcOk = NO;
		femaleCalcOK = NO;
	}
	if (NECK == 0) {
		maleCalcOk = NO;
		femaleCalcOK = NO;
	}
	if (WAIST == 0) {
		maleCalcOk = NO;
		femaleCalcOK = NO;
	}
	if (HIP == 0 && p.sexInt == 2) {
		femaleCalcOK = NO;
	}
	
	
	float BMRf;
	if (p.sexInt == 2) {
		//Female Calc
		BMRf = 655 +	(4.35 * WEIGHT) +
		(4.7 * HEIGHT) -
		(4.7 * [BIUtility age]);
	} else {
		//Male Calc
		BMRf = 66 +	(6.23 * WEIGHT) +
		(12.7 * HEIGHT) -
		(6.8 * [BIUtility age]);
	}
	
	float LBM;
	float BF;
	float FM;
	NSString * level;
	if (p.sexInt == 1) {
		//male Calc
		double WN = (WAIST) - (NECK);			
		
		//BF = ((495/(1.0324 - .19077 * log(WN) + .15456 * log(HEIGHT * 2.54))) - 450);
		float BF1 = 86.010*log10(WN) ;
		
		float BF2 = 70.041*log10(HEIGHT);
		BF = BF1 - BF2 + 36.76;
		
		if (BF < 13) {
			level = @"(Athletic)";
		} else if (BF >= 13 && BF < 18) {
			level = @"(Fit)";
		} else if (BF >= 18 && BF < 25) {
			level = @"(Acceptable)";
		} else {
			level = @"(Obese)";
		}
		
		
	} else {
		//female Calc
		//NAVY Calc
		double WHN = (WAIST) +
		(HIP) -
		(NECK);
		
		
		BF = 163.205*log10(WHN)-97.684*log10(HEIGHT) - 78.387;
		if (BF < 20) {
			level = @"(Athletic)";
		} else if (BF >= 20 && BF < 25) {
			level = @"(Fit)";
		} else if (BF >= 25 && BF < 32) {
			level = @"(Acceptable)";
		} else {
			level = @"(Obese)";
		}			
	}
	
	FM = BF * WEIGHT/100;
	
	LBM = WEIGHT - FM;
	
	if (!maleCalcOk && p.sexInt == 1) {
		BMRf = 0; LBM = 0; FM = 0; BF = 0; level = @"";
	}
	if (!femaleCalcOK && p.sexInt == 2) {
		BMRf = 0; LBM = 0; FM = 0; BF = 0; level = @"";
	}
	
	
		
	retData = [NSString stringWithFormat:@"Daily Metabolic Rate:\n   %0.0f cal\n", BMRf];
	retData = [NSString stringWithFormat:@"%@Total (incl. workout):\n    %0.0f cal\n\n", retData, (BMRf * [BIUtility caloricFactor])];
	retData = [NSString stringWithFormat:@"%@Lean Mass: %0.0f lbs\nFat Mass: %0.0f lbs\n\n", retData, LBM, FM];
	retData = [NSString stringWithFormat:@"%@Approx Body Fat: %0.0f%% \n     %@",retData, BF, level];
		
		
	return retData;
	
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
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	//[self weightChart];
	
}

- (void)dealloc {
    
	//[datePickerViewController release];
	[p release];
	[currentDate release];
	[super dealloc];
}



@end
