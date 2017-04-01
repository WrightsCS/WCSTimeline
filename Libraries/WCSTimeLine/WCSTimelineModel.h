//
//  WCSTimelineModel.h
//  WCSTimeline
//
//  Created by Aaron Wright on 3/15/17.
//  Copyright © 2017 Wrights Creative Services, L.L.C. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WCSState) {
    WCSStateUnknown,
    WCSStateInactive,
    WCSStateActive
};

@interface WCSTimelineModel : NSObject

@property (nonatomic, strong) UIImage * icon;
@property (nonatomic, strong) NSDate * time;
@property (nonatomic, strong) NSString * event;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, assign) BOOL isLast;
@property (nonatomic, assign) WCSState state;
@property (nonatomic, readonly) CGFloat cellHeight;
@property (nonatomic, assign) UIFont * contentFont;

@end
