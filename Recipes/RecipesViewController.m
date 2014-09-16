//
//  RecipesViewController.m
//  Recipes
//
//  Created by Jan Lottermoser on 28.08.14.
//  Copyright (c) 2014 Jan Lottermoser. All rights reserved.
//

#import "RecipesViewController.h"
#import "YummlyFetcher.h"
#import "RecipeOverviewViewController.h"


#define RESULTS_PER_FETCH 12
#define IMAGE_CELL_HEIGHT 214
#define LOADING_CELL_HEIGHT 55

@interface RecipesViewController () <UISearchBarDelegate>
@property (nonatomic, strong) RecipeSearchRequest *request;
@property (nonatomic) int page;
@property (nonatomic, strong) NSMutableDictionary *searchResponse;
@property (nonatomic, strong) NSMutableArray *matches; // of NSDictionary
@property (nonatomic, strong) NSMutableDictionary *recipes; // of NSDictionary
@property (nonatomic, strong) NSMutableDictionary *recipeImages; // of UIImage
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic) int fetchCount;
@end

@implementation RecipesViewController



- (void)setFetchCount:(int)fetchCount
{
    _fetchCount = fetchCount;
    //NSLog(@"%d", _fetchCount);
}

- (RecipeSearchRequest *)request
{
    if (!_request) {
        _request = [[RecipeSearchRequest alloc] init];
    }
    return _request;
}

- (NSMutableArray *)matches
{
    if (!_matches) {
        _matches = [[NSMutableArray alloc] init];
    }
    return _matches;
}

- (NSMutableDictionary *)recipes
{
    if (!_recipes) {
        _recipes = [[NSMutableDictionary alloc] init];
    }
    return _recipes;
}

- (NSMutableDictionary *)recipeImages
{
    if (!_recipeImages) {
        _recipeImages = [[NSMutableDictionary alloc] init];
    }
    return _recipeImages;
}

- (NSURLSession *)session
{
    if (!_session) {
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration ephemeralSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"Memory warning in RecipeVC");
}



- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.request.searchPhrase = searchBar.text;
    self.request.requirePictures = YES;
    self.searchResponse = nil;
    self.matches = nil;
    self.recipes = nil;
    self.recipeImages = nil;
    self.page = 0;
    [searchBar resignFirstResponder];
    [self.tableView reloadData];
}




- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show Recipe"]) {
        RecipeOverviewViewController *recipeVC = (RecipeOverviewViewController *)segue.destinationViewController;
        UITableViewCell *cell = (UITableViewCell *)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        NSString *recipeID = self.matches[indexPath.row][@"id"];
        // load recipe data
        NSURL *url = [YummlyFetcher URLForRecipeWithID:recipeID];
        NSURLSessionDownloadTask *recipeTask = [self.session downloadTaskWithURL:url
                                                          completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
            NSMutableDictionary *recipe = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:location] options:0 error:NULL];
            [self.recipes setValue:recipe forKey:recipeID];
            recipeVC.recipe = recipe;
                                                          }];
        [recipeTask resume];
        recipeVC.recipeImage = self.recipeImages[recipeID];
    }
}

- (void)loadNewRecipeData
{
    // load searchResponse
    NSURL *url = [YummlyFetcher URLForSearchWithParameters:self.request maxResults:RESULTS_PER_FETCH page:self.page];
    self.page += RESULTS_PER_FETCH;
    NSURLSessionDownloadTask *resultsTask = [self.session downloadTaskWithURL:url
                                                            completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        // handle searchresponse
        self.searchResponse = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:location] options:0 error:NULL];
        [self.matches addObjectsFromArray:self.searchResponse[@"matches"]];
        for (NSMutableDictionary *match in self.searchResponse[@"matches"]) {
            NSURL *url = [YummlyFetcher URLForImageWithRecipeInformation:match];
            NSURLSessionDownloadTask *imageTask = [self.session downloadTaskWithURL:url
                                                              completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                    // handle image download
                    [self.recipeImages setValue:[UIImage imageWithData:[NSData dataWithContentsOfURL:location]] forKey:match[@"id"]];
                    [self.tableView reloadData];
                }];
            [imageTask resume];

        }
    }];
    [resultsTask resume];
    self.fetchCount++;
}



#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= [self.matches count]) {
        UITableViewCell *loadingCell = [tableView dequeueReusableCellWithIdentifier:@"Loading Cell"];
        [((UIActivityIndicatorView *)loadingCell.contentView.subviews[0]) startAnimating];
        [self loadNewRecipeData];
        return loadingCell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Recipe Cell"];
        NSString *recipeID = self.matches[indexPath.row][@"id"];
        ((UIImageView *)cell.contentView.subviews[0]).image = self.recipeImages[recipeID];
        ((UILabel *)cell.contentView.subviews[1]).text = self.matches[indexPath.row][@"recipeName"];
        ((UILabel *)cell.contentView.subviews[2]).text = self.matches[indexPath.row][@"sourceDisplayName"];
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.matches count] + 1;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= [self.matches count]) {
        return LOADING_CELL_HEIGHT;
    } else {
        return IMAGE_CELL_HEIGHT;
    }
}

@end
