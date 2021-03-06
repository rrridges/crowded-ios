//
//  CDVenueViewController.m
//  Crowded
//
//  Created by Matt Bridges on 6/7/14.
//  Copyright (c) 2014 Intrepid. All rights reserved.
//

#import "CDVenueViewController.h"
#import "CDVenue.h"
#import "CDCrowdedView.h"
#import "CDBorderedView.h"
#import "Common.h"
#import "CDMenuItem.h"
#import "NSString+CrowdLevel.h"
#import "CDMenuViewController.h"

@interface CDVenueViewController ()
@property (weak, nonatomic) IBOutlet UILabel *address1Label;
@property (weak, nonatomic) IBOutlet UILabel *address2Label;
@property (weak, nonatomic) IBOutlet CDCrowdedView *crowdedView;
@property (weak, nonatomic) IBOutlet UILabel *crowdLevelLabel;
@property (weak, nonatomic) IBOutlet CDBorderedView *specialView;
@property (weak, nonatomic) IBOutlet UILabel *specialNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *specialDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *specialPriceLabel;
@end

@implementation CDVenueViewController

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
    if (!self.venue) {
        self.venue = [self dummyVenue];
    }
    [self setupWithVenue:self.venue];
    [self setupWithSpecial:[self dummySpecial]];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Venue" style:UIBarButtonItemStylePlain target:nil action:nil];
    // Do any additional setup after loading the view.
}

- (CDVenue *) dummyVenue {
    CDVenue *venue = [[CDVenue alloc] init];
    venue.address1 = @"187 Cambridge Street";
    venue.address2 = @"Cambridge, MA 02139";
    venue.name = @"Atwoods Tavern";
    venue.crowdLevel = 2;
    
    return venue;
}

- (CDMenuItem *)dummySpecial {
    CDMenuItem *item = [[CDMenuItem alloc] init];
    item.itemDescription = @"Farmhouse brewed with white sage, Baltimore MD 12.0 Oz, 6.6 ABV";
    item.name = @"SMUTTYNOSE CELLAR DOOR";
    item.price = [[NSDecimalNumber alloc] initWithDouble:8.0];
    return item;
}

- (void)setupWithVenue:(CDVenue *)venue {
    self.address1Label.text = venue.address1;
    self.address2Label.text = venue.address2;
    self.crowdedView.crowdLevel = venue.crowdLevel;
    self.crowdLevelLabel.text = [NSString stringForCrowdLevel:venue.crowdLevel];
    self.navigationItem.title = venue.name;
}

- (void)setupWithSpecial:(CDMenuItem *)item {
    self.specialView.layer.borderColor = UIColorFromRGB(0xDD6342).CGColor;
    self.specialNameLabel.text = item.name;
    self.specialDescriptionLabel.text = item.itemDescription;
    self.specialPriceLabel.text = [NSString stringWithFormat:@"$%.2f", item.price.floatValue];
}

- (CDMenuItem *)itemWithName:(NSString *)name description:(NSString *)description price:(NSDecimalNumber *)price {
    CDMenuItem *item = [[CDMenuItem alloc] init];
    item.itemDescription = description;
    item.name = name;
    item.price = price;
    return item;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"menuSegue"]) {
        CDMenuViewController *vc = (CDMenuViewController *)segue.destinationViewController;
        NSMutableArray *menuItems = [NSMutableArray array];
        
        [menuItems addObject:[self itemWithName:@"WEIHENSTEPHANER HEFE"
                                    description:@"Hefeweizen, Freising Germany. 20.0 oz, 5.1 ABV"
                                          price:[[NSDecimalNumber alloc] initWithDouble:7.0]]];
        [menuItems addObject:[self itemWithName:@"TRILLIUM DRY STACK #5"
                                    description:@"Farmhouse IPA, Boston MA. 13.0 oz, 7.3 ABV"
                                          price:[[NSDecimalNumber alloc] initWithDouble:7.0]]];
        [menuItems addObject:[self itemWithName:@"STILLWATER CELLAR DOOR"
                                    description:@"Farmhouse brewed with white sage, Baltimore MD. 12.0 oz, 6.6 ABV"
                                          price:[[NSDecimalNumber alloc] initWithDouble:8.0]]];
        [menuItems addObject:[self itemWithName:@"SMUTTYNOSE OLD BROWN DOG"
                                    description:@"American Brown Ale, Portsmouth NH. 16.0 oz, 6.9 ABV"
                                          price:[[NSDecimalNumber alloc] initWithDouble:6.0]]];
        [menuItems addObject:[self itemWithName:@"SMUTTYNOSE IPA"
                                    description:@"Hoppy American IPA, Portsmouth NH. 16.0 oz, 6.9 ABV"
                                          price:[[NSDecimalNumber alloc] initWithDouble:5.5]]];
        

        vc.menuItems = menuItems;
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
