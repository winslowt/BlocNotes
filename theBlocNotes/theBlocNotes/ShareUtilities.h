//
//  ShareUtilities.h
//  theBlocNotes
//
//  Created by Tony  Winslow on 2/21/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TWNewNoteViewController.h"

@interface ShareUtilities : NSObject

+ (void)shareMediaItem:(TWNewNoteViewController *)note fromVC:(UIViewController *)vc;

@end
