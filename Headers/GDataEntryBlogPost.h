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
//  GDataEntryBlogPost.h
//

#if !GDATA_REQUIRE_SERVICE_INCLUDES || GDATA_INCLUDE_BLOGGER_SERVICE

#import "GDataEntryBase.h"
#import "GDataThreadingElements.h"
#import "GDataMediaThumbnail.h"

@interface GDataEntryBlogPost : GDataEntryBase 

+ (GDataEntryBlogPost *)postEntry;

// extensions


//I REMOVED THESE BEACUSE THEY WERE CREATING A COMPILE ERROR.  THIS WILL PROBABLY BIT ME LATER.

//- (GDataMediaThumbnail *)thumbnail;
//- (void)setThumbnail:(GDataMediaThumbnail *)obj;

- (NSNumber *)total;
- (void)setTotal:(NSNumber *)num;

// convenience accessors

- (GDataLink *)enclosureLink;
- (GDataLink *)repliesHTMLLink;
- (GDataLink *)repliesAtomLink;

@end

#endif // !GDATA_REQUIRE_SERVICE_INCLUDES || GDATA_INCLUDE_BLOGGER_SERVICE
