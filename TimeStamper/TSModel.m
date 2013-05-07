//
//  EventNode.h
//  TimeStamper
//
//  Created by André Crabb on 4/2/13.
//  Copyright (c) 2013 Andre Crabb. All rights reserved.
//

/*
 Create new Event objects.
 Store Event objects.
 Handle voice-recording / input.
 Grab time stamp for ingredient objects.
 */


#import "TSModel.h"

@implementation TSModel

@synthesize currentEvent    = _currentEvent;
@synthesize events          = _events;
//static NSMutableArray *events;

static int SEC = 1;
static int MIN = 60;
static int HOUR = 3600;
static int DAY = 86400;

//int count = 1;
NSString*   saveFile;


//NSString *EVENTS = @"events";
//
//- (void) encodeWithCoder:(NSCoder *)encoder {
//    [encoder encodeObject:self.events forKey:EVENTS];
//}
//- (id) initWithCoder:(NSCoder *)decoder {
//    if((self = [super init]) != nil) {
//        self.events= [decoder decodeObjectForKey:EVENTS];
//    }
//    return self;
//    
//}



//-------------------------------------------------------------------------------------------
/*
 * Make a singleton of this object.
 */
+ (TSModel *)sharedInstance
{
    static TSModel *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TSModel alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

- (void) setUp {
    saveFile = @"~/Documents/tsEvents";
    saveFile = [saveFile stringByExpandingTildeInPath];
    self.events = [self loadProjects];
    if (self.events == nil) {
    NSLog(@"Events came back nil");
        self.events = [[NSMutableArray alloc] init];
    }
}

- (EventModel *)createNewEvent {
//    if (self.events == nil) {
//        [self setUp];
//    }
    EventModel *event = [[EventModel alloc] initWithName:[self getNextEventName]];
    self.currentEvent = event;
    [self.events addObject:self.currentEvent];
    NSLog(@"Event added to array: %@", self.events);
//    count++;
    return event;
}

- (NSString *)getNextEventName {
    return [NSString stringWithFormat:@"Event %d", self.events.count+1];
}

+ (NSInteger)getMinutesFromDate:(NSDate *)start toDate:(NSDate *)end {
    NSTimeInterval secondsBetween = [end timeIntervalSinceDate:start];
    int numberOfMinutes = secondsBetween / 60;
    return numberOfMinutes;
}

+ (NSString *) getTimeStringFromDate:(NSDate *)start toDate:(NSDate *)end {
    NSTimeInterval time = [end timeIntervalSinceDate:start];
    NSString *unit = @"sec";
    int mult = SEC;
    if (time > DAY) {
        mult = DAY;
        unit = @"dys";
    }
    else if (time > HOUR) {
        mult = HOUR;
        unit = @"hrs";
    }
    else if (time > MIN) {
        mult = MIN;
        unit = @"min";
    }
    return [NSString stringWithFormat:@"%d %@", (int)(time/mult), unit];
    
}


//store the array
- (void) saveProjects {
    NSLog(@"=== Attempting to save.");
    BOOL success = [NSKeyedArchiver archiveRootObject:self.events toFile:saveFile];
    NSLog(@"<<< Saved = %c.", success);
    NSLog(@"<<< yes: %c, no: %c.", YES, NO);
}

//load the array
- (NSMutableArray *) loadProjects {
    NSMutableArray *arr = [NSKeyedUnarchiver unarchiveObjectWithFile:saveFile];
    return arr;
}


@end
