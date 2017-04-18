//
//  MMPhotoPickerCell.h
//  MMCalculator
//
//  Created by 齐云浩 on 2017/4/12.
//
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface MMPhotoPickerCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *photo;

@property (strong, nonatomic) UIButton *selectBtn;

-(void)loadPhotoData:(PHAsset *)assetItem;

-(void)selectBtnStage:(NSMutableArray *)selectArray existence:(PHAsset *)assetItem;

@end
