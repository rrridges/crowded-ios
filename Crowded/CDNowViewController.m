//
//  CDNowViewController.m
//  Crowded
//
//  Created by Matt Bridges on 6/7/14.
//  Copyright (c) 2014 Intrepid. All rights reserved.
//

#import "CDNowViewController.h"
#import "CDNowTableViewCell.h"
#import "CDCrowdedView.h"
#import "CDVenue.h"

@interface CDNowViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) NSArray *specials;
@property (nonatomic) NSArray *venues;
@end

@implementation CDNowViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSArray *)dummySpecials {
    return @[@"Wild boar bratwurst special at",
             @"$20 Bucket of Ponys at the",
             @"Wednesday is always trivia night at"];
}

- (NSArray *)dummyVenues {
    NSArray *names = @[@"ATWOODS TAVERN",
                       @"BLEACHER BAR",
                       @"THE DRUID"];
    NSMutableArray *venues = [NSMutableArray array];
    for (NSString *name in names) {
        CDVenue *venue = [[CDVenue alloc] init];
        venue.name = name;
        [venues addObject:venue];
    }
    return venues;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.specials = [self dummySpecials];
    self.venues = [self dummyVenues];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 67;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.specials.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CDNowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NowCell" forIndexPath:indexPath];
    [self configureCell:cell forRow:indexPath.row];
    return cell;
}

- (void)configureCell:(CDNowTableViewCell *)cell forRow:(NSUInteger)row {
    CDVenue *venue = self.venues[row];
    NSString *special = self.specials[row];
    cell.crowdedView.crowdLevel = arc4random() % 3 + 2;
    cell.venueNameLabel.text = venue.name;
    cell.specialLabel.text = special;
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
