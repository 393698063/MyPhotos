//
//  SmartAlbumViewController.m
//  Photo框架
//
//  Created by jorgon on 07/04/17.
//  Copyright © 2017年 jorgon. All rights reserved.
//
#define kScreenSize [UIScreen mainScreen].bounds.size
#import "QGSmartAlbumViewController.h"
#import "QGBaseNavigationViewController.h"
#import "albumCell.h"
#import "QGSmallPhotoViewController.h"

@interface QGSmartAlbumViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, weak) UITableView * iTableView;
@property (nonatomic, strong) NSArray *  iDataAry;
@end

@implementation QGSmartAlbumViewController

+ (void)enterSmartAlbumWithAlbums:(NSArray *)albums
                 viewController:(UIViewController *)parentVc
             selectImageHandler:(selectImageHandler)imageHandler
              selectDataHandler:(selectImageDataHandler)dataHandler
{
    BOOL isHave = [[QGPhotoMananger defaultPhotoManager] judgeIsHavePhotoAblumAuthority];
    if (!isHave) {
        return ;
    }
    QGSmartAlbumViewController * smc = [[QGSmartAlbumViewController alloc] init];
    smc.iDataAry = albums.mutableCopy;
    smc.iSelectIamgeHandler = imageHandler;
    smc.iSelectImageDataHandler = dataHandler;
    QGBaseNavigationViewController * nvc = [[QGBaseNavigationViewController alloc] initWithRootViewController:smc];
    [parentVc presentViewController:nvc animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self prepareUI];
}

- (void)prepareUI
{
    self.title = @"照片";
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenSize.width, kScreenSize.height - 64)
                                                           style:UITableViewStylePlain];
    tableView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    tableView.estimatedRowHeight = 80.0f;
    [self.view addSubview:tableView];
    tableView.dataSource = self;
    tableView.delegate = self;
    self.iTableView = tableView;
    
    CGFloat x = 0;
    CGFloat h = 44;
    CGFloat y = self.view.bounds.size.height - 44;
    CGFloat w = self.view.bounds.size.width;
    UIToolbar * toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(x, y, w, h)];
    [toolbar setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:toolbar];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.iDataAry.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    albumCell * cell = [albumCell albumCellWithTableView:tableView];
    QGPhotoList * list = [self.iDataAry objectAtIndex:indexPath.row];
    [cell setDataWithModel:list];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    QGPhotoList * list = [self.iDataAry objectAtIndex:indexPath.row];
    NSArray * listAry = [[QGPhotoMananger defaultPhotoManager] getAssetsInAssetCollection:list.assetCollection ascending:YES];
    NSMutableArray * dataAry = [NSMutableArray arrayWithCapacity:1];
    [listAry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        QGPhotoSelectList * sList = [[QGPhotoSelectList alloc] init];
        sList.asset = (PHAsset *)obj;
        sList.selectedState = NO;
        [dataAry addObject:sList];
    }];
    [QGSmallPhotoViewController enterSmallPhotoWithPhotos:dataAry
                                           viewController:self
                                                    title:list.title
                                       selectImageHandler:self.iSelectIamgeHandler
                                        selectDataHandler:self.iSelectImageDataHandler];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    NSLog(@"%s",__func__);
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
