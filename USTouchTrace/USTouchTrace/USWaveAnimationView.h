//
//  USWaveAnimationView.h
//  USTouchTrace
//
//  Created by Qihe Bian on 1/11/13.
//  Copyright (c) 2013 Qihe Bian. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kAnimationDuration 0.2
#define kNumberOfWaves 1
#define kSpawnInterval 0.1
#define kWaveSpawnSize 6
#define kAnimationScaleFactor 3.5
#define kMaxWaveCount 20

#define kDebugCoordinates 0

@protocol USWaveLayerDelegate <NSObject>
- (void) layerDidFinishAnimation;
@end

@interface USWaveAnimationView : UIView <USWaveLayerDelegate> {
	int wavesSpawned_;
	int wavesDone_;
	NSTimer* timer_;
}

+ (void) waveAnimationAtPosition:(CGPoint)position forView:(UIView*)view;

@end