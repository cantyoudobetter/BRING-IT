//
//  GraphPoint.h
//  bring-it
//
//  Created by Michael Bordelon on 9/1/10.
//  Copyright 2010 bordeloniphone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TapkuLibrary/TapkuLibrary.h>

@interface GraphPoint : NSObject <TKGraphViewPoint> {
	int pk;
	NSNumber *value;
	NSString *label;
}
@property (nonatomic, retain) NSString * label;
- (id) initWithID:(int)pk value:(NSNumber*)number label:(NSString*)passedLabel;

@end

