//
//  GradientButton.h
//  bring-it
//
//  Created by Michael Bordelon on 8/16/10.
//  Copyright 2010 bordeloniphone. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface GradientButton : UIButton {
    CAGradientLayer *shineLayer;
    CALayer         *highlightLayer;
}

@end