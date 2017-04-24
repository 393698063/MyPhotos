//
//  QGBaseViewController.h
//  Photo框架
//
//  Created by jorgon on 18/04/17.
//  Copyright © 2017年 jorgon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QGPhotoMananger.h"

@interface QGBaseViewController : UIViewController
@property (nonatomic, copy) selectImageDataHandler iSelectImageDataHandler;
@property (nonatomic, copy) selectImageHandler iSelectIamgeHandler;
@end
