//
//  UserPreferences.m
//  genera
//
//  Created by VC N on 2/03/12.
/*
 Copyright (c) 2011 Museum Victoria
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
//


#import "UserPreferences.h"

@implementation UserPreferences


+(NSString*) userID{

    NSString *savedUserID;
    
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"UserID"]!=nil) {
        savedUserID = [[NSUserDefaults standardUserDefaults] stringForKey:@"UserID"];
    }else
    {
        savedUserID = nil;
        
    }
    
    return savedUserID;
}
+(BOOL) setUserID:(NSString *) userID{

    BOOL isSuccessful =YES;
    [[NSUserDefaults standardUserDefaults] setObject:userID forKey:@"UserID"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    return isSuccessful;
}

@end
