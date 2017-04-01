//
//  ViewController.m
//  WCSTimeline
//
//  Created by Aaron Wright on 3/15/17.
//  Copyright © 2017 Wrights Creative Services, L.L.C. All rights reserved.
//

#import "ViewController.h"
#import "WCSTimelineCell.h"

@interface ViewController ()
@property (nonatomic, strong) UIRefreshControl * refreshControl;
@property (nonatomic, weak) IBOutlet UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * timelineData;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self buildInterface];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (void)buildInterface
{
    self.title = NSLocalizedString(@"WCSTimeline", nil);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.tableView.refreshControl = self.refreshControl;
    [self.refreshControl addTarget:self action:@selector(reloadTimeline) forControlEvents:UIControlEventValueChanged];

    [self reloadTimeline];
}

- (void)reloadTimeline
{
    self.timelineData = nil;
    self.timelineData = [NSMutableArray new];
    
    for ( NSInteger i = 0; i < 10; i++ )
    {
        WCSTimelineModel * model = [WCSTimelineModel new];
        model.icon = [UIImage imageNamed:@"event"];
        model.time = [self randomDate];
        model.event = [NSString stringWithFormat:@"Event %li", (long)i];
        model.state = arc4random_uniform(3);
        model.content = [self randomString:i];
        [self.timelineData addObject:model];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"kLastRefresh"];
        self.refreshControl.attributedTitle = [self attributedRefreshTitle];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing];
            [self.tableView reloadData];
        });
    });
}

- (NSString*)randomString:(NSInteger)index {
    NSString * randomString = @"Lorem Ipsum is simply dummy text of the printing and typesetting industry.";
    switch ( index ) {
        case 0: {
            break;
        }
        default:
        case 1: {
            randomString = @"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry.";
            break;
        }
        case 2: {
            randomString = @"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry.";
            break;
        }
        case 3: {
            randomString = @"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry.";
            break;
        }
        case 4: {
            randomString = @"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry.";
            break;
        }
    }
    return randomString;
}

#pragma mark - UITableView Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.timelineData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WCSTimelineModel * model = self.timelineData[indexPath.row];
    return model.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"WCSTimelineCell";
    WCSTimelineCell * timelineCell = timelineCell = [[WCSTimelineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    timelineCell.selectionStyle = UITableViewCellSelectionStyleNone;
    timelineCell.backgroundColor = ( indexPath.row % 2 == 0 ? [self hex:@"f2f1f1" alpha:1.f] : [self hex:@"ffffff" alpha:1.f] );
    
    WCSTimelineModel * model = self.timelineData[indexPath.row];
    if (indexPath.row == self.timelineData.count - 1 ) {
        model.isLast = true;
    }
    timelineCell.model = model;
    
    return timelineCell;
}

#pragma mark - Utilities

- (NSDate*)randomDate
{
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDate *now = [NSDate date];
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:now];
    [comps setYear:[comps year] - 1];
    
    NSDate * startDate = [gregorian dateFromComponents:comps];
    NSDate * endDate = [NSDate date];
    
    NSTimeInterval timeBetweenDates = [endDate timeIntervalSinceDate:startDate];
    NSTimeInterval randomInterval = ((NSTimeInterval)arc4random() / ARC4RANDOM_MAX) * timeBetweenDates;
    
    return [startDate dateByAddingTimeInterval:randomInterval];
}

- (NSString*)friendlyDate
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd\'T\'HH:mm:ssZZZZZ";
    formatter.dateStyle = NSDateFormatterMediumStyle;
    formatter.timeStyle = NSDateFormatterMediumStyle;
    
    NSDate * date = [[NSUserDefaults standardUserDefaults] objectForKey:@"kLastRefresh"];
    
    return [formatter stringFromDate:date];
}

- (NSAttributedString*)attributedRefreshTitle
{
    NSString * string1 = @"Last Updated:";
    NSString * string2 = [self friendlyDate];
    
    NSMutableAttributedString * attributedDetails =
    [[NSMutableAttributedString alloc]
     initWithString:[NSString stringWithFormat:@"%@ %@", string1, string2] attributes:nil];
    
    NSMutableAttributedString * attributed = [[NSMutableAttributedString alloc] initWithAttributedString:attributedDetails];
    [attributed addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:10.f] range:[attributed.string rangeOfString:string1]];
    [attributed addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10.f] range:[attributed.string rangeOfString:string2]];
    
    return attributed;
}

- (UIColor*)hex:(NSString*)hex alpha:(float)alpha
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString length] < 6) return [UIColor grayColor];
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString length] != 6) return  [UIColor grayColor];
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:alpha];
}

@end
