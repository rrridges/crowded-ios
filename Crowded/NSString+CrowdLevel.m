//
//  NSString+CrowdLevel.m
//  Crowded
//
//  Created by Matt Bridges on 6/7/14.
//  Copyright (c) 2014 Intrepid. All rights reserved.
//

#import "NSString+CrowdLevel.h"

@implementation NSString (CrowdLevel)
+ (NSString *)stringForCrowdLevel:(NSInteger)crowdLevel {
    switch (crowdLevel) {
        case 0:
            return @"QUIET";
            break;
        case 1:
            return @"BUZZING";
            break;
        case 2:
            return @"LIVELY";
            break;
        case 3:
            return @"CROWDED";
            break;
        default:
            return @"PACKED";
            break;
    }
}
@end
