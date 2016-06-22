//
//  ViewController.m
//  ImageCache
//
//  Created by 龙少 on 16/6/22.
//  Copyright © 2016年 龙少. All rights reserved.
//

#import "ViewController.h"
#import "TableViewCell.h"
#import "Model.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
}
@property (nonatomic,strong)NSArray *modelArray;
// 存放所有下载操作的队列
@property (nonatomic,strong)NSOperationQueue *queue;
@end

@implementation ViewController

- (NSArray*)modelArray{
    if (!_modelArray) {
        NSMutableArray *appArray =[NSMutableArray array];
        NSString *file = [[NSBundle mainBundle]pathForResource:@"apps.plist" ofType:nil];
        NSArray *dicArray = [NSArray arrayWithContentsOfFile:file];
        for (NSDictionary *dic in dicArray) {
            Model *model = [Model modelWithDict:dic];
            [appArray addObject:model];
        }
        _modelArray = appArray;
    }
    return _modelArray;
}

- (NSOperationQueue*)queue{
    if (!_queue) {
        _queue = [[NSOperationQueue alloc]init];
    }
    return _queue;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 80;
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TableViewCell *cell = [TableViewCell tableViewCellWithTableView:tableView];
    Model *model = self.modelArray[indexPath.row];
    cell.textLabel.text = model.name;
    
    //创建操作，下载图片
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        NSURL *url = [NSURL URLWithString:model.icon];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        //回到主线程
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
             cell.imageView.image = image;
        }];
       
    }];
    
    //添加操作到队列中
    [self.queue addOperation:operation];
    return cell;
}

/*
 1.将下载图片的耗时操作放在子线程去做，有数据后返回主线程设置UI
 2.如何防止重复下载操作
 
 */











@end
