//
//  EventNode.h
//  TimeStamper
//
//  Created by André Crabb on 4/2/13.
//  Copyright (c) 2013 Andre Crabb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventModel.h"

@interface TSModel : NSObject //<NSCoding>
{
//    NSMutableArray *events;
}

@property (strong, nonatomic) EventModel        *currentEvent;
@property (strong, nonatomic) NSMutableArray    *events;
+ (TSModel *)sharedInstance;
+ (NSInteger) getMinutesFromDate:(NSDate*)start toDate:(NSDate*)end;
+ (NSString *) getTimeStringFromDate:(NSDate *)start toDate:(NSDate *)end;
- (EventModel *)createNewEvent;
- (void) saveProjects;
- (void) setUp;
    

@end
