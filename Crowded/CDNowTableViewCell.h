//
//  CDNowTableViewCell.h
//  Crowded
//
//  Created by Matt Bridges on 6/7/14.
//  Copyright (c) 2014 Intrepid. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CDCrowdedView;

@interface CDNowTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet CDCrowdedView *crowdedView;
@property (weak, nonatomic) IBOutlet UILabel *specialLabel;
@property (weak, nonatomic) IBOutlet UILabel *venueNameLabel;

@end
