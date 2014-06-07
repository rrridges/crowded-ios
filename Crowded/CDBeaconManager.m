//
//  CDBeaconManager.m
//  Crowded
//
//  Created by Matt Bridges on 6/7/14.
//  Copyright (c) 2014 Intrepid. All rights reserved.
//

#import "CDBeaconManager.h"
#import <CoreLocation/CoreLocation.h>

@interface CDBeaconManager () <CLLocationManagerDelegate>
@property (nonatomic) CLLocationManager *locationManager;
@end

@implementation CDBeaconManager

- (instancetype)init {
    if (self = [super init]) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
    }
    return self;
}

- (void)startMonitoring {
    
}


@end
