//
//  EventViewController.m
//  TimeStamper
//
//  Created by André Crabb on 4/2/13.
//  Copyright (c) 2013 Andre Crabb. All rights reserved.
//

#import "EventViewController.h"

#define FONT_SIZE 17.0f
#define CELL_CONTENT_WIDTH 200.0f
#define CELL_CONTENT_MARGIN 5.0f

@interface EventViewController ()

@end

@implementation EventViewController

@synthesize titleLabel              = _titleLabel;
@synthesize initialTimeLabel        = _initialTimeLabel;
@synthesize initialDateLabel        = _initialDateLabel;
@synthesize myModel                 = _myModel;
@synthesize myEvent                 = _myEvent;
@synthesize myView                  = _myView;
@synthesize dateFormatter           = _dateFormatter;
@synthesize recognizer              = _recognizer;

EventNode *selectedNode;
NSIndexPath *currentIndexPath;
NodeDetailViewController *detailController;
const int ALERT_REC = 1;
const int ALERT_EDIT = 2;
const int ALERT_SPIN = 3;

const unsigned char SpeechKitApplicationKey[] = {0x47, 0x59, 0xd7, 0xbf, 0xe9,
    0x87, 0x59, 0x34, 0x56, 0xcf, 0x7b, 0x38, 0x65, 0xce, 0xe9, 0x2f, 0xc1, 0x3d,
    0xd3, 0xbd, 0x58, 0xbf, 0x12, 0x6d, 0xca, 0x4c, 0xa8, 0xcc, 0xc3, 0xe8, 0x7d,
    0x0a, 0x41, 0x54, 0xca, 0x2b, 0xdb, 0x23, 0x5f, 0x31, 0xf3, 0xda, 0x69, 0x58,
    0xa8, 0x53, 0x87, 0x6a, 0x90, 0x5a, 0x27, 0xe8, 0x1a, 0x39, 0x56, 0xe4, 0x85,
    0xfe, 0xb1, 0x48, 0xe6, 0x2e, 0x53, 0x27};



//-------------------------------------------------------------------------------------------
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//-------------------------------------------------------------------------------------------
//- (void)receiveSegueData:(EventModel *)event {
//    self.myEvent = event;
//}
//-------------------------------------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //Background?
    [SpeechKit setupWithID:@"NMDPTRIAL_acrabb20130308013630"
                      host:@"sandbox.nmdp.nuancemobility.net"
                      port:443
                    useSSL:NO
                  delegate:nil];
    
   // Get underlying model of app
    self.myModel = [TSModel sharedInstance];
    self.myEvent = self.myModel.currentEvent;
    if (self.myEvent == nil) {
        NSLog(@"NIL EVENT IN EVENTVIEWCONTROLLER :(");
    }
    
//    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]
//                                        init];
//    refreshControl.tintColor = [UIColor blueColor];
//    self.refreshControl = refreshControl;
    
    // Tell view to...
    [self.titleLabel setText:self.myEvent.name];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    NSString *detail;
    [self.dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    detail = [self.dateFormatter stringFromDate:self.myEvent.dateStarted];
    [self.initialTimeLabel setText:detail];
//    NSLog(@"Event time: %@", detail);
    
    [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    detail = [self.dateFormatter stringFromDate:self.myEvent.dateStarted];
    [self.initialDateLabel setText:[self.dateFormatter stringFromDate:self.myEvent.dateStarted]];
    NSLog(@"Event date: %@", detail);
    
    
    [self.myView updateTable];
    NSLog(@">>> Event View Loaded");
    
//    self.myView.nodeTable.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Paper-3.png"]];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Paper-3.png"]];
    self.myView.nodeTable.backgroundView = imageView;
    
    
    if (self.myEvent.nodes.count == 1) {
        // Show alert to explain what's going on.
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Event started!"
                                                       message:@"Tap the 'Add' button below to add a node."
                                                      delegate:self
                                             cancelButtonTitle:@"Go!"
                                             otherButtonTitles:nil];
        [alert show];
    }
}


- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self.navigationController setToolbarHidden:YES animated:animated];
    
    // Make sure the nodeTable is aligned with the navigation bar properly.
        // ADD THIS PROPERLY WHEN SUPPORTING LANDSCAPE!
    
        // Attempt 1
//    float con = self.navigationController.navigationBar.frame.size.height;
//    [self.myView.nodeTable setFrame:CGRectMake(self.myView.nodeTable.frame.origin.x,
//                                              self.myView.nodeTable.frame.origin.y + con,
//                                              self.myView.nodeTable.frame.size.width,
//                                              self.myView.nodeTable.frame.size.height - con)];
        // Attempt 2
//    NSLayoutConstraint *c = [NSLayoutConstraint constraintWithItem:self.myView.nodeTable
//                                                         attribute:NSLayoutAttributeTop
//                                                         relatedBy:NSLayoutRelationEqual
//                                                            toItem:self.myView
//                                                         attribute:NSLayoutAttributeTop
//                                                        multiplier:0
//                                                          constant:con];
//    [self.myView.nodeTable addConstraint:c];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.myView.nodeTable deselectRowAtIndexPath:[self.myView.nodeTable indexPathForSelectedRow] animated:YES];
}

/******************************************************************************
    TableView Methods
 ******************************************************************************/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

//-------------------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.myEvent.nodes.count;
}

//-------------------------------------------------------------------------------------------
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    NSString *text = [[self.myRecipe.nodes objectAtIndex:[indexPath row]] text];
//    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
//    
//    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE]
//                   constrainedToSize:constraint
//                       lineBreakMode:NSLineBreakByWordWrapping];
//    
//    CGFloat height = MAX(size.height, 44.0f);
//    return height + (CELL_CONTENT_MARGIN * 2);
//}


//-------------------------------------------------------------------------------------------
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *NodeCellIdentifier = @"NODE_CELL_ID";
//    int row = indexPath.row;
    
    // Get a recycled cell.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NodeCellIdentifier];
    // If none exists, create a new one.
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:NodeCellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    // Set up the cell.
    EventNode *node = [self.myEvent.nodes objectAtIndex:indexPath.row];
    [node setTimeOffset:[TSModel getTimeStringFromDate:self.myEvent.dateStarted
                                                toDate:node.timeStamp]];
    [cell.detailTextLabel setText:node.timeOffset];
    [cell.textLabel setText:node.text];
    
    
    UILabel *label = cell.textLabel;
//    [cell sendSubviewToBack:label];
//    [label setHidden:YES];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 4.5, 225.0f, 40)];
//    [label setLineBreakMode:UILineBreakModeWordWrap];
    [label setLineBreakMode:NSLineBreakByWordWrapping];
//    [label setMinimumScaleFactor:.7];
//    [label setMinimumFontSize:FONT_SIZE];
    [label setNumberOfLines:0];
    [label setFont:[UIFont systemFontOfSize:FONT_SIZE]];
    [label setTag:1];
    label.text = [NSString stringWithFormat:@"%@", node.text];
//    [cell addSubview:label];
    

//    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(10.0f, 4.5f, 200.0f, 20.0f)];
////    [[UILabel alloc]initwithFrame:cell.textLabel.frame];
//    [lbl setLineBreakMode:NSLineBreakByWordWrapping];
//    [lbl setNumberOfLines:0];
//    lbl.text = [NSString stringWithFormat:@"%@", node.text];
//    
//    [cell.contentView addSubview:lbl];
    
//    [cell.textLabel setLineBreakMode:NSLineBreakByWordWrapping];
//    [cell.textLabel setNumberOfLines:0];

    
    // Return cell.
    return cell;
}

//-------------------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    selectedNode = [self.myEvent.nodes objectAtIndex:indexPath.row];
    currentIndexPath = indexPath;
    NSLog(@"Selected node: %@", selectedNode.text);
    
    // Go to node detail view.
    // HANDLED BY A CUSTOM SEGUE IN STORYBOARD
    
    [self performSegueWithIdentifier:@"NodeDetailSegue"
                              sender:[tableView cellForRowAtIndexPath:indexPath]];
  
    // For non-segues
