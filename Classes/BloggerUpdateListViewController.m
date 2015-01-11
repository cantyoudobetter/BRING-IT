//  BloggerUpdateListViewController.m
//  Bring It
//
//  Created by Michael Bordelon on 4/22/10.
//  Copyright 2010 Bordelon iPhone. All rights reserved.
//

#import "BloggerUpdateListViewController.h"



@implementation BloggerUpdateListViewController
@synthesize postsFound;


- (void)postComplete {
	[self dismissModalViewControllerAnimated:YES];
	[self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
	postsFound = NO;
	p = [[Profile alloc] init];
	[self fetchInitialBlogList];
	self.title = @"Create/Update Post";
	UINavigationBar *bar = [self.navigationController navigationBar];
	bar.barStyle = UIBarStyleBlack;
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back"
																			  style:UIBarButtonItemStyleBordered
																			 target:self
																			 action:@selector(handleBack:)] autorelease];
	
}

- (void) handleBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSInteger rows;
	
	if (postsFound) rows = ([[mPostFeed entries] count] + 2);
	else rows = 3;
	return rows;
	//return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSInteger h = 60;

	//if (indexPath.row == 0) h = 60;
	if (indexPath.row == 1) h = 30;

	
	return h;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UITableViewCell *cell;
	
	
	if (indexPath.row == 0) {

		cell = [tableView dequeueReusableCellWithIdentifier:@"NewEntry"];
		if (cell == nil) {
			cell = [[[GradientTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NewEntry"] autorelease];
		}	
		[cell.textLabel setText:@"Create New Blog Entry"];
		//cell.textLabel.textAlignment = UITextAlignmentCenter;
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		

	} else if (indexPath.row ==1) {
		cell = [tableView dequeueReusableCellWithIdentifier:@"help"];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"help"] autorelease];
		}	
		[cell.textLabel setText:@"or select a recent post below to update"];
		[cell.textLabel setFont:[UIFont fontWithName:@"Helvetica" size:16]];
		cell.textLabel.textAlignment = UITextAlignmentCenter;
		cell.accessoryType = UITableViewCellAccessoryNone;
		[cell.textLabel setTextColor:[UIColor blueColor]];
		
		
		
	} else {
		
		GDataEntryBase *entry = [mPostFeed entryAtIndex:(indexPath.row - 2)];
	    //NSLog([NSString stringWithFormat:@"%d:Entry:%@",( indexPath.row ), [[entry title] stringValue]]);
		if (postsFound) {
			cell = [tableView dequeueReusableCellWithIdentifier:@"UpdateCell"];
			if (cell == nil) {
				cell = [[[GradientTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UpdateCell"] autorelease];
			}	
			
			[cell.textLabel setText:[[entry title] stringValue]];
			NSDate *pubDate = [[entry publishedDate] date];
			NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
			[dateFormat setTimeStyle:NSDateFormatterLongStyle];
			[dateFormat setDateStyle:NSDateFormatterLongStyle];
			NSString *dateString = [dateFormat stringFromDate:pubDate];
			[cell.detailTextLabel setText:dateString];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

		} else {
			cell = [tableView dequeueReusableCellWithIdentifier:@"LoadingCell"];
			if (cell == nil) {
				cell = [[[GradientTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LoadingCell"] autorelease];
			}	
			[cell.detailTextLabel setFont:[UIFont fontWithName:@"Helvetica" size:8]];
			UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
			cell.accessoryView = spinner;
			[spinner startAnimating];
			[spinner release];
					[cell.textLabel setFont:[UIFont fontWithName:@"Helvetica" size:18]];
			[cell.textLabel setText:@"Loading Blog Post List..."];
			cell.accessoryType = UITableViewCellAccessoryNone;
			[cell.textLabel setTextColor:[UIColor grayColor]];
			cell.textLabel.textAlignment = UITextAlignmentCenter;
		}
	}		
	
	return cell;	
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
		
	if ((indexPath.row > 1 && postsFound) || (indexPath.row == 0)) {
		
		BloggerUpdateViewController *bloggerUpdateViewController = [[BloggerUpdateViewController alloc] 
														initWithNibName:@"BloggerUpdateViewController" 
														bundle:nil];
		bloggerUpdateViewController.delegate = self;
		if (indexPath.row == 0) {
			bloggerUpdateViewController.new = YES;
		
		}	else {
			bloggerUpdateViewController.new = NO;
			NSArray *entries = [mPostFeed entries];
			bloggerUpdateViewController.passedEntry = [entries objectAtIndex:(indexPath.row - 2)];
			
		}

		[self presentModalViewController:bloggerUpdateViewController animated:YES];
		[bloggerUpdateViewController release];
		
	}
		
		
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}


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
	//[self postTodaysBlogEntry];
	
	if (error == nil) {
		NSLog(@"Retrieved Blog List");
		[self fetchPostsForSelectedBlog];
	} else	{
		p.bloggerLastUpdate = [NSString stringWithFormat:@"Blogger Error: %@", error];
		[p updateProfile];
		[self dismissModalViewControllerAnimated:YES];
	}
	
	
	//[self updateUI];
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
- (void)fetchPostsForSelectedBlog {
	
	GDataEntryBlog *blog = [self selectedBlog];
	if (blog != nil) {
		
		[self setPostFeed:nil];
		[self setPostFetchError:nil];
		
		//[self setCommentFeed:nil];
		//[self setCommentFetchError:nil];
		
		NSURL *feedURL = [[blog feedLink] URL];
		
		GDataQuery * query = [GDataQuery queryWithFeedURL:feedURL];
		NSDate * d = [BIUtility addToDate:-1
									 date:[NSDate dateWithTimeIntervalSinceNow:0]];
		GDataDateTime * gDate = [GDataDateTime dateTimeWithDate:d 
													   timeZone:[NSTimeZone localTimeZone]];
		[query setPublishedMinDateTime:gDate];
		
		GDataServiceGoogleBlogger *service = [self bloggerService];
		GDataServiceTicket *ticket;
		ticket = [service fetchFeedWithQuery:query
								 feedClass:[GDataFeedBlogPost class]
								  delegate:self
						 didFinishSelector:@selector(blogPostTicket:finishedWithFeed:error:)];
//		ticket = [service fetchFeedWithURL:feedURL
//								 feedClass:[GDataFeedBlogPost class]
//								  delegate:self
//						 didFinishSelector:@selector(blogPostTicket:finishedWithFeed:error:)];
		[self setPostFeedTicket:ticket];
		//[self updateUI];
	}
}

// post feed fetch callback
- (void)blogPostTicket:(GDataServiceTicket *)ticket
	  finishedWithFeed:(GDataFeedBase *)feed
                 error:(NSError *)error {
	
	[self setPostFeed:feed];
	[self setPostFetchError:error];
	[self setPostFeedTicket:nil];
	postsFound = YES;
	[self.tableView reloadData];
	//[self updateUI];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
