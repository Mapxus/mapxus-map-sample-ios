//
//  MXMPOI+Language.m
//  MapxusMapSample
//
//  Created by chenghao guo on 2020/7/31.
//  Copyright © 2020 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MXMPOI+Language.h"

@implementation MXMPOI (Language)

- (NSString *)nameChooseBySystem {
    NSString *titleText = nil;
    NSString *preferredLanguage = [[[NSBundle mainBundle] preferredLocalizations] firstObject];
    if ([preferredLanguage containsString:@"en"]) {
        titleText = self.name_en;
    } else if ([preferredLanguage containsString:@"Hans"]) {
        titleText = self.name_cn;
    } else if ([preferredLanguage containsString:@"Hant"]) {
        titleText = self.name_zh;
    } else if ([preferredLanguage containsString:@"ja"]) {
        titleText = self.name_ja;
    } else if ([preferredLanguage containsString:@"ko"]) {
        titleText = self.name_ko;
    }
    if (titleText == nil || [titleText isEqualToString:@""]) {
        titleText = self.name_default;
    }
    return titleText;
}

@end
