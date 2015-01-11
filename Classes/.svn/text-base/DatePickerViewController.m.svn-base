//
//  DatePickerViewController.m
//  Bring It
//
//  Created by Michael Bordelon on 5/9/10.
//  Copyright 2010 Bordelon iPhone. All rights reserved.
//

#import "DatePickerViewController.h"


@implementation DatePickerViewController

@synthesize datePicker,delegate, viewTitle, initialDate, maxDate;
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

-(IBAction)cancelPressed:(id)sender {
	
	[self dismissModalViewControllerAnimated:YES];


}

-(IBAction)savePressed:(id)sender {
	
	
	[self.delegate handleDateChange:datePicker];
	
	
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	//self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Background.png"]];	
	UIColor * bg = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Background.png"]];
	self.view.backgroundColor = bg;
	[bg release];
	navTitle.text = viewTitle;
	[datePicker setDate:initialDate];
	[datePicker setMaximumDate:maxDate];
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
