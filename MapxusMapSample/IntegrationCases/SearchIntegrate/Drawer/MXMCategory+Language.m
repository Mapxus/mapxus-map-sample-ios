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
        titleText = self.titleMap.en;
    } else if ([preferredLanguage containsString:@"Hans"]) {
        titleText = self.titleMap.zh_Hans;
    } else if ([preferredLanguage containsString:@"Hant"]) {
        titleText = self.titleMap.zh_Hant;
    }
    if (titleText == nil || [titleText isEqualToString:@""]) {
        titleText = self.titleMap.en;
    }
    return titleText;
}

@end
