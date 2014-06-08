//
//  CDBarTabTableViewCell.h
//  Crowded
//
//  Created by Matt Bridges on 6/8/14.
//  Copyright (c) 2014 Intrepid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDBarTabTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@end
