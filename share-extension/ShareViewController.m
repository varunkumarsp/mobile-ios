//
//  ShareViewController.m
//  share-extension
//
//  Created by Nguyen Manh Toan on 6/3/15.
//  Copyright (c) 2015 eXo Platform. All rights reserved.
//

#import "ShareViewController.h"
#import "AccountViewController.h"
#import "Account.h"
#import "defines.h"
#import <MobileCoreServices/MobileCoreServices.h>
#define kRestVersion @"v1-alpha3"
#define kRestContextName @"rest"
#define kPortalContainerName @"portal"

@interface ShareViewController () {
    SLComposeSheetConfigurationItem *spaceItem;
    SLComposeSheetConfigurationItem *accountItem;
    int loggingStatus;
    NSURLConnection * connection;
    SocialSpace * selectedSpace;
    NSURLSession * session;
    NSString* currentRepository;
    NSString* defaultWorkspace;
    NSString* userHomeJcrPath;
}
@property (nonatomic, retain) NSMutableArray * allAccounts;
@property (nonatomic, retain) Account * selectedAccount;

@end

@implementation ShareViewController
enum {eXoStatusNotLogin     =  0,
    eXoStatusLoggingIn      =  1,
    eXoStatusLoggedIn       =  2,
    eXoStatusLoggedFail     =  3,
    eXoStatusLoadingSpaceId =  4,
    eXoStatusCheckingUploadFoder = 5,
    eXoStatusCreatingUploadFoder = 6,
    eXoStatusLoggInAuthentificationFail     =  7
};
- (BOOL)isContentValid {
    return YES;
}

-(void) viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    self.navigationItem.title = @"eXo";
    loggingStatus = eXoStatusNotLogin;
    [self initListAccounts];
    [self login];
}

-(void) initListAccounts {
    NSUserDefaults *mySharedDefaults = [[NSUserDefaults alloc] initWithSuiteName: @"group.com.exoplatform.mob.eXoPlatformiPHone"];
    self.allAccounts = [[NSMutableArray alloc] init];
    if (mySharedDefaults){
        NSArray * allUsernames = [mySharedDefaults objectForKey:EXO_SHARE_EXTENSION_ALL_ACCOUNTS];
        
        if (allUsernames) {
            for (int i=0; i < allUsernames.count; i++){
                Account * account = [[Account alloc] init];
                account.userName = [allUsernames[i] objectForKey:@"username"];
                account.password = [allUsernames[i] objectForKey:@"password"];
                account.serverURL = [allUsernames[i] objectForKey:@"serverURL"];
                account.accountName = [allUsernames[i] objectForKey:@"accountName"];
                [self.allAccounts addObject:account];
            }
        }
        int selectedAccountIndex = [[mySharedDefaults objectForKey:EXO_SHARE_EXTENSION_SELECTED_ACCOUNT_INDEX] intValue];
        if (selectedAccountIndex >=0 && selectedAccountIndex < self.allAccounts.count){
            self.selectedAccount = self.allAccounts[selectedAccountIndex];
            NSString * currentAccount = [mySharedDefaults objectForKey:EXO_SHARE_EXTENSION_USERNAME];
            NSString * password       = [mySharedDefaults objectForKey:EXO_SHARE_EXTENSION_PASSWORD];
            NSString * serverURL      = [mySharedDefaults objectForKey:EXO_SHARE_EXTENSION_DOMAIN];
            if ([self.selectedAccount.userName isEqualToString:currentAccount] && [self.selectedAccount.serverURL isEqualToString:serverURL]){
                self.selectedAccount.password = password;
            }
            
        }
    }
}
#pragma mark - Loggin 
NSMutableData * data;
-(void) login {
    if (self.selectedAccount && self.selectedAccount.password.length>0){
        NSURLSessionConfiguration *sessionConfig =
        [NSURLSessionConfiguration ephemeralSessionConfiguration];
        
        [sessionConfig setHTTPAdditionalHeaders:@{@"Authorization":[self authentificationBase64]}];
        session  = [NSURLSession sessionWithConfiguration:sessionConfig];
        
        loggingStatus = eXoStatusLoggingIn;
        NSString * stringURL = [NSString stringWithFormat:@"%@/rest/private/platform/info#",self.selectedAccount.serverURL];
        NSURL * url = [NSURL URLWithString:stringURL];
        

        NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:url];
        //set default request timeout = 100 ms.
        [request setTimeoutInterval:100];
        [request setHTTPMethod:@"GET"];
        data = [[NSMutableData alloc] init];
        connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        [connection start];
    }
}
// make the authentification for selected accout
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    // authentification by challenge: create a credential with user & password.
    if([challenge previousFailureCount] == 0) {
        NSURLCredential *credential = [NSURLCredential credentialWithUser:self.selectedAccount.userName password:self.selectedAccount.password persistence:NSURLCredentialPersistenceNone];
        [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
    } else {
        loggingStatus =eXoStatusLoggInAuthentificationFail;
        self.selectedAccount.password = @"";
        [self reloadConfigurationItems];
    }
}
-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)aData {
    [data appendData:aData];
}


