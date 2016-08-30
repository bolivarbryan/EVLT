//
//  TimeConverter.m
//  Commercial
//
//  Created by Benjamin Petit on 19/11/2014.
//  Copyright (c) 2014 Emmanuel Levasseur. All rights reserved.
//

#import "TimeConverter.h"

@implementation TimeConverter

+ (NSString *)stringForNumberOfDays:(float)days {
    NSMutableArray *strings = [NSMutableArray array];
    float remains = days;
    
    // weeks
    if (remains > 4.9) {
        int weekCount = (int)floor(days/5);
        NSString *weekValue = [NSString stringWithFormat:@"%i", weekCount];
        remains -= 5*weekCount;
        NSString *weekUnit = weekCount >= 2 ? @"semaines" : @"semaine";
        [strings addObject:[NSString stringWithFormat:@"%@ %@", weekValue, weekUnit]];
    }
    
    // days
    if (remains > 0.9) {
        int daysCount = (int)floor(remains);
        NSString *dayValue = [NSString stringWithFormat:@"%i", daysCount];
        remains -= daysCount;
        NSString *dayUnit = daysCount >= 2 ? @"jours" : @"jour";
        [strings addObject:[NSString stringWithFormat:@"%@ %@", dayValue, dayUnit]];
    }
    
    // hours
    if (remains > 0.1) {
        int hoursCount = (int)roundf(remains*8);
        NSString *hourValue = [NSString stringWithFormat:@"%i", hoursCount];
        NSString *hourUnit = hoursCount >= 2 ? @"heures" : @"heure";
        [strings addObject:[NSString stringWithFormat:@"%@ %@", hourValue, hourUnit]];
    }
    
    // build the text
    return [strings componentsJoinedByString:@", "];
}

@end
