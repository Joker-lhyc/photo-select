//
//  MMAlbumsListViewController.m
//  PhotoSelect
//
//  Created by 齐云浩 on 2017/4/17.
//  Copyright © 2017年 齐云浩. All rights reserved.
//

#import "MMAlbumsListViewController.h"
#import "MMAlbumsTableViewCell.h"
#import "MMAlbumsViewController.h"
#import "MMAlbumsAddViewController.h"

@interface MMAlbumsListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *albumsTableView;
@property (nonatomic) NSMutableArray *albumsArray;
@property (nonatomic,strong)UIView *blankView;

@end

@implementation MMAlbumsListViewController
@synthesize albumsArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //标题
    self.title = @"Albums";
    //创建图形界面
    [self makeUI];
    //创建垃圾桶 永远存在 只删除内部文件
    [self makeTrash];
}

/*!
 @abstract 控制器显示时刷新数据
 */
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //获取相册数据
    self.albumsArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"Album"];
    NSMutableArray *arrayTrash = [[NSUserDefaults standardUserDefaults] objectForKey:@"Album/Trash"];
    //刷新数据
    if (self.albumsArray.count == 0 && arrayTrash.count == 0) {
        self.albumsTableView.hidden = YES;
        self.blankView.hidden = NO;
    }else{
        self.blankView.hidden = YES;
        self.albumsTableView.hidden = NO;
        [self.albumsTableView reloadData];
    }
}
/*!
 @abstract 加载图形界面
 */
- (void)makeUI
{
    //新建导航按钮 跳转 添加相册
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAlbum)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    //创建相册的 TableView
    UITableView *albumsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, DE_UISCREEN_WIDTH, DE_UISCREEN_HEIGHT) style:UITableViewStylePlain];
    albumsTableView.delegate   = self;
    albumsTableView.dataSource = self;
    albumsTableView.rowHeight  = 90.0;
    [self.view addSubview:albumsTableView];
    self.albumsTableView = albumsTableView;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //提示View
    _blankView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    _blankView.center = self.view.center;
    [self.view addSubview:_blankView];
    _blankView.hidden = YES;
    _blankView.backgroundColor = [UIColor clearColor];
    //提示的标题与字体
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _blankView.frame.size.width, 40)];
    titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    titleLabel.text = @"No albums";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [_blankView addSubview:titleLabel];
    //提示的文字内容
    UILabel * conLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame) + 10, _blankView.frame.size.width, 50)];
    conLabel.font = [UIFont systemFontOfSize:13];
    conLabel.numberOfLines = 2;
    conLabel.text = @"You have yet to create your first \n albums.Tap + to get started!";
    conLabel.textAlignment = NSTextAlignmentCenter;
    conLabel.textColor     = [UIColor grayColor];
    [_blankView addSubview:conLabel];
}

/*!
 @abstract 点击了添加相册按钮
 */
- (void)addAlbum
{
    MMAlbumsAddViewController * svc = [[MMAlbumsAddViewController alloc] init];
    
    UINavigationController *presNavigation = [[UINavigationController alloc] initWithRootViewController: svc];
    
    [self presentViewController:presNavigation animated:YES completion:^{
    }];
    
}


