//
//  CDVenue.h
//  Crowded
//
//  Created by Matt Bridges on 6/7/14.
//  Copyright (c) 2014 Intrepid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDVenue : NSObject
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *address1;
@property (nonatomic) NSString *address2;
@property (nonatomic) NSInteger crowdLevel;
@property (nonatomic) NSString *venueId;
@end
