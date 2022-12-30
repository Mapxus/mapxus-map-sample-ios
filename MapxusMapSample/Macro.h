//
//  Macro.h
//  MapxusMapSample
//
//  Created by chenghao guo on 2020/7/22.
//  Copyright © 2020 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#ifndef Macro_h
#define Macro_h

#import "ParamConfigInstance.h"

#define leadingSpace 20
#define trailingSpace 15
#define moduleSpace 20
#define innerSpace 10

#define widthScale ([UIScreen mainScreen].bounds.size.width/375.0f)
#define heightScale ([UIScreen mainScreen].bounds.size.height/667.0f)
//屏幕宽度
#define KScreenWidth  ([UIScreen mainScreen].bounds.size.width)
//屏幕高度
#define KScreenHeight ([UIScreen mainScreen].bounds.size.height)
//状态栏高度
#define KStatuesBarHeight  ([UIApplication sharedApplication].statusBarFrame.size.height)
//导航栏高度
#define KNavigationBarHeight 44.0
//导航栏高度+状态栏高度
#define kViewTopHeight (KStatuesBarHeight + KNavigationBarHeight)
//iphoneX适配差值
#define KiPhoneXSafeAreaDValue ([[UIApplication sharedApplication] statusBarFrame].size.height>20?34:0)

#define COLOR(rgbValue)     [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#endif /* Macro_h */
