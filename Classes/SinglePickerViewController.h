//
//  SinglePickerViewController.h
//  Bring It
//
//  Created by Michael Bordelon on 5/11/10.
//  Copyright 2010 Bordelon iPhone. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PickerDelegate <NSObject>
- (void)handlePickerChange:(NSInteger)index;
@end

@interface SinglePickerViewController : UIViewController 
<UIPickerViewDelegate, UIPickerViewDataSource>
{
	id <PickerDelegate> delegate;
	IBOutlet UIPickerView *singlePicker;
	NSArray *pickerData;
	IBOutlet UILabel *navTitle;
	IBOutlet UITextView *helpText;
	NSString * help;
	NSString *viewTitle;
	NSInteger initialRow;
	
}

@property (nonatomic, retain) UIPickerView *singlePicker;
@property (nonatomic, retain) NSArray *pickerData;
@property (nonatomic, assign) id <PickerDelegate> delegate;
@property (nonatomic, retain) NSString * viewTitle;
@property (nonatomic, readwrite) NSInteger initialRow;
@property (nonatomic, retain) NSString * help;

-(IBAction)cancelPressed:(id)sender;
-(IBAction)savePressed:(id)sender;


@end
