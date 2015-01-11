//
//  TextFieldViewController.m
//  Bring It
//
//  Created by Michael Bordelon on 5/11/10.
//  Copyright 2010 Bordelon iPhone. All rights reserved.
//

#import "TextViewController.h"


@implementation TextViewController
@synthesize  delegate, viewTitle, initialText;


- (void)viewDidLoad {
    [super viewDidLoad];
	//self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Background.png"]];	
	UIColor * bg = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Background.png"]];
	self.view.backgroundColor = bg;
	[bg release];
	navTitle.text = viewTitle;
	
	textField.layer.cornerRadius = 5;
	textField.clipsToBounds = YES;
	
	textField.text = initialText;
	
	[textField becomeFirstResponder];
	
}


-(IBAction)cancelPressed:(id)sender {
	
	[self dismissModalViewControllerAnimated:YES];
	
	
}

-(IBAction)savePressed:(id)sender {
	
	[self.delegate handleTextViewChange:textField.text];
	
	
}

-(IBAction)textFieldDoneEditing:(id)sender {
	[self savePressed:(id)sender];
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
