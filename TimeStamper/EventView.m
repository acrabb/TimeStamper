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
    [self.nodeTable reloadData];
    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0
                                                      inSection:0];
    [self.nodeTable scrollToRowAtIndexPath:scrollIndexPath
                          atScrollPosition:UITableViewScrollPositionBottom
                                  animated:YES];
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
