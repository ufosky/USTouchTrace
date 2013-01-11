//
//  USTouchTrace.h
//  USTouchTrace
//
//  Created by Qihe Bian on 1/11/13.
//  Copyright (c) 2013 Qihe Bian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "USDispatchWindow.h"

@interface USTouchTrace : NSObject

+ (USTouchTrace *)sharedTouchTrace;
- (void)startTouchTrace;
- (void)stopTouchTrace;
@end
