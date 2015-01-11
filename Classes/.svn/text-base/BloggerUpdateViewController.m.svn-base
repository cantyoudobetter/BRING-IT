//
//  BloggerUpdateViewController.m
//  Bring It
//
//  Created by Michael Bordelon on 5/24/10.
//  Copyright 2010 Bordelon iPhone. All rights reserved.
//

#import "BloggerUpdateViewController.h"


@implementation BloggerUpdateViewController
@synthesize delegate, new, passedEntry;


- (void)viewDidLoad {
    [super viewDidLoad];
	//mBlogsProgressIndicator.hidesWhenStopped = YES;
	
	p = [[Profile alloc] init];
	//mUsernameField.text = p.bloggerUsername;
	//mPasswordField.text = p.bloggerPassword;
	
		[self fetchInitialBlogList];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)dealloc {
	[mBlogFeed release];
	[mBlogFeedTicket release];
	[mBlogFetchError release];
	
	[mPostFeed release];
	[mPostFeedTicket release];
	[mPostFetchError release];
	
	[mEditPostTicket release];
	[p release];
	[super dealloc];
}


- (void)postTodaysBlogEntry {
	GDataEntryBlogPost *newEntry = [GDataEntryBlogPost postEntry];
	
	
	Nutrition * n = [[BIUtility nutritionForDate:[NSDate dateWithTimeIntervalSinceNow:0]] retain];
	
	NSArray * woList = [[[NSArray alloc] initWithArray:[BIUtility todaysScheduledWorkouts]] retain];

	NSString *title;
	if (woList.count > 0) {
		title = [NSString stringWithFormat:@"Day: %d, Calories: %d, %@", [BIUtility scheduleDay], n.calories, [[woList objectAtIndex:0] workoutName]];
	}	else {
			title = [NSString stringWithFormat:@"Day: %d, Calories: %d", [BIUtility scheduleDay], n.calories];
		}
	[woList release];
	[n release];
	NSString *content = [BIUtility todaysBlogEntry:YES];
	
	if (content.length == 0 ) {
		content = @"No Content";
	}
	
	//NSString *content = [mPostEditField stringValue];
	BOOL isDraft = FALSE;
	
	[newEntry setTitleWithString:title];
	[newEntry setContentWithString:content];
	[newEntry addAuthor:[GDataPerson personWithName:p.userName
											  email:nil]];
	GDataAtomPubControl *atomPub;
	atomPub = [GDataAtomPubControl atomPubControlWithIsDraft:isDraft];
	[newEntry setAtomPubControl:atomPub];
	
	NSURL *postURL = [[[self selectedBlog] postLink] URL];
	if (postURL != nil) {
		GDataServiceGoogleBlogger *service = [self bloggerService];
		[service setServiceUserData:newEntry];
		
		GDataServiceTicket *ticket;
		ticket = [service fetchEntryByInsertingEntry:newEntry
										  forFeedURL:postURL
											delegate:self
								   didFinishSelector:@selector(addEntryTicket:finishedWithEntry:error:)];
		[self setEditPostTicket:ticket];
		//[self updateUI];
	}
	
	
	
}

// add entry callback
- (void)addEntryTicket:(GDataServiceTicket *)ticket
     finishedWithEntry:(GDataEntryBlogPost *)addedEntry
                 error:(NSError *)error {
	
	if (error == nil) {
		//NSLog(@"No Error");
		//NSBeginAlertSheet(@"Add", nil, nil, nil,
		//				  [self window], nil, nil,
		//				  nil, nil, @"Added entry: %@", [[addedEntry title] stringValue]);
		
		//NSMutableArray *entries = [NSMutableArray arrayWithArray:[mPostFeed entries]];
		//[entries insertObject:addedEntry atIndex:0];
		//[mPostFeed setEntries:entries];
		NSDate *today = [NSDate dateWithTimeIntervalSinceNow:0];
		NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
		[dateFormat setTimeStyle:NSDateFormatterLongStyle];
		[dateFormat setDateStyle:NSDateFormatterLongStyle];
		NSString *dateString = [dateFormat stringFromDate:today];
		p.bloggerLastUpdate = [NSString stringWithFormat:@"Last Update: %@", dateString];
		[p updateProfile];
		
	} else {
		//NSLog(@"Error");
		// failed to add entry
		//GDataEntryBlogPost *addedEntry = [ticket postedObject];
		//NSBeginAlertSheet(@"Add", nil, nil, nil,
		//				  [self window], nil, nil,
		//				  nil, nil, @"Failed to add entry: %@\nError: %@",
		//				  [[addedEntry title] stringValue], error);
		p.bloggerLastUpdate = [NSString stringWithFormat:@"Update Error: %@", error];
							   [p updateProfile];

	}
	

	
	[self setEditPostTicket:nil];
	
	//[self dismissModalViewControllerAnimated:YES];
	[self.delegate postComplete];
	//[self dealloc];
	//[self updateUI];
}


#pragma mark Update an entry


