
//
//  Model.m
//  ImageCache
//
//  Created by 龙少 on 16/6/22.
//  Copyright © 2016年 龙少. All rights reserved.
//

#import "Model.h"

@implementation Model

+ (instancetype)modelWithDict:(NSDictionary*)dic{
    Model *model = [[Model alloc]init];
    model.name = dic[@"name"];
    model.icon = dic[@"icon"];
    return model;
}

@end
