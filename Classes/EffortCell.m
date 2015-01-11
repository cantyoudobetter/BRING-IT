//
//  EffortCell.m
//  Bring It
//
//  Created by Michael Bordelon on 5/4/10.
//  Copyright 2010 Bordelon iPhone. All rights reserved.
//

#import "EffortCell.h"


@implementation EffortCell
@synthesize effortButton;

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
    [super dealloc];
}


@end
