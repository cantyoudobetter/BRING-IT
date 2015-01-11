//
//  AboutViewController.h
//  Bring It
//
//  Created by Michael Bordelon on 6/7/10.
//  Copyright 2010 Bordelon iPhone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BIUtility.h"
#import "DBResetViewController.h"
#import "MBProgressHUD.h"


@interface AboutViewController : UIViewController <UIActionSheetDelegate, MBProgressHUDDelegate> {
	IBOutlet UILabel *verLabel;
	IBOutlet UIButton *backButton;
	IBOutlet UIButton *resetData;
	IBOutlet UIButton *backupData;
	MBProgressHUD *HUD;
	UITextField * codeField;
}
@property (retain, nonatomic) UILabel *verLabel;
-(IBAction)backPressed:(id)sender;
-(IBAction)resetPressed:(id)sender;
-(IBAction)updatePressed:(id)sender;
-(IBAction)backupPressed:(id)sender;
-(IBAction)restorePressed:(id)sender;
-(void) internetAlert;
- (BOOL)uploadFile:(NSData *)fileData filename:(NSString *)filename;

@end
