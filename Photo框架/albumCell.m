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
@property (weak, nonatomic) IBOutlet UILabel *photoCountLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *albumTitleLabelWidthConstraint;

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
    NSDictionary *attributes = @{NSFontAttributeName:self.albumTitleLabel.font};
    NSInteger options = NSStringDrawingUsesFontLeading |
    NSStringDrawingTruncatesLastVisibleLine |
    NSStringDrawingUsesLineFragmentOrigin;
    CGRect stringRect = [list.title boundingRectWithSize:CGSizeMake(MAXFLOAT, self.albumTitleLabel.font.lineHeight)
                                                 options:options attributes:attributes context:NULL];
    CGFloat width = ceil(stringRect.size.width);
    self.albumTitleLabelWidthConstraint.constant = width < 100?width:100;
    self.albumTitleLabel.text = list.title;
    self.photoCountLabel.text = [NSString stringWithFormat:@"(%ld)",list.photoNum];
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
