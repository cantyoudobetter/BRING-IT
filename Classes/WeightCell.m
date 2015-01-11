//
//  WeightCell.m
//  Bring It
//
//  Created by Michael Bordelon on 5/4/10.
//  Copyright 2010 Bordelon iPhone. All rights reserved.
//

#import "WeightCell.h"


@implementation WeightCell
@synthesize weightLabel, upButton, downButton, upButton5, downButton5;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
	[weightLabel release];
	[super dealloc];
}


@end
