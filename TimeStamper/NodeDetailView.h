//
//  NodeDetailView.h
//  TimeStamper
//
//  Created by André Crabb on 4/11/13.
//  Copyright (c) 2013 Andre Crabb. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NodeDetailViewController;

@interface NodeDetailView : UIView <UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet NodeDetailViewController *myController;
@property (strong, nonatomic) IBOutlet UIScrollView             *scrollView;
@property (strong, nonatomic) IBOutlet UITextView               *notesView;
@property (strong, nonatomic) IBOutlet UIImageView              *photoView;
@property (strong, nonatomic) IBOutlet UILabel                  *timeLabel;

- (void)registerForKeyboardNotifications;
- (void)dismissKeyboard;
- (void)setNotesText:(NSString*)notes;
- (void)setPhoto:(UIImage*)photo;
    
@end
