//
//  History.h
//  Bring It
//
//  Created by Michael Bordelon on 5/31/10.
//  Copyright 2010 Bordelon iPhone. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface History : NSObject {
	NSString * title;
	NSString * type;
	NSString * detail;
	NSInteger histID;
	
}


@property (nonatomic, assign) NSString *title;
@property (nonatomic, assign) NSString *type;
@property (nonatomic, assign) NSString *detail;
@property (nonatomic, readwrite) NSInteger histID;

@end
