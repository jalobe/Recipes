//
//  IngredientsTableViewController.h
//  Recipes
//
//  Created by Jan Lottermoser on 04.09.14.
//  Copyright (c) 2014 Jan Lottermoser. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewContainerManagementDelegate.h"

@interface IngredientsTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *ingredients;
@property (strong, nonatomic) id<ViewContainerManagementDelegate> delegate;

@end
