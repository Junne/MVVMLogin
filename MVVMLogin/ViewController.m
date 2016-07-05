//
//  ViewController.m
//  MVVMLogin
//
//  Created by baijf on 6/29/16.
//  Copyright © 2016 Junne. All rights reserved.
//

#import "ViewController.h"
#import "LoginService.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (strong, nonatomic) LoginService *loginService;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self bindTextField];
}

#pragma mark - Bind TextField

- (void)bindTextField
{
//    @weakify(self)
    [self.usernameTextField.rac_textSignal subscribeNext:^(id x) {
//        @strongify(self)
        NSLog(@"username = %@", x);
    }];
    
//    [[self.usernameTextField.rac_textSignal
//      filter:^BOOL(NSString *text) {
//          return text.length > 5;
//    }]
//     subscribeNext:^(id x) {
//         NSLog(@"filter x = %@", x);
//    }];
    
//    RACSignal *usernameSourceSignal = self.usernameTextField.rac_textSignal;
//    RACSignal *filteredUsername = [usernameSourceSignal filter:^BOOL(id value) {
//        NSString *text = value;
//        return text.length > 5;
//    }];
//    
//    [filteredUsername subscribeNext:^(id x) {
//        NSLog(@"filter x = %@", x);
//    }];
    
    [[[self.usernameTextField.rac_textSignal map:^id(NSString *text) {
        return @(text.length);
    }]
     filter:^BOOL(NSNumber *length) {
         return [length integerValue] > 5;
     }]
     subscribeNext:^(id x) {
         NSLog(@"username x = %@", x);
     }];
    
    [self.passwordTextfield.rac_textSignal subscribeNext:^(id x) {
        NSLog(@"password = %@", x);
    }];
    
    RACSignal *validUsernameSignal = [self.usernameTextField.rac_textSignal
                                      map:^id(NSString *text) {
                                          return @([self isValidUsername:text]);
                                      }];
    
    RACSignal *validPasswordSignal = [self.passwordTextfield.rac_textSignal
                                      map:^id(NSString *text) {
                                          return @([self isValidPassword:text]);
                                      }];
    
//    [[validPasswordSignal
//      map:^id(NSNumber *passwordValid) {
//        return [passwordValid boolValue] ? [UIColor clearColor] : [UIColor yellowColor];
//    }]
//      subscribeNext:^(UIColor *color) {
//          self.passwordTextfield.backgroundColor = color;
//      }];
    
    RAC(self.passwordTextfield, backgroundColor) = [validPasswordSignal map:^id(NSNumber *passwordValid) {
        return [passwordValid boolValue] ? [UIColor clearColor] : [UIColor yellowColor];
    }];
    
    RAC(self.usernameTextField, backgroundColor) = [validUsernameSignal map:^id(NSNumber *usernameValid) {
        return [usernameValid boolValue] ? [UIColor clearColor] : [UIColor yellowColor];
    }];
    
    
    
    RACSignal *signUpActiveSignal = [RACSignal combineLatest:@[validUsernameSignal,  validPasswordSignal]
                                                      reduce:^id(NSNumber *usernameValid, NSNumber *passwordValid){
                                                          return @([usernameValid boolValue] && [passwordValid boolValue]);
                                                      }];
    
    [signUpActiveSignal subscribeNext:^(NSNumber *signupActive) {
        self.loginButton.enabled = [signupActive boolValue];
    }];
    
    [[[self.loginButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     map:^id(id value) {
         return [self loginSignal];
     }]
     subscribeNext:^(id x) {
         NSLog(@"login result: %@", x);
     }];
    
//    [[[self.loginButton rac_signalForControlEvents:UIControlEventTouchUpInside]
//      flattenMap:^id(id x ) {
//          return [self loginSignal];
//      }]
//     subscribeNext:^(NSNumber *login) {
//         BOOL success = [login boolValue];
//         NSLog(@"login result = %d", success);
//     }];
    
//    [[[self.loginButton rac_signalForControlEvents:UIControlEventTouchUpInside]
//      flattenMap:^RACStream *(id value) {
//          return [self loginSignal];
//      }]
//      subscribeNext:^(NSNumber *login) {
//          BOOL success = [login boolValue];
//          NSLog(@"login result = %d", success);
//      }];
    
}

- (RACSignal *)loginSignal {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self.loginService loginWithUsername:self.usernameTextField.text password:self.passwordTextfield.text complete:^(BOOL success) {
            [subscriber sendNext:@(success)];
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}

- (BOOL)isValidUsername:(NSString *)username {
    return username.length > 5;
}

- (BOOL)isValidPassword:(NSString *)password {
    return password.length > 5;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
