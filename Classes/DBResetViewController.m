//
//  BloggerUpdateViewController.m
//  Bring It
//
//  Created by Michael Bordelon on 5/24/10.
//  Copyright 2010 Bordelon iPhone. All rights reserved.
//

#import "DBResetViewController.h"


@implementation DBResetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[NSThread detachNewThreadSelector:@selector(reset) toTarget:self withObject:nil];
	
	
	}


-(void)reset {

	[BIUtility copyDatabaseForced];
	
	[self dismissModalViewControllerAnimated:YES];
	
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
