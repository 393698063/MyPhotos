//
//  bigPhotoViewController.m
//  Photo框架
//
//  Created by jorgon on 18/04/17.
//  Copyright © 2017年 jorgon. All rights reserved.
//

#import "QGbigPhotoViewController.h"
#import "QGPhotoMananger.h"


@interface QGbigPhotoViewController ()
@property (nonatomic, strong) NSArray * images;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, weak) UIScrollView * iScrollView;
@end

@implementation QGbigPhotoViewController

+ (id)showBigPhotoWithImages:(NSArray *)images selectedIndex:(NSInteger)index
{
    QGbigPhotoViewController * bvc = [[QGbigPhotoViewController alloc] init];
    
    bvc.images = [NSArray arrayWithArray:images];
    bvc.index = index;
    return bvc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpUi];
}
- (BOOL)prefersStatusBarHidden
{
    return YES;
}
- (void)setUpUi
{
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationController.navigationBarHidden = YES;
    UIScrollView * scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    scrollView.bounces = NO;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    CGFloat width = scrollView.bounds.size.width;
    CGFloat height = scrollView.bounds.size.width * 0.8;
    [self.images enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView * imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(width * idx, 0, width, height);
        
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [scrollView addSubview:imageView];
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back:)];
        [imageView addGestureRecognizer:tap];
        [[QGPhotoMananger defaultPhotoManager] getImageByAsset:((QGPhotoSelectList *)obj).asset
                                                      makeSize:PHImageManagerMaximumSize
                                                makeResizeMode:PHImageRequestOptionsResizeModeExact
                                                    completion:^(UIImage *AssetImage)
         {
             [imageView setImage:AssetImage];
             imageView.frame = CGRectMake(width * idx, 0, width, AssetImage.size.height * width /AssetImage.size.width);
             imageView.center = scrollView.center;
         }];
    }];
    scrollView.contentSize = CGSizeMake(width * self.images.count, height);
    scrollView.contentOffset = CGPointMake(width * self.index, 0);
    self.iScrollView = scrollView;
    [self.view addSubview:scrollView];
}
- (void)back:(UITapGestureRecognizer *)tap
{
    [self.navigationController popViewControllerAnimated:YES];
    self.navigationController.navigationBarHidden = NO;
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
