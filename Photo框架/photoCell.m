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
@property (weak, nonatomic) IBOutlet UIButton *iSelectButton;
@property (nonatomic, copy) void (^iSelectHandler)(BOOL selectState);
@property (nonatomic, strong) QGPhotoSelectList * list;
@end

@implementation photoCell
- (void)setPhoto:(QGPhotoSelectList *)list selectHandler:(void (^)(BOOL selectState))selectHandler
{
    _list = list;
    self.iSelectHandler = selectHandler;
    [[QGPhotoMananger defaultPhotoManager] getImageByAsset:list.asset
                                                  makeSize:CGSizeMake(200, 200)
                                            makeResizeMode:PHImageRequestOptionsResizeModeExact
                                                completion:^(UIImage *AssetImage)
     {
         self.iPhotoImageView.image = AssetImage;
     }];
    self.iSelectButton.selected = list.selectedState;
}
- (IBAction)selectPhoto:(UIButton *)button
{
    button.selected = !button.selected;
    self.iSelectHandler(button.selected);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.iPhotoImageView.clipsToBounds = YES;
}

@end
