//
//  defines.h
//  eXoApp
//
//  Created by Tran Hoai Son on 5/8/09.
//  Copyright 2009 EXO-Platform. All rights reserved.
//

#define TIMEOUT_SEC							60.0
#define HEIGHT_OF_KEYBOARD_IPHONE_PORTRAIT	216.0
#define HEIGHT_OF_KEYBOARD_IPHONE_LANDSCAPE	162.0
#define HEIGHT_OF_KEYBOARD_IPAD_PORTRAIT	262.0
#define HEIGHT_OF_KEYBOARD_IPAD_LANDSCAPE	352.0

#define WIDTH_DIFF_BETWEEN_LANDSCAPE_AND_PORTRAIT 250
#define WIDTH_FOR_CONTENT_IPHONE 237
#define WIDTH_FOR_CONTENT_IPAD 409

#define DISTANCE_LANDSCAPE                  18
#define DISTANCE_PORTRAIT                   24
#define WIDTH_LANDSCAPE_WEBVIEW             800
#define WIDTH_PORTRAIT_WEBVIEW              550

// Key for storing the combination server_username when we sign-in
#define EXO_LAST_LOGGED_USER                @"last-logged-user"
#define EXO_PREFERENCE_USERID				@"userId"
#define EXO_PREFERENCE_USERNAME				@"username"
#define EXO_PREFERENCE_PASSWORD				@"password"
#define EXO_PREFERENCE_EXO_USERID			@"exo_user_id"
#define EXO_PREFERENCE_DOMAIN				@"domain_name"
#define EXO_PREFERENCE_SELECTED_SEVER		@"selected_server"
#define EXO_IS_USER_LOGGED                  @"sigin"
#define EXO_PREFERENCE_VERSION_SERVER       @"version_server"
#define EXO_PREFERENCE_EDITION_SERVER       @"edition_server"
#define EXO_PREFERENCE_VERSION_APPLICATION  @"version_application"
#define EXO_NOTIFICATION_ACTIVITY_UPDATED   @"notification-activity-updated"
#define EXO_NOTIFICATION_CHANGE_LANGUAGE    @"notification-change-language"
#define EXO_NOTIFICATION_SHOW_PRIVATE_DRIVE @"notification-show-private-drive"
#define EXO_NOTIFICATION_SERVER_ADDED       @"notification-server-added"
#define EXO_NOTIFICATION_SERVER_DELETED     @"notification-server-deleted"

#define EXO_PREFERENCE_LANGUAGE				@"language"
#define HTTP_PROTOCOL                       @"http://"
#define HTTPS_PROTOCOL                       @"https://"

#define SCR_WIDTH_LSCP_IPAD                 1024
#define SCR_HEIGHT_LSCP_IPAD                748

#define SCR_WIDTH_PRTR_IPAD                 768
#define SCR_HEIGHT_PRTR_IPAD                1004

#define EXO_MAX_HEIGHT                      80

#define SPECIAL_CHAR_NAME_SET                    @"[]/\\&~?*|<>\";:+()$%@#!"
#define SPECIAL_CHAR_URL_SET                    @"[]\\&~?*|<>\";+"

#define EXO_BACKGROUND_COLOR                [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgGlobal.png"]]
#define SELECTED_CELL_BG_COLOR              [UIColor colorWithRed:225./255 green:225./255 blue:225./255 alpha:1.]

#define DOCUMENT_JCR_PATH_REST              @"/rest/private/jcr/"
#define DOCUMENT_DRIVE_PATH_REST            @"/rest/private/managedocument/getDrives?driveType="
#define DOCUMENT_DRIVE_SHOW_PRIVATE_OPT     @"&showPrivate="
#define DOCUMENT_FILE_PATH_REST             @"/rest/private/managedocument/getFoldersAndFiles?driveName="
#define DOCUMENT_WORKSPACE_NAME             @"&workspaceName="
#define DOCUMENT_CURRENT_FOLDER             @"&currentFolder=" 


/*
 *  System Versioning Preprocessor Macros
 */ 

#define SYSTEM_VERSION_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

//iPhone 5 screen height minus the navigation bar and status bar: 568 - 44 - 20 = 504
#define iPHONE_5_SCREEN_HEIGH_MINUS_NAV_AND_STATUS_BAR 504

#define iPHONE_5_SCREEN_HEIGHT 548
#define iPHONE_SCREEN_HEIGH 460
//eXo cloud sign up
#define EXO_CLOUD_USER_NAME_FROM_URL @"exo_cloud_user_name_from_url"
#define EXO_CLOUD_ACCOUNT_CONFIGURED @"exo_cloud_account_configured"
#define EXO_NOT_COMPILANT_ERROR_DOMAIN @"exo_not_compliant"

//#define EXO_CLOUD_URL  @"http://exoplatform.net"
//#define EXO_CLOUD_HOST @"exoplatform.net"
#define EXO_CLOUD_TENANT_SERVICE_PATH @"rest/cloud-admin/cloudworkspaces/tenant-service"

#define EXO_CLOUD_HOST @"wks-acc.exoplatform.org"
#define EXO_CLOUD_URL @"http://wks-acc.exoplatform.org"
#define scrollHeight 80 /* how much should we scroll up/down when the keyboard is displayed/hidden */

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