//    detailController = [[NodeDetailViewController alloc] initWithNode:selectedNode];
//    detailController.modalTransitionStyle = ; //Could pick a different animation.
//    [self.navigationController pushViewController:detailController animated:YES];
//    [self presentViewController:detailController animated:YES completion:^{
        //code
//    }];
}

//-------------------------------------------------------------------------------------------
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
                                            forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSLog(@"Deleting row: %d", indexPath.row);
        [self.myEvent.nodes removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        NSLog(@"DELETED");
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}





//-------------------------------------------------------------------------------------------
/*
- (void)showPevious{ //Of:(NSIndexPath *)oldIndexPath {
    // TODO How to? :(
    NSLog(@"Previous button tapped.");
    if (currentIndexPath.row == 0) {
        return;
    }
    NSIndexPath* newIndexPath = [NSIndexPath indexPathForRow:currentIndexPath.row-1
                                                   inSection:currentIndexPath.section];
    currentIndexPath = newIndexPath;
    [self performSegueWithIdentifier:@"NodeDetailSegue"
                              sender:[self.myView.nodeTable cellForRowAtIndexPath:newIndexPath]];
}
*/

// This will get called too before the view appears
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"NodeDetailSegue"]) {
        NSLog(@">>> Node detail segue.");
        // Get destination view controller
        NodeDetailViewController *vc = [segue destinationViewController];
        [vc receiveSegueNode:selectedNode andVC:self];
    }
}


/******************************************************************************
 SKRecognizer Methods
 ******************************************************************************/

UIAlertView *alert;

//-------------------------------------------------------------------------------------------
- (void)recognizerDidBeginRecording:(SKRecognizer *) recognizer {
    NSLog(@">>> Recognizer started recording!");
    
    // Moved the following code to the button press.
    alert =[[UIAlertView alloc] initWithTitle:@"Listening..."
                                      message:nil
                                     delegate:self
                            cancelButtonTitle:@"Cancel"
                            otherButtonTitles:@"Done", nil];
    [alert setTag:ALERT_REC];
    [alert show];
    //    alert.cancelButtonIndex = 0;
}

//-------------------------------------------------------------------------------------------
- (void)recognizerDidFinishRecording:(SKRecognizer *) recognizer {
    NSLog(@"  > Recognizer finished recording!");
    [alert dismissWithClickedButtonIndex:2 animated:YES];
    alert = [[UIAlertView alloc] initWithTitle:@"Sending..."
                                       message:nil
                                      delegate:self
                             cancelButtonTitle:nil
                             otherButtonTitles:nil];
    alert.tag = ALERT_SPIN;
    [alert show];
}

//-------------------------------------------------------------------------------------------
- (void)willPresentAlertView:(UIAlertView *)alertView {
    UIActivityIndicatorView *aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    switch (alertView.tag) {
        case ALERT_REC:
            // Resize the alert view to make room for NDEV logo.
//            alertView.frame = CGRectMake( alertView.frame.origin.x,
//                                         alertView.frame.origin.y,
//                                         alertView.frame.size.width,
//                                         alertView.frame.size.height + 20);
            break;
        case ALERT_SPIN:
            aiv.center = CGPointMake(alert.bounds.size.width / 2, alert.bounds.size.height / 2);
            [aiv startAnimating];
            [alert addSubview:aiv];
            break;
            
        default:
            break;
    }
}

//-------------------------------------------------------------------------------------------
- (void)recognizer:(SKRecognizer *) recognizer didFinishWithResults:(SKRecognition *) results {
    NSLog(@"<<< Recognizer has results!");
    [alert setTitle:@"Receiving..."];
    [alert dismissWithClickedButtonIndex:2 animated:YES];
    if (![results.firstResult isEqualToString:@"(null)"]) {
        [self.myEvent addNodeWithString:results.firstResult];
        [self.myView updateTable];
        NSIndexPath *path = [NSIndexPath indexPathForRow:self.myEvent.nodes.count - 1
                           inSection:0];
        [self.myView.nodeTable scrollToRowAtIndexPath:path
                                     atScrollPosition:UITableViewScrollPositionBottom
                                             animated:YES];
    }
}

