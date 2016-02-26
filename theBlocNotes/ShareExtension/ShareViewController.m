//
//  ShareViewController.m
//  ShareExtension
//
//  Created by Tony  Winslow on 2/22/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import "ShareViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "TWNewNoteViewController.h"
#import "TWCoreDataStack.h"
#import "TWBlocNotes.h"




@interface ShareViewController ()

@end

@implementation ShareViewController

- (BOOL)isContentValid {
    
    NSInteger messageLength = [[self.contentText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length];
    NSInteger charactersRemaining = 100 - messageLength;
    self.charactersRemaining = @(charactersRemaining);
    
    if (charactersRemaining >= 0) {
        return YES;
    }
    
    return NO;
}

- (void) insertNoteEntry {
    TWCoreDataStack *coreDataStack = [TWCoreDataStack defaultStack];
    TWBlocNotes *note = [NSEntityDescription insertNewObjectForEntityForName:@"TWBlocNotes" inManagedObjectContext:coreDataStack.managedObjectContext];
    note.text = self.contentText;
    note.date = [[NSDate date] timeIntervalSince1970];
    [coreDataStack saveContext];
    
    
}

- (void)didSelectPost {
    
    
    NSExtensionItem *inputItem = self.extensionContext.inputItems.firstObject;
    
    NSExtensionItem *outputItem = [inputItem copy];
    outputItem.attributedContentText = [[NSAttributedString alloc] initWithString:self.contentText attributes:nil];
    // Complete this implementation by setting the appropriate value on the output item.
    
    NSArray *outputItems = @[outputItem];
    
    [self.extensionContext completeRequestReturningItems:outputItems completionHandler:nil];
    
    
    [self insertNoteEntry];
    // Or call [super didSelectPost] to use the superclass's default completion behavior.
}


- (NSArray *)configurationItems {
    // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
    return @[];
}

@end
