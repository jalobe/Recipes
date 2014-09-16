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





#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.ingredients count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Ingredient Cell" forIndexPath:indexPath];
    cell.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    cell.textLabel.text = self.ingredients[indexPath.row];
    return cell;
}


@end
