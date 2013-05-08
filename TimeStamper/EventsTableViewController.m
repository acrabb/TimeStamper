//
//  EventsTableViewController.m
//  TimeStamper
//
//  Created by André Crabb on 4/25/13.
//  Copyright (c) 2013 Andre Crabb. All rights reserved.
//

#import "EventsTableViewController.h"

@interface EventsTableViewController ()

@end

@implementation EventsTableViewController // <UITableViewDataSource, UITableViewDelegate>

@synthesize myModel = _myModel;
NSDateFormatter *dateFormatter;
NSString *detail;
NSString *INFO_MESSAGE = @"TimeStamper is an app to remember what you did! Just push a button and talk to your device. It'll remember things for you!\n\nSpeech recognition provided by Nuance Communications, Inc.";

//-------------------------------------------------------------------------------------------
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        NSLog(@"INIT with style!!!");
    }
    return self;
}

//-------------------------------------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.myModel = [TSModel sharedInstance];
    [self.myModel setUp];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Paper-1.png"]];
    self.tableView.backgroundView = imageView;
    
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [infoButton addTarget:self
                   action:@selector(helpButtonTapped:)
        forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *ib = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
    [self.navigationItem setLeftBarButtonItem:ib
                                     animated:YES];
    
//    NSLog(@"Loaded with events %@", [self.myModel.events description]);
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    dateFormatter = [[NSDateFormatter alloc] init];
}

//-------------------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

//-------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-------------------------------------------------------------------------------------------
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

//-------------------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.myModel.events.count;
}

//-------------------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EVENT_CELL_ID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];// forIndexPath:indexPath];
    
    // Configure the cell...
    EventModel *event = [self.myModel.events objectAtIndex:indexPath.row];
    [cell.textLabel setText:[NSString stringWithFormat:@"%@", event.name]];
    
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    detail = [dateFormatter stringFromDate:event.dateStarted];
    [cell.detailTextLabel setText:detail];//[NSString stringWithFormat:@"%d min", min]];
    
    return cell;
}

// Override to support conditional editing of the table view.
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Return NO if you do not want the specified item to be editable.
//    return YES;
//}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
                                            forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSLog(@"Deleting row: %d", indexPath.row);
        [self.myModel.events removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        NSLog(@"DELETED");
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

//-------------------------------------------------------------------------------------------
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    self.myModel.currentEvent = [self.myModel.events objectAtIndex:indexPath.row];
    NSLog(@">>> Selected row!");
    
    [self performSegueWithIdentifier:@"SavedEventSegue"
                              sender:[tableView cellForRowAtIndexPath:indexPath]];
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath
                                                  toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (IBAction)helpButtonTapped:(id)sender {
    NSLog(@"Help button tapped!");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"TimeStamper"
                                                    message:INFO_MESSAGE
                                                   delegate:nil
                                          cancelButtonTitle:@"Start remembering!"
                                          otherButtonTitles:nil, nil];
    [alert show];
}



// This will get called too before the view appears
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"NewEventSegue"]) {
        NSLog(@">>> New event segue.");
        // Get destination view controller
        [self.myModel createNewEvent];
        // TSModel's current item is now *event
    }
}

@end
