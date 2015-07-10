//
//  Detail.m
//  itunes
//
//  Created by ahmet on 23/06/15.
//  Copyright (c) 2015 ahmet. All rights reserved.
//

#import "Detail.h"

@interface Detail ()

@end

@implementation Detail

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
  /*  self.labelTitle.text = _dict[@"name"];;
    
    NSURL *url = [NSURL URLWithString:_dict[@"imageBig"]];
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    UIImage *Image = [[UIImage alloc] initWithData:data];

    self.bigImage.image = Image;
    
    self.summary.text = _dict[@"summary"];
    */
    
    [[self detailTableView]reloadData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString* CellIdentifier = @"CellDetail";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 
    
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

             }
    
    if (indexPath.row == 0) {
        
        self.detailTableView.rowHeight = 75;
        
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(20, -15, 400, 100)];
        
        lbl.text = _dict[@"name"];
        
        [cell.contentView addSubview:lbl];

    }else if (indexPath.row == 1){
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                       ^{
                           NSURL *imageURL = [NSURL URLWithString:_dict[@"imageBig"]];
                           NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                           
                           dispatch_sync(dispatch_get_main_queue(), ^{
                               
                               UIImage *Image = [UIImage imageWithData:imageData];
                               
                               UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - Image.size.width)/2, 30, Image.size.width, Image.size.height)];
                               imgView.tag = 1;
                               [cell.contentView addSubview:imgView];
                               imgView = nil;

                               UIImageView *_imgView = (UIImageView *)[cell.contentView viewWithTag:1];
                               _imgView.image = Image;
                               
                           });
                       });
  
        self.detailTableView.rowHeight = 250;

    }else if (indexPath.row == 2){
    
       UITextView *myText = [[UITextView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - self.view.frame.size.width*2/3) / 2, 50, self.view.frame.size.width*2/3, 0)];
   
        myText.text = _dict[@"summary"];

        NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:20.],
                                     NSForegroundColorAttributeName: [UIColor redColor]};
        NSAttributedString *as = [[NSAttributedString alloc] initWithString:myText.text attributes:attributes];
        
        CGFloat textViewHeight = [self textViewHeightForAttributedText:as andWidth:self.view.frame.size.width*2/3];

            
        myText.frame = CGRectMake(myText.frame.origin.x, myText.frame.origin.y, self.view.frame.size.width*2/3, textViewHeight);

        [cell.contentView addSubview:myText];
 
        self.detailTableView.rowHeight = textViewHeight*2/3;
        
    }
    
    return cell;
  
}

 - (CGFloat)textViewHeightForAttributedText:(NSAttributedString *)text andWidth:(CGFloat)width
 {
 UITextView *textView = [[UITextView alloc] init];
 [textView setAttributedText:text];
 CGSize size = [textView sizeThatFits:CGSizeMake(width, FLT_MAX)];
 return size.height;
 }


@end
