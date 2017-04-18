//
//  MMPhotoPickerCell.m
//  MMCalculator
//
//  Created by 齐云浩 on 2017/4/12.
//
//

#import "MMPhotoPickerCell.h"

@implementation MMPhotoPickerCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUILayout];
    }
    return self;
}
//界面布局
-(void)setUILayout{
    CGFloat photoSize = ([UIScreen mainScreen].bounds.size.width - 3) / 4;
    _photo = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, photoSize, photoSize)];
    _photo.layer.masksToBounds = YES;
    _photo.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_photo];
    
    CGFloat btnSize = photoSize / 4;
    _selectBtn = [[UIButton alloc]initWithFrame:CGRectMake(photoSize - btnSize - 5, 5, btnSize, btnSize)];
    [self.contentView addSubview:_selectBtn];
}
-(void)selectBtnStage:(NSMutableArray *)selectArray existence:(PHAsset *)assetItem{
    if ([selectArray containsObject:assetItem]) {
        [_selectBtn setImage:[UIImage imageNamed:@"select_yes"] forState:UIControlStateNormal];
    }else{
        [_selectBtn setImage:[UIImage imageNamed:@"select_no"] forState:UIControlStateNormal];
    }
}
-(void)loadPhotoData:(PHAsset *)assetItem{
    if ([assetItem isKindOfClass:[PHAsset class]]) {
        PHAsset *phAsset = assetItem;
        [[PHImageManager defaultManager]requestImageForAsset:phAsset targetSize:CGSizeMake(200, 200) contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            self.photo.image = result;
        }];
    }
}

@end
