//
//  MainNavigationController.m
//  HOUNOLVJU
//
//  Created by 蒋永昌 on 8/30/16.
//  Copyright © 2016 蒋永昌. All rights reserved.
//

#import "MainNavigationController.h"


@interface MainNavigationController ()<UINavigationControllerDelegate>

@end

@implementation MainNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;

//    self.navigationBar.barTintColor = [UIColor colorWithRed:68/255.0 green:193/255.0 blue:94/255.0 alpha:1.0];
    self.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationBar.alpha = 0.3;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
//    //导航栏背景透明
    UIImage *image = [UIImage new];
    [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:image];
}

//状态条设置为白色
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    

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
