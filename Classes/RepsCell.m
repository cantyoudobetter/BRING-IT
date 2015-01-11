//
//  RepsCell.m
//  Bring It
//
//  Created by Michael Bordelon on 4/24/10.
//  Copyright 2010 Bordelon iPhone. All rights reserved.
//

#import "RepsCell.h"


@implementation RepsCell

@synthesize repsLabel, upButton, downButton, upButton10, downButton10;


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
	[repsLabel release];
    [super dealloc];
}


@end
