//
//  BIUtility.h
//  Bring It
//
//  Created by Michael Bordelon on 4/18/10.
//  Copyright 2010 Bordelon iPhone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "Workout.h"
#import "Move.h"
#import "MoveDetail.h"
#import "Profile.h"
#import "Workout.h"
#import "Nutrition.h"
#import "History.h"
#import "Food.h"



@interface BIUtility : NSObject {

}
+ (BOOL) connectedToInternet;
+ (void) copyDatabaseForced;
+ (void) copyDatabaseIfNeeded ;
+ (void) updateDataIfNeeded;
+ (void) updateDataFromWeb;
+ (BOOL) updateNeeded;
+ (void) setInitialData;
+ (NSString *) getDBPath;
+ (NSInteger)scheduleDay;
+ (NSString *)todayDateString;
+ (NSDate *)dateFromString:(NSString *)date;
+ (NSString *)formattedDateFromString:(NSString *)date;
+ (NSString *)dateStringForDate:(NSDate *)date;
+ (void)deleteWorkoutInstance:(NSInteger)woInstanceID;
+ (void)flushTodaysWorkouts;
+ (NSString *)addToStart:(NSInteger)days startDate:(NSDate *)start;
+ (NSDate *)addToDate:(NSInteger)days date:(NSDate *)start;
+ (NSArray *)movesForWorkout:(NSInteger)woID;
+ (NSArray *)detailsForMove:(NSInteger)moveID;
+ (void)addInitialWorkout:(Workout *)wo;
+ (void)addInitialWorkout:(Workout *)wo forDate:(NSString *)date;
+ (NSInteger)workoutCountInProgram;
+ (NSArray *)workoutsConfiguredForToday;
+ (NSArray *) workoutForDate:(NSInteger)seqNumber Schedule:(NSInteger)sID;

+ (NSMutableArray *)todaysScheduledWorkouts;
+ (NSArray *)scheduledWorkoutsForDate:(NSString *)date;
+ (NSInteger)numberOfScheduledWorkouts;
+ (NSInteger)numberOfScheduledWorkoutsForDate:(NSString *)date;
+ (NSInteger)moveDetailIDForMove:(NSInteger)moveID Type:(NSString *)moveTypeCode;
+ (NSInteger)saveMoveDetailRecord:(MoveDetail *)md;
+ (void)saveBloggerConfig:(NSString *)username withPassword:(NSString *)password;
+ (NSArray *)recordedMoves;
+ (NSInteger)moveIDForMoveName:(NSString *)moveName;
+ (NSString *)lastRecordForMoveDetail:(NSInteger)moveDetailID;
+ (BOOL)detailsRecordedForMove:(NSInteger)moveID forDate:(NSString *)woDate;
+ (NSArray *)configuredPrograms;
+ (NSArray *)MeasureDateList;
+ (NSArray *)MeasureDateListForType:(NSString *)type;
+ (NSArray *)MoveDateListForMoveID:(NSString *)moveName andMoveType:(NSString *)moveType;
+ (NSArray *)moveDetailValueForMoveID:(NSString *)moveName Type:(NSString *)moveTypeCode Date:(NSString *)date;
+ (NSString *)latestMeasurement:(NSString *)measureType;
+ (NSString *)latestMeasurement:(NSString *)measureType forDate:(NSString *)date latest:(BOOL)latest;
+ (void)saveMeasurement:(NSString *)measureType withValue:(NSString *)measureValue forDate:(NSString *)date;
+ (NSInteger)age;
+ (float)caloricFactor;
+ (void)savePhase:(NSString *)phase andLevel:(NSString *)level;
+ (NSString *)currentPhase;
+ (NSString *)currentLevel;
+ (NSString *)phaseForDate:(NSString *)date;
+ (NSString *)levelForDate:(NSString *)date;
+ (NSArray *)allWorkouts;
//+ (void)addWorkoutForToday:(NSInteger)woID workoutName:(NSString *)woName;
+ (NSInteger)caloricTarget;
+ (Nutrition *)nutritionForDate:(NSDate *)nDate;
+ (void)saveNutrition:(Nutrition *)nutrition;
+ (void)saveNutrition:(Nutrition *)nutrition forDate:(NSString *)date;
+ (void) updateWorkout:(Workout *)wo;
+ (void) addDailyNote:(NSString *)note;
+ (void) addDailyNote:(NSString *)note forDate:(NSString *)date;
+ (NSString *) dailyNoteForDate:(NSString *)date;
+ (NSString *) todaysDailyNote;
//+ (NSString *) todaysBlogEntry;
+ (NSString*)textToHtml:(NSString*)htmlString;
+ (NSArray *) historyDateList;
+ (NSString *)recordForMoveDetail:(NSInteger)moveDetailID date:(NSString *)d;
+ (NSArray *) historyForDate:(NSString *)date;
+ (NSArray *) historyEditListForDate:(NSString *)date;
+ (NSArray *) moveHistoryForWO:(NSInteger) woID;
+ (NSArray *) moveHistoryDetailForMove:(NSInteger) moveID andWorkout:(NSInteger)woID;
+ (NSInteger) moveHistoryDetailCountForWorkout:(NSInteger) woID;
+ (NSArray *) weightList;
//+ (NSString *) blogEntryForDate:(NSString *)date; 
+ (NSInteger) portionTypeCount:(NSInteger)type level:(NSString *)level phase:(NSString *)phase;
+ (NSArray *) portionList;
+ (NSInteger) portionIDForType:(NSString *)type;
+ (NSString *) todaysBlogEntry:(BOOL)omitMeasure;
+ (NSString *) blogEntryForDate:(NSString *)date OmitMeasures:(BOOL)omitMeasure;
+ (NSArray *) foodsForPortionType:(NSInteger)typeID;
+ (NSString *)moveDetailForCode:(NSString *)code;
+ (float)bodyFatForWeight:(float)WEIGHT height:(float)HEIGHT waist:(float)WAIST neck:(float)NECK hip:(float)HIP;
@end
