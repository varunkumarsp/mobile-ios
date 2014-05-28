//
// Copyright (C) 2003-2014 eXo Platform SAS.
//
// This is free software; you can redistribute it and/or modify it
// under the terms of the GNU Lesser General Public License as
// published by the Free Software Foundation; either version 3 of
// the License, or (at your option) any later version.
//
// This software is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
// Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public
// License along with this software; if not, write to the Free
// Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
// 02110-1301 USA, or see the FSF site: http://www.fsf.org.
//


#import <XCTest/XCTest.h>
#import "AsyncProxyTestCase.h"
#import "SocialActivityStreamProxy.h"
#import "HTTPStubsHelper.h"
#import "SocialTestsHelper.h"

@interface SocialActivityStreamProxyTestCase : AsyncProxyTestCase<SocialProxyDelegate> {
    SocialActivityStreamProxy *asProxy;
    HTTPStubsHelper *httpHelper;
    SocialTestsHelper *socHelper;
}
@end

@implementation SocialActivityStreamProxyTestCase

- (void)setUp
{
    [super setUp];
    socHelper = [SocialTestsHelper getInstance];
    asProxy = [[SocialActivityStreamProxy alloc] init];
    asProxy.delegate = self;
    asProxy.userProfile = [socHelper createSocialUserProfile];
    [socHelper createSocialRestConfiguration];
    httpHelper = [HTTPStubsHelper getInstance];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}


- (void)testCreatePathForActivityType
{
    NSString *path = [asProxy createPathForType:ActivityStreamProxyActivityTypeAllUpdates];
    NSString *expectedPath = @"private/api/social/v1-alpha3/portal/activity_stream/feed.json";
    XCTAssertEqualObjects(path, expectedPath, @"All activities stream Rest URL is incorrect");
    
    path = [asProxy createPathForType:ActivityStreamProxyActivityTypeMyConnections];
    expectedPath = @"private/api/social/v1-alpha3/portal/activity_stream/connections.json";
    XCTAssertEqualObjects(path, expectedPath, @"My connections activities stream Rest URL is incorrect");
    
    path = [asProxy createPathForType:ActivityStreamProxyActivityTypeMySpaces];
    expectedPath = @"private/api/social/v1-alpha3/portal/activity_stream/spaces.json";
    XCTAssertEqualObjects(path, expectedPath, @"My spaces activities stream Rest URL is incorrect");
    
    path = [asProxy createPathForType:ActivityStreamProxyActivityTypeMyStatus];
    NSString *identityId = asProxy.userProfile.identity;
    expectedPath = [NSString stringWithFormat:@"private/api/social/v1-alpha3/portal/activity_stream/%@.json", identityId];
    XCTAssertEqualObjects(path, expectedPath, @"My status activities stream Rest URL is incorrect");
}

- (void)testGetActivityStream
{
    [httpHelper HTTPStubForActivityStream];
 
    [asProxy getActivityStreams:ActivityStreamProxyActivityTypeAllUpdates];
    
    [self wait];
    
    XCTAssertEqual(asProxy.arrActivityStreams.count, 1, @"Failed to get activity stream");
}

- (void)testActivityStreamBeforeActivity
{
    [httpHelper HTTPStubForActivityStream];
    
    SocialActivity *activity = [socHelper createSocialActivity];
    
    [asProxy getActivitiesOfType:ActivityStreamProxyActivityTypeAllUpdates BeforeActivity:activity];
    
    [self wait];
    
    XCTAssertEqual(asProxy.arrActivityStreams.count, 1, @"Failed to get activity stream before a certain activity");
}


@end