//
//  USTouchTrace.m
//  USTouchTrace
//
//  Created by Qihe Bian on 1/11/13.
//  Copyright (c) 2013 Qihe Bian. All rights reserved.
//

#import "USTouchTrace.h"
#import "UIWindow+TouchTrace.h"

static USTouchTrace *sharedTouchTrace_;

@implementation USTouchTrace

+ (USTouchTrace *)sharedTouchTrace
{
  if (!sharedTouchTrace_) {
    sharedTouchTrace_ = [[self alloc] init];
  }
  return sharedTouchTrace_;
}

- (void)startTouchTrace{
  UIView *view = nil;
  for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
    if ([window isKindOfClass:NSClassFromString(@"USDispatchWindow")]) {
      view = window;
      break;
    }
  }
  if (!view) {
    [[USDispatchWindow alloc] init];
  }
}
- (void)stopTouchTrace{
  UIView *view = nil;
  for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
    if ([window isKindOfClass:NSClassFromString(@"USDispatchWindow")]) {
      view = window;
      break;
    }
  }
  if (view) {
    [view removeFromSuperview];
  }
}
@end
