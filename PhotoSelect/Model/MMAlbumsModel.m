//
//  MMAlbumsModel.m
//  MMCalculator
//
//  Created by 齐云浩 on 2017/4/6.
//
//

#import "MMAlbumsModel.h"

@implementation MMAlbumsModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    ;
}
- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
+ (instancetype)AlbumsModelWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}


@end
