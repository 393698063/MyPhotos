//
//  smallPhotoViewController.m
//  Photo框架
//
//  Created by jorgon on 07/04/17.
//  Copyright © 2017年 jorgon. All rights reserved.
//
#define kScreenSize [UIScreen mainScreen].bounds.size
#import "QGSmallPhotoViewController.h"
#import "photoCell.h"
#import "QGbigPhotoViewController.h"
#import "QGCropViewController.h"

@interface QGSmallPhotoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, weak) UICollectionView * iCollectionView;
@property (nonatomic, strong) NSArray * iDataAry;
@property (nonatomic, strong) NSMutableArray * iSelectAry;
@end

@implementation QGSmallPhotoViewController

+ (void)enterSmallPhotoWithPhotos:(NSArray *)photos
                   viewController:(UIViewController *)parentVc
                            title:(NSString *)albumTitle
               selectImageHandler:(selectImageHandler)imageHandler
                selectDataHandler:(selectImageDataHandler)dataHandler
{
    BOOL isHave = [[QGPhotoMananger defaultPhotoManager] judgeIsHavePhotoAblumAuthority];
    if (!isHave) {
        return ;
    }
    QGSmallPhotoViewController * smc = [[QGSmallPhotoViewController alloc] init];
    smc.iDataAry = photos.mutableCopy;
    smc.iSelectIamgeHandler = imageHandler;
    smc.iSelectImageDataHandler = dataHandler;
    smc.title = albumTitle;
    [parentVc.navigationController pushViewController:smc animated:YES];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self prepareUI];
}
- (void)prepareUI
{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake((kScreenSize.width - 1 * 4) / 3, kScreenSize.width /3);
    layout.minimumLineSpacing = 1;
    layout.minimumInteritemSpacing = 1;
    layout.sectionInset = UIEdgeInsetsMake(1, 1, 1, 1);
    UICollectionView * collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height)
                                                           collectionViewLayout:layout];
    collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    [collectionView registerNib:[UINib nibWithNibName:@"photoCell" bundle:nil] forCellWithReuseIdentifier:@"photoCell"];
    
    [self.view addSubview:collectionView];
    self.iCollectionView = collectionView;
}
- (NSMutableArray *)iSelectAry
{
    if (_iSelectAry) {
        _iSelectAry = [NSMutableArray arrayWithCapacity:1];
    }
    return _iSelectAry;
}
#pragma mark - CollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.iDataAry.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    photoCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
    
    QGPhotoSelectList * list = [self.iDataAry objectAtIndex:indexPath.row];
    __weak typeof(self)weakSelf = self;
    [cell setPhoto:list selectHandler:^(BOOL selectState) {
        list.selectedState = selectState;
        [weakSelf.iSelectAry addObject:list];
    }];
    
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView
    didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSArray * selectArray = [NSArray arrayWithObject:self.iDataAry[indexPath.row]];
//    QGbigPhotoViewController * bvc = [QGbigPhotoViewController showBigPhotoWithImages:selectArray
    //                                                                        selectedIndex:0];
    //    [self.navigationController pushViewController:bvc animated:YES];
    
    QGPhotoSelectList * list = self.iDataAry[indexPath.row];
    [QGCropViewController cropImage:list.asset
                     viewController:self compeletion:^{
                         
                     }];
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
