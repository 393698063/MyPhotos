//
//  QGCropViewController.m
//  Photo框架
//
//  Created by jorgon on 19/04/17.
//  Copyright © 2017年 jorgon. All rights reserved.
//

#import "QGCropViewController.h"

@interface QGCropViewController ()<UIScrollViewDelegate>
@property (nonatomic, weak) UIScrollView * iScrollView;
@property (nonatomic, strong) PHAsset * iOriginAsset;
@property (nonatomic, weak) UIView * iCropView;
@property (nonatomic, weak) UIImageView * iImageView;
@property (nonatomic, weak) UIImage * iImage;
@end

@implementation QGCropViewController

+ (void)cropImage:(PHAsset *)asset
   viewController:(UIViewController *)vc
      compeletion:(void (^)())aCompeletion
{
    QGCropViewController * cvc = [[QGCropViewController alloc] init];
    cvc.iOriginAsset = asset;
    [vc.navigationController pushViewController:cvc animated:YES];
    cvc.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self prepareUI];
}
- (void)prepareUI
{
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationController.navigationBarHidden = YES;
    UIScrollView * scrollView = [[UIScrollView alloc] init];
    CGFloat width = self.view.bounds.size.width;
    CGFloat height = self.view.bounds.size.width * 0.8;
    scrollView.frame = CGRectMake(0, 0, width, height);
    scrollView.center = self.view.center;
    scrollView.backgroundColor = [UIColor cyanColor];
    scrollView.bounces = NO;
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    scrollView.showsHorizontalScrollIndicator = NO;
    
    __weak typeof(self)weakSelf = self;
    [[QGPhotoMananger defaultPhotoManager] getImageByAsset:self.iOriginAsset
                                                  makeSize:PHImageManagerMaximumSize
                                            makeResizeMode:PHImageRequestOptionsResizeModeNone completion:^(UIImage *AssetImage)
     {
         weakSelf.iImage = AssetImage;
         UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, AssetImage.size.height * width /AssetImage.size.width)];
//         imageView.center = weakSelf.view.center;
         imageView.image = AssetImage;
         [scrollView addSubview:imageView];
         UIPinchGestureRecognizer * pin = [[UIPinchGestureRecognizer alloc] initWithTarget:weakSelf
                                                                                    action:@selector(pinAction:)];
         imageView.userInteractionEnabled = YES;
         [weakSelf.view addGestureRecognizer:pin];
//         [imageView addGestureRecognizer:pin];
         weakSelf.iImageView = imageView;
     }];
    
    
    scrollView.contentSize = self.iImageView.frame.size;
    self.iScrollView = scrollView;
    [self.view addSubview:scrollView];
    
    UIView * cropView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
    cropView.center = self.view.center;
    cropView.backgroundColor = [UIColor clearColor];
    cropView.layer.borderWidth = 1;
    cropView.layer.borderColor = [UIColor whiteColor].CGColor;
    cropView.userInteractionEnabled = NO;
    [self.view addSubview:cropView];
    self.iCropView = cropView;
    
    
    CGFloat x = 0;
    CGFloat h = 44;
    CGFloat y = self.view.bounds.size.height - 44;
    CGFloat w = self.view.bounds.size.width;
    UIToolbar * toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(x, y, w, h)];
    [toolbar setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:toolbar];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 44, 30);
    [button setTitle:@"完成" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(cutImage:) forControlEvents:UIControlEventTouchUpInside];
    [toolbar addSubview:button];
    
    UIButton * canbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    canbutton.frame = CGRectMake(toolbar.frame.size.width - 44, 0, 44, 30);
    [canbutton setTitle:@"取消" forState:UIControlStateNormal];
    [canbutton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [toolbar addSubview:canbutton];

}

- (void)cutImage:(UIButton *)btn
{
    [self crop];
}
- (void)cancel:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
    self.navigationController.navigationBarHidden = NO;
}
- (void)crop{
    CGRect cropFrame = self.iCropView.frame;
    CGFloat orgX = cropFrame.origin.x * (self.iImage.size.width / self.iImageView.frame.size.width);
    CGFloat orgY = cropFrame.origin.y * (self.iImage.size.height / self.iImageView.frame.size.height);
    CGFloat width = cropFrame.size.width * (self.iImage.size.width / self.iImageView.frame.size.width);
    CGFloat height = cropFrame.size.height * (self.iImage.size.height / self.iImageView.frame.size.height);
    CGRect cropRect = CGRectMake(orgX, orgY, width, height);
    CGImageRef imgRef = CGImageCreateWithImageInRect(self.iImage.CGImage, cropRect);
    
    CGFloat deviceScale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(cropFrame.size, 0, deviceScale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, cropFrame.size.height);
    CGContextScaleCTM(context, 1, -1);
    CGContextDrawImage(context, CGRectMake(0, 0, cropFrame.size.width, cropFrame.size.height), imgRef);
    UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
    CGImageRelease(imgRef);
    UIGraphicsEndImageContext();
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        
        //写入图片到相册
        
        NSMutableArray * localIds = [NSMutableArray arrayWithCapacity:1];
        PHAssetChangeRequest *req = [PHAssetChangeRequest creationRequestForAssetFromImage:newImg];
        [localIds addObject:req.placeholderForCreatedAsset.localIdentifier];
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        
        NSLog(@"success = %d, error = %@", success, error);
        if (success) {
            
        }
        
    }];
}

- (void)pinAction:(UIPinchGestureRecognizer *)gesture
{
    UIView * view = self.iImageView;
    NSLog(@"%f",gesture.scale);
    CGRect originframe = view.frame;
    originframe.size.width = originframe.size.width * gesture.scale;
    originframe.size.height = originframe.size.height * gesture.scale;
    originframe.origin.x = originframe.origin.x - (originframe.size.width - view.frame.size.width) * 0.5;
    originframe.origin.y = originframe.origin.y - (originframe.size.height - view.frame.size.height) * 0.5;
    view.frame = originframe;
    
    self.iScrollView.contentSize = CGSizeMake(originframe.size.width, originframe.size.height);
//    view.center = self.iScrollView.center;

    gesture.scale = 1;
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return scrollView.subviews.firstObject;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"%s",__func__);
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
