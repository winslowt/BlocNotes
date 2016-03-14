//
//  TWEntryListTableViewController.m
//  theBlocNotes
//
//  Created by Tony  Winslow on 2/6/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import "TWEntryListTableViewController.h"
#import "TWCoreDataStack.h"
#import "TWBlocNotes.h"
#import "TWNewNoteViewController.h"


@interface TWEntryListTableViewController () <NSFetchedResultsControllerDelegate, UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property(nonatomic, strong) UISearchController *searchResultsController;
@property(nonatomic, weak) id< UISearchResultsUpdating > searchResultsUpdater;
@property(nonatomic, strong, readonly) UISearchBar *searchBar;
@property(nonatomic, strong) NSString *text;
@property (strong, nonatomic) NSFetchRequest *searchFetchRequest;
@property(nonatomic, getter=isSearchResultsButtonSelected) BOOL searchResultsButtonSelected;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSPredicate *searchPredicate;



@end

@implementation TWEntryListTableViewController

- (id) initWithStyle:(UITableViewStyle)style {
    
    self = [super initWithStyle:style];
    
    if (self) {
    }
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ///hmmmm did I do this right?
    
    self.searchResultsController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchResultsController.dimsBackgroundDuringPresentation = NO;
    self.searchResultsController.searchResultsUpdater = self;
    [self.searchResultsController.searchBar sizeToFit];
    self.tableView.tableHeaderView = self.searchResultsController.searchBar;
    self.tableView.delegate = self;
    self.definesPresentationContext = YES;
    
    [self.fetchedResultsController performFetch:nil];
    
}

- (void)didReceiveMemoryWarning {
     self.searchFetchRequest = nil;
    [super didReceiveMemoryWarning];
   
    
    // Dispose of any resources that can be recreated.
}


#pragma mark - Search

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar becomeFirstResponder];
//    
//    searchBar.text = searchBar.text;
    
    NSLog(@"%@",searchBar.text);
    
    
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    [searchBar setShowsCancelButton:YES];
    self.tableView.allowsSelection = NO;
    self.tableView.scrollEnabled = NO;
    
}

- (NSFetchRequest *)searchFetchRequest {
    
    if (_searchFetchRequest != nil)
    {
        return _searchFetchRequest;
    }
    
    _searchFetchRequest = [[NSFetchRequest alloc] init];
    TWCoreDataStack *stackedCore = [TWCoreDataStack defaultStack];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TWBlocNotes" inManagedObjectContext:stackedCore.managedObjectContext];
    [_searchFetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    [_searchFetchRequest setSortDescriptors:sortDescriptors];
    
    return _searchFetchRequest;
    
}


- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSString *searchString = self.searchResultsController.searchBar.text;
    self.searchPredicate = searchString.length == 0 ? nil : [NSPredicate predicateWithFormat:@"title contains [c] %@ or text contains[c] %@", searchString, searchString];
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.searchPredicate == nil ? [[self.fetchedResultsController sections] count] : 1;
//    return self.fetchedResultsController.sections.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.searchPredicate == nil) {
        
        id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
        
        return [sectionInfo numberOfObjects];
        
    } else {
        
//        return [self.filteredContentList count];
        
        return [[self.fetchedResultsController.fetchedObjects filteredArrayUsingPredicate:self.searchPredicate] count];
        
        
    }
    
}

//- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
//    TWBlocNotes *project = nil;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    TWBlocNotes *note = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = note.title;
    
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TWBlocNotes *entry = [self.fetchedResultsController objectAtIndexPath:indexPath];
    TWCoreDataStack *coreDataStack = [TWCoreDataStack defaultStack];
    [[coreDataStack managedObjectContext] deleteObject:entry];
    [coreDataStack saveContext];
    
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (self.searchPredicate == nil) {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo name];
}
    else {
        return nil;
        
    }
}

- (NSFetchRequest *)entryListFetchRequest {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"TWBlocNotes"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
    
    
    return fetchRequest;
    }

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController !=nil) {
        return _fetchedResultsController;
    }
    TWCoreDataStack *coreDataStack = [TWCoreDataStack defaultStack];
    NSFetchRequest *fetchRequest = [self entryListFetchRequest];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:coreDataStack.managedObjectContext sectionNameKeyPath:@"sectionName" cacheName:nil];
    
    _fetchedResultsController.delegate = self;
    

    
    return _fetchedResultsController;
}
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    //called whenever an item is inserted, edited, changed, or moved
    
    UITableView *tableView = self.tableView;
    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(nonnull id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
}


- (void) controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return YES;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    TWNewNoteViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TWNewNoteViewController"];
    TWBlocNotes *note = [self.fetchedResultsController objectAtIndexPath:indexPath];
    vc.entry = note; 
    
    UINavigationController *newNavigation = [[UINavigationController alloc] initWithRootViewController:vc];
    
    
    [self presentViewController:newNavigation animated:YES completion:nil];
    
 
}

- (instancetype)initWithSearchResultsController:(nullable UIViewController *)searchResultsController {
    
    return nil;
    
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    return NO;
    


//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
//   
//    NSString *searchString = searchBar.text;
//    
//    
////    self.filteredContentList = [[NSMutableArray alloc] init];
////    [self.filteredContentList removeAllObjects];
//    
//    
    
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text=@"";
    
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    self.tableView.allowsSelection = YES;
    self.tableView.scrollEnabled = YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
         
    return self.searchPredicate == nil;
    
}


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
