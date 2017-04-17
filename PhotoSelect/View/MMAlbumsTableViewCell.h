//
//  MMAlbumsTableViewCell.h
//  MMCalculator
//
//  Created by 齐云浩 on 2017/4/6.
//
//

#import <UIKit/UIKit.h>

@interface MMAlbumsTableViewCell : UITableViewCell
@property(nonatomic,strong) UIImageView *coverPhoto;//封面
@property(nonatomic,strong) UILabel *nameLable;//相册名称
@property(nonatomic,strong) UILabel *numberLable;//图片数量

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
