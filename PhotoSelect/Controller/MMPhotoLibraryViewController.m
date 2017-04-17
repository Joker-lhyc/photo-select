//
//  MMPhotoLibraryViewController.m
//  PhotoSelect
//
//  Created by 齐云浩 on 2017/4/17.
//  Copyright © 2017年 齐云浩. All rights reserved.
//

#import "MMPhotoLibraryViewController.h"
#import "MMPhotoDatas.h"
#import "MMPhotoListCell.h"
#import "MMPhotoPickerViewController.h"


@interface MMPhotoLibraryViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) UITableView *alumbTable;
@property (strong, nonatomic) PHPhotoLibrary *assetsLibrary;
@property (strong, nonatomic) NSMutableArray *alubms;
@property (strong, nonatomic) MMPhotoDatas *datas;
@end

@implementation MMPhotoLibraryViewController

-(void)close{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 懒加载获取图片数据类
-(MMPhotoDatas *)datas{
    if (!_datas) {
        _datas = [[MMPhotoDatas alloc]init];
    }
    return _datas;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //导航栏内容
    UIBarButtonItem *colseButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(close)];
    self.navigationItem.leftBarButtonItem = colseButton;
    self.navigationItem.title = @"Import photos";
    
    //创建相册列表
    _alumbTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DE_UISCREEN_WIDTH, DE_UISCREEN_HEIGHT) style:UITableViewStylePlain];
    _alumbTable.delegate   = self;
    _alumbTable.dataSource = self;
    _alumbTable.rowHeight  = 70.0;
    _alumbTable.separatorStyle = NO;
    [self.view addSubview:_alumbTable];
    
    //获得相册资源
    _alubms = [NSMutableArray array];
    _alubms = [self.datas getPhotoListDatas];
}
#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _alubms.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MMPhotoListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[MMPhotoListCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell loadPhotoListData:[_alubms objectAtIndex:indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MMPhotoPickerViewController *photopickerController = [[MMPhotoPickerViewController alloc]init];
    
    photopickerController.PhotoResult = self.photoResult;
    photopickerController.selectNum = self.selectNum;
    photopickerController.fetch = [self.datas getFetchResult:[_alubms objectAtIndex:indexPath.row]];
    photopickerController.isAlubSeclect = YES;
    photopickerController.title = @"Photos";
    
    [self.navigationController pushViewController:photopickerController animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
