//
//  Model.h
//  ImageCache
//
//  Created by 龙少 on 16/6/22.
//  Copyright © 2016年 龙少. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *icon;
+ (instancetype)modelWithDict:(NSDictionary*)dic;
@end
