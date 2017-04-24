//
//  photoCell.h
//  Photo框架
//
//  Created by jorgon on 07/04/17.
//  Copyright © 2017年 jorgon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QGPhotoMananger.h"

@interface photoCell : UICollectionViewCell

- (void)setPhoto:(QGPhotoSelectList *)list selectHandler:(void(^)(BOOL selectState))selectHandler;
@end
