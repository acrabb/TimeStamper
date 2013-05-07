//
//  TSViewController.m
//  TimeStamper
//
//  Created by André Crabb on 4/9/13.
//  Copyright (c) 2013 Andre Crabb. All rights reserved.
//

#import "TSViewController.h"
#import "EventsTableViewController.h"
#import "EventViewController.h"

@interface TSViewController ()

@end

@implementation TSViewController

@synthesize myModel                 = _myModel;
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSLog(@"Loading model!");
    self.myModel = [TSModel sharedInstance];
    [self.myModel setUp];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// This will get called too before the view appears
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"NewEventSegue"]) {
//        NSLog(@">>> New event segue.");
        // Get destination view controller
        [self.myModel createNewEvent];
//        EventModel *event = self.myModel.currentEvent;
//        EventViewController *vc = [segue destinationViewController];
//        [vc receiveSegueData:event];
    }
    else if ([[segue identifier] isEqualToString:@"EventTableSegue"]) {
//        NSLog(@">>> Event table segue.");
        // Get destination view controller
//        EventsTableViewController *vc = [segue destinationViewController];
//        [vc receiveSegueData:selectedNode];
    }
}



@end
