//
//  FeedViewController.m
//  HW4_Tweet
//
//  Created by Yu Yichen on 9/24/13.
//  Copyright (c) 2013 Yu Yichen. All rights reserved.
//

#import "FeedViewController.h"
#import "DetailViewController.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>

@interface FeedViewController ()

@end

@implementation FeedViewController
@synthesize twitterFeed;

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
    
    [self downloadTwitterFeed];
    
    

    
}


-(void) refreshAction
{
    [self downloadTwitterFeed];
    [self.tableView reloadData];
   
    
}


-(BOOL) userHasAccess
{
    return [SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter];
}

- (void) downloadTwitterFeed
{
    //  Step 0: Check that the user has local Twitter accounts
    if ([self userHasAccess]) {
        
        //  Step 1:  Obtain access to the user's Twitter accounts
        ACAccountStore *accountStore=[[ACAccountStore alloc]init];
        ACAccountType *twitterAccountType = [accountStore
                                             accountTypeWithAccountTypeIdentifier:
                                             ACAccountTypeIdentifierTwitter];
      
        
        [accountStore
         requestAccessToAccountsWithType:twitterAccountType
         options:nil
         completion:^(BOOL granted, NSError *error){
             if (granted==YES)
             {
                 
                 //  Step 2:  Create a request
                 NSArray *twitterAccounts =
                 [accountStore accountsWithAccountType:twitterAccountType];
                 NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/search/tweets.json"];
                 NSDictionary *params = @{@"q" : @"apple"};
                 SLRequest *request =
                 [SLRequest requestForServiceType:SLServiceTypeTwitter
                                    requestMethod:SLRequestMethodGET
                                              URL:url
                                       parameters:params];
                 
                 //  Attach an account to the request
                 [request setAccount:[twitterAccounts lastObject]];
                 
                 //  Step 3:  Execute the request
                 [request performRequestWithHandler:^(NSData *responseData,
                                                      NSHTTPURLResponse *urlResponse,
                                                      NSError *error) {
                     if (responseData) {
                         if (urlResponse.statusCode >= 200 && urlResponse.statusCode < 300) {
                             NSError *jsonError;
                             NSDictionary *results =
                             [NSJSONSerialization
                              JSONObjectWithData:responseData
                              options:NSJSONReadingAllowFragments error:&jsonError];
                             
                             if (results) {
                                 // Get the "results" key from NSDictionary into an NSArray that will be read by the UITableView dataSource
                                 // "twitterFeed" is a NSMutableArray @property of the view controller
                                 
                                 self.twitterFeed = [NSMutableArray arrayWithArray:[results objectForKey:@"statuses"]];
                                 dispatch_async(dispatch_get_main_queue(),^{
                                 [self.tableView reloadData];
                                 [self.refreshControl endRefreshing];});
                             }
                             else {
                                 // Our JSON deserialization went awry
                                 NSLog(@"JSON Error: %@", [jsonError localizedDescription]);
                             }
                         }
                         else {
                             // The server did not respond successfully... were we rate-limited?
                             NSLog(@"The response status code is %d", urlResponse.statusCode);
                         }
                     }
                 }];
               }//block for granted==yes
              else
              {
                  // Access was not granted, or an error occurred
                  NSLog(@"%@", [error localizedDescription]);
              }
         }];
    }
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
    
    return [twitterFeed count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FeedCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSLog(@"Asking for cell: %d",indexPath.row);
    cell.textLabel.text=[twitterFeed objectAtIndex:indexPath.row][@"text"];
    NSLog(@"%@",[twitterFeed objectAtIndex:indexPath.row]);
    cell.detailTextLabel.text=[twitterFeed objectAtIndex:indexPath.row][@"user"][@"name"];
   
    
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
        [self.twitterFeed removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}



// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSDictionary *oldTweet=[NSDictionary dictionaryWithDictionary:[self.twitterFeed objectAtIndex:fromIndexPath.row]];
    [self.twitterFeed removeObjectAtIndex:fromIndexPath.row];
    [self.twitterFeed insertObject:oldTweet atIndex:toIndexPath.row];
}


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([segue.identifier isEqualToString:@"segueToDetail"]){
        
        NSIndexPath *indexPath=[self.tableView indexPathForSelectedRow];
        
        
        NSDictionary *selectTweet=[self.twitterFeed objectAtIndex:indexPath.row];
        [segue.destinationViewController setCurrentTweet:selectTweet];
        
    }

}


@end
