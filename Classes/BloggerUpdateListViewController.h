//
//  BloggerUpdateListViewController.h
//  Bring It
//
//  Created by Michael Bordelon on 6/6/10.
//  Copyright 2010 Bordelon iPhone. All rights reserved.
//






#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Bring_ItAppDelegate.h"
#import "UACellBackgroundView.h"
#import "GradientTableViewCell.h"
#import "BIUtility.h"
#import "GDataBlogger.h"
#import "Profile.h"
#import "BloggerUpdateViewController.h"


@interface BloggerUpdateListViewController : UITableViewController 
<UITableViewDelegate, UITableViewDataSource, BloggerDelegate> {
	BOOL postsFound;
	Profile * p;
	GDataFeedBase *mBlogFeed;
	GDataServiceTicket *mBlogFeedTicket;
	NSError *mBlogFetchError;
	
	GDataFeedBase *mPostFeed;
	GDataServiceTicket *mPostFeedTicket;
	NSError *mPostFetchError;
	
	GDataServiceTicket *mEditPostTicket;
}
@property (nonatomic, readwrite) BOOL postsFound;


//- (void)fetchInitalBlogs;
- (void)fetchPostsForSelectedBlog;
//- (void)addEntry;
//- (void)updateSelectedPost;

- (GDataServiceGoogleBlogger *)bloggerService;
- (GDataEntryBlog *)selectedBlog;
//- (GDataEntryBlogPost *)selectedPost;
//- (GDataEntryBlogComment *)selectedComment;

- (GDataFeedBase *)blogFeed;
- (void)setBlogFeed:(GDataFeedBase *)feed;
- (NSError *)blogFetchError;
- (void)setBlogFetchError:(NSError *)error;
- (GDataServiceTicket *)blogFeedTicket;
- (void)setBlogFeedTicket:(GDataServiceTicket *)ticket;

- (GDataFeedBase *)postFeed;
- (void)setPostFeed:(GDataFeedBase *)feed;
- (NSError *)postFetchError;
- (void)setPostFetchError:(NSError *)error;
- (GDataServiceTicket *)postFeedTicket;
- (void)setPostFeedTicket:(GDataServiceTicket *)ticket;
- (void)fetchInitialBlogList;


@end