//
//  NSDate+NVTimeAgo.h
//  Adventures
//
//  Created by Nikil Viswanathan on 4/18/13.
//  Copyright (c) 2013 Nikil Viswanathan. All rights reserved.
//

/*
    This NSDate category adds the facebook style "time ago" date formatting.
    This mimics Facebook mobile (the desktop version has slightly different date formatting).
    This assumes all dates are in the past.
 
 
    To use this in your iOS project:
    --------------------------------
    1. Drag both NSDate+NVTimeAgo.m aand NSDate+NVTimeAgo.h into your iOS project in XCode
    2. In the files that you want to use this functionality in,itType: 
        
            #import "NSDate+NVTimeAgo.h" 
 
        somewhere near the top of your file.
 
    3. Use the date formatter on a date by calling:   
 
        [date formattedAsTimeAgo];
 
       where date is an (NSDate *) and represents a date IN THE PAST (relative to now).
 
 
       If you have a mysql datetime string and you want to convert it to the time ago format, do:
    
       NSString *mysqlDatetime = <Get from the database>
       NSString *timeAgoFormattedDate = [NSDate mysqlDatetimeFormattedAsTimeAgo:mysqlDatetime];
 
 
 
 
    Made By Nikil Viswanathan
    -------------------------
    4/18/2013
    You can contact me on: www.nikilster.com
 
 
 
    Date Format
    -----------
     < 1 minute       	= "Just now"
     < 1 hour         	= "x minutes ago"
     Today            	= "x hours ago"
     Yesterday        	= "Yesterday at 1:28pm"
     < Last 7 days    	= "Friday at 1:48am"
     < Last 30 days   	= "March 30 at 1:14 pm"
     < 1 year         	= "September 15"
     Anything else    	= "September 9, 2011"
 
 
*/

#import <Foundation/Foundation.h>

@interface NSDate (NVFacebookTimeAgo)

/*
    Mysql Datetime Formatted As Time Ago
    Takes in a mysql datetime string and returns the Time Ago date format
 */
+ (NSString*)mysqlDatetimeFormattedAsTimeAgo:(NSString *)mysqlDatetime;


/*
    Formatted As Time Ago
    Returns the time formatted as Time Ago (in the style of Facebook's mobile date formatting)
 */
- (NSString *)formattedAsTimeAgo;

@end
