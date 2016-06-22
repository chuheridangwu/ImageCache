//
//  TableViewCell.m
//  ImageCache
//
//  Created by 龙少 on 16/6/22.
//  Copyright © 2016年 龙少. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

+ (instancetype)tableViewCellWithTableView:(UITableView*)tableView{
    static NSString *name = @"TableViewCell";
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:name];
    if (!cell) {
        cell  = [[TableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:name];
    }
    return cell;
}

@end
