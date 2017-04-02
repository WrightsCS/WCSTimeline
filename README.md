# WCSTimeline
Simple timeline with data model written in Objective-C.

<img src="/screens/1.PNG" width="50%" />

Example
------------

This example creates `10` sequential event models with random dates. Each model is assigned to `timeLineData` array at the end of the loop. You will need to reload the tableView!

Model attributes:
* icon: UIImage
* time: NSDate
* event: NSString
* state: WCSState
* content: NSString

```objc
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
```

@WrightsCS
------------

Twitter: @WrightsCS
http://www.wrightscsapps.com 

Apps using WCSTimeline
------------

If you are using this in your app, please let me know and I will add your app here!
