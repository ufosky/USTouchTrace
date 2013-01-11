//
//  UIWindow+TouchTrace.m
//  USTouchTrace
//
//  Created by Qihe Bian on 1/11/13.
//  Copyright (c) 2013 Qihe Bian. All rights reserved.
//

#import "UIWindow+TouchTrace.h"
#include <objc/runtime.h>

void sendEvent(id self, SEL _cmd, UIEvent *event){
  // collect all the touches we care about from the event
  NSSet *touches = [event allTouches];
  NSMutableSet *began = nil;
  NSMutableSet *moved = nil;
  NSMutableSet *ended = nil;
  NSMutableSet *cancelled = nil;
  
  // sort the touches by phase so we can handle them similarly to normal event dispatch
  for(UITouch *touch in touches) {
    switch ([touch phase]) {
      case UITouchPhaseBegan:
        if (!began) began = [NSMutableSet set];
        [began addObject:touch];
        break;
      case UITouchPhaseMoved:
        if (!moved) moved = [NSMutableSet set];
        [moved addObject:touch];
        break;
      case UITouchPhaseEnded:
        if (!ended) ended = [NSMutableSet set];
        [ended addObject:touch];
        break;
      case UITouchPhaseCancelled:
        if (!cancelled) cancelled = [NSMutableSet set];
        [cancelled addObject:touch];
        break;
      default:
        break;
    }
  }
  // call our methods to handle the touches
  static UIView *view = nil;
  if (![self isKindOfClass:NSClassFromString(@"USDispatchWindow")]){
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
      if ([window isKindOfClass:NSClassFromString(@"USDispatchWindow")]) {
        view = window;
        break;
      }
    }
  }

  if (began)     [view touchesBegan:began withEvent:event];
  if (moved)     [view touchesMoved:moved withEvent:event];
  if (ended)     [view touchesEnded:ended withEvent:event];
  if (cancelled) [view touchesCancelled:cancelled withEvent:event];
  
  if (![self isKindOfClass:NSClassFromString(@"USDispatchWindow")]) {
    [self performSelector:@selector(_sendEvent:) withObject:event];
  }
}

void swizzle(Class c, SEL orig, SEL new)
{
  Method origMethod = class_getInstanceMethod(c, orig);
  Method newMethod = class_getInstanceMethod(c, new);
  if(class_addMethod(c, orig,
                     method_getImplementation(newMethod),
                     method_getTypeEncoding(newMethod))){
    class_replaceMethod(c, new,
                        method_getImplementation(origMethod),
                        method_getTypeEncoding(origMethod));
  }else{
    method_exchangeImplementations(origMethod, newMethod);
  }
}

@implementation UIWindow (TouchTrace)
+ (void)load {
  class_addMethod([self class], @selector(_sendEvent:), (IMP) sendEvent, "v@:@");
  swizzle(self, @selector(sendEvent:), @selector(_sendEvent:));
}
@end
