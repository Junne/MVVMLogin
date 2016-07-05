//
//  LoginService.m
//  MVVMLogin
//
//  Created by baijf on 7/5/16.
//  Copyright © 2016 Junne. All rights reserved.
//

#import "LoginService.h"

@implementation LoginService

- (void)loginWithUsername:(NSString *)username password:(NSString *)password complete:(LoginResponse)completeBlock
{
    double delayInSeconds = 2.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        BOOL success = [username isEqualToString:@"username"] && [password isEqualToString:@"password"];
        completeBlock(success);
    });
}

@end
