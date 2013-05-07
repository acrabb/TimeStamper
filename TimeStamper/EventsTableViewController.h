//
//  EventsTableViewController.h
//  TimeStamper
//
//  Created by André Crabb on 4/25/13.
//  Copyright (c) 2013 Andre Crabb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSModel.h"

@interface EventsTableViewController : UITableViewController

@property (strong, nonatomic) TSModel *myModel;

- (IBAction)helpButtonTapped:(id)sender;

@end
