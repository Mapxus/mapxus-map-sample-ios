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
  } else if ([preferredLanguage containsString:@"ja"]) {
    titleText = self.titleMap.ja;
  } else if ([preferredLanguage containsString:@"ko"]) {
    titleText = self.titleMap.ko;
  } else if ([preferredLanguage containsString:@"fil"]) {
    titleText = self.titleMap.fil;
  } else if ([preferredLanguage containsString:@"id"]) {
    titleText = self.titleMap._id;
  } else if ([preferredLanguage containsString:@"pt"]) {
    titleText = self.titleMap.pt;
  } else if ([preferredLanguage containsString:@"th"]) {
    titleText = self.titleMap.th;
  } else if ([preferredLanguage containsString:@"vi"]) {
    titleText = self.titleMap.vi;
  } else if ([preferredLanguage containsString:@"ar"]) {
    titleText = self.titleMap.ar;
  }
  if (titleText == nil || [titleText isEqualToString:@""]) {
    titleText = self.titleMap.en;
  }
  return titleText;
}

@end
