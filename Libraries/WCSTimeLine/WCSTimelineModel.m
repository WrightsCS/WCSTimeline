//
//  WCSTimelineModel.m
//  WCSTimeline
//
//  Created by Aaron Wright on 3/15/17.
//  Copyright © 2017 Wrights Creative Services, L.L.C. All rights reserved.
//

#import "WCSTimelineModel.h"

@implementation WCSTimelineModel

@synthesize cellHeight = _cellHeight;

- (NSString*)description {
    return [NSString stringWithFormat:@"<<WCSTimelineModel: %@> time=%@, event=%@, content=%@, cellHeight=%f>",
            self,
            self.time,
            self.event,
            self.content,
            self.cellHeight
            ];
}

- (CGFloat)cellHeight {
    return [self heightForContent:self.content];
}

- (CGFloat)heightForContent:(NSString *)stringContent
{
    NSDictionary * attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:10.f]};
    NSMutableAttributedString * contentString = [[NSMutableAttributedString alloc] initWithString:stringContent attributes:attributes];
    CGRect rect = [contentString boundingRectWithSize:(CGSize){320, MAXFLOAT}
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                        context:nil];
    return rect.size.height + 45;
}

@end
