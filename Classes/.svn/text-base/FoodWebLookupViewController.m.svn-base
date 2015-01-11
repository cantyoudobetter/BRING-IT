//
//  FoodWebLookupViewController.m
//  Bring It
//
//  Created by Michael Bordelon on 5/15/10.
//  Copyright 2010 Bordelon iPhone. All rights reserved.
//

#import "FoodWebLookupViewController.h"


@implementation FoodWebLookupViewController
@synthesize webView, searchValue;

- (void)viewDidLoad {
    [super viewDidLoad];
	NSString *urlAddress = [NSString stringWithFormat:@"http://ccm.about.com/main?search=%@",searchValue];
	
	//Create a URL object.
	NSURL *url = [NSURL URLWithString:urlAddress];
	
	//URL Requst Object
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	
	//Load the request in the UIWebView.
	[webView loadRequest:requestObj];
	
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
- (IBAction)doneButtonPressed:(id)sender {
		[self dismissModalViewControllerAnimated:YES];
}

@end
