//
//  EventNode.h
//  TimeStamper
//
//  Created by André Crabb on 4/2/13.
//  Copyright (c) 2013 Andre Crabb. All rights reserved.
//

#import "EventModel.h"

@implementation EventModel

@synthesize dateStarted     = _dateStarted;
@synthesize nodes           = _nodes;
//@synthesize savedSinceEdit  = _savedSinceEdit;
@synthesize name            = _name;

NSDateFormatter *dateFormatter;

NSString *DATE_STARTED  = @"date";
NSString *NODES         = @"nodes";
NSString *NAME          = @"name";


//-------------------------------------------------------------------------------------------
- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.dateStarted forKey:DATE_STARTED];
    [encoder encodeObject:self.nodes forKey:NODES];
    [encoder encodeObject:self.name forKey:NAME];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init]) != nil) {
        self.name = [decoder decodeObjectForKey:NAME];
        self.dateStarted = [decoder decodeObjectForKey:DATE_STARTED];
        self.nodes = [decoder decodeObjectForKey:NODES];
    }
    return self;
}

//-------------------------------------------------------------------------------------------
EventNode *node;
- (id)init {
    if((self = [super init])!= nil) {
        // Init vars
        dateFormatter = [[NSDateFormatter alloc] init];
        self.dateStarted = [NSDate date];
        self.nodes = [[NSMutableArray alloc] init];
        
        // Add initial node to array.
        NSString *time = [self getTimeStarted];
        NSString *date = [self getDateStarted];
        NSString *began = [NSString stringWithFormat:@"Event at %@ on %@", time, date];
        node = [[EventNode alloc] initWithString:began];
        [self.nodes addObject:node];
    }
    return self;
}

//-------------------------------------------------------------------------------------------
- (id)initWithName:(NSString*)name {
    self.name = name;
    return [self init];
}

//-------------------------------------------------------------------------------------------
- (EventNode *)addNodeWithString:(NSString *) string {
    EventNode *node = [[EventNode alloc] initWithString:string];
    NSLog(@"Created node: %@", node.text);
    [self.nodes addObject:node];
    return node;
}

//-------------------------------------------------------------------------------------------
- (NSString*)getTimeStarted {
    [dateFormatter setDateFormat:@"H:mm"];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    return [dateFormatter stringFromDate:self.dateStarted];

}
//-------------------------------------------------------------------------------------------
- (NSString*)getDateStarted {
    [dateFormatter setDateFormat:@"M/d/yy"];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    return [dateFormatter stringFromDate:self.dateStarted];
}


@end
