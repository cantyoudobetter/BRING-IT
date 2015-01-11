//
//  Food.h
//  bring-it
//
//  Created by Michael Bordelon on 8/27/10.
//  Copyright 2010 bordeloniphone. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Food : NSObject {

	NSInteger foodID;
	NSInteger typeID;
	NSString * foodType;
	NSString * description;
	NSInteger calories;
	
}
@property (nonatomic, readwrite) NSInteger foodID;
@property (nonatomic, readwrite) NSInteger typeID;
@property (nonatomic, readwrite) NSInteger calories;
@property (nonatomic, retain) NSString * foodType;
@property (nonatomic, retain) NSString * description;



@end
