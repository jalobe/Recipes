//
//  ViewContainerManagementDelegate.h
//  Recipes
//
//  Created by Jan Lottermoser on 05.09.14.
//  Copyright (c) 2014 Jan Lottermoser. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ViewContainerManagementDelegate <NSObject>

// delegates must implement this method and toggle the container view from and to fullscreen or if no fullscreen is supported return NO
@required
- (BOOL)toggleFullscreenAnimated:(BOOL)animated;

@end
