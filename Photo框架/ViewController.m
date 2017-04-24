//
//  ViewController.m
//  Photo框架
//
//  Created by jorgon on 06/04/17.
//  Copyright © 2017年 jorgon. All rights reserved.
//

#import "ViewController.h"
#import "QGPhotoMananger.h"
#import "QGSmartAlbumViewController.h"
#import "QGBaseNavigationViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)addphoto:(id)sender {
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil
                                                                               message:nil
                                                                        preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                                                    handler:nil];
    UIAlertAction * photo = [UIAlertAction actionWithTitle:@"照片" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action)
    {
        [QGSmartAlbumViewController enterSmartAlbumWithAlbums:[[QGPhotoMananger defaultPhotoManager] getAllPhotoList]
                                               viewController:self
                                           selectImageHandler:^(NSArray *imagesAry) {
                                               
                                           } selectDataHandler:^(NSArray *dataAry) {
                                               
                                           }];
    }];
    
    UIAlertAction * camero = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * _Nonnull action)
                              {
                                  [[QGPhotoMananger defaultPhotoManager] takePhotoWithViewController:self
                              compeletion:^(QGPhotoModel *model) {
                                  
                              }];
                              }];
    
    [alertController addAction:photo];
    [alertController addAction:camero];
    [alertController addAction:cancel];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
