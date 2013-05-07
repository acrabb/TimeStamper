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
//    EventNode *node = [self.myEvent.nodes objectAtIndex:indexPath.row];
    EventModel *event = [self.myModel.events objectAtIndex:indexPath.row];
    [cell.textLabel setText:[NSString stringWithFormat:@"%@", event.name]];
    
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    detail = [dateFormatter stringFromDate:event.dateStarted];
//    [self.initialDateLabel setText:[self.dateFormatter stringFromDate:self.myEvent.dateStarted]];
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
}



// This will get called too before the view appears
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"NewEventSegue"]) {
        NSLog(@">>> New event segue.");
        // Get destination view controller
        [self.myModel createNewEvent];
        EventModel *event = self.myModel.currentEvent;
        //        EventViewController *vc = [segue destinationViewController];
//        [vc receiveSegueData:event];
    }
//    else if ([[segue identifier] isEqualToString:@"EventTableSegue"]) {
//        NSLog(@">>> Event table segue.");
        // Get destination view controller
//        EventsTableViewController *vc = [segue destinationViewController];
//        [vc receiveSegueData:selectedNode];
//    }
}
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([[segue identifier] isEqualToString:@"SavedEventSegue"]) {
//        NSLog(@">>> Saved Event segue.");
//        NSLog([NSString stringWithFormat:@"Saved event selected: %@", self.myModel.currentEvent]);
//        // Get destination view controller
////        NodeDetailViewController *vc = [segue destinationViewController];
////        [vc receiveSegueNode:selectedNode andVC:self];
//    }
//}

@end
