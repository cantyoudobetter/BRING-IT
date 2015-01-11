//
//  HistoryViewController.m
//  Bring It
//
//  Created by Michael Bordelon on 4/17/10.
//  Copyright 2010 Bordelon iPhone. All rights reserved.
//

#import "HistoryMenuController.h"


@implementation HistoryMenuController
//@synthesize dateList, historyList, tableIndex;

-(IBAction)historyListPressed:(id)sender {
	
	
	
	HistoryViewController *historyViewController = [[HistoryViewController alloc] 
																		initWithNibName:@"HistoryView" 
																		bundle:nil];
	historyViewController.hidesBottomBarWhenPushed = YES;
	Bring_ItAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	[delegate.historyNavController pushViewController:historyViewController animated:YES];
	[historyViewController release];
	
	
}

-(IBAction)historyEditPressed:(id)sender {
	
	
	
	HistoryCalendarEditController *historyCalendarEditController = [[HistoryCalendarEditController alloc] init];
	historyCalendarEditController.hidesBottomBarWhenPushed = YES;
	Bring_ItAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	[delegate.historyNavController pushViewController:historyCalendarEditController animated:YES];
	[historyCalendarEditController release];
	
}

-(IBAction)historyWeightChartPressed:(id)sender {
	
	UIViewController *vc = [[WeightGraphController alloc] init];
		
	[vc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
	[self presentModalViewController:vc animated:YES];
	[vc release];
	return;
	
}
-(IBAction)historyBFChartPressed:(id)sender {
	
	UIViewController *vc = [[BFGraphController alloc] init];
	
	[vc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
	[self presentModalViewController:vc animated:YES];
	[vc release];
	return;
	
}
-(IBAction)moveChartPressed:(id)sender {
	RecordedMovesListViewController *rmlvc = [[RecordedMovesListViewController alloc] init];
	rmlvc.hidesBottomBarWhenPushed = YES;
	Bring_ItAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	[delegate.historyNavController pushViewController:rmlvc animated:YES];
	[rmlvc release];

	
}
- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"History";
	UINavigationBar *bar = [self.navigationController navigationBar];
	bar.barStyle = UIBarStyleBlack;
	
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)dealloc {
    [super dealloc];
}


@end
