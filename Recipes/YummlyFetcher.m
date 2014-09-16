//
//  YummlyFetcher.m
//  Recipes
//
//  Created by Jan Lottermoser on 27.08.14.
//  Copyright (c) 2014 Jan Lottermoser. All rights reserved.
//

#import "YummlyFetcher.h"
#import "YummlyAPIAccess.h"

@implementation YummlyFetcher

#pragma mark - Public Interface

+ (NSURL *)URLForRecipeWithID:(NSString *)identifier
{
    NSString *query = [NSString stringWithFormat:@"%@/api/recipe/%@?_app_id=%@&_app_key=%@", YUMMLY_BASE_URL ,identifier, YUMMLY_APP_ID, YUMMLY_APP_KEY];
    query = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return [NSURL URLWithString:query];
}

+ (NSURL *)URLForSearchWithParameters:(RecipeSearchRequest *)request maxResults:(NSUInteger)maxResults page:(NSUInteger)page
{
    NSString *query = [NSString stringWithFormat:@"%@/api/recipes?_app_id=%@&_app_key=%@", YUMMLY_BASE_URL, YUMMLY_APP_ID, YUMMLY_APP_KEY];
    NSString *parameters = [self URLStringFromRecipeSearchRequest:request];
    query = [query stringByAppendingString:parameters];
    query = [query stringByAppendingString:[NSString stringWithFormat:@"&maxResult=%lu&start=%lu", (unsigned long)maxResults, (unsigned long)page]];
    query = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [NSURL URLWithString:query];
}


+ (NSURL *)URLForImageWithRecipeInformation:(NSDictionary *)recipe
{
    NSString *urlString = [recipe[@"smallImageUrls"] firstObject];
    urlString = [[urlString componentsSeparatedByString:@"="] firstObject];
    urlString = [urlString stringByAppendingString:@"=s360"];
    return [NSURL URLWithString:urlString];
}


#pragma mark - Private Helper Methods

+ (NSString *)URLStringFromRecipeSearchRequest:(RecipeSearchRequest *)request
{
    NSString *query = @"";
    
    // search phrase
    if (request.searchPhrase) {
        NSString *searchPhrase = @"&q=";
        NSArray *searchTerms = [request.searchPhrase componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" \t\n"]];
        searchPhrase = [searchPhrase stringByAppendingString:[searchTerms componentsJoinedByString:@" "]];
        query = [query stringByAppendingString:searchPhrase];
    }

    
    // ingredients
    if ([request.allowedIngredients count]) {
        query = [query stringByAppendingString:[self stringForMultiParameter:@"&allowedIngredient[]=" withValues:request.allowedIngredients]];
    }
    
    if ([request.excludedIngredients count]) {
        query = [query stringByAppendingString:[self stringForMultiParameter:@"&excludedIngredient[]=" withValues:request.excludedIngredients]];

    }
    
    // allergy
    if ([request.allowedAllergies count]) {
        query = [query stringByAppendingString:[self stringForMultiParameter:@"&allowedAllergy[]=" withValues:request.allowedAllergies]];

    }
    
    // diet
    if ([request.allowedDiets count]) {
        query = [query stringByAppendingString:[self stringForMultiParameter:@"&allowedDiet[]=" withValues:request.allowedDiets]];

    }
    
    // cuisine
    if ([request.allowedCuisine count]) {
        query = [query stringByAppendingString:[self stringForMultiParameter:@"&allowedCuisine[]=" withValues:request.allowedCuisine]];

    }

    if ([request.excludedCuisine count]) {
        query = [query stringByAppendingString:[self stringForMultiParameter:@"&excludedCuisine[]=" withValues:request.excludedCuisine]];
        
    }
    
    // course
    if ([request.allowedCourse count]) {
        query = [query stringByAppendingString:[self stringForMultiParameter:@"&allowedCourse[]=" withValues:request.allowedCourse]];
        
    }
    
    if ([request.excludedCourse count]) {
        query = [query stringByAppendingString:[self stringForMultiParameter:@"&excludedCourse[]=" withValues:request.excludedCourse]];
        
    }
    
    if ([request.allowedHoliday count]) {
        query = [query stringByAppendingString:[self stringForMultiParameter:@"&allowedHoliday[]=" withValues:request.allowedHoliday]];
        
    }
    
    if ([request.excludedHoliday count]) {
        query = [query stringByAppendingString:[self stringForMultiParameter:@"&excludedHoliday[]=" withValues:request.excludedHoliday]];
        
    }
    
    // nutrition
    if (request.nutritions) {
        __block NSString *nutritions = @"";
        [request.nutritions enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            nutritions = [nutritions stringByAppendingString:[NSString stringWithFormat:@"%@=%@", (NSString *)key, (NSString *)obj]];
        }];
        [query stringByAppendingString:nutritions];
    }
    
    
    // flavor
    if (request.flavors) {
        __block NSString *flavors = @"";
        [request.flavors enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            flavors = [flavors stringByAppendingString:[NSString stringWithFormat:@"%@=%@", (NSString *)key, (NSString *)obj]];
        }];
        query = [query stringByAppendingString:flavors];
    }
    
    // facet field
    if (request.facetFieldDiet) {
        query = [query stringByAppendingString:@"&facetField[]=diet"];
    }
    if (request.facetFieldIngredient) {
        query = [query stringByAppendingString:@"&facetField[]=ingredient"];
    }
    
    // max total time
    if (request.maxTotalTimeInSeconds) {
        query = [query stringByAppendingString:[NSString stringWithFormat:@"&maxTotalTimeInSeconds=%lu", (unsigned long)request.maxTotalTimeInSeconds]];
    }
    
    if (request.requirePictures) {
        query = [query stringByAppendingString:@"&requirePictures=true"];
    }
    
    return query;
}

+ (NSString *)stringForMultiParameter:(NSString *)param withValues:(NSArray *)values
{
    param = [param stringByAppendingString:[values componentsJoinedByString:param]];
    return param;
}


@end
