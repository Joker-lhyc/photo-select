//
//  MMPhotoDatas.m
//  MMCalculator
//
//  Created by 齐云浩 on 2017/4/12.
//
//

#import "MMPhotoDatas.h"

@implementation MMPhotoDatas

-(NSMutableArray *)getPhotoListDatas{
    NSMutableArray *dataArray = [NSMutableArray array];
    //获取资源时的参数，为nil时则是使用系统默认值
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc]init];
    //列出所有的智能相册
    PHFetchResult *smartAlbumsFetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:fetchOptions];
    [dataArray addObject:[smartAlbumsFetchResult objectAtIndex:0]];
    //列出所有用户创建的相册
    PHFetchResult *smartAlbumsFetchResult1 = [PHAssetCollection fetchTopLevelUserCollectionsWithOptions:fetchOptions];
    //遍历
    for (PHAssetCollection *sub in smartAlbumsFetchResult1) {
        [dataArray addObject:sub];
    }
    return dataArray;
}
-(PHFetchResult *)getFetchResult:(PHAssetCollection *)assetCollection{
    //获取某个相册的结果集
    PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    return fetchResult;
}
-(NSMutableArray *)getPhotoAssets:(PHFetchResult *)fetchResult{
    NSMutableArray *dataArray = [NSMutableArray array];
    for (PHAsset *asset in fetchResult) {
        //只添加图片类型资源，去除视频类型资源
        //当mediatype == 2时，之歌资源则视为视频资源
        NSLog(@"%ld",(unsigned long)asset.mediaSubtypes);
        if (asset.mediaSubtypes == 0 || asset.mediaSubtypes == 1 || asset.mediaSubtypes == 4 || asset.mediaSubtypes == 8) {
            
            [dataArray addObject:asset];
        }
    }
    return dataArray;
}
-(PHFetchResult *)getCameraRollFetchResul{
    //获取系统相册CameraRoll 的结果集
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc]init];
    PHFetchResult *smartAlbumsFetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:fetchOptions];
    PHFetchResult *fetch = [PHAsset fetchAssetsInAssetCollection:[smartAlbumsFetchResult objectAtIndex:0] options:nil];
    return fetch;
}
-(void)getImageObject:(id)asset complection:(void (^)(UIImage *,PHAsset *, BOOL))complection{
    
    if ([asset isKindOfClass:[PHAsset class]]) {
        PHAsset *phAsset = (PHAsset *)asset;
        CGFloat photoWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat aspectRatio = phAsset.pixelWidth / (CGFloat)phAsset.pixelHeight;
        //屏幕分辨率 scale = 1 代表 分辨率是320 * 480; = 2 代表 分辨率是 640 * 960; = 3 代表 分辨率是 1242 * 2208
        CGFloat multiple = [UIScreen mainScreen].scale;
        CGFloat pixelWidth = photoWidth * multiple;
        CGFloat pixelHeight = pixelWidth / aspectRatio;
        /**
         *  PHImageManager 是通过请求的方式拉取图像，并可以控制请求得到的图像的尺寸、剪裁方式、质量，缓存以及请求本身的管理（发出请求、取消请求）等
         *
         *  @param pixelWidth 获取图片的宽
         *  @param pixelHeight 获取图片的高
         *  @param contentMode 图片的剪裁方式
         *
         *  @return
         */
        [[PHImageManager defaultManager] requestImageForAsset:phAsset targetSize:CGSizeMake(pixelWidth, pixelHeight) contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            // 排除取消，错误，低清图三种情况，即已经获取到了高清图
            BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
            if (downloadFinined) {
                //回调
                if (complection){
                    complection(result,phAsset,[[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
                }
            }
            
        }];
    }
}

@end
