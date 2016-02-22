//
//  ShareUtilities.m
//  theBlocNotes
//
//  Created by Tony  Winslow on 2/21/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import "ShareUtilities.h"

@implementation ShareUtilities


+ (void)shareMediaItem:(TWNewNoteViewController *)note fromVC:(UIViewController *)vc {
    
    NSMutableArray *itemsToShare = [[NSMutableArray alloc] init];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
    [vc presentViewController:activityVC animated:YES completion:nil];
 
}
@end
