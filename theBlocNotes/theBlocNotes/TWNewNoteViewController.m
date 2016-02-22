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
#import "ShareUtilities.h"




@interface TWNewNoteViewController ()
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UITextField *textField;


@end

@implementation TWNewNoteViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        //what is this stuff
        
        
    }
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.entry !=nil) {
        self.textField.text = self.entry.text;
        self.textView.text = self.entry.title;
        
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dismissSelf {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void) insertTitle {
    TWCoreDataStack *stackedCore = [TWCoreDataStack defaultStack];
    TWBlocNotes *entry = [NSEntityDescription insertNewObjectForEntityForName:@"TWBlocNotes" inManagedObjectContext:stackedCore.managedObjectContext];
    entry.text = self.textView.text;
    entry.title = self.textView.text;
}
- (void) insertNoteEntry {
    TWCoreDataStack *coreDataStack = [TWCoreDataStack defaultStack];
    TWBlocNotes *note = [NSEntityDescription insertNewObjectForEntityForName:@"TWBlocNotes" inManagedObjectContext:coreDataStack.managedObjectContext];
    note.text = self.textView.text;
    note.title = self.textField.text;
    note.date = [[NSDate date] timeIntervalSince1970];
    [coreDataStack saveContext];
    
    
}

- (void) updateNoteEntry {
    self.entry.text = self.textField.text;
    
    TWCoreDataStack *coreStack = [TWCoreDataStack defaultStack];
    [coreStack saveContext];
}
- (IBAction)shareButtonPressed:(id)sender {
    
    [ShareUtilities shareMediaItem:self.textView fromVC:self];
    
    
    
    
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
