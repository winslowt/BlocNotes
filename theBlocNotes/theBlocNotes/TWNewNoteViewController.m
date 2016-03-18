//
//  TWNewNoteViewController.m
//  theBlocNotes
//
//  Created by Tony  Winslow on 2/4/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import "TWNewNoteViewController.h"
#import "TWBlocNotes.h"
#import "TWCoreDataStack.h"
#import "TWEntryListTableViewController.h"



@class NSDataDetector;

@interface TWNewNoteViewController () <UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) NSDataDetector *detector;
@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;
@property (nonatomic) NSUInteger *numberOfTapsRequired;
@property(nonatomic,getter=isEditing) BOOL editing;

@end

@implementation TWNewNoteViewController 

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        //what is this stuff
        
        
    }
    return self;
    
}

- (void)handleTap:(UITapGestureRecognizer *)sender {
    
    self.textView.editable = YES;
    self.textView.userInteractionEnabled = YES;
    
    if (self.textView.editable == NO) {
        
        self.textView.dataDetectorTypes = UIDataDetectorTypeAll;
        
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.entry !=nil) {
        self.textField.text = self.entry.title;
        self.textView.text = self.entry.text;
        
        self.textView.editable = NO;
        
        self.textView.dataDetectorTypes = UIDataDetectorTypeAll;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        
        tapGesture.numberOfTapsRequired = 2;
        
        [self.textView addGestureRecognizer:tapGesture];

    }

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dismissSelf {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

//- (void) insertTitle {
//    TWCoreDataStack *stackedCore = [TWCoreDataStack defaultStack];
//    TWBlocNotes *entry = [NSEntityDescription insertNewObjectForEntityForName:@"TWBlocNotes" inManagedObjectContext:stackedCore.managedObjectContext];
//    entry.text = self.textView.text;
//    entry.title = self.textField.text;
//}
- (void) insertNoteEntry {
    TWCoreDataStack *coreDataStack = [TWCoreDataStack defaultStack];
    TWBlocNotes *note = [NSEntityDescription insertNewObjectForEntityForName:@"TWBlocNotes" inManagedObjectContext:coreDataStack.managedObjectContext];
    note.text = self.textView.text;
    note.title = self.textField.text;
    note.date = [[NSDate date] timeIntervalSince1970];
    [coreDataStack saveContext];
    
    
}

- (void) updateNoteEntry {
    self.entry.text = self.textView.text;
    self.entry.title = self.textField.text;
    TWCoreDataStack *coreStack = [TWCoreDataStack defaultStack];
    [coreStack saveContext];
}
- (IBAction)shareWasPressed:(id)sender {
    
    NSMutableArray *itemsToShare = [NSMutableArray array];

    
    if (self.entry.text.length > 0) {
        [itemsToShare addObject:self.entry.text];
    }
    
    if (self.entry.title.length > 0) {
        [itemsToShare addObject:self.entry.title];
    }
    
    if (itemsToShare.count > 0) {
        UIActivityViewController *shareNoteVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
        [self presentViewController:shareNoteVC animated:YES completion:nil];
    }
    
}


- (IBAction)doneWasPressed:(id)sender {
    
    if (self.entry !=nil) {
        [self updateNoteEntry];
    }
    else {
        [self insertNoteEntry];
    }
    [self dismissSelf];
}
- (IBAction)cancelWasPressed:(id)sender {
    [self dismissSelf];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
