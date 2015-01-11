//
//  SinglePickerViewController.m
//  Bring It
//
//  Created by Michael Bordelon on 5/11/10.
//  Copyright 2010 Bordelon iPhone. All rights reserved.
//

#import "SinglePickerViewController.h"


@implementation SinglePickerViewController
@synthesize singlePicker, pickerData, delegate, viewTitle, initialRow, help;



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	//self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Background.png"]];	
	UIColor * bg = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Background.png"]];
	self.view.backgroundColor = bg;
	[bg release];
	navTitle.text = viewTitle;
	helpText.text = help;
	[singlePicker selectRow:initialRow inComponent:0 animated:YES];

}


-(IBAction)cancelPressed:(id)sender {
	
	[self dismissModalViewControllerAnimated:YES];
	
	
}

-(IBAction)savePressed:(id)sender {
	
	NSInteger row = [singlePicker selectedRowInComponent:0];
	[self.delegate handlePickerChange:row];
	
	
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
    [singlePicker release];
	[pickerData release];
	
	[super dealloc];
}

#pragma mark Picker Data Source Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return [pickerData count];
		
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	return [pickerData objectAtIndex:row];
}


@end
