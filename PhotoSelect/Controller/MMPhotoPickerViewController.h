//
//  MMPhotoPickerViewController.h
//  PhotoSelect
//
//  Created by 齐云浩 on 2017/4/17.
//  Copyright © 2017年 齐云浩. All rights reserved.
//

#import "LHBaseViewController.h"
#import <Photos/Photos.h>

@interface MMPhotoPickerViewController : LHBaseViewController

/**
 用于返回选择内容的Block
 */
@property (strong, nonatomic) void(^PhotoResult)(id responseObject);

/**
 多选图片的数量上限
 */
@property (assign, nonatomic) NSInteger selectNum;


/**
 Description
 */
@property (assign, nonatomic) BOOL isAlubSeclect;

/**
 用于获取相册内容的属性
 */
@property (strong, nonatomic) PHFetchResult *fetch;

@end
