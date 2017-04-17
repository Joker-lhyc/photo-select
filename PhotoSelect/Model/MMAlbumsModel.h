//
//  MMAlbumsModel.h
//  MMCalculator
//
//  Created by 齐云浩 on 2017/4/6.
//
//

#import <Foundation/Foundation.h>

@interface MMAlbumsModel : NSObject
@property (nonatomic,strong) NSString *name;//相册名称
@property (nonatomic,strong) NSString *number;//图片数量
@property (nonatomic,strong) NSString *photo;//封面
@property (nonatomic,strong) NSString *lock;//是否上锁
@property (nonatomic,strong) NSString *locknumber;//相册密码


- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)AlbumsModelWithDict:(NSDictionary *)dict;

@end
