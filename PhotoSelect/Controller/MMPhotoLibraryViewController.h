//
//  MMPhotoLibraryViewController.h
//  PhotoSelect
//
//  Created by 齐云浩 on 2017/4/17.
//  Copyright © 2017年 齐云浩. All rights reserved.
//

#import "LHBaseViewController.h"
#import <Photos/Photos.h>

@interface MMPhotoLibraryViewController : LHBaseViewController

/**
 多选图片的数量上限
 */
@property (assign, nonatomic) NSInteger selectNum;

/**
 用于返回选择内容的Block
 */
@property (strong, nonatomic) void (^photoResult)(id responseObject);;

@end
