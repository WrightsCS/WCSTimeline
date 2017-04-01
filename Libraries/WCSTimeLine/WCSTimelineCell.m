//
//  WCSTimelineCell.m
//  WCSTimeline
//
//  Created by Aaron Wright on 3/15/17.
//  Copyright © 2017 Wrights Creative Services, L.L.C. All rights reserved.
//

#import "WCSTimelineCell.h"
#import "NSDate+TimeAgo.h"
#import "Masonry.h"

@interface WCSTimelineCell ()
@property(nonatomic, strong) UIImageView * pointView;
@property(nonatomic, strong) UIImageView * lineView;
@property(nonatomic, strong) UILabel * timeLabel;
@property(nonatomic, strong) UILabel * eventLabel;
@property(nonatomic, strong) WCSLabel * contentLabel;
@property(nonatomic, strong) UIImageView * checkImage;
@end

@implementation WCSTimelineCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self )
    {
        self.lineView = [[UIImageView alloc] init];
        self.lineView.image = [UIImage imageNamed:@"line"];
        self.lineView.frame = CGRectMake(20, 20, 13, 13);
        [self.contentView addSubview:_lineView];
        
        self.pointView = [[UIImageView alloc] init];
        self.pointView.image = [UIImage imageNamed:@"point"];
        [self.contentView addSubview:_pointView];
        
        self.timeLabel = [[UILabel alloc] init];
        self.timeLabel.text = @"12:34 PM";
        self.timeLabel.font = [UIFont boldSystemFontOfSize:10.f];
        self.timeLabel.textAlignment = NSTextAlignmentCenter;
        self.timeLabel.numberOfLines = 0;
        [self.contentView addSubview:self.timeLabel];
        
        self.eventLabel = [[UILabel alloc] init];
        self.eventLabel.text = @"Event";
        self.eventLabel.font = [UIFont boldSystemFontOfSize:10.f];
        self.eventLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.eventLabel];
        
        self.contentLabel = [[WCSLabel alloc] init];
        self.contentLabel.text = @"Content";
        self.contentLabel.font = [UIFont systemFontOfSize:10.f];
        self.contentLabel.textAlignment = NSTextAlignmentLeft;
        self.contentLabel.numberOfLines = 0;
        [self.contentView addSubview:self.contentLabel];
        
        self.checkImage = [[UIImageView alloc] init];
        self.checkImage.image = nil;
        [self.contentView addSubview:self.checkImage];
        
        [self layoutTimeline];
        
        return self;
    }
    return nil;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)layoutTimeline
{
    [self.pointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.left.equalTo(self.contentView).offset(60);
        make.width.height.equalTo(@14);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.pointView);
        make.width.equalTo(@1);
        make.top.equalTo(self.contentView.mas_top);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@50);
        make.left.equalTo(@10);
        make.centerY.equalTo(self.pointView);
    }];
    
    [self.eventLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pointView).offset(15);
        make.centerY.equalTo(self.pointView);
        make.width.equalTo(self.contentView).offset(-120);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.eventLabel);
        make.top.equalTo(self.eventLabel).offset(20);
        make.width.equalTo(self.eventLabel);
    }];
    
    [self.checkImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(self.contentView.frame.size.width)).offset(-10);
        make.centerY.equalTo(self.contentView);
        make.width.height.equalTo(@20);
    }];
}

- (void)setModel:(WCSTimelineModel *)model
{
    //NSLog(@"Date: %@ Time Ago: %@", model.time, [model.time  formattedAsTimeAgo]);
    self.timeLabel.text = [model.time  formattedAsTimeAgo];
    
    if ( model.icon )
    {
        self.eventLabel.attributedText = [self title:model.event withIcon:model.icon];
    }
    else
    {
        self.eventLabel.text = model.event;
    }
    
    self.contentLabel.text = model.content;
    self.lineView.hidden = model.isLast ? false : false; // don't hide the line, but maybe do soemthing better n the future.
    
    [self.contentLabel sizeToFit];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(model.cellHeight-self.eventLabel.frame.size.height-25));
    }];
    
    switch ( model.state ) {
        default:
        case WCSStateUnknown: {
            self.checkImage.image = nil;
            break;
        }
        case WCSStateInactive: {
            self.checkImage.image = [UIImage imageNamed:@"checkmark-off"];
            break;
        }
        case WCSStateActive: {
            self.checkImage.image = [UIImage imageNamed:@"checkmark-on"];
            break;
        }
    }
}

- (NSAttributedString*)title:(NSString*)title withIcon:(UIImage*)icon
{
    NSMutableAttributedString * attributedDetails =
    [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@", title] attributes:nil];
    
    CGRect _attachmentFrame = CGRectMake(0, -5, 20, 20);
    
    NSTextAttachment * attachment = [[NSTextAttachment alloc] init];
    attachment.image = icon;
    attachment.bounds = _attachmentFrame;
    
    NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
    NSMutableAttributedString * attributed = [[NSMutableAttributedString alloc] initWithAttributedString:attachmentString];
    [attributed appendAttributedString:attributedDetails];
    [attributed addAttribute:NSFontAttributeName value:self.eventLabel.font range:[attributed.string rangeOfString:title]];
    
    return attributed;
}

@end
