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
@property (nonatomic) CLBeaconRegion *region;
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
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"5B17EDA0-EDC2-11E3-AC10-0800200C9A66"];
    CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid major:1 minor:0 identifier:@"Crowded Beacon 1"];
    self.region = region;
    NSLog(@"Monitoring available: %d", [CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]]);
    NSLog(@"Ranging available: %d", [CLLocationManager isRangingAvailable]);
    NSLog(@"Authorization status: %d", [CLLocationManager authorizationStatus]);

    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways) {
        [self.locationManager startMonitoringForRegion:region];
    } else {
        [self.locationManager requestAlwaysAuthorization];
    }
    
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    NSLog(@"Started monitoring");
    [self.locationManager requestStateForRegion:region];
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region {
    NSLog(@"Determined State: %d", state);
    if ([region isKindOfClass:[CLBeaconRegion class]]) {
        CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
        switch (state) {
            case CLRegionStateInside:
                [self.locationManager startRangingBeaconsInRegion:beaconRegion];
                break;
            default:
                break;
        }

    }
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    NSLog(@"Entered region");
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    NSLog(@"Exited region");
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Failed with error: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    for (CLBeacon *beacon in beacons) {
        NSLog(@"Ranged a beacon at distance: %f", beacon.accuracy);
    }
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    NSLog(@"Monitoring did fail with error: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    NSLog(@"Authorization status changed to %d", status);
    if (status == kCLAuthorizationStatusAuthorizedAlways) {
        [self.locationManager startMonitoringForRegion:self.region];
    }
}




@end
