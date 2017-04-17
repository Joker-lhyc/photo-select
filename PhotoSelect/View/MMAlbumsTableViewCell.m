//
//  MMAlbumsTableViewCell.m
//  MMCalculator
//
//  Created by 齐云浩 on 2017/4/6.
//
//

#import "MMAlbumsTableViewCell.h"

@implementation MMAlbumsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"MMAlbumsTableViewCell";
    MMAlbumsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"MMAlbumsTableViewCell" owner:nil options:nil][0];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle  = UITableViewCellSelectionStyleNone;
    cell.accessoryType   = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - 懒加载模块
- (UIImageView *)coverPhoto
{
    if (_coverPhoto == nil) {
        _coverPhoto = [[UIImageView alloc] init];
        _coverPhoto.contentMode = UIViewContentModeScaleAspectFill;
        _coverPhoto.clipsToBounds = YES;
        [self.contentView addSubview:_coverPhoto];
    }
    return _coverPhoto;
}

- (UILabel *)nameLable
{
    if (_nameLable == nil) {
        _nameLable = [[UILabel alloc] init];
        _nameLable.font = [UIFont systemFontOfSize:14];
        _nameLable.textColor = [UIColor blackColor];
        [self.contentView addSubview:_nameLable];
    }
    return _nameLable;
}

- (UILabel *)numberLable
{
    if (_numberLable == nil) {
        _numberLable = [[UILabel alloc] init];
        _numberLable.font = [UIFont systemFontOfSize:12];
        _numberLable.textColor = [UIColor grayColor];
        [self.contentView addSubview:_numberLable];
    }
    return _numberLable;
}

#pragma mark - 初始化farme
- (void)setFrameForUI
{
    _nameLable.frame   = CGRectMake(100, 30, 250, 15);
    _numberLable.frame = CGRectMake(100, 50, 250, 15);
    _coverPhoto.frame  = CGRectMake(15 , 10, 70 , 70);
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    // 设置frame
    [self setFrameForUI];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
