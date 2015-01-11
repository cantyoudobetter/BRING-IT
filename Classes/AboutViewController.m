//
//  AboutViewController.m
//  Bring It
//
//  Created by Michael Bordelon on 6/7/10.
//  Copyright 2010 Bordelon iPhone. All rights reserved.
//

#import "AboutViewController.h"


@implementation AboutViewController
@synthesize verLabel;

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
- (void)viewDidLoad {
	verLabel.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
	
}
-(IBAction)backPressed:(id)sender
{
	[self dismissModalViewControllerAnimated:YES];
}
-(IBAction)resetPressed:(id)sender
{

	UIActionSheet *actionSheet = [[UIActionSheet alloc]
								  initWithTitle:@"Are You Sure?" 
								  delegate:self
								  cancelButtonTitle:@"NO" 
								  destructiveButtonTitle:@"YES" 
								  otherButtonTitles:nil];
	[actionSheet showInView:self.view];
	[actionSheet release];
	
}

-(IBAction)updatePressed:(id)sender 
{
	HUD = [[MBProgressHUD alloc] initWithView:self.view];
	
	// Add HUD to screen
	[self.view addSubview:HUD];
	
	// Regisete for HUD callbacks so we can remove it from the window at the right time
	HUD.delegate = self;
	
	HUD.labelText = @"Please Wait";
	HUD.detailsLabelText = @"updating data";
	
	// Show the HUD while the provided method executes in a new thread
	[HUD showWhileExecuting:@selector(update) onTarget:self withObject:nil animated:YES];
	
	
	
	
}
-(void)update {
	
	if ([BIUtility connectedToInternet]) {
		[BIUtility updateDataFromWeb];
	} else {
		[self internetAlert];
	}
}

