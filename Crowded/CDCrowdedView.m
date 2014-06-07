//
//  CDCrowdedView.m
//  Crowded
//
//  Created by Matt Bridges on 6/7/14.
//  Copyright (c) 2014 Intrepid. All rights reserved.
//

#import "CDCrowdedView.h"
#import "Common.h"

@implementation CDCrowdedView

- (instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.crowdLevel = 4;
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    self.crowdLevel = 3;
}

- (void)setCrowdLevel:(NSInteger)crowdLevel {
    _crowdLevel = crowdLevel;
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGSize margin = CGSizeMake(self.bounds.size.width / 10.0, self.bounds.size.height / 10.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    if (self.crowdLevel > 3) {
        CGContextSetFillColorWithColor(context, UIColorFromRGB(0xC2262A).CGColor);
        CGContextFillEllipseInRect(context, self.bounds);
    }
    if (self.crowdLevel > 2) {
        CGContextSetFillColorWithColor(context, UIColorFromRGB(0xE35A35).CGColor);
        CGFloat indent = 1;
        CGContextFillEllipseInRect(context, CGRectMake(margin.width * indent,
                                                       margin.height * indent,
                                                       self.bounds.size.width - 2 * margin.width * indent,
                                                       self.bounds.size.height - 2 * margin.height * indent));
    }
    if (self.crowdLevel > 1) {
        CGContextSetFillColorWithColor(context, UIColorFromRGB(0xE38F39).CGColor);
        CGFloat indent = 2;
        CGContextFillEllipseInRect(context, CGRectMake(margin.width * indent,
                                                       margin.height * indent,
                                                       self.bounds.size.width - 2 * margin.width * indent,
                                                       self.bounds.size.height - 2 * margin.height * indent));
    }
    if (self.crowdLevel > 0) {
        CGContextSetFillColorWithColor(context, UIColorFromRGB(0xE4BB3D).CGColor);
        CGFloat indent = 3;
        CGContextFillEllipseInRect(context, CGRectMake(margin.width * indent,
                                                       margin.height * indent,
                                                       self.bounds.size.width - 2 * margin.width * indent,
                                                       self.bounds.size.height - 2 * margin.height * indent));
    }
    CGContextSetFillColorWithColor(context, UIColorFromRGB(0xFCD846).CGColor);
    CGFloat indent = 4;
    CGContextFillEllipseInRect(context, CGRectMake(margin.width * indent,
                                                   margin.height * indent,
                                                   self.bounds.size.width - 2 * margin.width * indent,
                                                   self.bounds.size.height - 2 * margin.height * indent));
    
    CGContextRestoreGState(context);
}


@end
