//
//  NodeDetailViewController.m
//  TimeStamper
//
//  Created by André Crabb on 4/4/13.
//  Copyright (c) 2013 Andre Crabb. All rights reserved.
//

#import "NodeDetailViewController.h"

@interface NodeDetailViewController ()

@end

@implementation NodeDetailViewController

@synthesize myView  = _myView;
@synthesize node    = _node;
EventViewController *prevVC;


//------------------------------------------------------------------------------
- (id)initWithNode:(EventNode*)node {
    self = [super initWithNibName:@"NodeDetailViewController" bundle:nil];
    if (self) {
        // SET UP STUFF
        self.node = node;
        NSLog(@"I'm here");
    }
    return self;
}


//------------------------------------------------------------------------------
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//------------------------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Set up gesture recognizer to tap the keyboard away.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self.myView
                                                                          action:@selector(dismissKeyboard)];
    [self.myView addGestureRecognizer:tap];
    [self.myView registerForKeyboardNotifications];
    
    // Set the time offlet label in the nav bar.
    [self.myView.timeLabel setText:[self.node timeOffset]];
}

- (NSArray *)setUpToolbarButtons {
    // Set up camera button
    UIBarButtonItem *cameraButton = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
                                                            target:self
                                                            action:@selector(imageViewTapped:)];
    // Set up flexible spacer
    UIBarButtonItem *flexSpacer = [[UIBarButtonItem alloc]
                               initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                            target:nil
                                                                            action:nil];
    // Set up social button
    UIBarButtonItem *socialButton = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                            target:self
                                                            action:@selector(socialButtonTapped:)];
    return [[NSArray alloc] initWithObjects:cameraButton, flexSpacer, socialButton, nil];
}

//------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated {
    NSLog(@">> NODE IS: %@", self.node);
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self.navigationController setToolbarHidden:NO animated:animated];
    
    // Set the toolbar button actions.
    [self setToolbarItems:[self setUpToolbarButtons]];
    
    // Popuplate notes
    NSString *note = self.node.notes;
    if (note == nil) {
        NSLog(@">> Notes are nil.");
        note = @"Notes...";
    }
    [self.myView setNotesText:note];
    // Popuplate image
    if (self.node.image != nil) {
        [self.myView.photoView setImage:self.node.image];
        // Fix autolayout stupidness.
        float ratio = (self.myView.photoView.image.size.height/self.myView.photoView.image.size.width);
        NSLayoutConstraint *c = [NSLayoutConstraint
                                 constraintWithItem:self.myView.photoView
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationLessThanOrEqual
                                    toItem:self.myView.photoView
                                 attribute:NSLayoutAttributeWidth
                                 multiplier:ratio
                                   constant:0];
        [self.myView.photoView addConstraint:c];
    }
}

//------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//------------------------------------------------------------------------------
- (void) viewWillDisappear:(BOOL)animated {
    NSLog(@"> BACK PRESSED! Saving notes: %@", self.myView.notesView.text);
    [self.node setNotes:self.myView.notesView.text];
}


//------------------------------------------------------------------------------
- (void)receiveSegueNode:(EventNode *)selectedNode andVC:(EventViewController *)vc {
    NSLog(@"Node Recieved: %@", selectedNode);
    self.node = selectedNode;
    prevVC = vc;
    self.navigationItem.title = selectedNode.text;
    NSLog(@"Got node: %@", selectedNode.text);
    // Update the view!
}


//------------------------------------------------------------------------------
/*
- (IBAction)prevButtonTapped:(id)sender {
    NSLog(@"PREVIOUS");
    [prevVC showPevious];
//    [self.navigationController.visibleViewController respondsToSelector:(showPreviousOf:)];
//    [self.navigationController pushViewController: animated:<#(BOOL)#>]
}
 */

