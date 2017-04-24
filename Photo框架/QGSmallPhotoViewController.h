//
//  smallPhotoViewController.h
//  Photo框架
//
//  Created by jorgon on 07/04/17.
//  Copyright © 2017年 jorgon. All rights reserved.
//

#import "QGBaseViewController.h"

@interface QGSmallPhotoViewController : QGBaseViewController

+ (void)enterSmallPhotoWithPhotos:(NSArray *)photos
                   viewController:(UIViewController *)parentVc
                            title:(NSString *)albumTitle
               selectImageHandler:(selectImageHandler)imageHandler
                selectDataHandler:(selectImageDataHandler)dataHandler;
@end
