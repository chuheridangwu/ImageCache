//
//  XBDownOperation.h
//  ImageCache
//
//  Created by 龙少 on 16/6/23.
//  Copyright © 2016年 龙少. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class XBDownOperation;
@protocol XBDownOperationDelegate <NSObject>

- (void)downImageWithOperation:(XBDownOperation*)operation image:(UIImage*)image indexPath:(NSIndexPath*)indexPath;

@end

@interface XBDownOperation : NSOperation
@property (nonatomic,copy)NSString *imageUrl;
@property (nonatomic,strong)NSIndexPath *indexPath;
@property (nonatomic,weak)id<XBDownOperationDelegate> delegate;
@end

