//
//  QGCropViewController.h
//  Photo框架
//
//  Created by jorgon on 19/04/17.
//  Copyright © 2017年 jorgon. All rights reserved.
//

#import "QGBaseViewController.h"
#import "QGPhotoMananger.h"

@interface QGCropViewController : QGBaseViewController
+ (void)cropImage:(PHAsset *)asset viewController:(UIViewController *)vc
      compeletion:(void(^)())aCompeletion;
@end
