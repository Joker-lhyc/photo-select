//
//  MMPhotoPickerViewController.m
//  PhotoSelect
//
//  Created by 齐云浩 on 2017/4/17.
//  Copyright © 2017年 齐云浩. All rights reserved.
//

#import "MMPhotoPickerViewController.h"
#import "MMPhotoDatas.h"
#import "MMPhotoPickerCell.h"
@interface MMPhotoPickerViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) NSMutableArray *photoArray;//展示图片数组

@property (strong, nonatomic) NSMutableArray *selectArray;//选中图片数组

@property (strong, nonatomic) UICollectionView *picsCollection;//展示图片用CollectionView

@property (strong, nonatomic) UIButton *selectBtn;//选中按钮

@property (assign, nonatomic) BOOL isSelect;//是否选中状态

@property (strong, nonatomic) UIBarButtonItem *cancelBtn;//取消按钮

@property (strong, nonatomic) UIButton *doneBtn;//完成按钮

@property (strong, nonatomic) UILabel *totalNumLabel;//显示图片总数量lable

@property (strong, nonatomic) MMPhotoDatas *datas;//图片数据模型
@end

@implementation MMPhotoPickerViewController

/*!
 @abstract 完成按钮 点击后返回选中图片
 */
-(UIButton *)doneBtn{
    if (!_doneBtn) {
        _doneBtn = [[UIButton alloc]initWithFrame:CGRectMake(DE_UISCREEN_WIDTH - 60, 0, 50, 44)];
        [_doneBtn addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
        _doneBtn.titleLabel.font = [UIFont systemFontOfSize:17.0f];
        [_doneBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:17]];
        [_doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_doneBtn setTitle:@"Done" forState:UIControlStateNormal];
        [_doneBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        
    }
    return _doneBtn;
}

/*!
 @abstract 取消所有操作 收回相册视图
 */
-(void)cancel{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*!
 @abstract 返回选中图片
 */
-(void)done{
    if ([self.selectArray count] == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        NSMutableArray *photos = [NSMutableArray array];
        for (int i = 0; i < self.selectArray.count; i++) {
            id asset = [self.selectArray objectAtIndex:i];
            [self.datas getImageObject:asset complection:^(UIImage *photo,PHAsset *asset, BOOL isDegraded) {
                if (isDegraded) {
                    return;
                }
                if (photo) {
                    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:photo,@"photo",asset,@"asset", nil];
                    [photos addObject:dict];
                }
                if (photos.count < self.selectArray.count) {
                    return;
                }
                if (self.PhotoResult) {
                    self.PhotoResult(photos);
                }
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
        }
    }
}

-(NSMutableArray *)photoArray{
    if (!_photoArray) {
        _photoArray = [NSMutableArray array];
    }
    return _photoArray;
}
-(NSMutableArray *)selectArray{
    if (!_selectArray) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}
#pragma mark - 加载图片数据
-(MMPhotoDatas *)datas{
    if (!_datas) {
        _datas = [[MMPhotoDatas alloc]init];
    }
    return _datas;
}
#pragma mark - 显示照片数量的Label
-(UILabel *)totalNumLabel{
    if (!_totalNumLabel) {
        _totalNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, DE_UISCREEN_WIDTH, 20)];
        _totalNumLabel.textColor = [UIColor blackColor];
        _totalNumLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _totalNumLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initInterUI];
    
    [self loadPhotoData];
    // 更新UI
    [self setupCollectionViewUI];
    //创建底部工具栏
    [self setUpTabbar];
}
-(void)setUpTabbar
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1.0];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:self.doneBtn];
    [self.view addSubview:view];
    
    _totalNumLabel.frame = CGRectMake(50, 0, DE_UISCREEN_WIDTH - 100, 44);
    [view addSubview:_totalNumLabel];
    
    UIView *viewLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DE_UISCREEN_WIDTH, 1)];
    viewLine.backgroundColor =[UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1.0];
    [view addSubview:viewLine];
    
    NSLayoutConstraint *tab_bottom = [NSLayoutConstraint constraintWithItem:_picsCollection attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTop multiplier:1 constant:0.0f];
    
    NSLayoutConstraint *tab_width = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:DE_UISCREEN_WIDTH];
    
    NSLayoutConstraint *tab_height = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44];
    
    [self.view addConstraints:@[tab_bottom,tab_width,tab_height]];
    
    
}

