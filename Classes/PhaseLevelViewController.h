//
//  PhaseLevelViewController.h
//  bring-it
//
//  Created by Michael Bordelon on 8/29/10.
//  Copyright 2010 bordeloniphone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BIUtility.h"
@protocol PhasePickerDelegate <NSObject>
- (void)handlePickerChangeForPhase:(NSInteger)phase andLevel:(NSInteger)level;
@end



@interface PhaseLevelViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {
	id <PhasePickerDelegate> delegate;

	IBOutlet UIPickerView * picker;
	IBOutlet UILabel * reccomendLevel;
	IBOutlet UILabel * reccomendPhase;
	IBOutlet UILabel * day;
	IBOutlet UILabel * caloricNeeds;
	
	
	NSArray * levelData;
	NSArray * phaseData;
}

@property (nonatomic, retain) UIPickerView * picker;
@property (nonatomic, retain) NSArray * levelData;
@property (nonatomic, retain) NSArray * phaseData;
@property (nonatomic, assign) id <PhasePickerDelegate> delegate;

-(IBAction)cancelPressed:(id)sender;
-(IBAction)savePressed:(id)sender;

@end
