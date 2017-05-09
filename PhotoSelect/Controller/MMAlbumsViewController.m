//
//  MMAlbumsViewController.m
//  PhotoSelect
//
//  Created by 齐云浩 on 2017/4/17.
//  Copyright © 2017年 齐云浩. All rights reserved.
//

#import "MMAlbumsViewController.h"
#import "MMPhotoCell.h"
#import "MMPhotoListViewController.h"
#import <Photos/Photos.h>
#import "MMPhotoView.h"


@interface MMAlbumsViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) UICollectionView *photoCollectionView;
@property (nonatomic) NSMutableArray *photoArray;
@property (nonatomic,strong) UIView *showView;
@property (nonatomic,strong) NSDictionary *info;
@property (nonatomic,strong) UIView *promptView;
@end

@implementation MMAlbumsViewController
@synthesize photoArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //获取相册内容
    self.photoArray = [[NSUserDefaults standardUserDefaults] objectForKey:_fileName];
    
    //加载UI界面
    [self makeUI];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.photoArray = [[NSUserDefaults standardUserDefaults] objectForKey:_fileName];
    
    [self.photoCollectionView reloadData];
}


#pragma mark - 懒加载
- (UICollectionView *)photoCollectionView
{
    if (_photoCollectionView == nil) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 1;
        layout.minimumLineSpacing = 1;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _photoCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, DE_UISCREEN_WIDTH, DE_UISCREEN_HEIGHT - 64) collectionViewLayout:layout];
        _photoCollectionView.delegate   = self;
        _photoCollectionView.dataSource = self;
        _photoCollectionView.showsVerticalScrollIndicator = NO;
        _photoCollectionView.bounces = YES;
        _photoCollectionView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_photoCollectionView];
        
        //处理item大小
        float photoX = (DE_UISCREEN_WIDTH - 3)/4;
        layout.itemSize = CGSizeMake(photoX, photoX);
        
        //注册cell
        [self.photoCollectionView registerNib:[UINib nibWithNibName:@"MMPhotoCell" bundle:nil] forCellWithReuseIdentifier:@"MMPhotoCell"];
    }
    return _photoCollectionView;
    
}

#pragma mark - 加载界面
/*!
 @abstract 加载UI界面
 */
- (void)makeUI
{
    //添加相片按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemAdd) target:self action:@selector(addPhoto)];
    if ([self.title isEqualToString:@"Trash"]) self.navigationItem.rightBarButtonItem = nil;
    
    //创建
    [self.photoCollectionView reloadData];
    
    //取消自动适应
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}
#pragma mark - collectionView 代理和数据源方法

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    MMPhotoCell *cell = (MMPhotoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"MMPhotoCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[MMPhotoCell alloc] init];
    }
    
    //读取并展示图片
    NSString *name = [NSString stringWithFormat:@"%@",self.photoArray[indexPath.row]];
    cell.Photo.image = [UIImage imageWithContentsOfFile:[_path stringByAppendingString:name]];
    cell.Photo.contentMode = UIViewContentModeScaleAspectFill;
    return cell;
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return  UIEdgeInsetsMake(0, 0, 0, 0);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    MMPhotoListViewController *svc = [[MMPhotoListViewController alloc] init];
    
    svc.photoArray = self.photoArray;
    svc.number = indexPath.row;
    svc.path = _path;
    svc.name = _fileName;
    
    [self.navigationController pushViewController:svc animated:YES];
    
}


#pragma mark - 点击添加图片
/*!
 @abstract 点击了添加图片按钮
 */
