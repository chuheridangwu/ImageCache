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
// 存放所有下载操作(url是key,operation对象是value)
@property (nonatomic,strong)NSMutableDictionary *operations;
// 存放所有下载完的图片
@property (nonatomic,strong)NSMutableDictionary *images;
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

- (NSMutableDictionary*)operations{
    if (!_operations) {
        _operations = [NSMutableDictionary dictionary];
    }
    return _operations;
}

- (NSMutableDictionary*)images{
    if (!_images) {
        _images = [NSMutableDictionary dictionary];
    }
    return _images;
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

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    
    //移除下载操作
    [self.queue cancelAllOperations];
    [self.operations removeAllObjects];
    //清空字典数据
    [self.images removeAllObjects];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TableViewCell *cell = [TableViewCell tableViewCellWithTableView:tableView];
    Model *model = self.modelArray[indexPath.row];
    cell.textLabel.text = model.name;
    
    //从字典中取出缓存图片
    UIImage *image = self.images[model.icon];
    if (image) {
        cell.imageView.image = image;
    }else{
        //设置占位图片
        cell.imageView.image = [UIImage imageNamed:@"placeImage.png"];
        
        //取出当前图片URL对应的下载操作(operation对象)
        NSBlockOperation *operation = self.operations[model.icon];
        if (!operation) {
            //创建操作，下载图片
            operation = [NSBlockOperation blockOperationWithBlock:^{
                NSURL *url = [NSURL URLWithString:model.icon];
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
                //回到主线程
                [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                    
                    //将图片添加入缓存字典中
                    if (image) {
                        self.images[model.icon] = image;
                    }
                    
                    //刷新单行的cell
                    [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    
                    //下载成功后，从字典中移除下载操作
                    [self.operations removeObjectForKey:model.icon];
                }];
                
            }];
            
            //添加操作到队列中
            [self.queue addOperation:operation];
            
            //将下载操作添加到字典
            self.operations[model.icon] = operation;
        }
    }
   
    
    return cell;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //暂停下载
    [self.queue setSuspended:YES];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    //恢复下载
    [self.queue setSuspended:NO];
}
/*
 1.将下载图片的耗时操作放在子线程去做，有数据后返回主线程设置UI
 2.如何防止重复下载操作，只需要保证一张图片只下载一次.
   从字典中取出NSBlockOperation对象，如果对象存在，不需要创建。如果不存在，创建对象，将对象存进字典
 3.使用字典存在下载操作有两个坏处:1.字典会越来越大。
                             2.如果网络不好，图片下载失败。这时NSBlockOperation对象已经添加到字典中去了，没有办法再次下载！
    解决办法:1.当图片下载成功后，从字典中移除下载操作
            2.重新创建一个字典，用来保存image。
 4.使用字典来放入缓存图片，如果有图片，直接设置，如果没有，查看是否有下载操作，如果没有，进行下载，下载成功后，将图片添加入images字典，从operations字典中移除
 5.如果当前图片没有下载，需要一张占位图片，图片下载完后刷新UI。
 6.如果有内存警告，清空字典，移除所有下载操作
 7.当用户滑动tableView时，可以暂停下载，停止滑动之后恢复下载
 */











@end
