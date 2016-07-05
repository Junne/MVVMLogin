//
//  LoginService.h
//  MVVMLogin
//
//  Created by baijf on 7/5/16.
//  Copyright © 2016 Junne. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^LoginResponse)(BOOL);

@interface LoginService : NSObject

- (void)loginWithUsername:(NSString *)username password:(NSString *)password complete:(LoginResponse)completeBlock;

@end
