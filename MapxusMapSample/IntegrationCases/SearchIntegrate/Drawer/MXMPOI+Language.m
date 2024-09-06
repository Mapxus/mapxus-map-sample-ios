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
    titleText = self.nameMap.en;
  } else if ([preferredLanguage containsString:@"Hans"]) {
    titleText = self.nameMap.zh_Hans;
  } else if ([preferredLanguage containsString:@"Hant"]) {
    titleText = self.nameMap.zh_Hant;
  } else if ([preferredLanguage containsString:@"ja"]) {
    titleText = self.nameMap.ja;
  } else if ([preferredLanguage containsString:@"ko"]) {
    titleText = self.nameMap.ko;
  } else if ([preferredLanguage containsString:@"fil"]) {
    titleText = self.nameMap.fil;
  } else if ([preferredLanguage containsString:@"id"]) {
    titleText = self.nameMap._id;
  } else if ([preferredLanguage containsString:@"pt"]) {
    titleText = self.nameMap.pt;
  } else if ([preferredLanguage containsString:@"th"]) {
    titleText = self.nameMap.th;
  } else if ([preferredLanguage containsString:@"vi"]) {
    titleText = self.nameMap.vi;
  } else if ([preferredLanguage containsString:@"ar"]) {
    titleText = self.nameMap.ar;
  }
  if (titleText == nil || [titleText isEqualToString:@""]) {
    titleText = self.nameMap.Default;
  }
  return titleText;
}

@end
