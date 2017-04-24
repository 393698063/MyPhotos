//
//  QGPhotoMananger.h
//  Photo框架
//
//  Created by jorgon on 06/04/17.
//  Copyright © 2017年 jorgon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>

/**
 * 选择的照片回调
 */
typedef void(^selectImageHandler)(NSArray * imagesAry);
/**
 * 选择的照片二进制数据回调
 */
typedef void(^selectImageDataHandler)(NSArray * dataAry);


@interface QGPhotoModel : NSObject

/**
*  通过asset取到照片
*/
@property(nonatomic,strong)PHAsset * asset;
/**
 *  照片的名字
 */
@property(nonatomic,strong)NSString * imageName;


@end

@interface QGPhotoList : NSObject
/**
 *  相册的名字
 */
@property(nonatomic,strong)NSString * title;
/**
 *  该相册的照片数量
 */
@property(nonatomic,assign)NSInteger  photoNum;
/**
 *  该相册的第一张图片
 */
@property(nonatomic,strong)PHAsset * firstAsset;

/**
 * 该相册的第一张图片
 */
@property(nonatomic,strong)UIImage * posterImage;

/**
 *  同过该属性可以取得该相册的所有照片
 */
@property(nonatomic,strong)PHAssetCollection * assetCollection;
@end


@interface QGPhotoSelectList : NSObject

/**
 *  图片
 */
@property (nonatomic, strong) PHAsset * asset;

/**
 * 选中状态
 */
@property (nonatomic, assign) BOOL selectedState;

@end

@interface QGPhotoMananger : NSObject

typedef void(^takePhotoBlock)(QGPhotoModel * model);

+ (id)defaultPhotoManager;

/**
 *  判断相册使用权限
 */

- (BOOL)judgeIsHavePhotoAblumAuthority;

/**
 *  获得所有的相册
 *
 *  @return  FZJPhotoList样式的相册
 */

-(NSArray<QGPhotoList *> *)getAllPhotoList;

/**
 *  取到对应的照片实体
 *
 *  @param asset      索取照片实体的媒介
 *  @param size       实际想要的照片大小
 *  @param resizeMode 控制照片尺寸
 *  @param completion block返回照片实体
 */

-(void)getImageByAsset:(PHAsset *)asset
              makeSize:(CGSize)size
        makeResizeMode:(PHImageRequestOptionsResizeMode)resizeMode
            completion:(void (^)(UIImage * AssetImage))completion;

/**
 *  取到对应的照片实体
 *
 *  @param asset      索取照片实体的媒介
 *  @param size       实际想要的照片大小
 *  @param resizeMode 控制照片尺寸 若想要原尺寸则可输入PHImageManagerMaximumSize
 *  @param deliveryMode 控制照片质量
 *  @param completion 返回照片实体
 */

- (void)getImageByAsset:(PHAsset *)asset makeSize:(CGSize)size
         makeResizeMode:(PHImageRequestOptionsResizeMode)resizeMode
           deliveryMode:(PHImageRequestOptionsDeliveryMode)deliveryMode
             completion:(void (^)(UIImage *))completion;

/**
 *   取得所有的照片资源
 *
 *  @param ascending 排序方式
 *
 *  @return 照片资源
 */

-(NSArray<PHAsset *> *)getAllAssetInPhotoAblumWithAscending:(BOOL)ascending;

/**
 *   取得所有的照片资源
 *
 *  @param LocalIdentifiers 照片本地标示
 *
 *  @return 照片资源
 */
- (NSArray<PHAsset *> *)getAssetWithLocalIdentifiers:(NSArray<NSString *> *)LocalIdentifiers;

/**
 *  获取指定相册内的所有图片
 */
- (NSArray<PHAsset *> *)getAssetsInAssetCollection:(PHAssetCollection *)assetCollection
                                         ascending:(BOOL)ascending;

/**
 * 照相
 */

- (void)takePhotoWithViewController:(UIViewController *)viewController
                        compeletion:(takePhotoBlock)aCompeletion;
@end


