//
//  Detail.h
//  itunes
//
//  Created by ahmet on 23/06/15.
//  Copyright (c) 2015 ahmet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Detail : UIViewController<UITabBarDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *detailTableView;

@property (weak, nonatomic) IBOutlet UILabel *labelTitle;

@property (weak, nonatomic) IBOutlet UIImageView *bigImage;

@property (weak, nonatomic) IBOutlet UITextView *summary;

@property (strong, nonatomic) NSDictionary *dict;

@end
