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
// Screen width
#define KScreenWidth  ([UIScreen mainScreen].bounds.size.width)
// Screen height
#define KScreenHeight ([UIScreen mainScreen].bounds.size.height)
// Status bar height
#define KStatuesBarHeight  ([UIApplication sharedApplication].statusBarFrame.size.height)
// Navigation bar height
#define KNavigationBarHeight 44.0
// Navigation bar height plus status bar height
#define kViewTopHeight (KStatuesBarHeight + KNavigationBarHeight)
// iPhone X safe-area adjustment
#define KiPhoneXSafeAreaDValue ([[UIApplication sharedApplication] statusBarFrame].size.height>20?34:0)

#define COLOR(rgbValue)     [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#endif /* Macro_h */
