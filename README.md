# photo-select
Photo album multiple choices, Album image local save.


#import "LHBaseViewController.h"          //基类控制器 其余控制器集成自本控制器

#import "LHNavigationController.h"        //重写导航栏

#import "MMAlbumsAddViewController.h"     //添加相册控制器

#import "MMAlbumsListViewController.h"    //相册列表控制器 当删除图片后自动展示垃圾箱cell

#import "MMAlbumsViewController.h"        //相册内容控制器 含添加多张图片&删除选中图片功能 请小心选择删除功能

#import "MMPhotoListViewController.h"     //图片列表控制器 含删除应用内图片功能 删除后在垃圾桶内可找到 含保存图片到本地功能

#import "MMPhotoLibraryViewController.h"  //相册列表控制器 读取并展示本地相册内容

#import "MMPhotoPickerViewController.h"   //相册内容控制器 用于选择所需图片