// finish download
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {

    if (data.length >0){
        NSError * error = nil;
        // convert the JSON to Space object (JSON string --> Dictionary --> Object.
        id jsonObjects = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        if (jsonObjects) {
            userHomeJcrPath = [jsonObjects objectForKey:@"userHomeNodePath"];
            currentRepository = [jsonObjects objectForKey:@"currentRepoName"];
            defaultWorkspace = [jsonObjects objectForKey:@"defaultWorkSpaceName"];
        }
    }
    
    loggingStatus =eXoStatusLoggedIn;
    [self reloadConfigurationItems];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    loggingStatus = eXoStatusLoggedFail;
    [self reloadConfigurationItems];
}


- (NSArray *)configurationItems {
    accountItem = [[SLComposeSheetConfigurationItem alloc] init];
    // Give your configuration option a title.
    [accountItem setTitle:NSLocalizedString(@"Account",nil)];
    // Give it an initial value.
    if (self.selectedAccount){
        [accountItem setValue:self.selectedAccount.accountName];
    } else {
        [accountItem setValue:NSLocalizedString(@"No account",nil)];
    }

    // Handle what happens when a user taps your option.
    [accountItem setTapHandler:^(void){
        // Create an instance of your configuration view controller.
        // Transfer to your configuration view controller.
        AccountViewController * accountVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AccountViewController"];
        accountVC.delegate = self;
        accountVC.allAccounts = self.allAccounts;
        [self.navigationController pushViewController:accountVC animated:YES];
    }];
    
    // space item
    spaceItem = [[SLComposeSheetConfigurationItem alloc] init];
    [spaceItem setTitle:NSLocalizedString(@"Space",nil)];
    
    // Give it an initial value.
    // Depense on the loggin status the message value could be the name of space in loggedIn, offline in loggedFail & logging in loggingIn.
    // By default the space is public space

    switch (loggingStatus) {
        case eXoStatusLoggedIn:{
            if (selectedSpace){
               [spaceItem setValue:selectedSpace.name];
            } else {
                [spaceItem setValue:NSLocalizedString(@"Public",nil)];
            }
        }        
            break;
        case eXoStatusLoggingIn:
            [spaceItem setValue:NSLocalizedString(@"Logging in",nil)];
            break;
        case eXoStatusLoggInAuthentificationFail:
            [spaceItem setValue:NSLocalizedString(@"Wrong password",nil)];
            break;
        case eXoStatusLoadingSpaceId:
            [spaceItem setValue:NSLocalizedString(@"Loading space id",nil)];
            break;

        default:
            if (self.selectedAccount){
                [spaceItem setValue:NSLocalizedString(@"Offline",nil)];
            } else {
                [spaceItem setValue:NSLocalizedString(@"No account",nil)];
            }

            break;
    }
    // Handle what happens when a user taps your option.
    
    [spaceItem setTapHandler:^(void){
        // User can select a space only after authentification.
        if (loggingStatus == eXoStatusLoggedIn){
            SpaceViewController  * spaceSelectionVC = [[SpaceViewController alloc] initWithStyle:UITableViewStylePlain];
            spaceSelectionVC.delegate = self;
            spaceSelectionVC.account  = self.selectedAccount;
            [self.navigationController pushViewController:spaceSelectionVC animated:YES];
        }
    }];

    // Return an array containing your item.
    return @[accountItem, spaceItem];
}

