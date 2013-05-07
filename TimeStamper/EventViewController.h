//
//  EventViewController.h
//  TimeStamper
//
//  Created by André Crabb on 4/2/13.
//  Copyright (c) 2013 Andre Crabb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpeechKit/SpeechKit.h>
#import <SpeechKit/SpeechKitErrors.h>
#import "TSModel.h"
#import "EventModel.h"
#import "EventView.h"
#import "EventNode.h"
#import "NodeDetailViewController.h"

@class EventViewController;

@protocol EventViewControllerDelegate
- (void)eventViewControllerDidFinish:(EventViewController *)controller;
@end


@interface EventViewController : UIViewController <UITableViewDataSource,
                                    UITableViewDelegate, SKRecognizerDelegate,
                                    UIAlertViewDelegate, UIActionSheetDelegate>


@property (assign, nonatomic) id <EventViewControllerDelegate> delegate;

@property (strong, nonatomic) TSModel               *myModel;
@property (strong, nonatomic) EventModel            *myEvent;
@property (strong, nonatomic) SKRecognizer          *recognizer;
@property (strong, nonatomic) NSDateFormatter       *dateFormatter;

@property (strong, nonatomic) IBOutlet EventView    *myView;
@property (strong, nonatomic) IBOutlet UILabel      *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel      *initialTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel      *initialDateLabel;
//@property (strong, nonatomic) IBOutlet UITableView  *nodeTable;



- (IBAction)menuButtonPressed:(id)sender;
- (IBAction)addNodeButtonPressed:(id)sender;
//- (void)showPevious; //Of:(NSIndexPath *)oldIndexPath;
//- (void)showNext;   //Of:(NSIndexPath *)oldIndexPath;
- (void)receiveSegueData:(EventModel *)event;



@end