-(void)setupCollectionViewUI
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    
    CGFloat photoSize = ([UIScreen mainScreen].bounds.size.width - 3) / 4;
    flowLayout.minimumInteritemSpacing = 1.0;//item 之间的行的距离
    flowLayout.minimumLineSpacing = 1.0;//item 之间竖的距离
    flowLayout.itemSize = (CGSize){photoSize,photoSize};
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _picsCollection = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [_picsCollection registerClass:[MMPhotoPickerCell class] forCellWithReuseIdentifier:@"PhotoPickerCell"];
    [_picsCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];
    flowLayout.footerReferenceSize = CGSizeMake(DE_UISCREEN_WIDTH, 70);
    _picsCollection.delegate = self;
    _picsCollection.dataSource = self;
    _picsCollection.backgroundColor = [UIColor whiteColor];
    [_picsCollection setUserInteractionEnabled:YES];
    _picsCollection.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_picsCollection];
    [_picsCollection reloadData];
    
    
    NSLayoutConstraint *pic_top = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_picsCollection attribute:NSLayoutAttributeTop multiplier:1 constant:-64.0f];
    
    NSLayoutConstraint *pic_bottom = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_picsCollection attribute:NSLayoutAttributeBottom multiplier:1 constant:44.0f];
    
    NSLayoutConstraint *pic_left = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_picsCollection attribute:NSLayoutAttributeLeft multiplier:1 constant:0.0f];
    
    NSLayoutConstraint *pic_right = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_picsCollection attribute:NSLayoutAttributeRight multiplier:1 constant:0.0f];
    
    [self.view addConstraints:@[pic_top,pic_bottom,pic_left,pic_right]];
    
}

- (void)initInterUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = cancelButton;
    
    [self initBackButton];
}
-(void)loadPhotoData{
    if (_isAlubSeclect == YES) {
        
        self.photoArray = [self.datas getPhotoAssets:_fetch];
        [self refreshTotalNumLabelData:_photoArray.count];
        
    }else{
        self.photoArray = [self.datas getPhotoAssets:[self.datas getCameraRollFetchResul]];
        [self refreshTotalNumLabelData:_photoArray.count];
    }
}
-(void)refreshTotalNumLabelData:(NSInteger)totalNum
{
    self.totalNumLabel.text = [NSString stringWithFormat:@"%ld Photos",(long)totalNum];
    NSLog(@"%ld",(long)totalNum);
}
#pragma mark - 选中的在数组中添加，取消的从数组中减少
-(void)selectPicBtn:(UIButton *)button{
    NSInteger index = button.tag;
    if (button.selected == NO) {
        [self shakeToShow:button];
        if (self.selectArray.count + 1 > _selectNum) {
            [self showSelectPhotoAlertView:_selectNum];
        }else{
            [self.selectArray addObject:[self.photoArray objectAtIndex:index]];
            [button setImage:[UIImage imageNamed:@"select_yes.png"] forState:UIControlStateNormal];
            button.selected = YES;
        }
    }else{
        [self shakeToShow:button];
        [self.selectArray removeObject:[self.photoArray objectAtIndex:index]];
        [button setImage:[UIImage imageNamed:@"select_no.png"] forState:UIControlStateNormal];
        button.selected = NO;
    }
    
    self.totalNumLabel.text = [NSString stringWithFormat:@"selected %ld Photos",(unsigned long)self.selectArray.count];
}
#pragma mark - 列表中按钮点击动画效果
-(void)shakeToShow:(UIButton *)button{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [button.layer addAnimation:animation forKey:nil];
}
#pragma UICollectionView --- Datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photoArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MMPhotoPickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoPickerCell" forIndexPath:indexPath];
    cell.selectBtn.tag = indexPath.row;
    [cell.selectBtn addTarget:self action:@selector(selectPicBtn:) forControlEvents:UIControlEventTouchUpInside];
    [cell loadPhotoData:[self.photoArray objectAtIndex:indexPath.row]];
    [cell selectBtnStage:self.selectArray existence:[self.photoArray objectAtIndex:indexPath.row]];
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath

{
    UICollectionReusableView *footerView = [[UICollectionReusableView alloc]init];
    footerView.backgroundColor = [UIColor redColor];
    if (kind == UICollectionElementKindSectionFooter){
        footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
    }

    return footerView;
    
}
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}
-(void)showSelectPhotoAlertView:(NSInteger)photoNumOfMax
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Remind" message:[NSString stringWithFormat:@"Can only choose %ld pictures",(long)photoNumOfMax]preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        
    }];
    
    [alert addAction:action1];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
