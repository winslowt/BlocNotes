//
//  TWBlocNotes.m
//  theBlocNotes
//
//  Created by Tony  Winslow on 2/4/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import "TWBlocNotes.h"


@implementation TWBlocNotes 

// Insert code here to add functionality to your managed object subclass

@dynamic date;
@dynamic title;
@dynamic text;
@dynamic imageData;
@dynamic magicIdea;
@dynamic mood;

- (NSString *)sectionName {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM yyyy"];
    
    return [dateFormatter stringFromDate:date];
}

@end
