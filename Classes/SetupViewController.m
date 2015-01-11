//
//  SetupViewController.m
//  Bring It
//
//  Created by Michael Bordelon on 4/17/10.
//  Copyright 2010 Bordelon iPhone. All rights reserved.
//

#import "SetupViewController.h"



@implementation SetupViewController

@synthesize  p, selectedDatePicker, startDate, birthDate, pickerType;


- (void)handleTextFieldChange:(NSString *)passedText {

	p.userName = passedText;
	[p updateProfile];
	[self.tableView reloadData];	
	[self dismissModalViewControllerAnimated:YES];
	
}



- (void)handleDateChange:(UIDatePicker *)updatedDatePicker {
	
	//self.selectedDatePicker = dp;
	//NSLog(@"HANDLING DATE");
	
	//NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
	//[dateFormat setDateStyle:NSDateFormatterShortStyle];
	
	//NSString *dt = [dateFormat stringFromDate:updatedDatePicker.date];
	NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormat setDateStyle:NSDateFormatterMediumStyle];
	
	
	if (pickerType == 1) {
		//self.startDate = dt;
		p.startDate = [BIUtility dateStringForDate:updatedDatePicker.date];
		[p updateProfile];
		[p release];
		p = [[Profile alloc] init];
		//self.startDate = [dateFormat stringFromDate:p.startDate];
		self.startDate = p.startDate;
		[self.tableView reloadData];	
		[self dismissModalViewControllerAnimated:YES];
		[BIUtility flushTodaysWorkouts];

		
	}

	
	if (pickerType == 2) {
		//self.birthDate = dt;
		p.birthDate = [BIUtility dateStringForDate:updatedDatePicker.date];
		[p updateProfile];
		[p release];
		p = [[Profile alloc] init];
		self.birthDate = p.birthDate;
		[self.tableView reloadData];	
		[self dismissModalViewControllerAnimated:YES];
	}

	navTitle.text = [NSString stringWithFormat:@"%d", [BIUtility scheduleDay]];
	
}

- (void)handlePickerChange:(NSInteger)index{
	
	
	//Update Schedule
	if (pickerType == 1) {
		p.scheduleID = (index + 1);
		[p updateProfile];
		[p release];
		p = [[Profile alloc] init];
		[self.tableView reloadData];	
		[self dismissModalViewControllerAnimated:YES];
		[BIUtility flushTodaysWorkouts];
	}
	
	
	//Update Sex
	if (pickerType == 2) {
		p.sexInt = (index + 1);
		[p updateProfile];
		[p release];
		p = [[Profile alloc] init];
		[self.tableView reloadData];	
		[self dismissModalViewControllerAnimated:YES];
		
	}
			navTitle.text = [NSString stringWithFormat:@"%d", [BIUtility scheduleDay]];

	//Update Loss Rate
	if (pickerType == 5) {
		float rate = index * 0.5;
		p.lossRate = [NSString stringWithFormat:@"%1.1f", rate];
		[p updateProfile];
		[p release];
		p = [[Profile alloc] init];
		[self.tableView reloadData];	
		[self dismissModalViewControllerAnimated:YES];
	}
	
	if (pickerType == 6) {
		//NSString * value = [NSString stringWithFormat:@"%d",(index + 50)];	
		NSInteger goal = index + 50;
		p.weightGoal = goal;
		[p updateProfile];
		[p release];
		p = [[Profile alloc] init];
		[self.tableView reloadData];	
		[self dismissModalViewControllerAnimated:YES];
		
	}
	
}
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

