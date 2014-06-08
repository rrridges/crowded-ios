//
//  CDWebService.m
//  Crowded
//
//  Created by Matt Bridges on 6/8/14.
//  Copyright (c) 2014 Intrepid. All rights reserved.
//

#import "CDWebService.h"

@implementation CDWebService
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
            completion(connectionError, nil);
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
@end
