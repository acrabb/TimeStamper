//
//  EventNode.h
//  TimeStamper
//
//  Created by André Crabb on 4/2/13.
//  Copyright (c) 2013 Andre Crabb. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "TSModel.h"

@interface EventNode : NSObject <NSCoding>

@property (strong, nonatomic) NSString  *text;
@property (strong, nonatomic) NSDate    *timeStamp;
@property (strong, nonatomic) NSString  *notes;
@property (strong, nonatomic) UIImage   *image;
@property (strong, nonatomic) NSString  *timeOffset;

- (id)initWithString:(NSString *)text;
//- (NSString *)getTimeOffsetString;

@end
