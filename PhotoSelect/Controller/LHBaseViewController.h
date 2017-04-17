//
//  LHBaseViewController.h
//  PhotoSelect
//
//  Created by 齐云浩 on 2017/4/17.
//  Copyright © 2017年 齐云浩. All rights reserved.
//
/*!
 @header LHBaseViewController.h
 @abstract 项目中所有ViewController继承自该类, 不要直接继承 UIViewController
 @version 1.00 2017/4/17 Creation
 */

#import <UIKit/UIKit.h>
// 屏幕宽和高
#define DE_UISCREEN_WIDTH               [UIScreen mainScreen].bounds.size.width
#define DE_UISCREEN_HEIGHT              [UIScreen mainScreen].bounds.size.height

@interface LHBaseViewController : UIViewController

/*!
 @method
 @abstract 用于捕捉返回事件
 @discussion 如果需要捕捉返回事件, 子类重载该方法并调用父类方法
 */
- (void)doBack;

/*!
 @method
 @abstract 初始化自定义的返回按钮
 @discussion 默认使用系统定义的返回键, 如果特殊要求或者需要捕捉返回事件调取该方法
 */
- (void)initBackButton;

@end
