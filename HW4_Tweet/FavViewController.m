//
//  FavViewController.m
//  HW4_Tweet
//
//  Created by Yu Yichen on 9/24/13.
//  Copyright (c) 2013 Yu Yichen. All rights reserved.
//

#import "FavViewController.h"
#import "FavCell.h"

@interface FavViewController ()

@end

@implementation FavViewController
@synthesize favTweets;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.leftBarButtonItem=[self editButtonItem];
    
    UIRefreshControl *pullToRefresh=[[UIRefreshControl alloc]init];
    pullToRefresh.tintColor=[UIColor purpleColor];
    [pullToRefresh addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventValueChanged];
    self.refreshControl=pullToRefresh;
}
-(void)viewWillAppear:(BOOL)animated
//it will be executed every time when the view appears
{
    NSUserDefaults  *defaults=[NSUserDefaults standardUserDefaults];
    favTweets=[NSMutableArray arrayWithArray:[defaults objectForKey:@"FavoriteTweets"]];
    [self.tableView reloadData];
}

-(void) refreshAction
{
    
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [favTweets count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FavCell";
    FavCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSLog(@"Asking for cell: %d",indexPath.row);
    cell.favAuthor.text=[self.favTweets objectAtIndex:indexPath.row][ @"User"];
    cell.favDate.text=[self.favTweets objectAtIndex:indexPath.row][ @"DateString"];
    cell.favText.text=[self.favTweets objectAtIndex:indexPath.row][@"Text"];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.favTweets removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        NSUserDefaults  *defaults=[NSUserDefaults standardUserDefaults];
        [defaults setObject:favTweets forKey:@"FavoriteTweets"];
        [defaults synchronize];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}



// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSDictionary *oldTweet=[NSDictionary dictionaryWithDictionary:[favTweets objectAtIndex:fromIndexPath.row]];
    [favTweets removeObjectAtIndex:fromIndexPath.row];
    [favTweets insertObject:oldTweet atIndex:toIndexPath.row];
}


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
