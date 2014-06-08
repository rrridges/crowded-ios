//
//  CDOrderQueueViewController.m
//  Crowded
//
//  Created by Matt Bridges on 6/8/14.
//  Copyright (c) 2014 Intrepid. All rights reserved.
//

#import "CDOrderQueueViewController.h"
#import "CDOrder.h"
#import "CDOrderQueueTableViewCell.h"
#import "Common.h"
#import "CDWebService.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface CDOrderQueueViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) NSArray *orders;
@property (nonatomic) CDWebService *webService;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation CDOrderQueueViewController

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
    
    self.navigationItem.title = @"Order Queue";
    self.webService = [[CDWebService alloc] init];
}

- (void)doPoll {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"Polling");
        [self.webService getOrdersForVenue:@"0" completion:^(NSError *error, id result) {
            if (!error && [result isKindOfClass:[NSArray class]] && [self ordersAreNew:result]) {
                self.orders = result;
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
                
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
    }
    return orders.count != self.orders.count;
}

- (void)viewWillAppear:(BOOL)animated {
    [SVProgressHUD show];
    
    [self.webService getOrdersForVenue:@"0" completion:^(NSError *error, id result) {
        if (!error && result) {
            [SVProgressHUD dismiss];
            self.orders = result;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        } else {
            [SVProgressHUD showErrorWithStatus:@"Oops! Something went wrong."];
        }
        [self doPoll];
    }];
}

- (NSArray *)dummyOrders {
    NSMutableArray *orders = [NSMutableArray array];
    
    for (int i = 0; i < 8; i++) {
        CDOrder *order = [[CDOrder alloc] init];
        order.userName = @"Matt B.";
        order.itemName = @"SMUTTYNOSE BROWN DOG ALE";
        order.userImage = @"photo_1.png";
        order.creationTimestamp = [NSDate date];
        order.readyTimestamp = [NSDate date];
        order.ready = NO;
        [orders addObject:order ];
    }

    return orders;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.orders.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CDOrderQueueTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderQueueCell" forIndexPath:indexPath];
    CDOrder *order = self.orders[indexPath.row];
    [self configureCell:cell withOrder:order];
    return cell;
}

- (void)configureCell:(CDOrderQueueTableViewCell *)cell withOrder:(CDOrder *)order {
    cell.userNameLabel.text = order.userName;
    cell.itemNameLabel.text = [order.itemName capitalizedString];
    if (order.ready) {
        cell.statusImageView.image = [UIImage imageNamed:@"status_done.png"];
        cell.containerView.layer.borderColor = UIColorFromRGB(0xDD6342).CGColor;
        cell.userNameLabel.textColor = UIColorFromRGB(0xDD6342);
    } else {
        cell.statusImageView.image = [UIImage imageNamed:@"status_in_line.png"];
        cell.containerView.layer.borderColor = UIColorFromRGB(0x4A7EC5).CGColor;
        cell.userNameLabel.textColor = UIColorFromRGB(0x4A7EC5);
    }
    cell.avatarImageView.image = [UIImage imageNamed:order.userImage];
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
