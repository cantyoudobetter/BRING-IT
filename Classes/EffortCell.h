//
//  EffortCell.h
//  Bring It
//
//  Created by Michael Bordelon on 5/4/10.
//  Copyright 2010 Bordelon iPhone. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EffortCell : UITableViewCell {
	IBOutlet UISegmentedControl *effortButton;
}

@property (nonatomic, retain) IBOutlet UISegmentedControl *effortButton;

@end
