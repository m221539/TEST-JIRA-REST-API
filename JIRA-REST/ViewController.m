//
//  ViewController.m
//  JIRA-REST
//
//  Created by ray on 16/10/24.
//  Copyright © 2016年 ray. All rights reserved.
//

#import "ViewController.h"

#import "JRIssueService.h"
#import "JREntranceService.h"

@interface ViewController ()

@property (nonatomic, strong) UIImageView *captchaView;
@property (nonatomic, strong) UITextField *usernameField;
@property (nonatomic, strong) UITextField *passwordField;
@property (nonatomic, strong) JREntranceService *service;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.captchaView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
    [self.view addSubview:self.captchaView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
    

}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    JRIssueService *sev = [[JRIssueService alloc] init];
//    JRFieldsUpdateModel *fm = [[JRFieldsUpdateModel alloc] init];
//    fm.projectId = @"10205";
//    fm.issueTypeId = @"1";
//    fm.summary = @"summary_test";
//    fm.priorityId = @"1";
//    fm.assigneeName = @"";
//    fm.components = @[@"10104", @"10135"];
//    fm.versions = @[@"10846", @"10835"];
//    JRIssueUpdateModel *im = [[JRIssueUpdateModel alloc] init];
//    im.fields = fm;
//    [sev updateIssue:im resultBlock:^(BOOL successed, NSError *error) {
//        
//    }];
    
    NSString *name = @"";
    NSString *password = @"";
    NSString *captcha = @"tigdays";

    
    __weak typeof(self) wSelf = self;
    self.service = [[JREntranceService alloc] init];
    [self.service loginWithUserName:name password:password captcha:captcha resultBlock:^(BOOL successed, UIImage *captcha) {
        if (!successed) {
            wSelf.captchaView.image = captcha;
        }
    }];
}


@end
