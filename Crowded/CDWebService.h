//
//  CDWebService.h
//  Crowded
//
//  Created by Matt Bridges on 6/8/14.
//  Copyright (c) 2014 Intrepid. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CDCompletionBlock)(NSError *error, id result);

@interface CDWebService : NSObject

- (void)patronArrivedWithId:(NSString *)userId atUUID:(NSUUID *)uuid major:(NSInteger)major minor:(NSInteger)minor completion:(CDCompletionBlock)completion;
- (void)placeOrderWithUserId:(NSString *)userId venueId:(NSString *)venueId drinkName:(NSString *)drinkName completion:(CDCompletionBlock)completion;
- (void)getOrdersForVenue:(NSString *)venueId completion:(CDCompletionBlock)completion;
- (void)patronLeftWithId:(NSString *)userId completion:(CDCompletionBlock)completion;

@end
