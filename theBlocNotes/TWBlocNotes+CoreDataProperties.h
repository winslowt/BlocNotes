//
//  TWBlocNotes+CoreDataProperties.h
//  theBlocNotes
//
//  Created by Tony  Winslow on 2/4/16.
//  Copyright © 2016 Bloc. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "TWBlocNotes.h"

NS_ASSUME_NONNULL_BEGIN

@interface TWBlocNotes (CoreDataProperties)

@property (nonatomic) NSTimeInterval date;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *text;
@property (nullable, nonatomic, retain) NSData *imageData;
@property (nullable, nonatomic, retain) NSString *magicIdea;

@end

NS_ASSUME_NONNULL_END