-(void) internetAlert {
	UIAlertView * alert = [[UIAlertView alloc]
						   initWithTitle:@"No Internet"
						   message:@"Check Your Connection" 
						   delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
	[alert show];
	[alert release];
	
}


-(IBAction)backupPressed:(id)sender 
{
	if ([BIUtility connectedToInternet]) {
		
	
	HUD = [[MBProgressHUD alloc] initWithView:self.view];
	
	// Add HUD to screen
	[self.view addSubview:HUD];
	
	// Regisete for HUD callbacks so we can remove it from the window at the right time
	HUD.delegate = self;
	
	HUD.labelText = @"Please Wait";
	HUD.detailsLabelText = @"sending database";
	
	// Show the HUD while the provided method executes in a new thread
	[HUD showWhileExecuting:@selector(backup) onTarget:self withObject:nil animated:YES];
	
	} else {
		[self internetAlert];
	}

	
	
	
}
-(void)backup {
	
	int r = arc4random() % 100000;
	//Profile * p = [[Profile alloc] init];
	
	NSString * fileName = [NSString stringWithFormat:@"%d",r ];
	
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	// the path to write file
	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"BRINGIT.sqlite"];
	
	
	NSData *fileData = [NSData dataWithContentsOfFile:filePath]; 
	NSString * alertTitle;
	NSString * alertMessage;
	if ([self uploadFile:fileData filename:fileName]) {
		alertTitle = @"Backup Successful";
		alertMessage = [NSString stringWithFormat:@"Jot Down Restore Code: %@",fileName];
	} else {
		alertTitle = @"Backup Failed";
		alertMessage = [NSString stringWithFormat:@"Try Again."];
		
	}
	UIAlertView * alert = [[UIAlertView alloc]
						   initWithTitle:alertTitle
						   message:alertMessage 
						   delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
	[alert show];
	[alert release];
}


-(IBAction)restorePressed:(id)sender 
{
	if ([BIUtility connectedToInternet]) {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enter Resore Code" message:@" "
						  
												   delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Restore", nil];
	
	
	
	CGRect frame = CGRectMake(14, 45, 255, 23);
	
	if(!codeField) {
		
		codeField = [[UITextField alloc] initWithFrame:frame];
		codeField.borderStyle = UITextBorderStyleBezel;
		codeField.textColor = [UIColor blackColor];
		codeField.textAlignment = UITextAlignmentCenter;
		codeField.font = [UIFont systemFontOfSize:14.0];
		codeField.placeholder = @"<enter code>";
		codeField.backgroundColor = [UIColor whiteColor];
		codeField.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
		codeField.keyboardType = UIKeyboardTypeNumberPad; 
		codeField.returnKeyType = UIReturnKeyDone;
		//codeField.delegate = self;
		codeField.clearButtonMode = UITextFieldViewModeWhileEditing; // has a clear 'x' button to the right
		
	}
	[alert addSubview:codeField];
	[alert show];
	[alert release];
	
	
	} else {
		[self internetAlert];
	}
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	// the user clicked one of the OK/Cancel buttons
	if ([[actionSheet title] isEqualToString:@"Enter Resore Code"] && buttonIndex == 1)
	{
	HUD = [[MBProgressHUD alloc] initWithView:self.view];
	
	// Add HUD to screen
	[self.view addSubview:HUD];
	
	// Regisete for HUD callbacks so we can remove it from the window at the right time
	HUD.delegate = self;
	
	HUD.labelText = @"Please Wait";
	HUD.detailsLabelText = @"restoring database";
	
	// Show the HUD while the provided method executes in a new thread
	[HUD showWhileExecuting:@selector(restore) onTarget:self withObject:nil animated:YES];
	}
	
	
	
}
-(void)restore {
	NSString * code = codeField.text;
	NSString* updateURL = [NSString stringWithFormat:@"http://www.bordeloniphone.com/biuserbackup/%@", code];
	NSLog(@"Checking backup at : %@", updateURL);
	NSData* updateData = [NSData dataWithContentsOfURL: [NSURL URLWithString: updateURL] ];
	
	NSFileManager *filemgr = [NSFileManager defaultManager];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths objectAtIndex:0];
	NSString *documentPath = [documentsDir stringByAppendingPathComponent:@"tempdb"];
	
	if([filemgr fileExistsAtPath:documentPath]) {
		[filemgr removeItemAtPath:documentPath error:NULL];
	}
	
	BOOL success = NO;
	BOOL badFile = NO;
	if ([filemgr createFileAtPath: documentPath contents: updateData attributes: nil]) {
		NSDictionary * attributes = [filemgr attributesOfItemAtPath:documentPath error:nil];
		NSNumber *theFileSize = [attributes objectForKey:NSFileSize];
		if ([theFileSize intValue] == 0) {
			badFile = YES;
		}
	}
		
	if (!badFile) {
		

		if  ([filemgr removeItemAtPath:[BIUtility getDBPath] error:NULL]) {
			if ([filemgr moveItemAtPath:documentPath toPath:[BIUtility getDBPath] error:NULL]) {
				success = YES;
			} else {
				success = NO;
			}
		} else {
			success = NO;
		}
	}
	[filemgr removeItemAtPath:documentPath error:NULL];
	[BIUtility updateDataFromWeb];

	
	NSString * alertTitle;
	NSString * alertMessage;
	if (success) {
		alertTitle = @"Restore Successful";
		alertMessage = [NSString stringWithFormat:@"Restart The App"];
	} 
	if (!success) {
		alertTitle = @"Restore Failed";
		alertMessage = [NSString stringWithFormat:@"Check Net Connection & Code"];
		
	}
	if (badFile) {
		alertTitle = @"Invalid Code";
		alertMessage = [NSString stringWithFormat:@"Try Again"];
	}
	UIAlertView * alert = [[UIAlertView alloc]
						   initWithTitle:alertTitle
						   message:alertMessage 
						   delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
	[alert show];
	[alert release];
}




- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger) buttonIndex {

	if (!(buttonIndex == [actionSheet cancelButtonIndex])) {

		HUD = [[MBProgressHUD alloc] initWithView:self.view];
		
		// Add HUD to screen
		[self.view addSubview:HUD];
		
		// Regisete for HUD callbacks so we can remove it from the window at the right time
		HUD.delegate = self;
		
		HUD.labelText = @"Please Wait";
		HUD.detailsLabelText = @"resetting database";
		
		// Show the HUD while the provided method executes in a new thread
		[HUD showWhileExecuting:@selector(reset) onTarget:self withObject:nil animated:YES];
		
		
		
		
	}
	
}


- (BOOL)uploadFile:(NSData *)fileData filename:(NSString *)filename{
	
	
    NSString *urlString = @"http://bordeloniphone.com/upload.php";
	
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
	
    NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
	
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@\"\r\n",filename]] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:fileData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
	
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnString = [[[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding] autorelease];
	//NSLog("RETURN:%@",returnString);
    return ([returnString isEqualToString:@"OK"]);
}


-(void)reset {
	
	[BIUtility copyDatabaseForced];
	
	//[self dismissModalViewControllerAnimated:YES];
	
}

- (void)dealloc {
    [super dealloc];
}
- (void)hudWasHidden {}

@end
