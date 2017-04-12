//
//  QGPhotoMananger.m
//  Photo框架
//
//  Created by jorgon on 06/04/17.
//  Copyright © 2017年 jorgon. All rights reserved.
//

#define kSystemVersion [UIDevice currentDevice].systemVersion.floatValue

#define kVersion 9.0

#import "QGPhotoMananger.h"



@interface QGPhotoMananger ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, copy) takePhotoBlock iPhotoBlock;
@property (nonatomic, strong) ALAssetsLibrary * iAssetLibrary;
@end

@implementation QGPhotoMananger

static QGPhotoMananger * manager = nil;

+ (id)defaultPhotoManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager) {
             manager = [[self alloc] init];
        }
    });
    return manager;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.iAssetLibrary = [[ALAssetsLibrary alloc] init];
    }
    return self;
}
/**
 *相册的使用权限
 */
- (BOOL)judgeIsHavePhotoAblumAuthority
{
    BOOL rtn = YES;
    if (kSystemVersion >= kVersion)
    {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusRestricted ||
            status == PHAuthorizationStatusDenied) {
            rtn = NO;
        }
    }
    else
    {
        ALAuthorizationStatus state = [ALAssetsLibrary authorizationStatus];
        if (state == ALAuthorizationStatusRestricted ||
            state == ALAuthorizationStatusDenied) {
            rtn = NO;
        }
    }
    return rtn;
}
/**
 *相机的使用权限
 */
- (BOOL)judgeIsHaveCameraAuthority
{
    BOOL rtn = YES;
    if (kSystemVersion >= kVersion)
    {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusRestricted ||
            status == AVAuthorizationStatusDenied) {
            rtn = NO;
        }
    }
    else
    {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusRestricted ||
            status == AVAuthorizationStatusDenied)
        {
            rtn = NO;
        }
    }
    return rtn;
    
}

//PHFetchResult，相册管理类，通过这个这类我们能获取到系统相册及用户自定义相册
- (PHFetchResult *)fetchAssetsInAssetCollection:(PHAssetCollection *)assetCollection ascending:(BOOL)ascending
{
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:ascending]];
#warning //PHAsset，这个类相当于一张照片的实体，但是我们必须通过处理才能变成可见的照片，
    // 拿到一张照片的asset便如老框架拿到一张照片的本地路径url
    PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:assetCollection options:option];
    return result;
}

- (NSString *)transformAblumTitle:(NSString *)title
{
    if ([title isEqualToString:@"Slo-mo"]) {
        return @"慢动作";
    } else if ([title isEqualToString:@"Recently Added"]) {
        return @"最近添加";
    } else if ([title isEqualToString:@"Favorites"]) {
        return @"最爱";
    } else if ([title isEqualToString:@"Recently Deleted"]) {
        return @"最近删除";
    } else if ([title isEqualToString:@"Videos"]) {
        return @"视频";
    } else if ([title isEqualToString:@"All Photos"]) {
        return @"所有照片";
    } else if ([title isEqualToString:@"Selfies"]) {
        return @"自拍";
    } else if ([title isEqualToString:@"Screenshots"]) {
        return @"屏幕快照";
    } else if ([title isEqualToString:@"Camera Roll"]) {
        return @"相机胶卷";
    }else if ([title isEqualToString:@"My Photo Stream"]){
        return @"我的照片流";
    }
    return nil;
}

/**
 *获取所有相册
 */
- (NSArray<QGPhotoList *> *)getAllPhotoList
{
    
    if (![self judgeIsHavePhotoAblumAuthority])
    {
        NSLog(@"no access");
        return nil;
    }
    NSMutableArray<QGPhotoList *> * photoList = [NSMutableArray arrayWithCapacity:1];
    
    if (kSystemVersion >= kVersion)
    {
        //PHFetchResult，相册管理类，通过这个这类我们能获取到系统相册及用户自定义相册
        /*
         PHAssetCollection，相册对象类，即我们需要对单个相册做处理以获得相册的相关参数，
         比如相册名、该相册包含的照片数量等。
         */
        PHFetchResult * smartAlbum = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                                              subtype:PHAssetCollectionSubtypeAlbumRegular
                                                                              options:nil];
        [smartAlbum enumerateObjectsUsingBlock:^(PHAssetCollection *  _Nonnull collection, NSUInteger idx, BOOL * _Nonnull stop)
         {
             if (!([collection.localizedTitle isEqualToString:@"Recently Deleted"] || [collection.localizedTitle isEqualToString:@"Videos"])) {
                 PHFetchResult * result = [self fetchAssetsInAssetCollection:collection ascending:NO];
                 if (result.count > 0) {
                     QGPhotoList * list = [[QGPhotoList alloc]init];
                     list.title = [self transformAblumTitle:collection.localizedTitle];
                     list.photoNum = result.count;
                     list.firstAsset = result.firstObject;
                     list.assetCollection = collection;
                     [photoList addObject:list];
                 }
             }
         }];
        /*
         *  用户创建的相册
         */
        PHFetchResult * userAlbum = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum
                                                                             subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary
                                                                             options:nil];
        [userAlbum enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull collection, NSUInteger idx, BOOL * _Nonnull stop) {
            PHFetchResult *result = [self fetchAssetsInAssetCollection:collection ascending:NO];
            if (result.count > 0) {
                QGPhotoList * list = [[QGPhotoList alloc]init];
                list.title = [self transformAblumTitle:collection.localizedTitle];
                if (list.title == nil) {
                    list.title = collection.localizedTitle;
                }
                list.photoNum = result.count;
                list.firstAsset = result.firstObject;
                list.assetCollection = collection;
                [photoList addObject:list];
                
            }
        }];
    }
    else
    {
        [self.iAssetLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                          usingBlock:^(ALAssetsGroup *group, BOOL *stop)
        {
            if (group.numberOfAssets > 0) {
                 QGPhotoList * list = [[QGPhotoList alloc]init];
                list.photoNum = group.numberOfAssets;
                list.title = [self transformAblumTitle:[group valueForProperty:@"ALAssetsGroupPropertyName"]];
                list.posterImage = (__bridge UIImage *)([group posterImage]);
                
                [photoList addObject:list];
            }
        } failureBlock:^(NSError *error) {
            NSLog(@"%@",error);
            
        }];
    }
    
    
    
    return photoList;
}

