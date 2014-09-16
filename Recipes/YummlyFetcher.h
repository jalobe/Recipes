//
//  YummlyFetcher.h
//  Recipes
//
//  Created by Jan Lottermoser on 27.08.14.
//  Copyright (c) 2014 Jan Lottermoser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RecipeSearchRequest.h"

@interface YummlyFetcher : NSObject


+ (NSURL *)URLForRecipeWithID:(NSString *)identifier;

+ (NSURL *)URLForSearchWithParameters:(RecipeSearchRequest *)request maxResults:(NSUInteger)maxResults page:(NSUInteger)page;

+ (NSURL *)URLForImageWithRecipeInformation:(NSDictionary *)recipe;

@end