- (void)addPhoto
{
    //创建标题
    NSString *cancelButtonTitle = NSLocalizedString(@"Close", nil);
    NSString *CameraButtonTitle = NSLocalizedString(@"Camera", nil);
    NSString *PhotoButtonTitle  = NSLocalizedString(@"Photo Library", nil);
    
    //创建Action控制器
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    //创建 actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"Close.");
    }];
    
    UIAlertAction *CameraAction = [UIAlertAction actionWithTitle:CameraButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"Camera.");
        UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
        ipc.delegate      = self;
        ipc.allowsEditing = YES;
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            NSLog(@"相机不可用.");
            return;
        }
        ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:ipc animated:YES completion:nil];
    }];
    
    UIAlertAction *PhotoAction = [UIAlertAction actionWithTitle:PhotoButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"Photo.");
        
        [self selectImage];
        
    }];
    
    //添加 actions.
    [alertController addAction:cancelAction];
    [alertController addAction:PhotoAction];
    [alertController addAction:CameraAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - 相机
/*!
 @abstract 相册收回后添加图片数据到本地
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //获取图片
    UIImage *originImage = (UIImage *)info[UIImagePickerControllerOriginalImage];
    NSData *mData = nil;
    mData = UIImageJPEGRepresentation(originImage, 1.0);
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    //保存图片 Documents是指定路径
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //产生唯一标识
    NSString *pictureName = [[[NSProcessInfo processInfo] globallyUniqueString] stringByAppendingString:@".png"];
    
    //保存
    BOOL isSaved = [fileManager createFileAtPath:[_path stringByAppendingString:pictureName] contents:mData attributes:nil];
    NSLog(@"图片保存状态：%d",isSaved);
    
    //将路径保存到 NSUserDefaults 中
    NSMutableArray *picArray = [[NSMutableArray alloc]init];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:_fileName]==nil) {
        [[NSUserDefaults standardUserDefaults] setObject:picArray forKey:_fileName];
    }
    
    //新建临时数组来接收NSUserDefaults数据
    NSArray *tempNoteArray = [[NSUserDefaults standardUserDefaults] objectForKey:_fileName];
    NSMutableArray *mutableNoteArray = [tempNoteArray mutableCopy];
    [mutableNoteArray insertObject:pictureName atIndex:[mutableNoteArray count]];
    [[NSUserDefaults standardUserDefaults] setObject:mutableNoteArray forKey:_fileName];
    
}


#pragma mark - 多图添加
-(void)selectImage{
    MMPhotoView *photoController  = [[MMPhotoView alloc]init];
    //选择图片的最大数
    photoController.selectPhotoOfMax = 1000;
    //选择图片的回调
    [photoController showIn:self result:^(id responseObject) {
        NSArray *array = (NSArray *)responseObject;
        NSLog(@"%@",responseObject);
        
        NSMutableArray *urlArray = [[NSMutableArray alloc] init];
        
        //保存图片到应用的沙盒路径下
        for (int i = 0; i < array.count; i++) {
            
            NSDictionary *dict = array[i];
            
            [urlArray addObject:[dict objectForKey:@"asset"]];
            
            //获取图片
            UIImage *originImage = (UIImage *)[dict objectForKey:@"photo"];
            NSData *mData = nil;
            mData = UIImageJPEGRepresentation(originImage, 1.0);
            
            //产生唯一标识
            NSString *pictureName = [[[NSProcessInfo processInfo] globallyUniqueString] stringByAppendingString:@".png"];
            
            //保存图片 Documents为指定路径
            BOOL isSaved = [[NSFileManager defaultManager] createFileAtPath:[_path stringByAppendingString:pictureName] contents:mData attributes:nil];
            NSLog(@"图片保存状态：%d",isSaved);
            
            //新建临时数组来接收NSUserDefaults数据
            NSArray *tempNoteArray = [[NSUserDefaults standardUserDefaults] objectForKey:_fileName];
            NSMutableArray *mutableNoteArray = [tempNoteArray mutableCopy];
            NSString *textstring = pictureName;
            [mutableNoteArray insertObject:textstring atIndex:[mutableNoteArray count]];
            [[NSUserDefaults standardUserDefaults] setObject:mutableNoteArray forKey:_fileName];
            
        }
        
        //删除图片数组 添加延时器是为了防止白屏
        double delayInSeconds = 0.1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            [self dellArray:urlArray];
        });
        
    }];
}
/*!
 @abstract 删除指定图片
 */
- (void)dellArray:(NSMutableArray *)info
{
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        [PHAssetChangeRequest deleteAssets:info];//删除多张 直接添加
    } completionHandler:^(BOOL success, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
