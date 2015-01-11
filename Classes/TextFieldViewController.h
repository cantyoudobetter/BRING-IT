//
//  TextFieldViewController.h
//  Bring It
//
//  Created by Michael Bordelon on 5/11/10.
//  Copyright 2010 Bordelon iPhone. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TextFieldDelegate <NSObject>
- (void)handleTextFieldChange:(NSString *)text;
@end

@interface TextFieldViewController : UIViewController 

{
	id <TextFieldDelegate> delegate;
	IBOutlet UITextField *textField;
	IBOutlet UILabel *navTitle;
	NSString *viewTitle;
	NSString * initialText;
	
}

@property (nonatomic, assign) id <TextFieldDelegate> delegate;
@property (nonatomic, retain) NSString * viewTitle;
@property (nonatomic, retain) NSString * initialText;

-(IBAction)cancelPressed:(id)sender;
-(IBAction)savePressed:(id)sender;
-(IBAction)textFieldDoneEditing:(id)sender;
@end
