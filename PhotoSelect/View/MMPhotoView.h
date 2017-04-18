//
//  MMPhotoView.h
//  MMCalculator
//
//  Created by 齐云浩 on 2017/4/12.
//
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

/**
 *  设置Block
 */
typedef void(^MMPhotoResult)(id responseObject);
@interface MMPhotoView : NSObject

@property (assign, nonatomic) NSInteger selectPhotoOfMax;//选择照片的最多张数

/**
 选中内容回调方法
 */
-(void)showIn:(UIViewController *)controller result:(MMPhotoResult)result;

@end
