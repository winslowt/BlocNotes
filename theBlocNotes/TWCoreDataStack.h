//
//  TWCoreDataStack.h
//  theBlocNotes
//
//  Created by Tony  Winslow on 2/3/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface TWCoreDataStack : NSObject

+ (instancetype)defaultStack;

- (id)initWithStoreURL:(NSURL *)storeURL modelURL:(NSURL *)modelURL;


@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic,strong) NSURL* modelURL;
@property (nonatomic,strong) NSURL* storeURL;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
