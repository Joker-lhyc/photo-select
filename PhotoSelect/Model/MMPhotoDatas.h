//
//  MMPhotoDatas.h
//  MMCalculator
//
//  Created by 齐云浩 on 2017/4/12.
//
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface MMPhotoDatas : NSObject


@property (assign, nonatomic) NSInteger type;

/*
 * 获取全部相册
 */
-(NSMutableArray *)getPhotoListDatas;
/*
 * 获取某一个相册的结果集
 */
-(PHFetchResult *)getFetchResult:(PHAssetCollection *)assetCollection;
/*
 * 获取图片实体，并把图片结果存放到数组中，返回值数组
 */
-(NSMutableArray *)getPhotoAssets:(PHFetchResult *)fetchResult;
/*
 * 只获取相机胶卷结果集
 */
-(PHFetchResult *)getCameraRollFetchResul;
/*
 * 回调方法使用数组
 */
-(void)getImageObject:(id)asset complection:(void (^)(UIImage *,PHAsset *, BOOL isDegraded))complection;
@end
