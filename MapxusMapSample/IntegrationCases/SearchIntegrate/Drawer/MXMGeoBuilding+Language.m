//
//  MXMGeoBuilding+Language.m
//  MapxusMapSample
//
//  Created by chenghao guo on 2020/7/31.
//  Copyright © 2020 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

#import "MXMGeoBuilding+Language.h"

@implementation MXMGeoBuilding (Language)

- (NSString *)nameChooseBySystem {
    NSString *titleText = nil;
    NSString *preferredLanguage = [[[NSBundle mainBundle] preferredLocalizations] firstObject];
    if ([preferredLanguage containsString:@"en"]) {
        titleText = self.nameMap.en;
    } else if ([preferredLanguage containsString:@"Hans"]) {
        titleText = self.nameMap.zh_Hans;
    } else if ([preferredLanguage containsString:@"Hant"]) {
        titleText = self.nameMap.zh_Hant;
    } else if ([preferredLanguage containsString:@"ja"]) {
        titleText = self.nameMap.ja;
    } else if ([preferredLanguage containsString:@"ko"]) {
        titleText = self.nameMap.ko;
    }
    if (titleText == nil || [titleText isEqualToString:@""]) {
        titleText = self.nameMap.Default;
    }
    return titleText;
}

@end
