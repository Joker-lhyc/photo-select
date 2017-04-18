//
//  MMAlbumsViewController.h
//  PhotoSelect
//
//  Created by 齐云浩 on 2017/4/17.
//  Copyright © 2017年 齐云浩. All rights reserved.
//

#import "LHBaseViewController.h"

@interface MMAlbumsViewController : LHBaseViewController

/**
 选中相册的文件名
 */
@property (nonatomic,strong) NSString *fileName;

/**
 选中相册的路径
 */
@property (nonatomic,strong) NSString *path;

@end
