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

@interface ExoTestCase : XCTestCase {
    NSArray *TEST_EMAILS_OK;
    NSArray *TEST_EMAILS_INCORRECT;
    NSArray *TEST_URLS_OK;
    NSArray *TEST_URLS_INCORRECT;

    NSString *TEST_SERVER_URL ;
    NSString *TEST_SERVER_NAME ;

}

- (NSString*)URLEncodedString:(NSString*)s;
- (void)initVariables;

@end