//
//  NutritionTableViewController.m
//  Recipes
//
//  Created by Jan Lottermoser on 10.09.14.
//  Copyright (c) 2014 Jan Lottermoser. All rights reserved.
//

#import "NutritionTableViewController.h"
#import "RecipeSearchRequest.h"

@interface NutritionTableViewController ()

@end

@implementation NutritionTableViewController




#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.nutritions count]) {
        return 5;
    } else {
        return 2;
    }
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
    UITableViewCell *cell = nil;
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Headline Cell" forIndexPath:indexPath];
        ((UILabel *)[cell.contentView.subviews firstObject]).text = @"Nutrition Estimates";
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Ingredient Cell" forIndexPath:indexPath];
        if (indexPath.row % 2) {
            cell.backgroundColor = [UIColor grayColor];
        }
        else {
            cell.backgroundColor = [UIColor whiteColor];
        }
        
        if ([self.nutritions count]){
            NSUInteger index = 0;
            switch (indexPath.row) {
                case 1: // calories
                    index = [self.nutritions indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                        return [obj[@"attribute"] isEqualToString:[RecipeSearchRequest nutritionStrings][Energy]];
                    }];
                    break;
                case 2: // fat
                    index = [self.nutritions indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                        return [obj[@"attribute"] isEqualToString:[RecipeSearchRequest nutritionStrings][Fat]];
                    }];
                    break;
                case 3: // carbs
                    index = [self.nutritions indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                        return [obj[@"attribute"] isEqualToString:[RecipeSearchRequest nutritionStrings][Carbohydrate]];
                    }];
                    break;
                case 4: // protein
                    index = [self.nutritions indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                        return [obj[@"attribute"] isEqualToString:[RecipeSearchRequest nutritionStrings][Protein]];
                    }];
                    break;
                default:
                    break;
            }
            if (index != NSNotFound) {
                NSMutableAttributedString *nutritionLine = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",[self.nutritions[index] valueForKeyPath:@"unit.abbreviation"]]];
                NSMutableAttributedString *nutritionValue = [[NSMutableAttributedString alloc] initWithString:[(NSNumber *)self.nutritions[index][@"value"] stringValue]];
                [nutritionLine insertAttributedString:nutritionValue atIndex:0];
                NSString *description = self.nutritions[index][@"description"];
                if ([description isMemberOfClass:[NSNull class]]) {
                    description = @"Calories";
                }
                [nutritionLine insertAttributedString:[[NSMutableAttributedString alloc] initWithString:description] atIndex:0];
                ((UILabel *)[cell.contentView.subviews firstObject]).attributedText = nutritionLine;
            }
            
        }
        
    }
        
    
    
    return cell;
}

@end