#pragma mark - delegate

-(void) spaceSelection:(SpaceViewController *)spaceSelection didSelectSpace:(SocialSpace *)space {
    
    if (!space) {
        selectedSpace = nil;
    } else {
        selectedSpace = space;
        [self getSpaceId:space];
    }
    [self reloadConfigurationItems];
    
}

-(void) accountSelection:(SpaceViewController *)accountSelection didSelectAccount:(Account *)account {
    if (account){
        self.selectedAccount  = account;
        loggingStatus = eXoStatusNotLogin;
        selectedSpace = nil;
        [self login];
        [self reloadConfigurationItems];
    }
}


# pragma mark - post methode
BOOL hasSentCompletedRequest;

- (void)didSelectPost {
    // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
    // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
    
    // Pull your photo out of the extension context.
    //Check All UTI Type Hierachy https://developer.apple.com/library/ios/documentation/FileManagement/Conceptual/understanding_utis/understand_utis_conc/understand_utis_conc.html
    
    hasSentCompletedRequest = NO;
    NSExtensionItem *inputItem = self.extensionContext.inputItems.firstObject;
    NSItemProvider * itemProvider = inputItem.attachments.firstObject;
    if (loggingStatus == eXoStatusLoggedIn){
        // All file in local (file URL)
        // -> All file share from email for example should be catch in this one.
        if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypeFileURL]) {
            [itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypeFileURL options:nil completionHandler:^(NSURL *url, NSError *error) {
                if (!error && url) {
                    NSString * filename =[[url absoluteString] lastPathComponent];
                    [self preparePostMessage:self.contentText file:url extension:filename];
                }
            }];
        // Image Type.
        } else if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypeImage]) {
            [itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypeImage options:nil completionHandler:^(id<NSSecureCoding> item, NSError *error) {
                if (!error && item) {
                    NSURL * url = (NSURL *) item;
                    NSString * filename =[[url absoluteString] lastPathComponent];
                    [self preparePostMessage:self.contentText file:url extension:filename];
                }
            }];
            
        } else if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypeAudio]||[itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypeMovie]) {
            // Type Audio/Video
            [itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypeMovie options:nil completionHandler:^(id<NSSecureCoding> item, NSError *error) {
                if (!error && item) {
                    NSURL * url = (NSURL *) item;
                    NSString * filename =[[url absoluteString] lastPathComponent];
                    [self preparePostMessage:self.contentText file:url extension:filename];
                }
            }];
        } else if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypeCompositeContent]) {
            // Base type for mixed content. For example, a PDF file contains both text and special formatting data.
            [itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypeData options:nil completionHandler:^(id<NSSecureCoding> item, NSError *error) {
                if (!error && item) {
                    NSURL * url = (NSURL *) item;
                    NSString * filename =[[url absoluteString] lastPathComponent];
                    [self preparePostMessage:self.contentText file:url extension:filename];
                }
            }];
        }  else if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypeURL]) {
            // case URL: the post message is the text in text field + the URL.
            [itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypeURL options:nil completionHandler:^(NSURL *url, NSError *error) {
                if (!error && url) {
                    NSString * message = [NSString stringWithFormat:@"%@ \n %@", self.contentText, url.absoluteString];
                    [self postMessage:message fileURL:nil fileName:nil];
                } 
            }];
        }
        else {
            // by default in the case of attachments doesn't existe. Post the text only
            [self postMessage:self.contentText fileURL:nil fileName:nil];
        }

    } else {
        // login fail (cause by: network connection/ wrong username, password/ no space id
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Cannot post",nil) message:NSLocalizedString(@"Login fail",nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
            [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
        }];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
 
}

-(NSString *) mobileFolderPath {
    return [NSString stringWithFormat:@"%@/rest/private/jcr/%@/%@%@/Public/Mobile",self.selectedAccount.serverURL,currentRepository, defaultWorkspace,userHomeJcrPath];
}

