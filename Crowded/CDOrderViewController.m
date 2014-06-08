//
//  CDOrderViewController.m
//  Crowded
//
//  Created by Matt Bridges on 6/8/14.
//  Copyright (c) 2014 Intrepid. All rights reserved.
//

#import "CDOrderViewController.h"
#import "CDMenuItem.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "CDWebService.h"

NSString * const kCDOrderPlacedNotification = @"kCDOrderPlacedNotification";

@interface CDOrderViewController ()
@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtotalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *taxLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UIView *successPopup;
@end

@implementation CDOrderViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupWithMenuItem:self.menuItem];
    // Do any additional setup after loading the view.
}

- (void)setupWithMenuItem:(CDMenuItem *)item {
    
    NSDecimalNumber *price = self.menuItem.price;
    double tax = price.doubleValue * 0.05;
    double tip = price.doubleValue * 0.2;
    self.itemNameLabel.text = self.menuItem.name;
    self.itemDescriptionLabel.text = self.menuItem.itemDescription;
    self.itemPriceLabel.text = [NSString stringWithFormat:@"$%0.2f", price.doubleValue];
    self.subtotalPriceLabel.text = [NSString stringWithFormat:@"$%0.2f", price.doubleValue];
    self.taxLabel.text = [NSString stringWithFormat:@"$%0.2f", tax];
    self.tipLabel.text = [NSString stringWithFormat:@"$%0.2f", tip];
    self.totalLabel.text = [NSString stringWithFormat:@"$%0.2f", tax + tip + price.doubleValue];
}

- (IBAction)completeOrderTapped:(id)sender {
    [SVProgressHUD showWithStatus:@"Ordering"];
    
    CDWebService *service = [[CDWebService alloc] init];
    NSDecimalNumber *price = self.menuItem.price;
    double tax = price.doubleValue * 0.05;
    double tip = price.doubleValue * 0.2;
    NSString *total = [NSString stringWithFormat:@"$%0.2f", tax + tip + price.doubleValue];
    
    [service placeOrderWithUserId:@"0" venueId:@"0" drinkName:self.menuItem.name price:total completion:^(NSError *error, id result) {
        if ([result boolValue]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kCDOrderPlacedNotification object:self];
            [SVProgressHUD dismiss];
            self.successPopup.hidden = NO;
        } else {
            [SVProgressHUD showErrorWithStatus:@"Oops! Something went wrong."];
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
