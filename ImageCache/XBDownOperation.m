//
//  XBDownOperation.m
//  ImageCache
//
//  Created by 龙少 on 16/6/23.
//  Copyright © 2016年 龙少. All rights reserved.
//

#import "XBDownOperation.h"


@implementation XBDownOperation

// 当NSBlockOperation被加入到NSOperationQueue中，会自动调用main方法
- (void)main{
    //由于重写了main方法，所以需要我们手动添加到自动释放池
    @autoreleasepool {
        //检测操作是否被取消
        if([self isCancelled]) return;
        
        NSURL *url = [NSURL URLWithString:self.imageUrl];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        // 返回主线程前再检查一次
        if([self isCancelled]) return;
        //回到主线程
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            if ([self.delegate respondsToSelector:@selector(downImageWithOperation:image: indexPath:)]) {
                [self.delegate downImageWithOperation:self image:image indexPath:self.indexPath];
            }
        }];
    }
   
}
@end