/*
 Check if the Mobile Folder in Server existe.
 */
-(void) preparePostMessage:(NSString *) message file:(NSURL  *) fileURL extension:(NSString *) fileExt {
    // you have a photo & text in self.contentText
    NSString * mobileFolderPath = [self mobileFolderPath];
    
    // Post Files process
    // 1. Check if folder contains the photos existe Asynchronous request - see reability
    // 1a. if not Create the folder (method: MKCOL, Authentification base64)
    // 2. Upload File ?
    // 3. Request Post Rest WS (method POST)
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:mobileFolderPath]];
    [request setHTTPMethod:@"HEAD"];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSUInteger statusCode = [((NSHTTPURLResponse*) response) statusCode];
        BOOL existe = statusCode >= 200 && statusCode < 300;
        [self postMessage:self.contentText file:fileURL uploadFolderExiste:existe];
    }];
    [dataTask resume];

}

/*
 If the mobile folder doesn't existe in server --> create a new one.
 */
-(void) postMessage:(NSString *) message file:(NSURL  *) fileURL uploadFolderExiste:(BOOL) existe {
    if (!existe) {
        NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:[self mobileFolderPath]]];
        [request setHTTPMethod:@"MKCOL"];
        
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSUInteger statusCode = [((NSHTTPURLResponse*) response) statusCode];
            if(statusCode >= 200 && statusCode < 300) {
                [self postMessage:message file:fileURL];
            }
        }];
        [dataTask resume];
    } else {
        [self postMessage:message file:fileURL];
    }
}


NSURLSession * uploadSession;

