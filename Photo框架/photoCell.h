//
//  photoCell.h
//  Photo框架
//
//  Created by jorgon on 07/04/17.
//  Copyright © 2017年 jorgon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface photoCell : UICollectionViewCell

+ (id)photoCellWithCollectionView:(UICollectionView *)collectionView;
- (void)setImage:(UIImage *)image;
@end
