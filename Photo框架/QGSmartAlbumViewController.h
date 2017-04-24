//
//  SmartAlbumViewController.h
//  Photo框架
//
//  Created by jorgon on 07/04/17.
//  Copyright © 2017年 jorgon. All rights reserved.
//

#import "QGBaseViewController.h"

@interface QGSmartAlbumViewController : QGBaseViewController

+ (void)enterSmartAlbumWithAlbums:(NSArray *)albums
                   viewController:(UIViewController *)parentVc
                  selectImageHandler:(selectImageHandler)imageHandler
              selectDataHandler:(selectImageDataHandler)dataHandler;

@end
