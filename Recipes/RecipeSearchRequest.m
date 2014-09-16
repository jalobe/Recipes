//
//  RecipeSearchRequest.m
//  Recipes
//
//  Created by Jan Lottermoser on 27.08.14.
//  Copyright (c) 2014 Jan Lottermoser. All rights reserved.
//

#import "RecipeSearchRequest.h"

@interface RecipeSearchRequest()
@property (nonatomic, strong, readwrite) NSMutableDictionary *flavors;
@property (nonatomic, strong, readwrite) NSMutableDictionary *nutritions;
@end

@implementation RecipeSearchRequest

+ (NSArray *)nutritionStrings
{
    return @[@"K", @"NA", @"CHOLE", @"FATRN", @"FASAT", @"CHOCDF", @"FIBTG", @"PROCNT", @"VITC", @"CA", @"FE", @"SUGAR", @"FAT_KCAL", @"FAT", @"VITA_IU"];
}

- (NSArray *)flavorString
{
    return @[@"sweet", @"meaty", @"sour", @"bitter", @"piquant"];
}

- (NSDictionary *)flavors
{
    return _flavors;
}

- (void)setMinValue:(float)value forFlavor:(Flavor)flavor
{
    if (!self.flavors) {
        _flavors = [[NSMutableDictionary alloc] init];
    }
    float val = value;
    if (val > 1) val = 1;
    NSString *key = [NSString stringWithFormat:@"&flavor.%@.min", [self flavorString][flavor]];
    NSString *valueString = [NSString stringWithFormat:@"%f", val];
    [self.flavors setValue:valueString forKey:key];
    
}

- (void)setMaxValue:(float)value forFlavor:(Flavor)flavor
{
    if (!self.flavors) {
        _flavors = [[NSMutableDictionary alloc] init];
    }
    float val = value;
    if (val > 1) val = 1;
    NSString *key = [NSString stringWithFormat:@"&flavor.%@.max", [self flavorString][flavor]];
    NSString *valueString = [NSString stringWithFormat:@"%f", val];
    [self.flavors setValue:valueString forKey:key];
}


- (NSDictionary *)nutritions
{
    return _nutritions;
}

- (void)setMinValue:(NSUInteger)value forNutrition:(Nutrition)nutrition
{
    if (!self.nutritions) {
        _nutritions = [[NSMutableDictionary alloc] init];
    }
    NSString *key = [NSString stringWithFormat:@"&nutrition.%@.min", [RecipeSearchRequest nutritionStrings][nutrition]];
    NSString *valueString = [NSString stringWithFormat:@"%lu", (unsigned long)value];
    [self.flavors setValue:valueString forKey:key];
}

- (void)setMaxValue:(NSUInteger)value forNutrition:(Nutrition)nutrition
{
    if (!self.nutritions) {
        _nutritions = [[NSMutableDictionary alloc] init];
    }
    NSString *key = [NSString stringWithFormat:@"&nutrition.%@.max", [RecipeSearchRequest nutritionStrings][nutrition]];
    NSString *valueString = [NSString stringWithFormat:@"%lu", (unsigned long)value];
    [self.flavors setValue:valueString forKey:key];
}

@end
