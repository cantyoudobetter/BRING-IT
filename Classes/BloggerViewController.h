/* Copyright (c) 2009 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

//
//  BloggerSampleWindowController.h
//

#import <UIKit/UIKit.h>

#import "GDataBlogger.h"
#import "BIUtility.h"
#import "Profile.h"
#import "SinglePickerViewController.h"


@interface BloggerViewController : UIViewController <PickerDelegate> {
	Profile *p;
	
  IBOutlet UITextField *mUsernameField;
  IBOutlet UITextField *mPasswordField;

  IBOutlet UITableView *mBlogsTable;
  IBOutlet UIActivityIndicatorView *mBlogsProgressIndicator;
  IBOutlet UITextView *mBlogsResultTextField;

  IBOutlet UITableView *mPostsTable;
  IBOutlet UIProgressView *mPostsProgressIndicator;
  IBOutlet UITextView *mPostsResultTextField;

  IBOutlet UITextField *mPostEditField;
  IBOutlet UIProgressView *mEditProgressIndicator;
  IBOutlet UIButton *mPostDraftCheckBox;
  IBOutlet UIButton *mAddPostButton;
  IBOutlet UIButton *mUpdatePostButton;
  IBOutlet UIButton *mDeletePostButton;

  IBOutlet UITableView *mCommentsTable;
  IBOutlet UIProgressView *mCommentsProgressIndicator;
  IBOutlet UITextView *mCommentsResultTextField;
	
  IBOutlet UILabel *mBlogName;
  IBOutlet UILabel *mBlogTitle;	
  IBOutlet UITextView *note;	

  GDataFeedBase *mBlogFeed;
  GDataServiceTicket *mBlogFeedTicket;
  NSError *mBlogFetchError;

  GDataFeedBase *mPostFeed;
  GDataServiceTicket *mPostFeedTicket;
  NSError *mPostFetchError;

  GDataServiceTicket *mEditPostTicket; // for add, update, delete

  GDataFeedBase *mCommentFeed;
  GDataServiceTicket *mCommentFeedTicket;
  NSError *mCommentFetchError;
}

//+ (BloggerViewController *)sharedBloggerViewController;
- (void)handlePickerChange:(NSInteger)index;
- (IBAction)getBlogsClicked:(id)sender;
- (void)fetchInitialBlogList;
//- (IBAction)addPostClicked:(id)sender;
//- (IBAction)updatePostClicked:(id)sender;
//- (IBAction)deletePostClicked:(id)sender;

//- (IBAction)draftCheckboxClicked:(id)sender;

//- (IBAction)loggingCheckboxClicked:(id)sender;
- (IBAction)saveButtonClicked:(id)sender;
- (IBAction)textFieldDoneEditing:(id)sender;

@end
