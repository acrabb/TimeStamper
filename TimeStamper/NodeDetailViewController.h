//
//  NodeDetailViewController.h
//  TimeStamper
//
//  Created by André Crabb on 4/4/13.
//  Copyright (c) 2013 Andre Crabb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventNode.h"
#import "NodeDetailView.h"
#import <Social/Social.h>
#import <Social/Social.h>
#import "EventViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>

//@class NodeDetailView;

@interface NodeDetailViewController : UIViewController
            <UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) IBOutlet NodeDetailView   *myView;
@property (strong, nonatomic) EventNode                 *node;
//- (IBAction)prevButtonTapped:(id)sender;
//- (IBAction)nextButtonTapped:(id)sender;
- (IBAction)imageViewTapped:(id)sender;

- (id)initWithNode:(EventNode*)node;
- (void)receiveSegueNode:(EventNode*) node andVC:(EventViewController *)vc;
- (IBAction)socialButtonTapped:(id)sender;

@end
