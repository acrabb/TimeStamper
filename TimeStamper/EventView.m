//
//  EventView.m
//  TimeStamper
//
//  Created by André Crabb on 4/2/13.
//  Copyright (c) 2013 Andre Crabb. All rights reserved.
//

#import "EventView.h"
#import "EventViewController.h"


@implementation EventView

@synthesize nodeTable       = _nodeTable;
@synthesize nodes           = _nodes;
@synthesize myController    = _myController;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) updateTable {
//    [self.nodeTable setContentOffset:CGPointMake(0, CGFLOAT_MAX)];
//    UITableViewScrollPositionBottom
    [self.nodeTable reloadData];
    
    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.nodeTable scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];

    //    NSIndexPath *path = [[NSIndexPath alloc] init];
    
    
    //    cell.textLabel.text = @"YAYYY!";
    //    cell.backgroundColor = [UIColor redColor];
    ////    [self.nodeTable addSubview:cell];
    //    [self.nodeTable insertSubview:cell atIndex:nextCount];
    //    nextCount++;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
