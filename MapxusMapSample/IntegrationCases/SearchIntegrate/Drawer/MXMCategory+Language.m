//
//  MXMCategory+Language.m
//  MapxusMapSample
//
//  Created by chenghao guo on 2020/7/31.
//  Copyright © 2020 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MXMCategory+Language.h"

@implementation MXMCategory (Language)

- (NSString *)titleChooseBySystem {
    NSString *titleText = nil;
    NSString *preferredLanguage = [[[NSBundle mainBundle] preferredLocalizations] firstObject];
    if ([preferredLanguage containsString:@"en"]) {
        titleText = self.title_en;
    } else if ([preferredLanguage containsString:@"Hans"]) {
        titleText = self.title_cn;
    } else if ([preferredLanguage containsString:@"Hant"]) {
        titleText = self.title_zh;
    }
    if (titleText == nil || [titleText isEqualToString:@""]) {
        titleText = self.title_en;
    }
    return titleText;
}

@end
