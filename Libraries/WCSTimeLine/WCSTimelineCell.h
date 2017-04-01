//
//  WCSTimelineCell.h
//  WCSTimeline
//
//  Created by Aaron Wright on 3/15/17.
//  Copyright © 2017 Wrights Creative Services, L.L.C. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WCSLabel.h"
#import "WCSTimelineModel.h"

#define ARC4RANDOM_MAX 0x100000000

@interface WCSTimelineCell : UITableViewCell
@property (nonatomic, strong) WCSTimelineModel * model;
@end
