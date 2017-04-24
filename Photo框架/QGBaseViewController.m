//
//  QGBaseViewController.m
//  Photo框架
//
//  Created by jorgon on 18/04/17.
//  Copyright © 2017年 jorgon. All rights reserved.
//

#import "QGBaseViewController.h"

@interface QGBaseViewController ()

@end

@implementation QGBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton * cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleBtn.frame = CGRectMake(0, 0, 88, 44);
    //    cancleBtn.backgroundColor = [UIColor redColor];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancleBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -30);
    [cancleBtn addTarget:self action:@selector(cancle:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * right = [[UIBarButtonItem alloc] initWithCustomView:cancleBtn];
    self.navigationItem.rightBarButtonItem = right;
}

- (void)cancle:(UIButton *)button
{
//    if (self.navigationController.childViewControllers.count == 1) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//    }
    
}
- (void)dealloc
{
    NSLog(@"%s",__func__);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
