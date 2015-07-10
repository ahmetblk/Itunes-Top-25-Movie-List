//
//  ViewController.m
//  Itunes Movie
//
//  Created by ahmet on 22/06/15.
//  Copyright (c) 2015 ahmet. All rights reserved.
//

#import "ViewController.h"
#import "Detail.h"


NSDictionary *summaryDic;

@interface ViewController (){
    
    NSMutableData *webData;
    NSURLConnection *connection;
    NSString *imageUrlIcon;
    NSString *imageUrlBig;
    NSMutableArray *array;

}

@end

@implementation ViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[self tableView]setDelegate:self];
    [[self tableView]setDataSource:self];
    
    array = [[NSMutableArray alloc]init];

    
//    NSURL *url = [NSURL URLWithString:@"http://itunes.apple.com/us/rss/topmovies/limit=10/genre=4401/json"];
    NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/tr/rss/topmovies/limit=25/json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    connection = [NSURLConnection connectionWithRequest:request delegate:self];
    
    if (connection) {
        webData = [[NSMutableData alloc]init];
    }

    self.tableView.contentOffset = CGPointMake(0, 0);
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [webData setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [webData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"fail with error");
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    NSDictionary *allDataDictionary = [NSJSONSerialization JSONObjectWithData:webData options:0 error:nil];
    NSDictionary *feed = [allDataDictionary objectForKey:@"feed"];
    
    NSDictionary *auther = [feed objectForKey:@"author"];
    NSDictionary *name = [auther objectForKey:@"name"];
    NSString *labelItunes = [name objectForKey:@"label"];
    
        NSLog(@"%@", labelItunes);
    
    self.titleTableView.title = labelItunes;
    
    NSArray *arrayOfEntry = [feed objectForKey:@"entry"];
    for (NSDictionary *diction in arrayOfEntry) {
        NSMutableDictionary *dictionary = [NSMutableDictionary new];

        // add title
        NSDictionary *title = [diction objectForKey:@"title"];
        NSString *labelName = [title objectForKey:@"label"];
        
        // add category
        NSDictionary *category = [diction objectForKey:@"category"];
        NSDictionary *attributes = [category objectForKey:@"attributes"];
        NSString *labelCategory = [attributes objectForKey:@"label"];
        
        // add image
        NSArray *arrayOfImage = [diction objectForKey:@"im:image"];
         for (NSDictionary *imageLink in arrayOfImage) {
     
            NSString *imageName = [imageLink objectForKey:@"label"];
          NSDictionary *attributesImage = [imageLink objectForKey:@"attributes"];
            NSString *height = [attributesImage objectForKey:@"height"];
            NSLog(@" image link : %@", imageLink);
            NSLog(@" imageName : %@", imageName);
            NSLog(@" height : %@", height);
             
             if (60 == [height intValue]) {
                 imageUrlIcon = imageName;
                 NSLog(@"imageUrlIcon : %@",imageUrlIcon);
                 
                 [dictionary setObject:imageUrlIcon forKey:@"imageIcon"];
             }else{
                 imageUrlBig = imageName;
                 NSLog(@"imageUrlBig : %@",imageUrlBig);
                 [dictionary setObject:imageUrlBig forKey:@"imageBig"];
             }
        }
        
        // add summary
        NSDictionary *summary = [diction objectForKey:@"summary"];
        NSString *labelSum = [summary objectForKey:@"label"];

        // variable add dictionary
        [dictionary setObject:labelName forKey:@"name"];
        [dictionary setObject:labelCategory forKey:@"category"];
        [dictionary setObject:labelSum forKey:@"summary"];
        
        // dictionary add variable
        [array addObject:dictionary];
        
        NSLog(@"%@", array);
    }
    
    [[self tableView]reloadData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [array count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"IconCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
#ifdef PAID
    NSLog(@"paid app");
#endif
        
    //array[indexPath.row];
    cell.textLabel.text = [array objectAtIndex:indexPath.row][@"name"];
    cell.detailTextLabel.text = [array objectAtIndex:indexPath.row][@"category"];
    
    NSURL *url = [NSURL URLWithString:[array objectAtIndex:indexPath.row][@"imageIcon"]];
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    UIImage *Image = [[UIImage alloc] initWithData:data];

    // asign image
    
    cell.imageView.image = Image;
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
    summaryDic = array[indexPath.row];
    
    [self performSegueWithIdentifier:@"yourSegue" sender:self];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"yourSegue"])
    {
        //if you need to pass data to the next controller do it here
          Detail *controller = segue.destinationViewController;
           controller.dict = summaryDic;
       
      
        
    }
}

@end
