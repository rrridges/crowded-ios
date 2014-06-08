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
#import "CDBeaconManager.h"
#import "CDVenueViewController.h"

@interface CDNowViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) NSArray *specials;
@property (nonatomic) NSArray *venues;
@property (nonatomic) CDVenue *headerVenue;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *currentVenueLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentVenueAddressLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

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

- (CDVenue *) dummyVenue {
    CDVenue *venue = [[CDVenue alloc] init];
    venue.address1 = @"187 Cambridge Street";
    venue.address2 = @"Cambridge, MA 02139";
    venue.name = @"Atwoods Tavern";
    venue.crowdLevel = 2;
    
    return venue;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.specials = [self dummySpecials];
    self.venues = [self dummyVenues];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(venueChanged:) name:kCDBeaconManagerVenueChangedNotification object:nil];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerTapped)];
    [self.headerView addGestureRecognizer:tap];
    self.navigationItem.title = @"Now";
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"venueSegue"]) {
        CDVenueViewController *vc = (CDVenueViewController *)segue.destinationViewController;
        vc.venue = self.selectedVenue;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CDNowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NowCell" forIndexPath:indexPath];
    [self configureCell:cell forRow:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        self.selectedVenue = [self dummyVenue];
        [self performSegueWithIdentifier:@"venueSegue" sender:self];
    }
}

- (void)configureCell:(CDNowTableViewCell *)cell forRow:(NSUInteger)row {
    CDVenue *venue = self.venues[row];
    NSString *special = self.specials[row];
    cell.crowdedView.crowdLevel = arc4random() % 3 + 2;
    cell.venueNameLabel.text = venue.name;
    cell.specialLabel.text = special;
}

- (void)venueChanged:(NSNotification *)notification {
    CDBeaconManager *manager = [notification object];
    if (manager.currentVenue) {
        CDVenue *venue = manager.currentVenue;
        self.currentVenueLabel.text = venue.name;
        self.currentVenueAddressLabel.text = venue.address1;
        self.headerVenue = venue;
        [self showHeaderView];
    } else {
        [self hideHeaderView];
    }
}

- (void)showHeaderView {
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.headerView.frame;
        frame.origin.y = 20;
        self.headerView.frame = frame;
        frame = self.tableView.frame;
        frame.origin.y = 20 + self.headerView.frame.size.height;
        frame.size.height = 500 - self.headerView.frame.size.height;
        self.tableView.frame = frame;
    }];
}

- (void)hideHeaderView {
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.headerView.frame;
        frame.origin.y = -53;
        self.headerView.frame = frame;
        frame = self.tableView.frame;
        frame.origin.y = 20;
        frame.size.height = 500;
        self.tableView.frame = frame;
    }];
}

- (void)headerTapped {
    self.selectedVenue = self.headerVenue;
    [self performSegueWithIdentifier:@"venueSegue" sender:self];
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
