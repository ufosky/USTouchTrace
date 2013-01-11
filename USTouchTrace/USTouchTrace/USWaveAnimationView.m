//
//  USWaveAnimationView.m
//  USTouchTrace
//
//  Created by Qihe Bian on 1/11/13.
//  Copyright (c) 2013 Qihe Bian. All rights reserved.
//

#import "USWaveAnimationView.h"
#import <QuartzCore/QuartzCore.h>


@interface USWaveLayer : CALayer
{
	__unsafe_unretained id<USWaveLayerDelegate> parentView_;
}
@property (assign) id<USWaveLayerDelegate> parentView;
- (void) startAnimation;
@end

@implementation USWaveLayer
@synthesize parentView = parentView_;

- (void)drawInContext:(CGContextRef)theContext
{
	CGContextSetRGBStrokeColor(theContext, 255, 0, 0, 1.0);
  CGContextSetLineWidth(theContext, 1.5f);
	CGContextStrokeEllipseInRect(theContext, CGRectMake(self.bounds.size.width/2-(kWaveSpawnSize/2), self.bounds.size.height/2-(kWaveSpawnSize/2), kWaveSpawnSize, kWaveSpawnSize));
}

- (void) startAnimation
{
	CABasicAnimation* scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
	scaleAnimation.duration = kAnimationDuration;
	scaleAnimation.delegate = self;
	scaleAnimation.repeatCount = 0;
	scaleAnimation.removedOnCompletion = FALSE;
	scaleAnimation.fillMode = kCAFillModeForwards;
	scaleAnimation.toValue = [NSNumber numberWithFloat:kAnimationScaleFactor];
	[self addAnimation:scaleAnimation forKey:@"scale"];
	
	CABasicAnimation* opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	opacityAnimation.duration = kAnimationDuration;
	opacityAnimation.repeatCount = 0;
	opacityAnimation.removedOnCompletion = FALSE;
	opacityAnimation.fillMode = kCAFillModeForwards;
	opacityAnimation.toValue = [NSNumber numberWithFloat:0.0];
	[self addAnimation:opacityAnimation forKey:@"opacity"];
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
	if ([parentView_ respondsToSelector:@selector(layerDidFinishAnimation)]) {
		[parentView_ layerDidFinishAnimation];
	}
}

@end


@interface USWaveAnimationView ()
- (void) spawnWave;
@end


@implementation USWaveAnimationView

+ (void) waveAnimationAtPosition:(CGPoint)position forView:(UIView*)view
{
  NSArray *subviews = [view subviews];
  if ([subviews count] > kMaxWaveCount) {
    USWaveAnimationView *waveAnimationView = [subviews objectAtIndex:0];
    [waveAnimationView stopAnimation];
    [waveAnimationView removeFromSuperview];
  }

	USWaveAnimationView* waveAnimationView = [[[self alloc] initWithFrame:CGRectMake(0, 0, 100, 100)] autorelease];
	[waveAnimationView setCenter:position];
	[view addSubview:waveAnimationView];
}

- (id)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    [self setUserInteractionEnabled:NO];
		wavesSpawned_ = 0;
		wavesDone_ = 0;
    
#if kDebugCoordinates==1
		UIView* xView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 1)];
		[xView setBackgroundColor:[UIColor blueColor]];
		[xView setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
		[self addSubview:xView];
		
		UIView* yView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, self.bounds.size.height)];
		[yView setBackgroundColor:[UIColor blueColor]];
		[yView setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
		[self addSubview:yView];
#endif
		[self spawnWave];
		if (1<kNumberOfWaves) {
			timer_ = [NSTimer scheduledTimerWithTimeInterval:kSpawnInterval target:self selector:@selector(spawnWave) userInfo:nil repeats:YES];
		}
  }
  return self;
}

- (void) spawnWave
{
	USWaveLayer* wave = [USWaveLayer layer];
	[wave setBounds:CGRectMake(0, 0, kWaveSpawnSize+6, kWaveSpawnSize+6)];
	wave.position = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
	
	wave.shadowColor = [UIColor redColor].CGColor;
	wave.shadowOffset = CGSizeMake(0, 0);
	wave.shadowOpacity = 1.0;
	wave.shadowRadius = 3.0;
	
	[wave setParentView:self];
	[self.layer addSublayer:wave];
	[wave setNeedsDisplay];
	[wave startAnimation];
	
	wavesSpawned_++;
	if (wavesSpawned_ == kNumberOfWaves) {
		[timer_ invalidate];
		/*
		 * - (void)invalidate
		 *
		 * "The NSRunLoop object removes and releases the timer,
		 * either just before the invalidate method returns or at some later point."
		 *
		 */
		timer_ = nil;
	}
}

- (void) stopAnimation{
  for (USWaveLayer* wave in [[self layer] sublayers]) {
    [wave setParentView:nil];
  }
}
- (void) layerDidFinishAnimation
{
	wavesDone_++;
	if (wavesDone_==wavesSpawned_) {
		[self removeFromSuperview];
	}
}

@end
