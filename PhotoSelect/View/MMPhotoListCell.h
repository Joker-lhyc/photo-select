//
//  MMPhotoListCell.h
//  MMCalculator
//
//  Created by 齐云浩 on 2017/4/12.
//
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface MMPhotoListCell : UITableViewCell

@property (strong, nonatomic) UIImageView *coverImage;//相册图片，显示相册的最后一张图片

@property (strong, nonatomic) UILabel *title;//相册标题，显示相册标题

@property (strong, nonatomic) UILabel *subTitle;//相册副标题，显示相册中含有多少张图片
/**
 *  加载数据方法
 *  @param assetItem 某个相册
 */
-(void)loadPhotoListData:(PHAssetCollection *)assetItem;
@end
