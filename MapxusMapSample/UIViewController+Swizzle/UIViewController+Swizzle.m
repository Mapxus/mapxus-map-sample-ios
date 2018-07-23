//
//  UIViewController+Swizzle.m
//  healthCare
//
//  Created by GuoChenghao on 16/7/18.
//  Copyright © 2016年 WideVision. All rights reserved.
//

#import "UIViewController+Swizzle.h"
#import "JRSwizzle.h"

@implementation UIViewController (Swizzle)

#pragma mark life cycle
+ (void)load
{
    NSError *error1;
    [self jr_swizzleMethod:@selector(viewWillDisappear:) withMethod:@selector(customViewWillDisappear:) error:&error1];
    if (error1) {
        NSLog(@"Swizzle error: %@", error1);
    }
}

- (void)customViewWillDisappear:(BOOL)animated
{
    //    返回按钮
    if (!self.navigationItem.backBarButtonItem
        && self.navigationController.viewControllers.count > 1) {//设置返回按钮(backBarButtonItem的图片不能设置；如果用leftBarButtonItem属性，则iOS7自带的滑动返回功能会失效)
        self.navigationItem.backBarButtonItem = [self backButton];
    }
    [self customViewWillDisappear:animated];
}
#pragma mark end

#pragma mark - event response
- (void)goBack_Swizzle
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark end

#pragma mark - private_M
- (UIBarButtonItem *)backButton{
    NSDictionary *textAttributes;
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title = @" ";
    temporaryBarButtonItem.target = self;
    if ([temporaryBarButtonItem respondsToSelector:@selector(setTitleTextAttributes:forState:)]){
        textAttributes = @{
                           NSFontAttributeName: [UIFont boldSystemFontOfSize:15],
                           NSForegroundColorAttributeName: [UIColor whiteColor],
                           };
        
        [[UIBarButtonItem appearance] setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    }
    temporaryBarButtonItem.action = @selector(goBack_Swizzle);
    return temporaryBarButtonItem;
}
#pragma mark end


@end
