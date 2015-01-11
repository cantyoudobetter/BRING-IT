//
//  HomeViewController.m
//  Bring It
//
//  Created by Michael Bordelon on 4/17/10.
//  Copyright 2010 Bordelon iPhone. All rights reserved.
//

#import "HomeViewController.h"
#import "BIUtility.h"
#import "Profile.h"


@implementation HomeViewController
@synthesize dayLabel, bi;

- (void)applicationWillTerminate:(NSNotification *)notification {

	//sqlite3_close(database);
	
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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	bi = [[BIUtility alloc] init];

	self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Background.png"]];

	dayLabel.text = [NSString stringWithFormat:@"You Are On Day %d", [BIUtility scheduleDay]];
	

}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	//Profile *p = [[[Profile alloc] init] autorelease];
	NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormat setDateStyle:NSDateFormatterShortStyle];
	//NSString *sd = [dateFormat stringFromDate:p.startDate];
	dayLabel.text = [NSString stringWithFormat:@"You Are On Day %d", [BIUtility scheduleDay]];
	
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


- (void)dealloc {
	[bi release];
    [super dealloc];
}


@end
