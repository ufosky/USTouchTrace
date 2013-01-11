//
//  USDispatchWindow.m
//  USTouchTrace
//
//  Created by Qihe Bian on 1/11/13.
//  Copyright (c) 2013 Qihe Bian. All rights reserved.
//

#import "USDispatchWindow.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "USWaveAnimationView.h"
@implementation USDispatchWindow

- (id)init{
  self = [super init];
  if (self) {
    [self setHidden:NO];
    [self setWindowLevel:UIWindowLevelStatusBar+9999.f];
    [self setUserInteractionEnabled:NO];
    [self setFrame:[[UIScreen mainScreen] bounds]];
  }
  return self;
}
- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self setHidden:NO];
    [self setWindowLevel:UIWindowLevelStatusBar+9999.f];
    [self setUserInteractionEnabled:NO];
  }
  return self;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

}
- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
  for (UITouch *touch in touches) {
    CGPoint touchPoint = [touch locationInView:self];
    [USWaveAnimationView waveAnimationAtPosition:touchPoint forView:self];
  }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  for (UITouch *touch in touches) {
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    [USWaveAnimationView waveAnimationAtPosition:touchPoint forView:self];
  }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{

}

@end
