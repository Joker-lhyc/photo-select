//
//  LHBaseViewController.m
//  PhotoSelect
//
//  Created by 齐云浩 on 2017/4/17.
//  Copyright © 2017年 齐云浩. All rights reserved.
//

#import "LHBaseViewController.h"

@interface LHBaseViewController ()

@end

@implementation LHBaseViewController


#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //背景色
    self.view.backgroundColor = [UIColor colorWithRed:245.0f/255.0f green:245.0f/255.0f blue:245.0f/255.0f alpha:1.0f];
    //导航栏颜色
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:23/255.0 green:23/255.0 blue:23/255.0 alpha:1.0];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:16],NSFontAttributeName,nil]];
}

#pragma mark - Initialization

- (void)initBackButton{
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    backView.backgroundColor = [UIColor clearColor];
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 13.0f, 10.0f, 18.0f)];
    backImageView.image = [UIImage imageNamed:@"left_arrow"];
    [backView addSubview:backImageView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 44, 44);
    [backBtn addTarget:self action:@selector(doBack) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:backBtn];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backView];
    self.navigationItem.leftBarButtonItem = backItem;
    
}

#pragma mark - Handler

- (void)doBack{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
