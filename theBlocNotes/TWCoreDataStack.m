//
//  TWCoreDataStack.m
//  theBlocNotes
//
//  Created by Tony  Winslow on 2/3/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import "TWCoreDataStack.h"


@implementation TWCoreDataStack

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


+ (instancetype) defaultStack {
    static TWCoreDataStack *defaultStack;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        defaultStack = [[self alloc] init];
        
    });
    
    return defaultStack;
}

//- (id)initWithStoreURL:(NSURL*)storeURL modelURL:(NSURL*)modelURL
//{
//    self = [super init];
//    if (self) {
//        self.storeURL = storeURL;
//        self.modelURL = modelURL;
//    }
//    return self;
//}

- (void)saveContext {
    //responsible for saving the contents of our in memory store to persistent store on disk
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator !=nil) {
       
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    self.managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    
}
//    __weak NSPersistentStoreCoordinator *psc = self.managedObjectContext.persistentStoreCoordinator;
    
    NSNotificationCenter *dc = [NSNotificationCenter defaultCenter];
    [dc addObserver:self
           selector:@selector(storesWillChange:)
               name:NSPersistentStoreCoordinatorStoresWillChangeNotification
             object:_persistentStoreCoordinator];
    
    [dc addObserver:self
           selector:@selector(storesDidChange:)
               name:NSPersistentStoreCoordinatorStoresDidChangeNotification
             object:_persistentStoreCoordinator];
    
    [dc addObserver:self
           selector:@selector(persistentStoreDidImportUbiquitousContentChanges:)
               name:NSPersistentStoreDidImportUbiquitousContentChangesNotification
             object:_persistentStoreCoordinator];
//    NSError* error;
//    [self.managedObjectContext.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
//                                                                       configuration:nil
//                                                                                 URL:self.storeURL
//                                                                             options:@{ NSPersistentStoreUbiquitousContentNameKey : @"iCloud.winslowt.theBlocNotes"}
//                                                                               error:&error];
    return _managedObjectContext;
}

- (void)persistentStoreDidImportUbiquitousContentChanges:(NSNotification*)note
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"%@", note.userInfo.description);
    
    NSManagedObjectContext *moc = self.managedObjectContext;
    [moc performBlock:^{
        [moc mergeChangesFromContextDidSaveNotification:note];
        
        // you may want to post a notification here so that which ever part of your app
        // needs to can react appropriately to what was merged.
        // An exmaple of how to iterate over what was merged follows, although I wouldn't
        // recommend doing it here. Better handle it in a delegate or use notifications.
        // Note that the notification contains NSManagedObjectIDs
        // and not NSManagedObjects.
        NSDictionary *changes = note.userInfo;
        NSMutableSet *allChanges = [NSMutableSet new];
        [allChanges unionSet:changes[NSInsertedObjectsKey]];
        [allChanges unionSet:changes[NSUpdatedObjectsKey]];
        [allChanges unionSet:changes[NSDeletedObjectsKey]];
        
        for (NSManagedObjectID *objID in allChanges) {
            // do whatever you need to with the NSManagedObjectID
         // you can retrieve the object from with [moc objectWithID:objID]
            
            [moc objectWithID:objID];
            
        }
        
        
    }];
}

- (void)storesWillChange:(NSNotification *)note {
    NSManagedObjectContext *moc = self.managedObjectContext;
    [moc performBlockAndWait:^{
        NSError *error = nil;
        if ([moc hasChanges]) {
            [moc save:&error];
        }
        
        [moc reset];
    }];
    
    // now reset your UI to be prepared for a totally different
    // set of data (eg, popToRootViewControllerAnimated:)
    // but don't load any new data yet.
}
    
- (void)storesDidChange:(NSNotification *)note {
 
    
    // here is when you can refresh your UI and
    // load new data from the new store
}

-(NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
        
        //lazy loaded property context technique
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"theBlocNotes" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"BlocNote.sqlite"];
    //where diary is going to live
    
    NSError *error = nil;
    
    [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                                       configuration:nil
                                                                                 URL:storeURL
                                                                             options:@{ NSPersistentStoreUbiquitousContentNameKey : @"iCloud.winslowt.theBlocNotes"}
                                                                               error:&error];

//    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
//        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        abort();
//    }
    
    return _persistentStoreCoordinator;
}

- (NSURL *)applicationDocumentsDirectory {
    
    NSURL *containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.Winslow"];
    NSLog(@"%@", containerURL.absoluteString);
    return containerURL;
    
}



@end