- (void)updateSelectedPost {
	GDataEntryBlogPost *editedEntry = [[passedEntry copy] autorelease];
	if (editedEntry) {
		BOOL isDraft = FALSE;
		// save the edited text into the entry
		//NSString *newContent = [BIUtility BlogEntryForDate:[[editedEntry publishedDate] date]];
		NSString *newContent = [BIUtility todaysBlogEntry:YES];
		Nutrition * n = [[BIUtility nutritionForDate:[NSDate dateWithTimeIntervalSinceNow:0]] retain];

		NSArray * woList = [[[NSArray alloc] initWithArray:[BIUtility todaysScheduledWorkouts]] retain];
		
		NSString *title;
		if (woList.count > 0) {
			title = [NSString stringWithFormat:@"Day: %d, Calories: %d, %@", [BIUtility scheduleDay], n.calories, [[woList objectAtIndex:0] workoutName]];
		} else {
			title = [NSString stringWithFormat:@"Day: %d, Calories: %d", [BIUtility scheduleDay], n.calories];
		}
		[woList release];
		[n release];
		[[editedEntry content] setStringValue:newContent];
	    [[editedEntry title] setStringValue:title];
		
		GDataAtomPubControl *atomPub = [editedEntry atomPubControl];
		if (atomPub == nil) {
			atomPub = [GDataAtomPubControl atomPubControl];
			[editedEntry setAtomPubControl:atomPub];
		}
		[atomPub setIsDraft:isDraft];
		
		// send the edited entry to the server
		GDataServiceGoogleBlogger *service = [self bloggerService];
		
		// remember the old entry; we'll replace the edited one with it later
		[service setServiceUserData:passedEntry];
		
		GDataServiceTicket *ticket;
		ticket = [service fetchEntryByUpdatingEntry:editedEntry
										   delegate:self
								  didFinishSelector:@selector(addEntryTicket:finishedWithEntry:error:)];
		[self setEditPostTicket:ticket];
		//[self updateUI];
	}
}






// get a google service object with the current username/password
//
// A "service" object handles networking tasks.  Service objects
// contain user authentication information as well as networking
// state information (such as cookies and the "last modified" date for
// fetched data.)

- (GDataServiceGoogleBlogger *)bloggerService {
	
	static GDataServiceGoogleBlogger* service = nil;
	
	if (!service) {
		service = [[GDataServiceGoogleBlogger alloc] init];
		
		[service setShouldCacheDatedData:YES];
		[service setServiceShouldFollowNextLinks:YES];
	}
	
	// update the name/password each time the service is requested
	NSString *username = p.bloggerUsername;
	NSString *password = p.bloggerPassword;
	
	[service setUserCredentialsWithUsername:username
								   password:password];
	
	return service;
}

- (void)fetchInitialBlogList {
	
	[self setBlogFeed:nil];
	[self setBlogFetchError:nil];
	
	[self setPostFeed:nil];
	[self setPostFetchError:nil];
	
	
	
	NSURL* feedURL = [GDataServiceGoogleBlogger blogFeedURLForUserID:kGDataServiceDefaultUser];
	
	GDataServiceGoogleBlogger *service = [self bloggerService];
	GDataServiceTicket *ticket;
	
	ticket = [service fetchFeedWithURL:feedURL
							 feedClass:[GDataFeedBlog class]
							  delegate:self
					 didFinishSelector:@selector(initialBlogListTicket:finishedWithFeed:error:)];
	[self setBlogFeedTicket:ticket];
	
	//[self updateUI];
}
- (void)initialBlogListTicket:(GDataServiceTicket *)ticket
			 finishedWithFeed:(GDataFeedBase *)feed
						error:(NSError *)error {
	
	[self setBlogFeed:feed];
	[self setBlogFetchError:error];
	[self setBlogFeedTicket:nil];
	
	if (error == nil) {

		if (new) {
			[self postTodaysBlogEntry];
		} else {
			[self updateSelectedPost];
		}
		
		
		
		
		
	} else	{
		p.bloggerLastUpdate = [NSString stringWithFormat:@"Update Error: %@", error];
		[p updateProfile];
			[self dismissModalViewControllerAnimated:YES];
	}
	
	}
- (GDataEntryBlog *)selectedBlog {
	
	NSArray *blogs = [mBlogFeed entries];
	
	int rowIndex = -1;	
	if ([p.bloggerAddress length] > 0 ) {
		rowIndex = [p.bloggerAddress integerValue];
	} 
	if ([blogs count] > 0 && rowIndex > -1) {
		
		GDataEntryBlog *blog = [blogs objectAtIndex:rowIndex];
		return blog;
	}
	return nil;
}

- (NSString*)textToHtml:(NSString*)htmlString {
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&"  withString:@"&amp;"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<"  withString:@"&lt;"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@">"  withString:@"&gt;"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"""" withString:@"&quot;"];    
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"'"  withString:@"&#039;"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
    return htmlString;
}



- (GDataFeedBase *)blogFeed {
	return mBlogFeed;
}

- (void)setBlogFeed:(GDataFeedBase *)feed {
	[mBlogFeed autorelease];
	mBlogFeed = [feed retain];
}

- (NSError *)blogFetchError {
	return mBlogFetchError;
}

- (void)setBlogFetchError:(NSError *)error {
	[mBlogFetchError release];
	mBlogFetchError = [error retain];
}

- (GDataServiceTicket *)blogFeedTicket {
	return mBlogFeedTicket;
}

- (void)setBlogFeedTicket:(GDataServiceTicket *)ticket {
	[mBlogFeedTicket autorelease];
	mBlogFeedTicket = [ticket retain];
}

- (GDataFeedBase *)postFeed {
	return mPostFeed;
}

- (void)setPostFeed:(GDataFeedBase *)feed {
	[mPostFeed autorelease];
	mPostFeed = [feed retain];
}

- (NSError *)postFetchError {
	return mPostFetchError;
}

- (void)setPostFetchError:(NSError *)error {
	[mPostFetchError release];
	mPostFetchError = [error retain];
}

- (GDataServiceTicket *)postFeedTicket {
	return mPostFeedTicket;
}

- (void)setPostFeedTicket:(GDataServiceTicket *)ticket {
	[mPostFeedTicket autorelease];
	mPostFeedTicket = [ticket retain];
}

- (GDataServiceTicket *)editPostTicket {
	return mEditPostTicket;
}

- (void)setEditPostTicket:(GDataServiceTicket *)ticket {
	[mEditPostTicket autorelease];
	mEditPostTicket = [ticket retain];
}

@end
