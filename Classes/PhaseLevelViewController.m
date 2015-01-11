//
//  PhaseLevelViewController.m
//  bring-it
//
//  Created by Michael Bordelon on 8/29/10.
//  Copyright 2010 bordeloniphone. All rights reserved.
//

#import "PhaseLevelViewController.h"


@implementation PhaseLevelViewController
@synthesize picker, levelData, phaseData, delegate;
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


- (void)viewDidLoad {
    [super viewDidLoad];

	levelData = [[NSArray alloc] initWithObjects:@"Level 1", @"Level 2", @"Level 3", nil];
	
	phaseData = [[NSArray alloc] initWithObjects:@"Phase 1", @"Phase 2", @"Phase 3", nil];
	NSInteger d = [BIUtility scheduleDay];
	NSInteger c = [BIUtility caloricTarget];
	day.text = [NSString stringWithFormat:@"%d", d];
	caloricNeeds.text = [NSString stringWithFormat:@"%d cals/day", c];
	if (d < 29) {
		reccomendPhase.text = @"Reccomend Phase 1";
	} else if (d > 28 && d < 57) {
		reccomendPhase.text = @"Reccomend Phase 2";
	} else {
		reccomendPhase.text = @"Reccomend Phase 3";
	}

	if (c < 2400) {
		reccomendLevel.text = @"Reccomend Level 1";
	} else if (c >= 2400  && c < 3000) {
		reccomendLevel.text = @"Reccomend Level 2";
	} else {
		reccomendLevel.text = @"Reccomend Level 3";
	}
	
	NSInteger level =  [[BIUtility currentLevel] integerValue];
	NSInteger phase =  [[BIUtility currentPhase] integerValue];

	
	[picker selectRow:(phase-1) inComponent:0 animated:YES];
	[picker selectRow:(level-1) inComponent:1 animated:YES];

	
	
}


-(IBAction)cancelPressed:(id)sender {
		[self dismissModalViewControllerAnimated:YES];
}
-(IBAction)savePressed:(id)sender {
		
	[BIUtility savePhase:[NSString stringWithFormat:@"%d", ([picker selectedRowInComponent:0]+1)] 
				andLevel:[NSString stringWithFormat:@"%d", ([picker selectedRowInComponent:1]+1)]];
	[self dismissModalViewControllerAnimated:YES];
}
#pragma mark Picker Data Source
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	
	return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {

	if (component == 0) {
		return [phaseData count];
	} else {
		return [levelData count];
	}
	
}

#pragma mark Picker Data Source
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	
	if (component == 0) {
		return [phaseData objectAtIndex:row];
	} else {
		return [levelData objectAtIndex:row];
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
    [super dealloc];
}






@end
