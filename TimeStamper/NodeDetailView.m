//
//  NodeDetailView.m
//  TimeStamper
//
//  Created by André Crabb on 4/11/13.
//  Copyright (c) 2013 Andre Crabb. All rights reserved.
//

#import "NodeDetailView.h"

@implementation NodeDetailView

@synthesize myController    = _myController;
@synthesize scrollView      = scrollView;
@synthesize notesView       = _notesView;
@synthesize photoView       = _photoView;
@synthesize timeLabel       = _timeLabel;
@synthesize toolbar         = _toolbar;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSLog(@"Detail View Loaded!");
        self.photoView.clipsToBounds = YES;
    }
    return self;
}

- (void)setNotesText:(NSString*)notes {
    self.notesView.text = notes;
    [self.notesView setNeedsDisplay];
}


- (void)setPhoto:(UIImage*)photo {
    NSLog(@">Detail> Setting photo.");
    [self.photoView setImage:photo];
    
    
    /*/
//    UIImage * img = [UIImage imageNamed:@"someImage.png"];
    UIImage * img = photo;
    CGSize imgSize = img.size;
    
    float ratio=self.photoView.frame.size.width/imgSize.width;
    
    float scaledHeight=imgSize.height*ratio;
    if(scaledHeight < self.photoView.frame.height)
    {
        //update height of your imageView frame with scaledHeight
        self.photoView si
    }
    /**/
}


// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIDeviceOrientationPortrait
        || orientation == UIDeviceOrientationPortraitUpsideDown ) {
        // Device is in portrait mode.
        // Do nothing.
    } else {
        // Device is in landscape.
        // Make the keyboard not stupid.
        kbSize.height = kbSize.width;
    }
    
//    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] convertrec];
    
//                     convertRect:self.frame
//                                                                            fromView:self].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, self.notesView.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, self.notesView.frame.origin.y-kbSize.height);
        [self.scrollView setContentOffset:scrollPoint animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
}



//----------------------------------------------------------------
- (void)dismissKeyboard {
    [self.notesView resignFirstResponder];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
