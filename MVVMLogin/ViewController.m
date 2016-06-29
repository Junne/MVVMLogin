//
//  ViewController.m
//  MVVMLogin
//
//  Created by baijf on 6/29/16.
//  Copyright © 2016 Junne. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

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
    
    [[self.usernameTextField.rac_textSignal
      filter:^BOOL(NSString *text) {
          return text.length > 5;
    }]
     subscribeNext:^(id x) {
        
    }];
    
    [self.passwordTextfield.rac_textSignal subscribeNext:^(id x) {
        NSLog(@"password = %@", x);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
