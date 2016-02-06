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


@interface TWNewNoteViewController ()
@property (nonatomic, strong) UITextView *textView;

@end

@implementation TWNewNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dismissSelf {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void) insertNoteEntry {
    TWCoreDataStack *coreDataStack = [TWCoreDataStack defaultStack];
    TWBlocNotes *note = [NSEntityDescription insertNewObjectForEntityForName:@"TWBlocNotes" inManagedObjectContext:coreDataStack.managedObjectContext];
    note.text = self.textView.text;
    note.date = [[NSDate date] timeIntervalSince1970];
    [coreDataStack saveContext];
    
    
}
- (IBAction)doneWasPressed:(id)sender {
    [self insertNoteEntry];
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
