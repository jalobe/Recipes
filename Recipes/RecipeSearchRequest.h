//
//  RecipeSearchRequest.h
//  Recipes
//
//  Created by Jan Lottermoser on 27.08.14.
//  Copyright (c) 2014 Jan Lottermoser. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    sweet = 0,
    meaty,
    sour,
    bitter,
    piquant
} Flavor;

typedef enum {
    Potassium = 0,
    Sodium,
    Cholesterol,
    Fatty_acids_trans,
    Fatty_acids_suturated,
    Carbohydrate,
    Fiber,
    Protein,
    VitaminC,
    Calcium,
    Iron,
    Sugars,
    Energy,
    Fat,
    VitaminA
} Nutrition;

@interface RecipeSearchRequest : NSObject

@property (nonatomic, strong) NSString *searchPhrase;
@property (nonatomic) BOOL requirePictures;
@property (nonatomic, strong) NSArray *allowedIngredients;
@property (nonatomic, strong) NSArray *excludedIngredients;
@property (nonatomic, strong) NSArray *allowedAllergies;
@property (nonatomic, strong) NSArray *allowedDiets;
@property (nonatomic, strong) NSArray *allowedCuisine;
@property (nonatomic, strong) NSArray *excludedCuisine;
@property (nonatomic, strong) NSArray *allowedCourse;
@property (nonatomic, strong) NSArray *excludedCourse;
@property (nonatomic, strong) NSArray *allowedHoliday;
@property (nonatomic, strong) NSArray *excludedHoliday;
@property (nonatomic) NSUInteger maxTotalTimeInSeconds;
@property (nonatomic, strong, readonly) NSDictionary *nutritions;
@property (nonatomic, strong, readonly) NSDictionary *flavors;
@property (nonatomic) BOOL *facetFieldDiet;
@property (nonatomic) BOOL *facetFieldIngredient;



- (void)setMinValue:(float)value forFlavor:(Flavor)flavor;
- (void)setMaxValue:(float)value forFlavor:(Flavor)flavor;

- (void)setMinValue:(NSUInteger)value forNutrition:(Nutrition)nutrition;
- (void)setMaxValue:(NSUInteger)value forNutrition:(Nutrition)nutrition;
+ (NSArray *)nutritionStrings;

@end