//------------------------------------------------------------------------------
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"PREV_SEGUE"]) {
        NSLog(@">>> SHOW PREV.");
        // Get destination view controller
        [self.navigationController popViewControllerAnimated:YES];
        //        NodeDetailViewController *vc = [segue destinationViewController];
//        [vc receiveSegueNode:selectedNode andVC:self];
    }
}
//------------------------------------------------------------------------------
- (IBAction)nextButtonTapped:(id)sender {
    NSLog(@"NEXT");
    //home make annimations
    // go to this view with this model
    // method to swap data in view.
    // then work on annimations.
    
}

//------------------------------------------------------------------------------
- (IBAction)imageViewTapped:(id)sender {
    // Bring up camera
    NSLog(@"Image view tapped.");
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        // camera not available.
        return;
    }
    [self showCameraUI];

}


// ---------- CAMERA -------------
- (IBAction) showCameraUI {
    [self startCameraControllerFromViewController: self
                                    usingDelegate: self];
}
//------------------------------------------------------------------------------
- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                   UINavigationControllerDelegate>) delegate {
    
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeCamera] == NO)
        || (delegate == nil)
        || (controller == nil))
        return NO;
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    // Displays a control that allows the user to choose picture or
    // movie capture, if both are available:
//    cameraUI.mediaTypes =
//    [UIImagePickerController availableMediaTypesForSourceType:
//     UIImagePickerControllerSourceTypeCamera];
    cameraUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];


    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    cameraUI.allowsEditing = NO;
    
    cameraUI.delegate = delegate;
    
//    [controller presentModalViewController: cameraUI animated: YES];
     [controller presentViewController: cameraUI animated: YES completion: nil];
    return YES;
    
}


//------------------------------------------------------------------------------
// For responding to the user accepting a newly-captured picture or movie
- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage, *imageToSave;
    
    // Handle a still image capture
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0)
        == kCFCompareEqualTo) {
        
        editedImage = (UIImage *) [info objectForKey:
                                   UIImagePickerControllerEditedImage];
        originalImage = (UIImage *) [info objectForKey:
                                     UIImagePickerControllerOriginalImage];
        
        if (editedImage) {
            imageToSave = editedImage;
        } else {
            imageToSave = originalImage;
        }
        
        // Save the new image (original or edited) to the Camera Roll
//        UIImageWriteToSavedPhotosAlbum (imageToSave, nil, nil , nil);
        self.node.image = imageToSave;
        [self.myView setPhoto:imageToSave];
    }
//    [[picker parentViewController] dismissModalViewControllerAnimated: YES];
    [picker dismissViewControllerAnimated: YES completion: nil];
}


// ---------- SOCIAL -------------

//- (IBAction)socialButtonTapped:(id)sender {
//    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
//        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
//        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
//            if (result == SLComposeViewControllerResultCancelled) {
//                NSLog(@"# Sharing CANCELLED");
//            } else {
//                NSLog(@"# Sharing DONE");
//            }
//            [controller dismissViewControllerAnimated:YES completion:nil];
//        };
//        controller.completionHandler = myBlock;
//        
//        // Add text to fb post value from iOS
//        [controller setInitialText:[NSString stringWithFormat:@"%@", self.node.notes]];
//        // Add url option
//        [controller addImage:self.node.image];
//        // Add image option
//        
//        [self presentViewController:controller animated:YES completion:nil];
//    } else {
//        NSLog(@"Sharing service unavailable.");
//    }
//}
- (IBAction)socialButtonTapped:(id)sender {
    NSArray *acts = [[NSArray alloc] initWithObjects:UIActivityTypePrint,
                     UIActivityTypeCopyToPasteboard, nil];
    UIActivityViewController *controller = [[UIActivityViewController alloc]
                                            initWithActivityItems:[[NSArray alloc]
                                                                   initWithObjects:self.node.image,
                                                                        self.node.notes, nil]
                                            applicationActivities:nil];
//    controller.excludedActivityTypes = acts;
    [self presentViewController:controller animated:YES completion:nil];
}



@end
