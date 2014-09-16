//
//  WebViewController.h
//  Recipes
//
//  Created by Jan Lottermoser on 01.09.14.
//  Copyright (c) 2014 Jan Lottermoser. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewContainerManagementDelegate.h"

@interface WebViewController : UIViewController
@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic) id<ViewContainerManagementDelegate> delegate;

@end
