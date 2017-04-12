//
//  photoCell.m
//  Photo框架
//
//  Created by jorgon on 07/04/17.
//  Copyright © 2017年 jorgon. All rights reserved.
//

#import "photoCell.h"

@interface photoCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iPhotoImageView;

@end

@implementation photoCell

- (void)setImage:(UIImage *)image
{
    self.iPhotoImageView.image = image;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.iPhotoImageView.clipsToBounds = YES;
}

@end
