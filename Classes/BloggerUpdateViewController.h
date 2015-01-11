//
//  BloggerUpdateViewController.h
//  Bring It
//
//  Created by Michael Bordelon on 5/24/10.
//  Copyright 2010 Bordelon iPhone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>

#import "GDataBlogger.h"
#import "BIUtility.h"
#import "Profile.h"

@protocol BloggerDelegate <NSObject>
- (void)postComplete;
@end


@interface BloggerUpdateViewController : UIViewController {
	Profile * p;
	GDataEntryBlogPost *passedEntry;
	BOOL new;
	
	
	id <BloggerDelegate> delegate;

	
	GDataFeedBase *mBlogFeed;
	GDataServiceTicket *mBlogFeedTicket;
	NSError *mBlogFetchError;
	
	GDataFeedBase *mPostFeed;
	GDataServiceTicket *mPostFeedTicket;
	NSError *mPostFetchError;
	
	GDataServiceTicket *mEditPostTicket;
}
@property (nonatomic, assign) id <BloggerDelegate> delegate;
@property (nonatomic, copy) GDataEntryBlogPost *passedEntry;
@property (nonatomic, readwrite) BOOL new;

//- (void)fetchInitalBlogs;
- (void)fetchInitialBlogList;
//- (void)fetchPostsForSelectedBlog;
//- (void)addEntry;
- (void)updateSelectedPost;
//- (void)deleteSelectedPost;

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
- (void)setEditPostTicket:(GDataServiceTicket *)ticket;
@end
