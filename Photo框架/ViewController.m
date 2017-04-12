//
//  ViewController.m
//  Photo框架
//
//  Created by jorgon on 06/04/17.
//  Copyright © 2017年 jorgon. All rights reserved.
//

#import "ViewController.h"
#import "QGPhotoMananger.h"
#import "SmartAlbumViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)addphoto:(id)sender {
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@""
                                                                               message:nil
                                                                        preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"" style:UIAlertActionStyleCancel
                                                    handler:nil];
    UIAlertAction * photo = [UIAlertAction actionWithTitle:@"照片" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action)
    {
        SmartAlbumViewController * albumViewController = [[SmartAlbumViewController alloc] init];
        albumViewController.dataAry = [[QGPhotoMananger defaultPhotoManager] getAllPhotoList];
        [self.navigationController pushViewController:albumViewController animated:YES];
    }];
    
    __weak typeof(self)weakSelf = self;
    UIAlertAction * camero = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * _Nonnull action)
                              {
                                  [[QGPhotoMananger defaultPhotoManager] takePhotoWithViewController:weakSelf compeletion:^(QGPhotoModel *model) {
                                      SmartAlbumViewController * albumViewController = [[SmartAlbumViewController alloc] init];
                                      albumViewController.dataAry = [[QGPhotoMananger defaultPhotoManager] getAllPhotoList];
                                      [weakSelf.navigationController pushViewController:albumViewController animated:YES];
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
