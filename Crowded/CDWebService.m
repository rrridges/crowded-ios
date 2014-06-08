//
//  CDWebService.m
//  Crowded
//
//  Created by Matt Bridges on 6/8/14.
//  Copyright (c) 2014 Intrepid. All rights reserved.
//

#import "CDWebService.h"
#import "CDOrder.h"

@interface CDWebService ()

@property (nonatomic) NSDictionary *names;
@property (nonatomic) NSDictionary *images;

@end

@implementation CDWebService

- (instancetype)init {
    if (self = [super init]) {
        self.names = @{@"0":@"Frank M.",
                       @"1":@"Praveen A.",
                       @"2":@"Matt B.",
                       @"3": @"Alice C.",
                       @"4": @"Max M."};
        self.images = @{@"0":@"photo_1.png",
                        @"1":@"photo_2.png",
                        @"2":@"photo_3.png",
                        @"3":@"photo_4.png",
                        @"4":@"photo_5.png"};
    }
    return self;
}

- (void)patronArrivedWithId:(NSString *)userId atUUID:(NSUUID *)uuid major:(NSInteger)major minor:(NSInteger)minor completion:(CDCompletionBlock)completion {
    NSURL *url = [NSURL URLWithString:@"http://crowded-api.herokuapp.com/addNewVenuePatronAndReturnVenue"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSMutableDictionary *payload = [NSMutableDictionary dictionary];
    payload[@"user_id"] = userId;
    payload[@"beaconuuid"] = uuid.UUIDString;
    payload[@"beaconmajor"] = [NSString stringWithFormat:@"%d",major];
    payload[@"beaconminor"] = [NSString stringWithFormat:@"%d",minor];

    NSData *body = [NSJSONSerialization dataWithJSONObject:payload options:0 error:nil];
    NSString *bodyString = [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding];
    NSLog(@"%@", bodyString);
    
    [request setHTTPBody:body];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (!connectionError && httpResponse.statusCode == 200) {
            id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if ([json isKindOfClass:[NSDictionary class]]) {
                completion(nil, json);
            }
        } else {
            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"Response: %@ Error: %@ StatusCode: %d", responseString, connectionError, httpResponse.statusCode);
            completion(connectionError, false);
        }
    }];
}

- (void)placeOrderWithUserId:(NSString *)userId venueId:(NSString *)venueId drinkName:(NSString *)drinkName completion:(CDCompletionBlock)completion{
    NSURL *url = [NSURL URLWithString:@"http://crowded-api.herokuapp.com/addNewOrder"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSMutableDictionary *payload = [NSMutableDictionary dictionary];
    payload[@"user_id"] = userId;
    payload[@"venue_id"] = venueId;
    payload[@"drinkName"] = drinkName;
    payload[@"specialInstructions"] = @"";
    
    NSData *body = [NSJSONSerialization dataWithJSONObject:payload options:0 error:nil];
    NSString *bodyString = [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding];
    NSLog(@"%@", bodyString);
    
    [request setHTTPBody:body];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (!connectionError && httpResponse.statusCode == 200) {
            completion(nil, @true);
        } else {
            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"Response: %@ Error: %@ StatusCode: %d", responseString, connectionError, httpResponse.statusCode);
            completion(connectionError, @false);
        }
    }];
}

- (void)getOrdersForVenue:(NSString *)venueId completion:(CDCompletionBlock)completion {
    NSURL *url = [NSURL URLWithString:@"http://crowded-api.herokuapp.com/order"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (!connectionError && httpResponse.statusCode == 200) {
            id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if ([json isKindOfClass:[NSArray class]]) {
                NSArray *orders = [self ordersFromPayload:json];
                completion(nil, orders);
            }
        } else {
            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"Response: %@ Error: %@ StatusCode: %d", responseString, connectionError, httpResponse.statusCode);
            completion(connectionError, @false);
        }
    }];
}

- (NSArray *)ordersFromPayload:(NSArray *)payload {
    NSMutableArray *orders = [NSMutableArray array];
    
    for (NSDictionary *orderJson in payload) {
        CDOrder *order = [[CDOrder alloc] init];
        if (self.names[orderJson[@"user_id"]]) {
            order.userName = self.names[orderJson[@"user_id"]];
            order.itemName = orderJson[@"drinkName"];
            order.userImage = self.images[orderJson[@"user_id"]];
            order.ready = [orderJson[@"drinkReady"] boolValue];
            order.readyTimestamp = [self dateFromString:orderJson[@"readyTimestamp"]];
            order.creationTimestamp = [self dateFromString:orderJson[@"creationTimestamp"]];
            order.orderId = orderJson[@"_id"];
        
            [orders addObject:order];
        }
    }
    
    NSSortDescriptor *creation = [[NSSortDescriptor alloc] initWithKey:@"creationTimestamp" ascending:NO];
    NSSortDescriptor *ready = [[NSSortDescriptor alloc] initWithKey:@"readyTimestamp" ascending:NO];
    [orders sortUsingDescriptors:@[ready, creation]];
    return orders;
}

- (NSDate *)dateFromString:(NSString *)input {
    static NSDateFormatter *formatter;
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
    }
    [formatter setDateFormat:@"yyyy-MM-dd'T'hh:mm:ss.SSS'Z'"];
    
    if ([input isKindOfClass:[NSString class]]) {
        return [formatter dateFromString:input];
    } else {
        return nil;
    }
    
}

- (void)patronLeftWithId:(NSString *)userId completion:(CDCompletionBlock)completion {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://crowded-api.herokuapp.com/removeVenuePatrons/%@", userId]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"DELETE"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (!connectionError && httpResponse.statusCode == 200) {
            NSLog(@"Successfully left");
            completion(nil, @true);
        } else {
            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"Response: %@ Error: %@ StatusCode: %d", responseString, connectionError, httpResponse.statusCode);
            completion(connectionError, @false);
        }
    }];
    
}

@end
