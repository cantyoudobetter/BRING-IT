//
//  DatePickerViewController.h
//  Bring It
//
//  Created by Michael Bordelon on 5/9/10.
//  Copyright 2010 Bordelon iPhone. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "SetupViewController.h"

//@protocol DatePickerDelegate;

@protocol DatePickerDelegate <NSObject>
- (void)handleDateChange:(UIDatePicker *)updatedDatePicker;
@end

@interface DatePickerViewController : UIViewController {
	id <DatePickerDelegate> delegate;
	IBOutlet UIDatePicker *datePicker;
	IBOutlet UILabel *navTitle;
	NSString *viewTitle;
	NSDate *initialDate;
	NSDate *maxDate;
}

@property (retain, nonatomic) UIDatePicker *datePicker;
@property (nonatomic, assign) id <DatePickerDelegate> delegate;
@property (nonatomic, retain) NSString * viewTitle;
@property (nonatomic, retain) NSDate *initialDate;
@property (nonatomic, retain) NSDate *maxDate;

-(IBAction)cancelPressed:(id)sender;
-(IBAction)savePressed:(id)sender;
@end