- (void)viewWillAppear:(BOOL)animated {
	[p release];
	p = [[Profile alloc] init];
	NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormat setDateStyle:NSDateFormatterMediumStyle];
	self.startDate = p.startDate;
	self.birthDate = p.birthDate;
	navTitle.text = [NSString stringWithFormat:@"%d", [BIUtility scheduleDay]];

	[self.tableView reloadData];
	[super viewWillAppear:animated];
	navTitle.hidden = NO;

	
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	p = [[Profile alloc] init];
	NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormat setDateStyle:NSDateFormatterMediumStyle];
	self.startDate = p.startDate;
	self.birthDate = p.birthDate;


	self.view.backgroundColor = [UIColor blackColor];
	
	UIImageView * iv = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title.png"]] autorelease];
	self.navigationItem.titleView = iv;
	
	UIButton* infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight]; 
	[infoButton addTarget:self action:@selector(showInfoView:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem * bi = [[[UIBarButtonItem alloc] initWithCustomView:infoButton] autorelease];
	self.navigationItem.rightBarButtonItem = bi;
		
     UIButton *home = [UIButton buttonWithType:UIButtonTypeCustom];  
     UIImage *homeImage = [[UIImage imageNamed:@"calendar.png"]  
                         stretchableImageWithLeftCapWidth:10 topCapHeight:10];  
     [home setBackgroundImage:homeImage forState:UIControlStateNormal];  
     [home addTarget:self action:@selector(calendarPressed:)  
                 forControlEvents:UIControlEventTouchUpInside];  
     home.frame = CGRectMake(0, 0, 35, 35);  
     UIBarButtonItem *calendarButton = [[[UIBarButtonItem alloc]  
                         initWithCustomView:home] autorelease];  
     self.navigationItem.leftBarButtonItem = calendarButton;  
	
	
	UINavigationBar *bar = [self.navigationController navigationBar];
	navTitle = [[UILabel alloc] initWithFrame:CGRectMake(9, 13, 28, 25)];
	
	navTitle.backgroundColor = [UIColor clearColor];
	navTitle.font = [UIFont boldSystemFontOfSize:19];
	navTitle.adjustsFontSizeToFitWidth = YES;
	navTitle.textAlignment = UITextAlignmentCenter;
	navTitle.textColor = [UIColor blackColor];
	//label.highlightedTextColor = [UIColor blackColor];
	navTitle.text = [NSString stringWithFormat:@"%d", [BIUtility scheduleDay]];
	[bar addSubview:navTitle];
	bar.barStyle = UIBarStyleBlackTranslucent;
	//self.title = @"Home";
	[self update];
/*
	if ([BIUtility updateNeeded]) { 

		
		HUD = [[MBProgressHUD alloc] initWithView:self.view];
	
		// Add HUD to screen
		[self.view addSubview:HUD];
	
		// Regisete for HUD callbacks so we can remove it from the window at the right time
		HUD.delegate = self;
	
		HUD.labelText = @"Please Wait";
		HUD.detailsLabelText = @"upgrading data";
	
		// Show the HUD while the provided method executes in a new thread
		[HUD showWhileExecuting:@selector(update) onTarget:self withObject:nil animated:YES];
	 
	}
*/		
		NSOperationQueue *queue = [[NSOperationQueue new] autorelease];
		NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self
																			selector:@selector(loadDataFromWebWithOperation)
																			  object:nil];
		[queue addOperation:operation];
		[operation release];
	
}

- (void) loadDataFromWebWithOperation {
	
	if ([BIUtility connectedToInternet]) {
		[BIUtility updateDataFromWeb];
	}
}



-(void)update {
	[BIUtility updateDataIfNeeded];
	
}
	


-(IBAction)showInfoView:(id)sender{  
	navTitle.hidden = YES;
	AboutViewController *aboutViewController = [[AboutViewController alloc] 
																	  initWithNibName:@"AboutViewController" 
																	  bundle:nil];
	//Bring_ItAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	//[delegate.setupNavController pushViewController:aboutViewController animated:YES];
	[self presentModalViewController:aboutViewController animated:YES];
	[aboutViewController release];

}	
-(IBAction)calendarPressed:(id)sender{  
	int schedDay = [BIUtility scheduleDay];
	int woInProg = [BIUtility workoutCountInProgram];
	if ((woInProg > 0) && (schedDay <= woInProg)) {
		navTitle.hidden = YES;
		UpcomingScheduleViewController *upcomingScheduleViewController = [[UpcomingScheduleViewController alloc] 
																		initWithNibName:@"UpcomingScheduleViewController" 
																		bundle:nil];
		Bring_ItAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
		[delegate.setupNavController pushViewController:upcomingScheduleViewController animated:YES];
		[upcomingScheduleViewController release];
	}
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

	[navTitle release];
	[p release];
	[super dealloc];
}

- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
		return UITableViewCellAccessoryDisclosureIndicator;
	
	
}

- (void)handleTextViewChange:(NSString *)passedText {
	
	[BIUtility addDailyNote:passedText];
	[self.tableView reloadData];	
	[self dismissModalViewControllerAnimated:YES];
	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UITableViewCell *cell;
	UACellBackgroundView *bv = [[[UACellBackgroundView alloc] initWithFrame:CGRectZero] autorelease];
	
	if (indexPath.section == 0) {
		bv.position = UACellBackgroundViewPositionSingle;
		cell = [tableView dequeueReusableCellWithIdentifier:@"DailyNoteCell"];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier: @"DailyNoteCell"] autorelease];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}	
		NSString * note;
		if ([BIUtility todaysDailyNote] == nil) {
			note = @"Enter Today's Note";
		} else {
			note = [BIUtility todaysDailyNote];
		}

		[cell.textLabel setText:[NSString stringWithFormat:@"%@", note]];
		cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        cell.textLabel.numberOfLines = 0;
		[cell.textLabel setFont:[UIFont fontWithName:@"Helvetica" size:15]];
		cell.imageView.image = [UIImage imageNamed:@"1note.png"];
	}
	
	if (indexPath.section == 1) {
		if (indexPath.row == 0) {
			cell = [tableView dequeueReusableCellWithIdentifier:@"BlogCell"];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier: @"BlogCell"] autorelease];
				cell.accessoryType = UITableViewCellAccessoryNone;
			}	
			//[cell.textLabel setText:@"Program: P90X"];
			NSString *cellText = [NSString stringWithFormat:@"Blogger Setup"];
			[cell.textLabel setText:cellText];
			if ([p.bloggerAddress intValue] == -1) bv.position = UACellBackgroundViewPositionSingle;
			else bv.position = UACellBackgroundViewPositionTop;
			cell.imageView.image = [UIImage imageNamed:@"blogger_logo.png"];
		}
		if (indexPath.row == 1) {
			cell = [tableView dequeueReusableCellWithIdentifier:@"BlogUpdateCell"];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier: @"BlogUpdateCell"] autorelease];
				cell.accessoryType = UITableViewCellAccessoryNone;
			}	
			//[cell.textLabel setText:@"Program: P90X"];
			NSString *cellText = [NSString stringWithFormat:@"Update Today's Blog"];
			[cell.textLabel setText:cellText];
			[cell.detailTextLabel setText:p.bloggerLastUpdate];
			[cell.detailTextLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
			cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
			cell.detailTextLabel.numberOfLines = 0;
			bv.position = UACellBackgroundViewPositionBottom;
			//cell.image = [UIImage imageNamed:@"blogger_logo.png"];
			cell.detailTextLabel.backgroundColor = [UIColor clearColor];
			
		}
	}	
	if (indexPath.section == 2) {
	
		if (indexPath.row == 0) {
			cell = [tableView dequeueReusableCellWithIdentifier:@"NameCell"];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier: @"NameCell"] autorelease];
				cell.accessoryType = UITableViewCellAccessoryNone;
			}	
			NSString *cellText = [NSString stringWithFormat:@"Name: %@", p.userName];
			[cell.textLabel setText:cellText];		
			bv.position = UACellBackgroundViewPositionTop;
			cell.imageView.image = [UIImage imageNamed:@"1name.png"];

		} 
		
		if (indexPath.row == 1) {
			
			cell = [tableView dequeueReusableCellWithIdentifier:@"BirthCell"];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier: @"BirthCell"] autorelease];
				cell.accessoryType = UITableViewCellAccessoryNone;
			}	
			NSString *cellText = [NSString stringWithFormat:@"Birth Date: %@", [BIUtility formattedDateFromString:self.birthDate]];
			[cell.textLabel setText:cellText];
			bv.position = UACellBackgroundViewPositionMiddle;
			cell.imageView.image = [UIImage imageNamed:@"1birth.png"];
			
		} 
		
		if (indexPath.row == 2) {
			
			cell = [tableView dequeueReusableCellWithIdentifier:@"SexCell"];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier: @"SexCell"] autorelease];
				cell.accessoryType = UITableViewCellAccessoryNone;
			}	
			NSString *cellText = [NSString stringWithFormat:@"Sex: %@", p.sex];
			[cell.textLabel setText:cellText];		
			bv.position = UACellBackgroundViewPositionBottom;
			cell.imageView.image = [UIImage imageNamed:@"1sex.png"];
		} 
		
		
		
	}
	
	
	if (indexPath.section == 3) {
	
	if (indexPath.row == 0) {
		cell = [tableView dequeueReusableCellWithIdentifier:@"ProgramCell"];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier: @"ProgramCell"] autorelease];
			cell.accessoryType = UITableViewCellAccessoryNone;
		}	
		//[cell.textLabel setText:@"Program: P90X"];
		NSString *cellText = [NSString stringWithFormat:@"Program: %@", p.scheduleName];
		[cell.textLabel setText:cellText];
		bv.position = UACellBackgroundViewPositionTop;
		cell.imageView.image = [UIImage imageNamed:@"1program.png"];
	} 
	
	if (indexPath.row == 1) {

		cell = [tableView dequeueReusableCellWithIdentifier:@"StartCell"];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier: @"StartCell"] autorelease];
			cell.accessoryType = UITableViewCellAccessoryNone;
		}	
		//Workout *wo = [todaysWorkouts objectAtIndex:indexPath.section];			
		NSString *cellText = [NSString stringWithFormat:@"Start Date: %@", [BIUtility formattedDateFromString:self.startDate]];
		[cell.textLabel setText:cellText];
		
		bv.position = UACellBackgroundViewPositionBottom;
		cell.imageView.image = [UIImage imageNamed:@"1start.png"];
	} 
	}
	if (indexPath.section == 4) 
	{
		if (indexPath.row == 0) {
			cell = [tableView dequeueReusableCellWithIdentifier:@"LossCell"];
			if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier: @"LossCell"] autorelease];
			cell.accessoryType = UITableViewCellAccessoryNone;
			}	
			//[cell.textLabel setText:@"Program: P90X"];
			NSString *cellText = [NSString stringWithFormat:@"Wt Loss Rate: %@ lbs/wk", p.lossRate];
			[cell.textLabel setText:cellText];
			bv.position = UACellBackgroundViewPositionTop;
			cell.imageView.image = [UIImage imageNamed:@"1flag.png"];
		} 
		if (indexPath.row == 1) {
				
			cell = [tableView dequeueReusableCellWithIdentifier:@"GoalCell"];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier: @"GoalCell"] autorelease];
				cell.accessoryType = UITableViewCellAccessoryNone;
			}	
			NSString *cellText = [NSString stringWithFormat:@"Goal Weight: %d", p.weightGoal];
			[cell.textLabel setText:cellText];
				
			bv.position = UACellBackgroundViewPositionBottom;
			cell.imageView.image = [UIImage imageNamed:@"goal.png"];
		} 
	}

			
		
	

	cell.textLabel.backgroundColor = [UIColor clearColor];	


	cell.backgroundView = bv;
	//[bv release];	
	return cell;	
	
	//[cell release];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSUInteger row = [indexPath row];
	if (indexPath.section == 0) {
		TextViewController *textViewController = [[TextViewController alloc] 
												  initWithNibName:@"TextViewController" 
												  bundle:nil];
		
		textViewController.delegate = self;
		textViewController.viewTitle = @"Daily Note";
		textViewController.initialText = [BIUtility todaysDailyNote];
		//self.woIndex = indexPath.section;
		
		[self presentModalViewController:textViewController animated:YES];
		
		[textViewController release];
	
	}

	if (indexPath.section == 1) {
		/*
		if (row == 0) {
			
            BloggerViewController *bloggerViewController = [[BloggerViewController alloc] 
															initWithNibName:@"BloggerViewController" 
															bundle:nil];
			[self presentModalViewController:bloggerViewController animated:YES];
			[bloggerViewController release];
             
        }
        
		if (row == 1) {
			
			BloggerUpdateListViewController *bloggerUpdateListViewController = [[BloggerUpdateListViewController alloc] 
																		initWithNibName:@"BloggerUpdateListViewController" 
																		bundle:nil];
			Bring_ItAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
			[delegate.setupNavController pushViewController:bloggerUpdateListViewController animated:YES];
			[bloggerUpdateListViewController release];
			navTitle.hidden = YES;
		
         }
         
		*/
		
		
		
	}
	
	
	if (indexPath.section == 2) {
		
		if (row == 0) {
			TextFieldViewController *textFieldViewController = [[TextFieldViewController alloc] 
																	  initWithNibName:@"TextFieldViewController" 
																	  bundle:nil];
			
			textFieldViewController.delegate = self;
			textFieldViewController.viewTitle = @"Enter Your Name";
			textFieldViewController.initialText = p.userName;
			
			[self presentModalViewController:textFieldViewController animated:YES];
			
			[textFieldViewController release];
			
		}
		
		
		if (row == 1) {
			DatePickerViewController *datePickerViewController = [[DatePickerViewController alloc] 
																  initWithNibName:@"DatePickerViewController" 
																  bundle:nil];
			
			datePickerViewController.delegate = self;
			datePickerViewController.viewTitle = @"Birth Date";
			datePickerViewController.initialDate = [BIUtility dateFromString:p.birthDate];
			datePickerViewController.maxDate = [BIUtility dateFromString:[BIUtility todayDateString]];
			pickerType = 2; // 1 is ofr Start Date and 2 is for Birth Date.  I am sure this is bad OO and I should send it back through the delegate but I am lazy.
			
			
			[self presentModalViewController:datePickerViewController animated:YES];
			
			[datePickerViewController release];
			
		}
		if (row == 2) {
			SinglePickerViewController *singlePickerViewController = [[SinglePickerViewController alloc] 
																	  initWithNibName:@"SinglePickerViewController" 
																	  bundle:nil];
			
			singlePickerViewController.delegate = self;
			singlePickerViewController.viewTitle = @"Select Sex";
			singlePickerViewController.help = @"Note: Sex is used in metabolic calculations.";
			NSArray * array = [[NSArray alloc] initWithObjects:@"Male", @"Female", nil];
			singlePickerViewController.pickerData = array;
			[array release];
			singlePickerViewController.initialRow = (p.sexInt - 1);
			pickerType = 2; // 2 for sex			
			
			[self presentModalViewController:singlePickerViewController animated:YES];
			
			[singlePickerViewController release];
			
		}
		
	}
	if (indexPath.section == 3) {
		
		if (row == 0) {
			SinglePickerViewController *singlePickerViewController = [[SinglePickerViewController alloc] 
																	  initWithNibName:@"SinglePickerViewController" 
																	  bundle:nil];
			
			singlePickerViewController.delegate = self;
			singlePickerViewController.viewTitle = @"Select Program";
			singlePickerViewController.help = @"Note: Changing the program will reset today's workout(s).";
			singlePickerViewController.pickerData = [BIUtility configuredPrograms];
			//datePickerViewController.initialDate = p.startDate;
			singlePickerViewController.initialRow = (p.scheduleID - 1);
			pickerType = 1; // 1 for Schedule/Program			
			
			[self presentModalViewController:singlePickerViewController animated:YES];
			
			[singlePickerViewController release];
			
		}
		
		if (row == 1) {
			DatePickerViewController *datePickerViewController = [[DatePickerViewController alloc] 
																  initWithNibName:@"DatePickerViewController" 
																  bundle:nil];
			
			datePickerViewController.delegate = self;
			datePickerViewController.viewTitle = @"Start Date";
			datePickerViewController.initialDate = [BIUtility dateFromString:p.startDate];
			datePickerViewController.maxDate = [BIUtility dateFromString:[BIUtility todayDateString]];			
			pickerType = 1; // 1 is ofr Start Date and 2 is for Birth Date.  I am sure this is bad OO and I should send it back through the delegate but I am lazy.
			
			
			[self presentModalViewController:datePickerViewController animated:YES];
			
			[datePickerViewController release];
			
		}
		
		
		
	}
	if (indexPath.section == 4) {
		
		if (row == 0) {
			SinglePickerViewController *singlePickerViewController = [[SinglePickerViewController alloc] 
																	  initWithNibName:@"SinglePickerViewController" 
																	  bundle:nil];
			
			singlePickerViewController.delegate = self;
			singlePickerViewController.viewTitle = @"Weekly Wt Loss";
			singlePickerViewController.help = @"Note: This value is used to calculate your daily caloric intake.";
			NSArray * rates = [[NSArray alloc] initWithObjects:@"0.0 lb", @"0.5 lb", @"1.0 lb", @"1.5 lb", @"2.0 lb", @"2.5 lb", @"3.0 lb", nil];
			singlePickerViewController.pickerData = rates;
		    float lRate = [p.lossRate floatValue];
			
			singlePickerViewController.initialRow = lRate/0.5;
			pickerType = 5; // 5 for loss rate			
			[self presentModalViewController:singlePickerViewController animated:YES];
			[singlePickerViewController release];
			
		}
		if (row == 1) {
			SinglePickerViewController *singlePickerViewController = [[SinglePickerViewController alloc] 
																	  initWithNibName:@"SinglePickerViewController" 
																	  bundle:nil];
			
			NSMutableArray * list = [[NSMutableArray alloc] init];
			pickerType = 6; // 6 for Weight	Goal		
			//NSString * type = @"Weight";
			for (int y = 50 ; y <= 400; y++) {
				NSString * yString = [NSString stringWithFormat:@"%d lbs",y];
				[list addObject:yString];
			}
			singlePickerViewController.initialRow = (p.weightGoal-50);
			//else singlePickerViewController.initialRow = 100;		
			singlePickerViewController.help = @"Note: This value will show up on the weight charts.";
			
			singlePickerViewController.viewTitle = @"Goal Weight";
			singlePickerViewController.delegate = self;
			singlePickerViewController.pickerData = list;
			[self presentModalViewController:singlePickerViewController animated:YES];
			
			[singlePickerViewController release];
			
			
			[list release];
			
			
		}
		
	}
	
	
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	
	NSInteger h;
	if (indexPath.section == 1 && indexPath.row == 1) {
		NSString *cellText = p.bloggerLastUpdate;
		UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:15];
		CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
		CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
		h =  labelSize.height + 20;
		if (h<25) h=45;
	} else if (indexPath.section == 0 ) {
		
		NSString *cellText = [BIUtility todaysDailyNote];
		UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:15];
		CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
		CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
		h =  labelSize.height + 30;
		if (h<45) h=45;
	} else {
		h = 45;
	}
	
	return h;
	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 5;
	
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSInteger n = 0;
	
	if (section == 0) {
		n = 1;
	} else if (section == 2)	{	
		n = 3;
	} else if (section == 3)	{	
		n = 2;
	} else if (section == 4)	{
		n = 2;
	} else if (section == 1)	{

		if ([p.bloggerAddress intValue] > -1) n = 2; 
		else n = 1;
	}
	
	return n;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([self tableView:tableView titleForHeaderInSection:section] != nil) {
        return 35;
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
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    [view autorelease];
    [view addSubview:label];
	
    return view;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	if (section == 0) {
	
		return @"Daily Note";
	} else if (section == 1) {
		return @"Sharing";
	} else if (section == 2) {
		return @"Setup";
	} else {
		return nil;
	}

	
	
}

@end
