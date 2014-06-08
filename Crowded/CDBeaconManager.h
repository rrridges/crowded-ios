//
//  CDBeaconManager.h
//  Crowded
//
//  Created by Matt Bridges on 6/7/14.
//  Copyright (c) 2014 Intrepid. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kCDBeaconManagerVenueChangedNotification;

@class CDVenue;

@interface CDBeaconManager : NSObject

@property (nonatomic) CDVenue *currentVenue;
- (void)startMonitoring;

@end
