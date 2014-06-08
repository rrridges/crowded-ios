//
//  CDBeaconManager.m
//  Crowded
//
//  Created by Matt Bridges on 6/7/14.
//  Copyright (c) 2014 Intrepid. All rights reserved.
//

#import "CDBeaconManager.h"
#import "CDVenue.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>

NSString * const kCDBeaconManagerVenueChangedNotification = @"kCDBeaconManagerVenueChangedNotification";

@interface CDBeaconManager () <CLLocationManagerDelegate, CBCentralManagerDelegate>
@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) CBCentralManager *bluetoothManager;
@property (nonatomic) CLBeaconRegion *region;
@property (atomic) NSInteger operationCount;
@end

@implementation CDBeaconManager

- (instancetype)init {
    if (self = [super init]) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.bluetoothManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
        self.bluetoothManager.delegate = self;
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

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSString *stateString = nil;
    switch(self.bluetoothManager.state)
    {
        case CBCentralManagerStateResetting:
            stateString = @"The connection with the system service was momentarily lost, update imminent.";
            break;
        case CBCentralManagerStateUnsupported:
            stateString = @"The platform doesn't support Bluetooth Low Energy.";
            break;
        case CBCentralManagerStateUnauthorized:
            stateString = @"The app is not authorized to use Bluetooth Low Energy.";
            break;
        case CBCentralManagerStatePoweredOff:
            [self setCurrentVenueWithBeacon:nil];
            stateString = @"Bluetooth is currently powered off.";
            break;
        case CBCentralManagerStatePoweredOn:
            stateString = @"Bluetooth is currently powered on and available to use.";
            break;
        default: stateString = @"State unknown, update imminent."; break;
    }
    
    NSLog(@"Bluetooth state changed to %@", stateString);
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
                [self setCurrentVenueWithBeacon:beaconRegion];
                //[self.locationManager startRangingBeaconsInRegion:beaconRegion];
                break;
            default:
                break;
        }

    }
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    NSLog(@"Entered region");
    [self setCurrentVenueWithBeacon:(CLBeaconRegion *)region];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    NSLog(@"Exited region");
    [self setCurrentVenueWithBeacon:nil];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Failed with error: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    for (CLBeacon *beacon in beacons) {
        //NSLog(@"Ranged a beacon at distance: %f", beacon.accuracy);
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


- (void)setCurrentVenueWithBeacon:(CLBeaconRegion *)region {
    
    NSInteger operationId = ++self.operationCount;
    
    if (!region) {
        self.currentVenue = nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:kCDBeaconManagerVenueChangedNotification object:self];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            @synchronized (self) {
                if (self.operationCount == operationId) {
                    CDVenue *venue = [[CDVenue alloc] init];
                    venue.name = @"Atwoods";
                    self.currentVenue = venue;
                    [[NSNotificationCenter defaultCenter] postNotificationName:kCDBeaconManagerVenueChangedNotification object:self];
                }
            }
        });
    }
}



@end
