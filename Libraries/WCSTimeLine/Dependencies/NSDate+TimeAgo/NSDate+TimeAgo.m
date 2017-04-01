//
//  NSDate+NVTimeAgo.m
//  Adventures
//
//  Created by Nikil Viswanathan on 4/18/13.
//  Copyright (c) 2013 Nikil Viswanathan. All rights reserved.
//

#import "NSDate+TimeAgo.h"

@implementation NSDate (NVFacebookTimeAgo)


#define SECOND  1
#define MINUTE  (SECOND * 60)
#define HOUR    (MINUTE * 60)
#define DAY     (HOUR   * 24)
#define WEEK    (DAY    * 7)
#define MONTH   (DAY    * 31)
#define YEAR    (DAY    * 365.24)

/*
    Mysql Datetime Formatted As Time Ago
    Takes in a mysql datetime string and returns the Time Ago date format
 */
+ (NSString *)mysqlDatetimeFormattedAsTimeAgo:(NSString *)mysqlDatetime
{
    //http://stackoverflow.com/questions/10026714/ios-converting-a-date-received-from-a-mysql-server-into-users-local-time
    //If this is not in UTC, we don't have any knowledge about
    //which tz it is. MUST BE IN UTC.
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date = [formatter dateFromString:mysqlDatetime];
    
    return [date formattedAsTimeAgo];
    
}


/*
    Formatted As Time Ago
    Returns the date formatted as Time Ago (in the style of the mobile time ago date formatting for Facebook)
 */
- (NSString *)formattedAsTimeAgo
{    
    //Now
    NSDate *now = [NSDate date];
    NSTimeInterval secondsSince = -(int)[self timeIntervalSinceDate:now];
    
    //Should never hit this but handle the future case
    if(secondsSince < 0)
        return @"In The Future";
        
    
    // < 1 minute = "Just now"
    if(secondsSince < MINUTE)
        return @"Just now";
    
    
    // < 1 hour = "x minutes ago"
    if(secondsSince < HOUR)
        return [self formatMinutesAgo:secondsSince];
  
    
    // Today = "x hours ago"
    if([self isSameDayAs:now])
        return [self formatAsToday:secondsSince];
 
    
    // Yesterday = "Yesterday at 1:28 PM"
    if([self isYesterday:now])
        return [self formatAsYesterday];
  
    
    // < Last 7 days = "Friday at 1:48 AM"
    if([self isLastWeek:secondsSince])
        return [self formatAsLastWeek];

    
    // < Last 30 days = "March 30 at 1:14 PM"
    if([self isLastMonth:secondsSince])
        return [self formatAsLastMonth];
    
    // < 1 year = "September 15"
    if([self isLastYear:secondsSince])
        return [self formatAsLastYear];
    
    // Anything else = "September 9, 2011"
    return [self formatAsOther];
    
}



/*
 ========================== Date Comparison Methods ==========================
 */

/*
    Is Same Day As
    Checks to see if the dates are the same calendar day
 */
- (BOOL)isSameDayAs:(NSDate *)comparisonDate
{
    //Check by matching the date strings
    NSDateFormatter *dateComparisonFormatter = [[NSDateFormatter alloc] init];
    [dateComparisonFormatter setDateFormat:@"yyyy-MM-dd"];
    
    //Return true if they are the same
    return [[dateComparisonFormatter stringFromDate:self] isEqualToString:[dateComparisonFormatter stringFromDate:comparisonDate]];
}




/*
 If the current date is yesterday relative to now
 Pasing in now to be more accurate (time shift during execution) in the calculations
 */
- (BOOL)isYesterday:(NSDate *)now
{
    return [self isSameDayAs:[now dateBySubtractingDays:1]];
}


//From https://github.com/erica/NSDate-Extensions/blob/master/NSDate-Utilities.m
- (NSDate *) dateBySubtractingDays: (NSInteger) numDays
{
	NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + DAY * -numDays;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;
}


/*
    Is Last Week
    We want to know if the current date object is the first occurance of
    that day of the week (ie like the first friday before today 
    - where we would colloquially say "last Friday")
    ( within 6 of the last days)
 
    TODO: make this more precise (1 week ago, if it is 7 days ago check the exact date)
 */
- (BOOL)isLastWeek:(NSTimeInterval)secondsSince
{
    return secondsSince < WEEK;
}


/*
    Is Last Month
    Previous 31 days?
    TODO: Validate on fb
    TODO: Make last day precise
 */
- (BOOL)isLastMonth:(NSTimeInterval)secondsSince
{
    return secondsSince < MONTH;
}


/*
    Is Last Year
    TODO: Make last day precise
 */

- (BOOL)isLastYear:(NSTimeInterval)secondsSince
{
    return secondsSince < YEAR;
}

/*
 =============================================================================
 */





/*
   ========================== Formatting Methods ==========================
 */


// < 1 hour = "x minutes ago"
- (NSString *)formatMinutesAgo:(NSTimeInterval)secondsSince
{
    //Convert to minutes
    int minutesSince = (int)secondsSince / MINUTE;
    
    //Handle Plural
    if(minutesSince == 1)
        return @"1 minute ago";
    else
        return [NSString stringWithFormat:@"%d minutes ago", minutesSince];
}


