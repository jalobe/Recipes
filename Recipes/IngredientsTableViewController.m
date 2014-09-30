//
//  IngredientsTableViewController.m
//  Recipes
//
//  Created by Jan Lottermoser on 04.09.14.
//  Copyright (c) 2014 Jan Lottermoser. All rights reserved.
//

#import "IngredientsTableViewController.h"

@interface IngredientsTableViewController ()

@end

@implementation IngredientsTableViewController


- (void)setIngredients:(NSArray *)ingredients
{
    _ingredients = [self formatIngredientLines:ingredients];
}


- (NSArray *)formatIngredientLines:(NSArray *)ingredients
{
    NSMutableArray *formattedIngredients = [[NSMutableArray alloc] init];
    NSString *line;
    for (NSString *ingredient in ingredients) {
        line = [ingredient stringByReplacingOccurrencesOfString:@"tablespoons" withString:@"tbs." options:NSCaseInsensitiveSearch range:NSMakeRange(0, ingredient.length)];
        line = [line stringByReplacingOccurrencesOfString:@"tablespoon" withString:@"tbs." options:NSCaseInsensitiveSearch range:NSMakeRange(0, line.length)];
        line = [line stringByReplacingOccurrencesOfString:@"teaspoons" withString:@"tsp." options:NSCaseInsensitiveSearch range:NSMakeRange(0, line.length)];
        line = [line stringByReplacingOccurrencesOfString:@"teaspoon" withString:@"tsp." options:NSCaseInsensitiveSearch range:NSMakeRange(0, line.length)];
        NSUInteger from = [line rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"("] options:0].location;
        NSUInteger to = [line rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@")"] options:NSBackwardsSearch].location;
        if (from != NSNotFound) {
            line = [line stringByReplacingCharactersInRange:NSMakeRange(from, to - from + 1) withString:
                    @""];
        }
        [formattedIngredients addObject:line];
    }
    return formattedIngredients;
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.ingredients count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        UITableViewCell *headlineCell = [tableView dequeueReusableCellWithIdentifier:@"Headline Cell"];
        return headlineCell.contentView.frame.size.height;
    } else {
        UITableViewCell *ingredientCell = [tableView dequeueReusableCellWithIdentifier:@"Ingredient Cell"];
        return ingredientCell.contentView.frame.size.height;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Headline Cell" forIndexPath:indexPath];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Ingredient Cell" forIndexPath:indexPath];
        cell.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
        cell.textLabel.text = self.ingredients[indexPath.row];
    }
    return cell;
}


@end
