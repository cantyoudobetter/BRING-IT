//
//  DemoCalendarMonth.h
//  TapkuLibraryDemo
//
//  Created by Devin Ross on 10/31/09.
//  Copyright 2009 Devin Ross. All rights reserved.
//

#import <TapkuLibrary/TapkuLibrary.h>
#import <UIKit/UIKit.h>
#import "BIUtility.h"
#import "History.h"
#import "TextViewController.h"
#import "NutritionViewController.h"
#import "WorkoutViewController.h"
#import "MeasureViewController.h"


@interface HistoryCalendarEditController : TKCalendarMonthTableViewController <TextDelegate> {
	NSMutableArray *dataArray;
	NSMutableDictionary *dataDictionary;
	NSString * selectedDate;

	
}
@property (nonatomic, retain) NSString * selectedDate;

@end
