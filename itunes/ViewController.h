//
//  ViewController.h
//  itunes
//
//  Created by ahmet on 22/06/15.
//  Copyright (c) 2015 ahmet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, NSURLConnectionDataDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UINavigationItem *titleTableView;

@end