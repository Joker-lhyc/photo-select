//
//  MMAlbumsAddViewController.m
//  PhotoSelect
//
//  Created by 齐云浩 on 2017/4/17.
//  Copyright © 2017年 齐云浩. All rights reserved.
//

#import "MMAlbumsAddViewController.h"

@interface MMAlbumsAddViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic,strong) NSArray *array;
@property (nonatomic,strong) UITextField *NameField;

@end

@implementation MMAlbumsAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"New album";
    
    _array = [[NSArray alloc] initWithObjects:@"Cover photo",@"Security",@"Sorting", nil];
    
    [self makeUI];
}

/*!
 @abstract 加载界面
 */
- (void)makeUI
{
    //返回按钮
    UIBarButtonItem *backButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(backClick)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    //确认保存按钮
    UIBarButtonItem *addButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(sureClick)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    //创建笔记的 TableView
    UITableView *albumSetTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    albumSetTableView.delegate   = self;
    albumSetTableView.dataSource = self;
    albumSetTableView.rowHeight  = 50.0;
    albumSetTableView.backgroundColor = [UIColor clearColor];
    albumSetTableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:albumSetTableView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //TableView的头部View
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DE_UISCREEN_WIDTH, 120)];
    headView.backgroundColor = [UIColor clearColor];
    albumSetTableView.tableHeaderView = headView;
    
    //上层分割线
    UIView *lineView01 = [[UIView alloc] initWithFrame:CGRectMake(0, 29.5, DE_UISCREEN_WIDTH, 0.5)];
    lineView01.backgroundColor = [UIColor colorWithRed:212/255.0 green:210/255.0 blue:213/255.0 alpha:1.0];
    [headView addSubview:lineView01];
    
    //相册名字View
    UIView *nameView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, DE_UISCREEN_WIDTH, 50)];
    nameView.backgroundColor = [UIColor whiteColor];
    [headView addSubview:nameView];
    
    //相册名字textField
    UITextField *NameField = [[UITextField alloc] initWithFrame:CGRectMake(15, 10, DE_UISCREEN_WIDTH - 30, 30)];
    NameField.placeholder  = @"Album name";
    NameField.font = [UIFont systemFontOfSize:14];
    NameField.returnKeyType = UIReturnKeyDone;
    NameField.delegate = self;
    self.NameField = NameField;
    [self.NameField becomeFirstResponder];
    [nameView addSubview:NameField];
    
    //下层分割线
    UIView *lineView02 = [[UIView alloc] initWithFrame:CGRectMake(0, 80, DE_UISCREEN_WIDTH, 0.5)];
    lineView02.backgroundColor = [UIColor colorWithRed:212/255.0 green:210/255.0 blue:213/255.0 alpha:1.0];
    [headView addSubview:lineView02];
    
    //底部的分割线
    UIView *lineView03 = [[UIView alloc] initWithFrame:CGRectMake(0, 119.5, DE_UISCREEN_WIDTH, 0.5)];
    lineView03.backgroundColor = [UIColor colorWithRed:212/255.0 green:210/255.0 blue:213/255.0 alpha:1.0];
    //    [headView addSubview:lineView03];
    
    //TableView的尾部View
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DE_UISCREEN_WIDTH, 0.5)];
    lineView.backgroundColor = [UIColor colorWithRed:212/255.0 green:210/255.0 blue:213/255.0 alpha:1.0];
    //    albumSetTableView.tableFooterView = lineView;
    
    
}

#pragma mark - TableView 的代理以及数据源方法
/*!
 @abstract 行数
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}
/*!
 @abstract cell内容
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // cell的标识
    static NSString *CellIdentifier = @"Cell";
    //初始化行
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle  = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text = _array[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    //添加右侧箭头
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
/*!
 @abstract cell点击事件
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}




#pragma mark - 点击事件
/*!
 @abstract 点击返回
 */
- (void)backClick
{
    [self.NameField resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}
/*!
 @abstract 点击并保存相册
 */
- (void)sureClick
{
    //判断相册名字长度
    if (self.NameField.text.length < 1) {
        return;
    }
    
    //保存图片 Documents是指定路径
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Albums"] stringByAppendingPathComponent:self.NameField.text];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    if(!(isDirExist && isDir))
    {
        BOOL bCreateDir = [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        if(!bCreateDir){
            NSLog(@"创建文件夹失败！");
        }
        NSLog(@"创建文件夹成功，文件路径%@",path);
        [self dismissViewControllerAnimated:YES completion:nil];
    }else
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Remind" message:@"You have created this album" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    //初始化数组
    NSMutableArray *AlbumArray = [[NSMutableArray alloc]init];
    //判断NSUserDefaults中是否有key叫note的数据如果没有就添加
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"Album"]==nil) {
        [[NSUserDefaults standardUserDefaults] setObject:AlbumArray forKey:@"Album"];
    }
    //新建临时数组来接收NSUserDefaults数据
    NSArray *tempNoteArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"Album"];
    //复制数组
    NSMutableArray *mutableNoteArray = [tempNoteArray mutableCopy];
    //获取文本框的值
    NSString *textstring = self.NameField.text;
    //添加到负责数组中
    [mutableNoteArray insertObject:textstring atIndex:0 ];
    [[NSUserDefaults standardUserDefaults] setObject:mutableNoteArray forKey:@"Album"];
}
/*!
 @abstract 取消响应者
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.NameField resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
