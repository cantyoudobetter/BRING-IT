//
//  Workout.h
//  Bring It
//
//  Created by Michael Bordelon on 4/22/10.
//  Copyright 2010 Bordelon iPhone. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Workout : NSObject {
	
	NSInteger woInstanceID;
	NSInteger workoutID;
	NSString *workoutName;
	NSString *woNote;
	NSDate	 *woDate;
	NSInteger woComplete;
}

@property (nonatomic, readwrite) NSInteger woInstanceID;
@property (nonatomic, readwrite) NSInteger workoutID;
@property (nonatomic, retain) NSString *workoutName;
@property (nonatomic, retain) NSString *woNote;
@property (nonatomic, readwrite) NSInteger woComplete;
@property (nonatomic, retain) NSDate *woDate;




@end
