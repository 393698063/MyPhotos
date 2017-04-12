//
//  SmartAlbumViewController.m
//  Photo框架
//
//  Created by jorgon on 07/04/17.
//  Copyright © 2017年 jorgon. All rights reserved.
//
#define kScreenSize [UIScreen mainScreen].bounds.size
#import "SmartAlbumViewController.h"
#import "QGPhotoMananger.h"
#import "albumCell.h"
#import "smallPhotoViewController.h"

@interface SmartAlbumViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, weak) UITableView * iTableView;
@end

@implementation SmartAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self prepareUI];
}

- (void)prepareUI
{
    
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenSize.width, kScreenSize.height - 64)
                                                           style:UITableViewStylePlain];
    tableView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    [self.view addSubview:tableView];
    tableView.dataSource = self;
    tableView.delegate = self;
    self.iTableView = tableView;
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataAry.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    albumCell * cell = [albumCell albumCellWithTableView:tableView];
    QGPhotoList * list = [self.dataAry objectAtIndex:indexPath.row];
    [cell setDataWithModel:list];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    smallPhotoViewController * phVc = [[smallPhotoViewController alloc] init];
    QGPhotoList * list = [self.dataAry objectAtIndex:indexPath.row];
    phVc.iDataAry = [[QGPhotoMananger defaultPhotoManager] getAssetsInAssetCollection:list.assetCollection ascending:YES];
    [self.navigationController pushViewController:phVc animated:YES];
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