//-------------------------------------------------------------------------------------------
- (void)recognizer:(SKRecognizer *) recognizer didFinishWithError:(NSError *) error
                                                       suggestion:(NSString *) suggestion {
    [alert dismissWithClickedButtonIndex:2 animated:YES];
    if ([error code] == SKCancelledError) {
        NSLog(@"<<< Recognizer CANCELLED!");
        // stuff
    } else {
        NSLog(@"<<< Recognizer has errors!");
        alert = [[UIAlertView alloc] initWithTitle:@"Something went wrong :("
                                           message:@"Do you has teh interwebz?"
                                          delegate:self
                                 cancelButtonTitle:@"No..."
                                 otherButtonTitles:nil];
        [alert show];
    }
}

//-------------------------------------------------------------------------------------------
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"Alert %d clicked", alertView.tag);
    switch (alertView.tag) {
        case ALERT_REC:
            [self handleRecognizerAlert:buttonIndex];
            break;
        case ALERT_EDIT:
            [self handleEditAlert:alertView forIndex:buttonIndex];
            break;
            
        default:
            break;
    }
}

//-------------------------------------------------------------------------------------------
- (void)handleRecognizerAlert:(int) buttonIndex {
    switch (buttonIndex) {
        case 0:
            // cancel
            NSLog(@"> Alert Rec: Cancel button pressed");
            [self.recognizer cancel];
            break;
        case 1:
            NSLog(@"> Alert Rec: Done button pressed");
            [self.recognizer stopRecording];
            break;
        default:
            break;
    }
}

//-------------------------------------------------------------------------------------------
- (void)handleEditAlert:(UIAlertView *)alertView forIndex:(int) buttonIndex {
    switch (buttonIndex) {
        case 0:
            // cancel
            NSLog(@"> Alert Edit: Cancel button pressed");
            break;
        case 1:
            NSLog(@"> Alert Edit: Done button pressed");
            [self.myEvent setName:[[alertView textFieldAtIndex:0] text]];
            [self.titleLabel setText:self.myEvent.name];
            break;
        default:
            NSLog(@"> Alert Edit: DEFAULT");
            break;
    }
    
}

//-------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-------------------------------------------------------------------------------------------
- (IBAction)menuButtonPressed:(id)sender {
    UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:@"Menu"
                                                      delegate:self
                                             cancelButtonTitle:@"Cancel"
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:@"Edit Event Name", nil];
    [menu showInView:self.myView];
//    [menu showFromBarButtonItem:self.navigationItem.backBarButtonItem animated:YES];
}

//-------------------------------------------------------------------------------------------
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        NSLog(@"> Menu: Cancel button pressed");
        [actionSheet dismissWithClickedButtonIndex:actionSheet.cancelButtonIndex animated:YES];
    } else if (buttonIndex == 0) {
        NSLog(@"> Menu: Edit name button pressed");
        [self showEditNameAlert];
        [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    }
}



//-------------------------------------------------------------------------------------------
- (void) showEditNameAlert{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enter event name:"
                                                   message:nil
                                                  delegate:self
                                         cancelButtonTitle:@"Cancel"
                                         otherButtonTitles:@"Done", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [[alert textFieldAtIndex:0] setText:self.myEvent.name];
    [alert setTag:ALERT_EDIT];
    [alert show];
}
//-------------------------------------------------------------------------------------------
- (IBAction)addNodeButtonPressed:(id)sender {
    NSLog(@"V: Add node pressed");
    
//    alert =[[UIAlertView alloc] initWithTitle:@"Listening..."
//                                      message:nil
//                                     delegate:self
//                            cancelButtonTitle:@"Cancel"
//                            otherButtonTitles:@"Done", nil];
//    [alert setTag:ALERT_REC];
////    [alert addSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Nuancelogo_dark_144x72.png"]]];
//    [alert show];
    self.recognizer = [[SKRecognizer alloc] initWithType:SKDictationRecognizerType
                                               detection:SKShortEndOfSpeechDetection
                                                language:@"en_US"
                                                delegate:self];
}


@end
