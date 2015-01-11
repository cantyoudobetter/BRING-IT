//
//  Bring_ItAppDelegate.m
//  Bring It
//
//  Created by Michael Bordelon on 4/17/10.
//  Copyright Bordelon iPhone 2010. All rights reserved.
//

#import "Bring_ItAppDelegate.h"
#import "BIUtility.h"


@implementation Bring_ItAppDelegate

@synthesize window;
@synthesize rootController;
@synthesize workoutNavController, setupNavController, historyNavController, nutritionNavController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    

    // Override point for customization after application launch
    [window addSubview:rootController.view];
	[window makeKeyAndVisible];
	
	
	//COPY THE DEFAULT DB TO THE APPLICATION DOCUMENT DIR IF IT DOES NOT EXIST
	[BIUtility copyDatabaseIfNeeded];
	

	rootController.moreNavigationController.navigationBar.hidden = YES;
	


}


- (void)dealloc {
	[rootController release];
    [window release];
    [super dealloc];
}



 
@end
