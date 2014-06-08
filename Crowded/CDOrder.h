//
//  CDOrder.h
//  Crowded
//
//  Created by Matt Bridges on 6/8/14.
//  Copyright (c) 2014 Intrepid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDOrder : NSObject
@property (nonatomic) NSString *userName;
@property (nonatomic) NSString *itemName;
@property (nonatomic) NSString *userImage;
@property (nonatomic) NSDate *creationTimestamp;
@property (nonatomic) NSDate *readyTimestamp;
@property (nonatomic) BOOL ready;
@property (nonatomic) NSString *orderId;
@end