#pragma mark - Table view data source
/*!
 @abstract 行数
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableArray *arrayTrash = [[NSUserDefaults standardUserDefaults] objectForKey:@"Album/Trash"];
    
    //垃圾桶相册为空时 返回相册原数组 ，不为空 展示垃圾桶
    if (arrayTrash.count == 0) return albumsArray.count;
    
    return albumsArray.count + 1;
}
/*!
 @abstract cell内容
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MMAlbumsTableViewCell *cell = [MMAlbumsTableViewCell cellWithTableView:tableView];
    //垃圾桶cell
    if (indexPath.row == albumsArray.count) {
        
        //读取并展示相册内容
        NSMutableArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"Album/Trash"];
        cell.nameLable.text   = @"Trash";
        cell.numberLable.text = [NSString stringWithFormat:@"%lu photos",(unsigned long)array.count];
        cell.coverPhoto.image = [UIImage imageNamed:@"trash"];

        return cell;
    }
    
    //读取并展示相册内容
    NSMutableArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:albumsArray[indexPath.row]];
    NSString *name = [NSString stringWithFormat:@"%@",[array firstObject]];
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Albums"] stringByAppendingPathComponent:albumsArray[indexPath.row]];
    cell.nameLable.text   = albumsArray[indexPath.row];
    cell.numberLable.text = [NSString stringWithFormat:@"%lu photos",(unsigned long)array.count];
    cell.coverPhoto.image = [UIImage imageWithContentsOfFile:[path stringByAppendingString:name]];
    
    //当相册内照片为空时 显示默认封面
    if (array.count == 0) {
        
        cell.coverPhoto.image = [UIImage imageNamed:@"no_data"];
    }
    
    return cell;
}
/*!
 @abstract cell点击事件
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MMAlbumsViewController * detailView=[[MMAlbumsViewController alloc] init];
    
    //读取并展示相册内容
    if (indexPath.row == albumsArray.count) {
        
        detailView.fileName = @"Album/Trash";
        
        detailView.title    = @"Trash";
        
        detailView.path     = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Albums"] stringByAppendingPathComponent:@"Trash"];
        
        [self.navigationController pushViewController:detailView animated:YES];
        
        return;
    }
    
    detailView.fileName = albumsArray[indexPath.row];
    
    detailView.title    = albumsArray[indexPath.row];
    
    detailView.path     = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Albums"] stringByAppendingPathComponent:albumsArray[indexPath.row]];
    
    [self.navigationController pushViewController:detailView animated:YES];
    
    
}

#pragma mark - 左滑删除
/*!
 @abstract 设Cell可编辑
 */
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == albumsArray.count) return NO;
    return YES;
}
/*!
 @abstract 定义编辑样式
 */
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
/*!
 @abstract 左滑删除
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //删除文件以及路径
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Albums"] stringByAppendingPathComponent:albumsArray[indexPath.row]];
    //删除前 先保存文件到物理垃圾桶
    NSString *pathTrash = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Albums"] stringByAppendingPathComponent:@"Trash"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSMutableArray *nameArray = [[NSUserDefaults standardUserDefaults] objectForKey:albumsArray[indexPath.row]];
    
    for (int i = 0; i < nameArray.count; i++) {
        
        NSString *name = [NSString stringWithFormat:@"%@",nameArray[i]];
        
        BOOL isCopy   = [fileManager copyItemAtPath:[path stringByAppendingString:name] toPath:[pathTrash stringByAppendingString:name] error:nil];
        NSLog(@"移动%d",isCopy);
    }
    
    //删除
    BOOL isDelete = [fileManager removeItemAtPath:path error:nil];
    NSLog(@"删除%d",isDelete);
    
    
    //保存路径到路径垃圾桶
    NSMutableArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:albumsArray[indexPath.row]];
    NSMutableArray *arrayTrash = [[NSUserDefaults standardUserDefaults] objectForKey:@"Album/Trash"];
    NSMutableArray *mutablearrayTrash = [arrayTrash mutableCopy];
    for (int i = 0; i < array.count; i++) {
        [mutablearrayTrash addObject:array[i]];
    }
    [[NSUserDefaults standardUserDefaults] setObject:mutablearrayTrash forKey:@"Album/Trash"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:albumsArray[indexPath.row]];//防止同名相册被创建后 显示相册图片数量不为空
    
    //删除在数组中元素
    NSArray *tempNoteArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"Album"];
    NSMutableArray *mutablePicArray = [tempNoteArray mutableCopy];
    //获取相册名称并删除 保存
    NSString *textstring = albumsArray[indexPath.row];
    [mutablePicArray removeObject:textstring];
    [[NSUserDefaults standardUserDefaults] setObject:mutablePicArray forKey:@"Album"];
    //刷新
    [self viewWillAppear:YES];
}

#pragma mark - 创建垃圾桶相册
- (void)makeTrash
{
    //创建垃圾桶路径
    NSString *pathDel = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Albums"] stringByAppendingPathComponent:@"Trash"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:pathDel isDirectory:&isDir];
    if(!(isDirExist && isDir))
    {
        BOOL bCreateDir = [fileManager createDirectoryAtPath:pathDel withIntermediateDirectories:YES attributes:nil error:nil];
        if(!bCreateDir){
            NSLog(@"创建文件夹失败！");
        }
        NSLog(@"创建文件夹成功，文件路径%@",pathDel);
    }
    
    //创建垃圾桶数组
    NSMutableArray *picArray = [[NSMutableArray alloc]init];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"Album/Trash"]==nil) {
        [[NSUserDefaults standardUserDefaults] setObject:picArray forKey:@"Album/Trash"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
