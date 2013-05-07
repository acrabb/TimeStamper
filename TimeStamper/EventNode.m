//
//  EventNode.h
//  TimeStamper
//
//  Created by André Crabb on 4/2/13.
//  Copyright (c) 2013 Andre Crabb. All rights reserved.
//

#import "EventNode.h"

@implementation EventNode

// Corresponds to number of sections in NodeDetailTableView. Listed in PCH.
@synthesize text            = _text;
@synthesize timeStamp       = _timeStamp;
@synthesize notes           = _notes;
@synthesize image           = _image;
@synthesize timeOffset   = _timeOffset;


NSString *TEXT          = @"text";
NSString *TIME_STAMP    = @"timeStamp";
NSString *NOTES         = @"notes";
NSString *IMAGE         = @"image";


//-------------------------------------------------------------------------------------------
- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.text forKey:TEXT];
    [encoder encodeObject:self.timeStamp forKey:TIME_STAMP];
    [encoder encodeObject:self.notes forKey:NOTES];
    [encoder encodeObject:self.image forKey:IMAGE];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init]) != nil) {
        self.text = [decoder decodeObjectForKey:TEXT];
        self.timeStamp = [decoder decodeObjectForKey:TIME_STAMP];
        self.notes = [decoder decodeObjectForKey:NOTES];
        self.image = [decoder decodeObjectForKey:IMAGE];
    }
    return self;
}

//-------------------------------------------------------------------------------------------
- (id) initWithString:(NSString *)text {
    if ((self = [super init]) != nil) {
        self.text = self.notes = text;
        self.timeStamp = [NSDate date];
    }
    return self;
}

@end