#pragma mark -  获取asset相对应的照片
- (void)getImageByAsset:(PHAsset *)asset
               makeSize:(CGSize)size
         makeResizeMode:(PHImageRequestOptionsResizeMode)resizeMode
             completion:(void (^)(UIImage *))completion
{
    if (![self judgeIsHavePhotoAblumAuthority])
    {
        NSLog(@"no access");
        return ;
    }
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    /**
     resizeMode：对请求的图像怎样缩放。有三种选择：None，不缩放；Fast，尽快地提供接近或稍微大于要求的尺寸；Exact，精准提供要求的尺寸。
     deliveryMode：图像质量。有三种值：Opportunistic，在速度与质量中均衡；HighQualityFormat，不管花费多长时间，提供高质量图像；FastFormat，以最快速度提供好的质量。
     这个属性只有在 synchronous 为 true 时有效。
     */
    option.resizeMode = resizeMode;//控制照片尺寸
    //option.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;//控制照片质量
    //option.synchronous = YES;
    option.networkAccessAllowed = YES;
    //param：targetSize 即你想要的图片尺寸，若想要原尺寸则可输入PHImageManagerMaximumSize
    [[PHCachingImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFit options:option resultHandler:^(UIImage * _Nullable image, NSDictionary * _Nullable info) {
        completion(image);
    }];
}

#pragma mark ----  取到所有的asset资源
- (NSArray<PHAsset *> *)getAllAssetInPhotoAblumWithAscending:(BOOL)ascending
{
    
    if (![self judgeIsHavePhotoAblumAuthority])
    {
        NSLog(@"no access");
        return nil;
    }
    
    NSMutableArray<PHAsset *> *assets = [NSMutableArray array];
    
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    //ascending 为YES时，按照照片的创建时间升序排列;为NO时，则降序排列
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:ascending]];
    
    PHFetchResult *result = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:option];
    
    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PHAsset *asset = (PHAsset *)obj;
        [assets addObject:asset];
    }];
    
    return assets;
}

#pragma mark ---  获得指定相册的所有照片

- (NSArray<PHAsset *> *)getAssetsInAssetCollection:(PHAssetCollection *)assetCollection
                                         ascending:(BOOL)ascending
{
    NSMutableArray<PHAsset *> *arr = [NSMutableArray array];
    
    PHFetchResult *result = [self fetchAssetsInAssetCollection:assetCollection ascending:ascending];
    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [arr addObject:obj];
    }];
    return arr;
}


#pragma mark - 照相
- (void)takePhotoWithViewController:(UIViewController *)viewController compeletion:(takePhotoBlock)aCompeletion
{
    if (![self judgeIsHaveCameraAuthority]) {
        NSLog(@"无权限");
        return;
    }
    self.iPhotoBlock = aCompeletion;
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController * picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = sourceType;
        [viewController presentViewController:picker animated:YES completion:nil];
    }else{
        NSLog(@"该设备没有摄像头");
    }
}


#pragma mark - 照相代理

/**
 *  写入相册
 */
-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    [picker dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  写入相册后的方法
 */
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo{
    if (!error) {
        PHAsset * asset = [[[QGPhotoMananger defaultPhotoManager] getAllAssetInPhotoAblumWithAscending:YES] lastObject];
        QGPhotoModel * model = [[QGPhotoModel alloc]init];
        model.asset = asset;
        model.imageName = [asset valueForKey:@"filename"];
        if (self.iPhotoBlock) {
            self.iPhotoBlock(model);
        }
    }
}

@end


@implementation QGPhotoList



@end

@implementation QGPhotoModel



@end







