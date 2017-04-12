//
//  albumCell.m
//  Photo框架
//
//  Created by jorgon on 07/04/17.
//  Copyright © 2017年 jorgon. All rights reserved.
//

#import "albumCell.h"

@interface albumCell ()
@property (weak, nonatomic) IBOutlet UIImageView *albumImageView;
@property (weak, nonatomic) IBOutlet UILabel *albumTitleLabel;

@end

@implementation albumCell

+ (id)albumCellWithTableView:(UITableView *)tableView
{
    albumCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
    }
    return cell;
}
- (void)setDataWithModel:(QGPhotoList *)list
{
    [[QGPhotoMananger defaultPhotoManager] getImageByAsset:list.firstAsset
                                                  makeSize:CGSizeMake(80, 80)
                                            makeResizeMode:PHImageRequestOptionsResizeModeNone completion:^(UIImage *AssetImage) {
                                                self.albumImageView.image = AssetImage;
                                            }];
    self.albumTitleLabel.text = list.title;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.albumImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
