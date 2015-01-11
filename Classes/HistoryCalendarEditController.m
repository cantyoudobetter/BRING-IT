//
//  DemoCalendarMonth.m
//  TapkuLibraryDemo
//
//  Created by Devin Ross on 10/31/09.
//  Copyright 2009 Devin Ross. All rights reserved.
//

#import "HistoryCalendarEditController.h"


@implementation HistoryCalendarEditController
@synthesize selectedDate;

- (void) generateDataForStartDate:(NSDate*)start endDate:(NSDate*)end{
	
	[dataArray release];
	//[dataDictionary release];
	dataArray = [[NSMutableArray alloc] init];
	//dataDictionary = [[NSMutableDictionary alloc] init];
	
	NSDate *d = start;
	NSInteger count;
	while(YES){
		count = [[BIUtility historyForDate:[BIUtility dateStringForDate:d]] count];
		if (count > 0) {
			[dataArray addObject:[NSNumber numberWithBool:YES]];
		}else{
			[dataArray addObject:[NSNumber numberWithBool:NO]];
		}
		
		TKDateInformation info = [d dateInformation];
		info.day++;
		d = [NSDate dateFromDateInformation:info];
		if([d compare:end]==NSOrderedDescending) break;
	}
	

}

- (void) viewDidLoad{

	srand([[NSDate date] timeIntervalSince1970]);
	//selectedDate = [NSDate alloc];
	
	//selectedDate = [NSString alloc];
	selectedDate = [[BIUtility dateStringForDate:[NSDate date]] retain];
	NSLog(@"selectedDate: %@", selectedDate);
	[self.monthView selectDate:[NSDate date]];
	self.title = @"Edit History";
	[super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
	
	[self.tableView reloadData];
	[super viewWillAppear:animated];
	
}



- (NSArray*) calendarMonthView:(TKCalendarMonthView*)monthView marksFromDate:(NSDate*)startDate toDate:(NSDate*)lastDate{
	
	[self generateDataForStartDate:startDate endDate:lastDate];
	return dataArray;
	
}
- (void) calendarMonthView:(TKCalendarMonthView*)monthView didSelectDate:(NSDate*)d{
	selectedDate = [[BIUtility dateStringForDate:d] retain];
	//selectedDate = [monthView dateSelected];
	[self.tableView reloadData];
}
- (void) calendarMonthView:(TKCalendarMonthView*)mv monthDidChange:(NSDate*)d{
	[super calendarMonthView:mv monthDidChange:d];
	[self.tableView reloadData];
	NSLog(@"Month Did Change: %@ %@",d,[monthView dateSelected]);
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
	
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	NSDate * sel =[BIUtility dateFromString:selectedDate];
	NSDate * today = [BIUtility dateFromString:[BIUtility todayDateString]];
	if([today compare:sel]==NSOrderedDescending || [today compare:sel]==NSOrderedSame) {
		return 4;
	} else {
		return 1;
	}

}
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	
	UITableViewCell *cell;
	
	NSDate * sel =[BIUtility dateFromString:selectedDate];
	NSDate * today = [BIUtility dateFromString:[BIUtility todayDateString]];
	NSLog(@"compare: %d", [today compare:sel]);
	if([today compare:sel]==NSOrderedDescending || [today compare:sel]==NSOrderedSame) {
		NSArray * histList = [[BIUtility historyEditListForDate:selectedDate] retain];
		
		History * h = [histList objectAtIndex:(indexPath.row)];
		
	
		
		[tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%d",  h.histID]];
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
											 reuseIdentifier:[NSString stringWithFormat:@"%d",  h.histID]] autorelease];
		if (h.detail != nil && h.detail.length > 0) {
			[cell.detailTextLabel setText:h.detail];
			[cell.detailTextLabel setFont:[UIFont fontWithName:@"Helvetica" size:13]];
			cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
			cell.detailTextLabel.numberOfLines = 0;
			cell.detailTextLabel.backgroundColor = [UIColor clearColor];
		}
		cell.imageView.image = [UIImage imageNamed:h.type];
		[cell.textLabel setText:h.title];
		cell.accessoryType = UITableViewCellAccessoryNone;
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
		[histList release];
	
	} else {
		if (indexPath.row == 0) {
		[tableView dequeueReusableCellWithIdentifier:@"HistMeasureCell"];
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
										   reuseIdentifier:@"HistMeasureCell"] autorelease];
		[cell.textLabel setText:@"Cannot Record In The Future"];
		cell.accessoryType = UITableViewCellAccessoryNone;
		}
	}

	
    return cell;
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSInteger h;
	NSDate * sel =[BIUtility dateFromString:selectedDate];

	NSDate * today = [BIUtility dateFromString:[BIUtility todayDateString]];
	if([today compare:sel]==NSOrderedDescending || [today compare:sel]==NSOrderedSame) {
		NSArray * histList = [[BIUtility historyEditListForDate:selectedDate] retain];
		NSLog(@"row: %d", indexPath.row);
		History * hist = [histList objectAtIndex:(indexPath.row)];
		
		
		NSString *cellText = hist.detail;
		UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:15];
		CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
		CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
		h =  labelSize.height + 30;
		if (h<25) h=50;
		[histList release];
	} else {
		h=30;
	}
	
		
	return h;
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	//NSUInteger row = [indexPath row];
	NSDate * sel =[BIUtility dateFromString:selectedDate];
	
	NSDate * today = [BIUtility dateFromString:[BIUtility todayDateString]];
	if([today compare:sel]==NSOrderedDescending || [today compare:sel]==NSOrderedSame) {

	if (indexPath.row == 0) {
		TextViewController *textViewController = [[TextViewController alloc] 
												  initWithNibName:@"TextViewController" 
												  bundle:nil];
		
		textViewController.delegate = self;
		textViewController.viewTitle = [NSString stringWithFormat:@"%@ Note", selectedDate];
		textViewController.initialText = [BIUtility dailyNoteForDate:selectedDate];
		[self presentModalViewController:textViewController animated:YES];
		
		[textViewController release];
		
	}
	if (indexPath.row == 1) {
		NutritionComponentViewController *nVC = [[NutritionComponentViewController alloc]
										 initWithNibName:@"NutritionComponentViewController"
										 bundle:nil];
										
		nVC.editMode = YES;
		nVC.passedDate = selectedDate;
		//[self presentModalViewController:nVC animated:YES];
		nVC.hidesBottomBarWhenPushed = YES;
		Bring_ItAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
		[delegate.historyNavController pushViewController:nVC animated:YES];
		
			
		[nVC release];
			
		}
	if (indexPath.row == 2) {
		WorkoutViewController *wVC = [[WorkoutViewController alloc]
											initWithNibName:@"WorkoutView"
											bundle:nil];
			
		wVC.editMode = YES;
		wVC.passedDate = selectedDate;
		//[self presentModalViewController:wVC animated:YES];
		wVC.hidesBottomBarWhenPushed = YES;
		Bring_ItAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
		[delegate.historyNavController pushViewController:wVC animated:YES];
		[wVC release];
		
	}
	if (indexPath.row == 3) {
		MeasureViewController *mVC = [[MeasureViewController alloc]
										  initWithNibName:@"MeasureView"
										  bundle:nil];
			
		mVC.editMode = YES;
		mVC.passedDate = selectedDate;
			
		[self presentModalViewController:mVC animated:YES];
		[mVC release];
			
	}	
	}



}
- (void)dealloc {
	//[selectedDate release];
	[super dealloc];
}

- (void)handleTextViewChange:(NSString *)passedText {
	
	[BIUtility addDailyNote:passedText forDate:selectedDate];
	[self.tableView reloadData];	
	[self dismissModalViewControllerAnimated:YES];
	
}

@end