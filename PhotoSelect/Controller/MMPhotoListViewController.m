//
//  MMPhotoListViewController.m
//  PhotoSelect
//
//  Created by 齐云浩 on 2017/4/17.
//  Copyright © 2017年 齐云浩. All rights reserved.
//

#import "MMPhotoListViewController.h"
#import <Photos/Photos.h>

@interface MMPhotoListViewController ()<UIScrollViewDelegate>
@property (nonatomic,strong) UIScrollView *photoScrollView;
@property (nonatomic,strong) UIView *bottomView;

@end

@implementation MMPhotoListViewController
@synthesize photoArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [NSString stringWithFormat:@"%d of %d",_number + 1,self.photoArray.count];
    
    //加载界面
    [self makeUI];
    //加载底部按钮
    [self makeBottomView];
}
#pragma mark - 加载UI界面
- (void)makeUI
{
    //取消自动适应
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //滑动展示View
    _photoScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, DE_UISCREEN_WIDTH, DE_UISCREEN_HEIGHT)];
    _photoScrollView.backgroundColor = [UIColor blackColor];
    _photoScrollView.pagingEnabled   = YES;
    _photoScrollView.bounces  = NO;
    _photoScrollView.delegate = self;
    _photoScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_photoScrollView];
    
    //读取并展示图片
    CGFloat maxX = 0;
    for (int i = 0; i < [self.photoArray count]; i++) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake( DE_UISCREEN_WIDTH * i, 0, DE_UISCREEN_WIDTH, DE_UISCREEN_HEIGHT)];
        imageView.contentMode     = UIViewContentModeScaleAspectFit;
        imageView.backgroundColor = [UIColor clearColor];
        imageView.tag   = i;
        NSString *name  = [NSString stringWithFormat:@"%@",self.photoArray[i]];
        imageView.image = [UIImage imageWithContentsOfFile:[_path stringByAppendingString:name]];
        [_photoScrollView addSubview:imageView];
        
        maxX = CGRectGetMaxX(imageView.frame);
    }
    _photoScrollView.contentSize = CGSizeMake(maxX, 0);
    
    //定位到被点击的图片位置下
    CGPoint position = CGPointMake(DE_UISCREEN_WIDTH * _number, 0);
    [_photoScrollView setContentOffset:position animated:YES];
}
/*!
 @abstract 页面底部功能栏
 */
-(void)makeBottomView{//功能按钮：保存图片到本地 上一张图 下一张图 删除图片
    
    CGFloat x = self.view.frame.size.width / 4;
    CGFloat h = 49;
    
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 49, self.view.frame.size.width, 49)];
    [self.view addSubview:self.bottomView];
    [self.view bringSubviewToFront:self.bottomView];
    self.bottomView.backgroundColor = [UIColor colorWithRed:64/255.0 green:64/255.0 blue:64/255.0 alpha:1];
    
    for (int i = 0; i < 4 ; i++) {
        UIButton *bottomButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, h, h)];
        bottomButton.center = CGPointMake(x * i + x / 2, h/2);
        bottomButton.tag = i + 100;
        [self.bottomView addSubview:bottomButton];
        if (i == 0) {
            [bottomButton setImage:[UIImage imageNamed:@"share"] forState:(UIControlStateNormal)];
        }
        else if (i == 1) {
            [bottomButton setImage:[UIImage imageNamed:@"skip-back"] forState:(UIControlStateNormal)];
        }
        else if (i == 2) {
            [bottomButton setImage:[UIImage imageNamed:@"skip-forward"] forState:(UIControlStateNormal)];
        }
        else if (i == 3) {
            [bottomButton setImage:[UIImage imageNamed:@"photo_delete"] forState:(UIControlStateNormal)];
        }
        [bottomButton addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
}

#pragma mark - 刷新数据

/*!
 @abstract 刷新scrollView
 */
- (void)scrollViewReload
{
    //重加载 并且在为空时返回上一界面
    self.photoArray = [[NSUserDefaults standardUserDefaults] objectForKey:_name];
    if (self.photoArray.count == 0) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    self.title = [NSString stringWithFormat:@"%d of %d",_number + 1,self.photoArray.count];
    
    //移除被删除的图片
    for(UIImageView *view in [_photoScrollView subviews])
    {
        if (view.tag == _number) {
            
            [view removeFromSuperview];
        }else if (view.tag > _number)
        {
            view.frame = CGRectMake(view.frame.origin.x - DE_UISCREEN_WIDTH, 0, DE_UISCREEN_WIDTH, DE_UISCREEN_HEIGHT);
            view.tag = view.tag - 1;
        }
    }
    
    //重定位到当前位置
    _photoScrollView.contentSize = CGSizeMake(self.photoArray.count * DE_UISCREEN_WIDTH, 0);
    CGPoint position = CGPointMake(DE_UISCREEN_WIDTH * _number, 0);
    [_photoScrollView setContentOffset:position animated:YES];
    
}

