//
//  MMPhotoListViewController.h
//  PhotoSelect
//
//  Created by 齐云浩 on 2017/4/17.
//  Copyright © 2017年 齐云浩. All rights reserved.
//

#import "LHBaseViewController.h"

@interface MMPhotoListViewController : LHBaseViewController

/**
 相册数组
 */
@property (nonatomic) NSMutableArray *photoArray;

/**
 数组元素数量
 */
@property (nonatomic) NSUInteger number;

/**
 相册路径
 */
@property (nonatomic,strong) NSString *path;

/**
 相册名字
 */
@property (nonatomic,strong) NSString *name;

@end
