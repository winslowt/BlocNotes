//
//  TWBlocNotes.h
//  theBlocNotes
//
//  Created by Tony  Winslow on 2/4/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef NS_ENUM(int16_t, TWBlocNotesEntryMood) {
    TWBlocNotesEntryMoodGood = 0,
    TWBlocNotesEntryMoodAverage = 1,
    TWBlocNotesEntryBad = 2
    
    
};



@interface TWBlocNotes : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

@property (nonatomic) NSTimeInterval date;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *text;
@property (nullable, nonatomic, retain) NSData *imageData;
@property (nullable, nonatomic, retain) NSString *magicIdea;
@property (nonatomic) int16_t mood;

@property (nullable,nonatomic, readonly) NSString *sectionName;

@end




