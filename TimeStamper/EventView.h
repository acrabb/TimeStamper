//
//  EventView.h
//  TimeStamper
//
//  Created by André Crabb on 4/2/13.
//  Copyright (c) 2013 Andre Crabb. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EventViewController;


@interface EventView : UIView

@property (strong, nonatomic) IBOutlet UITableView          *nodeTable;
@property (strong, nonatomic) IBOutlet EventViewController  *myController;
@property (strong, nonatomic) NSMutableArray                *nodes;

- (void) updateTable;


@end
