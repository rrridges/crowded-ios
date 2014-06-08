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

@interface CDOrderQueueViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) NSArray *orders;
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
    self.orders = [self dummyOrders];
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
    if (indexPath.row < 2) {
        order.ready = YES;
    }
    [self configureCell:cell withOrder:order];
    return cell;
}

- (void)configureCell:(CDOrderQueueTableViewCell *)cell withOrder:(CDOrder *)order {
    cell.userNameLabel.text = order.userName;
    cell.itemNameLabel.text = order.itemName;
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
