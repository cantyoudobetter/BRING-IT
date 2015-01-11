//
//  RepsCell.h
//  Bring It
//
//  Created by Michael Bordelon on 4/24/10.
//  Copyright 2010 Bordelon iPhone. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RepsCell : UITableViewCell {
	IBOutlet UILabel  *repsLabel;
	IBOutlet UIButton *upButton;
	IBOutlet UIButton *downButton;
	IBOutlet UIButton *upButton10;
	IBOutlet UIButton *downButton10;
	

}

@property (nonatomic, retain) IBOutlet UILabel *repsLabel;
@property (nonatomic, retain) IBOutlet UIButton *upButton;
@property (nonatomic, retain) IBOutlet UIButton *downButton;
@property (nonatomic, retain) IBOutlet UIButton *upButton10;
@property (nonatomic, retain) IBOutlet UIButton *downButton10;


//-(IBAction)upButtonPressed:(id)sender;
//-(IBAction)downButtonPressed:(id)sender;



@end