/*!
 @abstract 获取当前页数
 */
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // 得到每页宽度
    CGFloat pageWidth = sender.frame.size.width;
    // 根据当前的x坐标和页宽度计算出当前页数
    _number = floor((sender.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    self.title = [NSString stringWithFormat:@"%d of %d",_number + 1,self.photoArray.count];
}

#pragma mark - 相片操作

/*!
 @abstract 删除指定照片弹框
 */
- (void)deletePhoto
{
    //创建Alert控制器
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Are you sure?" message:@"Are you sure want to delete this photos?" preferredStyle:UIAlertControllerStyleAlert];
    
    //创建 Alert.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {        }];
    
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self delPhoto];
    }];
    
    //添加 actions.
    [alertController addAction:cancelAction];
    [alertController addAction:deleteAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

/*!
 @abstract 删除指定照片方法
 */
- (void)delPhoto
{
    //删除文件以及路径
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Albums"] stringByAppendingPathComponent:_name];
    //删除前 先保存文件到物理垃圾桶
    NSString *pathTrash = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Albums"] stringByAppendingPathComponent:@"Trash"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSMutableArray *nameArray = [[NSUserDefaults standardUserDefaults] objectForKey:_name];
    
    NSString *name = [NSString stringWithFormat:@"%@",nameArray[_number]];
    
    BOOL isCopy   = [fileManager copyItemAtPath:[path stringByAppendingString:name] toPath:[pathTrash stringByAppendingString:name] error:nil];
    NSLog(@"移动%d",isCopy);
    
    //删除
    BOOL isDelete = [fileManager removeItemAtPath:[path stringByAppendingString:name] error:nil];
    NSLog(@"删除%d",isDelete);
    
    //保存路径到路径垃圾桶数组
    NSMutableArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:_name];
    
    NSMutableArray *arrayTrash = [[NSUserDefaults standardUserDefaults] objectForKey:@"Album/Trash"];
    
    NSMutableArray *mutablearray = [array mutableCopy];
    
    NSMutableArray *mutablearrayTrash = [arrayTrash mutableCopy];
    
    [mutablearrayTrash addObject:array[_number]];
    
    [[NSUserDefaults standardUserDefaults] setObject:mutablearrayTrash forKey:@"Album/Trash"];
    
    [mutablearray removeObjectAtIndex:_number];
    
    [[NSUserDefaults standardUserDefaults] setObject:mutablearray forKey:_name];
    
    [self scrollViewReload];
    
}

/*!
 @abstract 上一张图片
 */
- (void)backPhoto
{
    if (_number == 0) return;
    CGPoint position = CGPointMake(DE_UISCREEN_WIDTH * _number - DE_UISCREEN_WIDTH, 0);
    [_photoScrollView setContentOffset:position animated:YES];
}

/*!
 @abstract 下一张图片
 */
- (void)morePhoto
{
    if (_number == self.photoArray.count - 1) return;
    CGPoint position = CGPointMake(DE_UISCREEN_WIDTH * _number + DE_UISCREEN_WIDTH, 0);
    [_photoScrollView setContentOffset:position animated:YES];
}

/*!
 @abstract 保存指定照片弹框
 */
- (void)savePhoto
{
    //创建Alert控制器
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Remind" message:@"Do you want to save this photos to the album?" preferredStyle:UIAlertControllerStyleAlert];
    
    //创建 Alert.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {        }];
    
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString *name  = [NSString stringWithFormat:@"%@",self.photoArray[_number]];
        
        [self loadImageFinished:[UIImage imageWithContentsOfFile:[_path stringByAppendingString:name]]];
    }];
    
    //添加 actions.
    [alertController addAction:cancelAction];
    [alertController addAction:deleteAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
/*!
 @abstract 保存指定照片方法
 */
- (void)loadImageFinished:(UIImage *)image
{
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        
        //写入图片到相册
        PHAssetChangeRequest *req = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        NSLog(@"%@",req);
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        
        NSLog(@"success = %d, error = %@", success, error);
    }];
}

/*!
 @abstract 底部按钮点击事件
 */
- (void)buttonClick:(UIButton *)button
{
    if (button.tag == 100) {//保存
        
        [self savePhoto];
        
    }else if (button.tag == 101) {//后退
        
        [self backPhoto];
        
    }else if (button.tag == 102) {//前进
        
        [self morePhoto];
        
    }else if (button.tag == 103) {//删除
        
        [self deletePhoto];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
