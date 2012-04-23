//
//  SocialPostCommentProxy.m
//  eXo Platform
//
//  Created by Tran Hoai Son on 7/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SocialPostCommentProxy.h"
#import "SocialRestConfiguration.h"
#import "SocialComment.h"


@implementation SocialPostCommentProxy

@synthesize comment=_comment, userIdentity = _userIdentity;

- (id)init 
{
    if ((self = [super init])) 
    {
        _comment=@"";
    } 
    return self;
}

- (void)dealloc 
{
    [super dealloc];
}

#pragma mark - helper methods

//Helper to create the base URL
- (NSString *)createBaseURL {
    SocialRestConfiguration* socialConfig = [SocialRestConfiguration sharedInstance];
    
    return [NSString stringWithFormat:@"%@/%@/private/api/social/%@/%@/activity/", socialConfig.domainNameWithCredentials, socialConfig.restContextName,socialConfig.restVersion, socialConfig.portalContainerName]; 
}


#pragma mark - Call methods

-(void)postComment:(NSString *)commentValue forActivity:(NSString *)activityIdentity
{
    if (commentValue != nil) {
        _comment = commentValue;
    }
    
    
    RKObjectManager* manager = [RKObjectManager objectManagerWithBaseURL:[self createBaseURL]];
    [RKObjectManager setSharedManager:manager];
    manager.serializationMIMEType = RKMIMETypeJSON;
    
    RKObjectRouter* router = [[RKObjectRouter new] autorelease];
    manager.router = router;
    
    // Send POST requests for instances of SocialActivityDetails to '/activity.json'
    [router routeClass:[SocialComment class] toResourcePath:[NSString stringWithFormat:@"%@/comment.json",activityIdentity] forMethod:RKRequestMethodPOST];
    
    // Let's create an SocialActivityDetails
    SocialComment* commentToPost = [[SocialComment alloc] init];
    commentToPost.text = _comment;
    
    //Register our mappings with the provider FOR SERIALIZATION
    RKObjectMapping *commentSimpleMapping = [RKObjectMapping mappingForClass: 
                                              [SocialComment class]]; 
    [commentSimpleMapping mapKeyPath:@"text" toAttribute:@"text"]; 
    
    //Configure a serialization mapping for our SocialComment class 
    RKObjectMapping *commentSimpleSerializationMapping = [commentSimpleMapping 
                                                           inverseMapping]; 
    
    //serialization mapping 
    [manager.mappingProvider 
     setSerializationMapping:commentSimpleSerializationMapping forClass:[SocialComment 
                                                                          class]]; 
    
    
    
   
    
    // Create our new SocialComment mapping
    RKObjectMapping* socialCommentMapping = [RKObjectMapping mappingForClass:[SocialComment class]];
    [socialCommentMapping mapKeyPathsToAttributes:
     @"createdAt",@"createdAt",
     @"text",@"text",
     @"postedTime",@"postedTime",
     @"identityId",@"identityId",
     nil];
        
    // Send a POST to /articles to create the remote instance
    [manager postObject:commentToPost mapResponseWith:socialCommentMapping delegate:self];  
}


#pragma mark - RKObjectLoaderDelegate methods

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response 
{
    NSLog(@"Loaded payload: %@", [response bodyAsString]);
}


- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects 
{
    if (delegate && [delegate respondsToSelector:@selector(proxyDidFinishLoading:)]) {
        [delegate proxyDidFinishLoading:self];
    }
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error 
{
    if (delegate && [delegate respondsToSelector:@selector(proxy: didFailWithError:)]) {
        [delegate proxy:self didFailWithError:error];
    }
}

@end