// Today = "x hours ago"
- (NSString *)formatAsToday:(NSTimeInterval)secondsSince
{
    //Convert to hours
    int hoursSince = (int)secondsSince / HOUR;
    
    //Handle Plural
    if(hoursSince == 1)
        return @"1 hour ago";
    else
        return [NSString stringWithFormat:@"%d hours ago", hoursSince];
}


// Yesterday = "Yesterday at 1:28 PM"
- (NSString *)formatAsYesterday
{
    //Create date formatter
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //Format
    [dateFormatter setDateFormat:@"h:mm a"];
    return [NSString stringWithFormat:@"Yesterday at %@", [dateFormatter stringFromDate:self]];
}


// < Last 7 days = "Friday at 1:48 AM"
- (NSString *)formatAsLastWeek
{
    //Create date formatter
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

    //Format
    [dateFormatter setDateFormat:@"EEE 'at' h:mm a"];
    return [dateFormatter stringFromDate:self];
}


// < Last 30 days = "March 30 at 1:14 PM"
- (NSString *)formatAsLastMonth
{
    //Create date formatter
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //Format
    [dateFormatter setDateFormat:@"MMM d 'at' h:mm a"];
    return [dateFormatter stringFromDate:self];
}


// < 1 year = "September 15"
- (NSString *)formatAsLastYear
{
    //Create date formatter
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //Format
    [dateFormatter setDateFormat:@"MMM d"];
    return [dateFormatter stringFromDate:self];
}


// Anything else = "September 9, 2011"
- (NSString *)formatAsOther
{
    //Create date formatter
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //Format
    [dateFormatter setDateFormat:@"LLL d, yyyy"];
    return [dateFormatter stringFromDate:self];
}


/*
 =======================================================================
 */





/*
 ========================== Test Method ==========================
 */

/*
    Test the format
    TODO: Implement unit tests
 */
+ (void)runTests
{
    NSLog(@"1 Second in the future: %@\n", [[NSDate dateWithTimeIntervalSinceNow:1] formattedAsTimeAgo]);
    NSLog(@"Now: %@\n", [[NSDate dateWithTimeIntervalSinceNow:0] formattedAsTimeAgo]);
    NSLog(@"1 Second: %@\n", [[NSDate dateWithTimeIntervalSinceNow:-1] formattedAsTimeAgo]);
    NSLog(@"10 Seconds: %@\n", [[NSDate dateWithTimeIntervalSinceNow:-10] formattedAsTimeAgo]);
    NSLog(@"1 Minute: %@\n", [[NSDate dateWithTimeIntervalSinceNow:-60] formattedAsTimeAgo]);
    NSLog(@"2 Minutes: %@\n", [[NSDate dateWithTimeIntervalSinceNow:-120] formattedAsTimeAgo]);
    NSLog(@"1 Hour: %@\n", [[NSDate dateWithTimeIntervalSinceNow:-HOUR] formattedAsTimeAgo]);
    NSLog(@"2 Hours: %@\n", [[NSDate dateWithTimeIntervalSinceNow:-2*HOUR] formattedAsTimeAgo]);
    NSLog(@"1 Day: %@\n", [[NSDate dateWithTimeIntervalSinceNow:-1*DAY] formattedAsTimeAgo]);
    NSLog(@"1 Day + 3 seconds: %@\n", [[NSDate dateWithTimeIntervalSinceNow:-1*DAY-3] formattedAsTimeAgo]);
    NSLog(@"2 Days: %@\n", [[NSDate dateWithTimeIntervalSinceNow:-2*DAY] formattedAsTimeAgo]);
    NSLog(@"3 Days: %@\n", [[NSDate dateWithTimeIntervalSinceNow:-3*DAY] formattedAsTimeAgo]);
    NSLog(@"5 Days: %@\n", [[NSDate dateWithTimeIntervalSinceNow:-5*DAY] formattedAsTimeAgo]);
    NSLog(@"6 Days: %@\n", [[NSDate dateWithTimeIntervalSinceNow:-6*DAY] formattedAsTimeAgo]);
    NSLog(@"7 Days - 1 second: %@\n", [[NSDate dateWithTimeIntervalSinceNow:-7*DAY+1] formattedAsTimeAgo]);
    NSLog(@"10 Days: %@\n", [[NSDate dateWithTimeIntervalSinceNow:-10*DAY] formattedAsTimeAgo]);
    NSLog(@"1 Month + 1 second: %@\n", [[NSDate dateWithTimeIntervalSinceNow:-MONTH-1] formattedAsTimeAgo]);
    NSLog(@"1 Year - 1 second: %@\n", [[NSDate dateWithTimeIntervalSinceNow:-YEAR+1] formattedAsTimeAgo]);
    NSLog(@"1 Year + 1 second: %@\n", [[NSDate dateWithTimeIntervalSinceNow:-YEAR+1] formattedAsTimeAgo]);
}
/*
 =======================================================================
 */



@end
