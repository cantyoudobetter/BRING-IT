//
//  TextFieldViewController.h
//  Bring It
//
//  Created by Michael Bordelon on 5/11/10.
//  Copyright 2010 Bordelon iPhone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>  
#import "SinglePickerViewController.h"

@protocol TextDelegate <NSObject>
- (void)handleTextViewChange:(NSString *)text;
@end

@interface TextViewController : UIViewController 

{
	id <TextDelegate> delegate;
	IBOutlet UITextView *textField;
	IBOutlet UILabel *navTitle;
	NSString *viewTitle;
	NSString * initialText;
	
}

@property (nonatomic, assign) id <TextDelegate> delegate;
@property (nonatomic, retain) NSString * viewTitle;
@property (nonatomic, retain) NSString * initialText;

-(IBAction)cancelPressed:(id)sender;
-(IBAction)savePressed:(id)sender;
-(IBAction)textFieldDoneEditing:(id)sender;
@end
