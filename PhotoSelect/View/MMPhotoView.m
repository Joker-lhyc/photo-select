//
//  MMPhotoView.m
//  MMCalculator
//
//  Created by 齐云浩 on 2017/4/12.
//
//

#import "MMPhotoView.h"
#import "MMPhotoLibraryViewController.h"
#import "MMPhotoPickerViewController.h"

@interface MMPhotoView ()

@property (strong, nonatomic) MMPhotoLibraryViewController *photoListController;

@property (strong, nonatomic) UINavigationController *photoListNavigationController;

@property (strong, nonatomic) MMPhotoPickerViewController *photoPickerController;

@end

@implementation MMPhotoView

#pragma mark - 懒加载
-(MMPhotoLibraryViewController *)photoListController{
    if (!_photoListController) {
        _photoListController = [[MMPhotoLibraryViewController alloc]init];
    }
    return _photoListController;
}
-(UINavigationController *)photoListNavigationController{
    if (!_photoListNavigationController) {
        _photoListNavigationController = [[UINavigationController alloc]initWithRootViewController:self.photoListController];
    }
    return _photoListNavigationController;
}
-(MMPhotoPickerViewController *)photoPickerController{
    if (!_photoPickerController) {
        _photoPickerController = [[MMPhotoPickerViewController alloc]init];
    }
    return _photoPickerController;
}
#pragma mark - 弹出控制器
-(void)showIn:(UIViewController *)controller result:(MMPhotoResult)result{
    
    //相册权限判断
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusDenied) {
        //相册权限未开启
        [self showAlertViewToController:controller];
        
    }else if(status == PHAuthorizationStatusNotDetermined){
        //相册进行授权
        /* * * 第一次安装应用时直接进行这个判断进行授权 * * */
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
            //授权后直接打开照片库
            if (status == PHAuthorizationStatusAuthorized){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showController:controller result:result];
                });
                
            }
        }];
    }else if (status == PHAuthorizationStatusAuthorized){
        [self showController:controller result:result];
    }
}
-(void)showController:(UIViewController *)controller result:(MMPhotoResult)result
{
    //授权完成，打开相册
    //Block传值
    self.photoListController.photoResult = result;
    
    //设定最多选择照片的张数
    self.photoListController.selectNum = _selectPhotoOfMax;
    [self showPhotoList:controller];
    
    
    //Block传值
    self.photoPickerController.PhotoResult = result;
    self.photoPickerController.isAlubSeclect = NO;
    //设定最多选择照片的张数
    self.photoPickerController.selectNum = _selectPhotoOfMax;
}
-(void)showPhotoList:(UIViewController *)controller
{
    [controller presentViewController:self.photoListNavigationController animated:YES completion:nil];
}

-(void)showAlertViewToController:(UIViewController *)controller
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app名称
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Remind" message:[NSString stringWithFormat:@"Please open your iPhone access %@ Settings - > > Privacy photos mobile phone photo album",app_Name] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        
    }];
    
    [alert addAction:action1];
    [controller presentViewController:alert animated:YES completion:nil];
}

@end
