//
//  MMPhotoListCell.m
//  MMCalculator
//
//  Created by 齐云浩 on 2017/4/12.
//
//

#import "MMPhotoListCell.h"

@implementation MMPhotoListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUILayout];
    }
    return self;
}
/**
 *  设置界面布局
 */
-(void)setUILayout{
    CGFloat jianGe = 5;
    CGFloat image_W_H = 60;
    CGFloat labelWidth = [UIScreen mainScreen].bounds.size.width - 90;
    CGFloat labelHeight = 25;
    _coverImage = [[UIImageView alloc]initWithFrame:CGRectMake(2 * jianGe, jianGe, image_W_H, image_W_H)];
    _coverImage.layer.masksToBounds = YES;
    _coverImage.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_coverImage];
    
    _title = [[UILabel alloc]initWithFrame:CGRectMake(_coverImage.frame.size.width + _coverImage.frame.origin.x + 2 * jianGe, jianGe, labelWidth, labelHeight)];
    _title.textColor = [UIColor blackColor];
    [self.contentView addSubview:_title];
    
    _subTitle = [[UILabel alloc]initWithFrame:CGRectMake(_coverImage.frame.size.width + _coverImage.frame.origin.x + 2 * jianGe, _title.frame.size.height + _title.frame.origin.y + jianGe * 2, labelWidth, labelHeight)];
    _subTitle.textColor = [UIColor blackColor];
    [self.contentView addSubview:_subTitle];
    
}

-(void)loadPhotoListData:(PHAssetCollection *)assetItem{
    if ([assetItem isKindOfClass:[PHAssetCollection class]]) {
        PHFetchResult *group = [PHAsset fetchAssetsInAssetCollection:assetItem options:nil];
        
        [[PHImageManager defaultManager]requestImageForAsset:[group lastObject] targetSize:CGSizeMake(200, 200) contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            if (result == nil) {
                self.coverImage.image = [UIImage imageNamed:@"no_data.png"];
            }else{
                self.coverImage.image = result;
            }
        }];
        PHAssetCollection *titleAsset = assetItem;
        if ([titleAsset.localizedTitle isEqualToString:@"All Photos"]) {
            self.title.text = @"All Photos";
        }else{
            self.title.text = [NSString stringWithFormat:@"%@",titleAsset.localizedTitle];
        }
        self.subTitle.text = [NSString stringWithFormat:@"%lu",(unsigned long)group.count];
    }
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
