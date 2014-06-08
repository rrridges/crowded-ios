//
//  CDOrder.m
//  Crowded
//
//  Created by Matt Bridges on 6/8/14.
//  Copyright (c) 2014 Intrepid. All rights reserved.
//

#import "CDOrder.h"

@implementation CDOrder
- (NSString *)description {
    return [NSString stringWithFormat:@"creation: %@, ready: %@", self.creationTimestamp, self.readyTimestamp];
}
@end
