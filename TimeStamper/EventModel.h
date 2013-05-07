//
//  EventNode.h
//  TimeStamper
//
//  Created by André Crabb on 4/2/13.
//  Copyright (c) 2013 Andre Crabb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventNode.h"

@interface EventModel : NSObject <NSCoding>

@property (strong, nonatomic) NSDate            *dateStarted;
@property (strong, nonatomic) NSMutableArray    *nodes;
@property (strong, nonatomic) NSString          *name;

- (id)initWithName:(NSString *)name;
- (EventNode *)addNodeWithString:(NSString *)string;

@end