-(NSURLSession *) uploadSession {
    if (!uploadSession){
        NSURLSessionConfiguration * config = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.exoplatform.mob.eXoPlatformiPHone.share-extension.session"];
        config.sharedContainerIdentifier = @"group.com.exoplatform.mob.eXoPlatformiPHone";
        uploadSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    }
    return uploadSession;
}
-(void) postMessage:(NSString *) message file:(NSURL  *) fileURL {
    if (fileURL) {
        NSData * fileData = [[NSData alloc] initWithContentsOfURL:fileURL];
        if (fileData.length < 5000000){
            NSString * fileExt = [[fileURL absoluteString] lastPathComponent];
            NSLog(@"posting message %@ data length %lu ...", message, fileData.length);
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy_MM_dd_hh_mm_ss"];
            NSString * fileAttachName = [dateFormatter stringFromDate:[NSDate date]];
            fileExt = [fileExt stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            fileExt = [fileExt stringByReplacingOccurrencesOfString:@" " withString:@"_"];
            fileExt = [fileExt stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
            if ([fileExt rangeOfString:@"."].location!=NSNotFound){
                fileAttachName = [NSString stringWithFormat:@"Mobile_%@_%@",fileAttachName,fileExt];
            } else {
                fileAttachName = [NSString stringWithFormat:@"Mobile_%@.%@",fileAttachName,fileExt];
            }
            
            NSString * urlString = [NSString stringWithFormat:@"%@/%@", [self mobileFolderPath], fileAttachName];
            
            NSMutableURLRequest *request =[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
            [request setHTTPMethod:@"PUT"];
            [request setValue:@"T" forHTTPHeaderField:@"Overwrite"];
            [request setHTTPBody:fileData];
            
            NSURLSession * aSession = [self uploadSession];
            NSURLSessionDataTask * uploadTask = [aSession dataTaskWithRequest:request];
            
            [uploadTask resume];
            
            [self postMessage:message fileURL:urlString fileName:fileAttachName];
        } else {
            [self postMessage:message fileURL:nil fileName:nil];
        }
    } else {
        [self postMessage:message fileURL:nil fileName:nil];
    }
}
-(void) URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {

}
-(void) URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error {
    
}

-(void) postMessage:(NSString *) message fileURL:(NSString *) fileURL fileName:(NSString*) fileName {
    
    if (!hasSentCompletedRequest) {
        hasSentCompletedRequest = YES;
        [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
    }

    NSString * title = message;
    NSString * type;
    NSDictionary * templateParams;

    NSString * urlString = [NSString stringWithFormat:@"%@/rest/private/api/social/%@/%@/activity.json",self.selectedAccount.serverURL, kRestVersion, kPortalContainerName];
    if (selectedSpace && selectedSpace.spaceId.length > 0){
        type = @"exosocial:spaces";
        urlString = [NSString stringWithFormat:@"%@?identity_id=%@", urlString, selectedSpace.spaceId];
    }

    // 2
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    
    if (fileURL) {
        type = @"DOC_ACTIVITY";
        NSString* docPath = [fileURL substringFromIndex:[fileURL rangeOfString:userHomeJcrPath].location];
        NSRange rangeOfDocLink = [fileURL rangeOfString:@"jcr"];
        NSString* docLink = [NSString stringWithFormat:@"/rest/%@", [fileURL substringFromIndex:rangeOfDocLink.location]];
        title = [NSString stringWithFormat:@"Shared a document <a href=\"%@\">%@</a>\"", docLink, fileName];
        templateParams = @{
                           @"DOCPATH":docPath,
                           @"MESSAGE":message,
                           @"DOCLINK":docLink,
                           @"WORKSPACE":defaultWorkspace,
                           @"REPOSITORY":currentRepository,
                           @"DOCNAME":fileName
                           };
    }
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:title forKey:@"title"];
    if (type){
        [dictionary setValue:type forKey:@"type"];
    }
    if (templateParams) {
        [dictionary setValue:templateParams forKey:@"templateParams"];
    }
    
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary
                                                   options:kNilOptions error:&error];
    [request setHTTPBody:data];
    
    if (!error) {
        NSURLSession * aSession = [self uploadSession];
        NSURLSessionDataTask *uploadTask = [aSession dataTaskWithRequest:request];
        
        [uploadTask resume];
    }
}


-(void) getSpaceId:(SocialSpace*) space {
    
    loggingStatus = eXoStatusLoadingSpaceId;
    
    NSString * path = [NSString stringWithFormat:@"%@/rest/private/api/social/v1-alpha3/portal/identity/space/%@.json",self.selectedAccount.serverURL, space.name];
    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:path]
                completionHandler:^(NSData *data,
                                    NSURLResponse *response,
                                    NSError *error) {
                    if (!error) {
                        NSError * error = nil;
                        // convert the JSON to Space object (JSON string --> Dictionary --> Object.
                        id jsonObjects = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                        if (jsonObjects){
                            selectedSpace.spaceId = [jsonObjects objectForKey:@"id"];
                        }
                        loggingStatus = eXoStatusLoggedIn;
                    } else {
                        loggingStatus = eXoStatusLoggedFail;
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self reloadConfigurationItems];
                    });
                }];
    [dataTask resume];
}


-(NSString *) authentificationBase64 {
    NSString * username = self.selectedAccount.userName;
    NSString * password = self.selectedAccount.password;
    
    NSString * basicAuth = @"Basic ";
    NSString * authorizationHead = [basicAuth stringByAppendingString: [self stringEncodedWithBase64:[NSString stringWithFormat:@"%@:%@",username, password]]];

    return authorizationHead;
}


- (NSString*)stringEncodedWithBase64:(NSString*)str
{
    static const char *tbl = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    
    const char *s = [str UTF8String];
    long length = [str length];
    char *tmp = malloc(length * 4 / 3 + 4);
    
    int i = 0;
    int n = 0;
    char *p = tmp;
    
    while (i < length)
    {
        n = s[i++];
        n *= 256;
        if (i < length) n += s[i];
        i++;
        n *= 256;
        if (i < length) n += s[i];
        i++;
        
        p[0] = tbl[((n & 0x00fc0000) >> 18)];
        p[1] = tbl[((n & 0x0003f000) >> 12)];
        p[2] = tbl[((n & 0x00000fc0) >>  6)];
        p[3] = tbl[((n & 0x0000003f) >>  0)];
        
        if (i > length) p[3] = '=';
        if (i > length + 1) p[2] = '=';
        
        p += 4;
    }
    
    *p = '\0';
    
    NSString* ret = @(tmp);
    free(tmp);
    
    return ret;
}
@end
