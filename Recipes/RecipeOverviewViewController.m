//
//  RecipeOverviewViewController.m
//  Recipes
//
//  Created by Jan Lottermoser on 03.09.14.
//  Copyright (c) 2014 Jan Lottermoser. All rights reserved.
//

#import "RecipeOverviewViewController.h"
#import "WebViewController.h"
#import "IngredientsTableViewController.h"
#import "NutritionTableViewController.h"

@interface RecipeOverviewViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *recipeImageView;
@property (weak, nonatomic) IBOutlet UILabel *recipeName;
@property (weak, nonatomic) IBOutlet UILabel *recipeSource;
@property (weak, nonatomic) IBOutlet UIView *container;
@property (strong, nonatomic) UIViewController *currentVC;
@property (strong, nonatomic) IngredientsTableViewController *ingredientsVC;
@property (strong, nonatomic) NutritionTableViewController *nutritionVC;
@property (weak, nonatomic) IBOutlet UIButton *nutritionButton;
@property (weak, nonatomic) IBOutlet UIButton *ingredientsButton;
@property (weak, nonatomic) IBOutlet UIButton *directionButton;

@end

@implementation RecipeOverviewViewController

- (IBAction)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setRecipe:(NSDictionary *)recipe
{
    _recipe = recipe;
    self.ingredientsVC.ingredients = _recipe[@"ingredientLines"];
    self.recipeName.text = self.recipe[@"name"];
    self.recipeSource.text = [self.recipe valueForKeyPath:@"source.sourceDisplayName"];
    [self.ingredientsVC.tableView reloadData];
}

- (void)setRecipeImage:(UIImage *)recipeImage
{
    _recipeImage = recipeImage;
    self.recipeImageView.image = _recipeImage;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.ingredientsVC = self.childViewControllers.lastObject;
    self.nutritionVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NutritionVC"];
    self.currentVC = self.ingredientsVC;
    self.recipeImageView.image = self.recipeImage;
    self.recipeName.text = self.recipe[@"name"];
    self.recipeSource.text = [self.recipe valueForKeyPath:@"source.sourceDisplayName"];
    
}



- (IBAction)showIngredients:(UIButton *)sender
{
    if (self.currentVC != self.ingredientsVC) {
        self.ingredientsVC.delegate = self;
        self.ingredientsVC.ingredients = self.recipe[@"ingredientLines"];
        [self.ingredientsVC.tableView reloadData];
        [self addChildViewController:self.ingredientsVC];
        self.ingredientsVC.view.frame = self.container.bounds;
        [self moveToNewController:self.ingredientsVC];
    }
}

- (IBAction)showNutrition:(UIButton *)sender
{
    if (self.currentVC != self.nutritionVC) {
        self.nutritionVC.nutritions = self.recipe[@"nutritionEstimates"];
        NSLog(@"%@",self.recipe[@"nutritionEstimates"]);
        [self addChildViewController:self.nutritionVC];
        self.nutritionVC.view.frame = self.container.bounds;
        [self moveToNewController:self.nutritionVC];
        [self.nutritionVC.tableView reloadData];
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show Directions"]) {
        ((WebViewController *)segue.destinationViewController).url = [NSURL URLWithString:[self.recipe valueForKeyPath:@"source.sourceRecipeUrl"]];
    }
}

- (void)moveToNewController:(UIViewController *)newController
{
    [self.currentVC willMoveToParentViewController:nil];
    [self transitionFromViewController:self.currentVC toViewController:newController duration:.6 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{}
                            completion:^(BOOL finished) {
                                [self.currentVC removeFromParentViewController];
                                [self.currentVC.view removeFromSuperview];
                                [newController didMoveToParentViewController:self];
                                self.currentVC = newController;
                            }];
}

- (BOOL)toggleFullscreenAnimated:(BOOL)animated
{
    

    if (animated) {
        [UIView animateWithDuration:0.5 animations:^{
            self.recipeImageView.frame = CGRectMake(self.recipeImageView.frame.origin.x, self.recipeImageView.frame.origin.y, self.recipeImageView.frame.size.width, self.recipeImageView.frame.size.height - 20);
            self.container.frame = CGRectMake(self.container.frame.origin.x, self.recipeImageView.frame.origin.y + self.recipeImageView.frame.size.height, self.container.frame.size.width, self.container.frame.size.height + 20);
            [self.container layoutIfNeeded];
        }];
    } else {
        
    }
    NSLog(@"%f", self.container.frame.origin.y);
    NSLog(@"%f", self.container.frame.size.height);
    return YES;
}


@end
