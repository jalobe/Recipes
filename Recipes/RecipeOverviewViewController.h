//
//  RecipeOverviewViewController.h
//  Recipes
//
//  Created by Jan Lottermoser on 03.09.14.
//  Copyright (c) 2014 Jan Lottermoser. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewContainerManagementDelegate.h"

@interface RecipeOverviewViewController : UIViewController <ViewContainerManagementDelegate>

@property (strong, nonatomic) NSDictionary *recipe;
@property (strong, nonatomic) UIImage *recipeImage;


@end

