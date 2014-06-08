//
//  CDBarTabViewController.m
//  Crowded
//
//  Created by Matt Bridges on 6/8/14.
//  Copyright (c) 2014 Intrepid. All rights reserved.
//

#import "CDBarTabViewController.h"
#import "CDWebService.h"
#import "CDOrder.h"
#import "CDBarTabTableViewCell.h"
#import "Common.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface CDBarTabViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSArray *orders;
@property (nonatomic) CDWebService *webService;
@end

@implementation CDBarTabViewController

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
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"My Tab";
    self.webService = [[CDWebService alloc] init];
    
    [self doPoll];
}

- (void)doPoll {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"Polling Tab");
        [self.webService getOrdersForVenue:@"0" completion:^(NSError *error, id result) {
            if (!error && [result isKindOfClass:[NSArray class]] ) {
                
                NSArray *filtered = [result filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                    if ([evaluatedObject isKindOfClass:[CDOrder class]]) {
                        CDOrder *order = evaluatedObject;
                        return [order.userId isEqualToString:@"0"];
                    } else {
                        return false;
                    }
                }]];
                
                if ([self ordersAreNew:filtered]) {
                    self.orders = filtered;
                    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
                }
                
            }
            
            [self doPoll];
            
        }];
    });
}

- (BOOL)ordersAreNew:(NSArray *)orders {
    for (int i = 0; i < MIN(self.orders.count, orders.count); i++) {
        CDOrder *left = orders[i];
        CDOrder *right = self.orders[i];
        if (![left.orderId isEqualToString:right.orderId]) {
            return YES;
        }
        if (left.ready != right.ready && left.ready) {
            self.navigationController.tabBarItem.badgeValue = @"1";
            return YES;
        }
    }
    return orders.count != self.orders.count;
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.tabBarItem.badgeValue = nil;
    [SVProgressHUD show];
    [self.webService getOrdersForVenue:@"0" completion:^(NSError *error, id result) {
        if (!error && [result isKindOfClass:[NSArray class]]) {
            [SVProgressHUD dismiss];

            NSArray *filtered = [result filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                if ([evaluatedObject isKindOfClass:[CDOrder class]]) {
                    CDOrder *order = evaluatedObject;
                    return [order.userId isEqualToString:@"0"];
                } else {
                    return false;
                }
            }]];
            
            self.orders = filtered;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
            
        
        } else {
            [SVProgressHUD showErrorWithStatus:@"Oops! Something went wrong."];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.orders.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CDBarTabTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"barTabCell" forIndexPath:indexPath];
    CDOrder *order = self.orders[indexPath.row];
    [self configureCell:cell withOrder:order];
    return cell;
}

- (void)configureCell:(CDBarTabTableViewCell *)cell withOrder:(CDOrder *)order {
    cell.itemNameLabel.text = [order.itemName capitalizedString];
    if (order.price) {
        cell.priceLabel.text = order.price;
    }
    if (order.ready) {
        cell.statusImageView.image = [UIImage imageNamed:@"status_done.png"];
        cell.containerView.layer.borderColor = UIColorFromRGB(0xDD6342).CGColor;
    } else {
        cell.statusImageView.image = [UIImage imageNamed:@"status_in_line.png"];
        cell.containerView.layer.borderColor = UIColorFromRGB(0x4A7EC5).CGColor;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
