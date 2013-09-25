//
//  DetailViewController.m
//  HW4_Tweet
//
//  Created by Yu Yichen on 9/24/13.
//  Copyright (c) 2013 Yu Yichen. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController
@synthesize tweetDate;
@synthesize tweetContent;
@synthesize tweetAuthor;
@synthesize userImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    tweetDate.text=self.currentTweet[@"created_at"];
    tweetContent.text=self.currentTweet[@"text"];
    tweetAuthor.text=self.currentTweet[@"user"][@"name"];
    
    NSURL *userURL=[NSURL URLWithString:self.currentTweet[@"user"][@"profile_image_url"]];
    NSData *userData=[[NSData alloc]initWithContentsOfURL:userURL];
    UIImage *user=[[UIImage alloc]initWithData:userData];
    userImage.image=user;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)addButton:(UIBarButtonItem *)sender {
    // Retrieve the NSUserDefaults dictionary
    NSUserDefaults  *defaults = [NSUserDefaults standardUserDefaults];
    
    // Retrieve a mutable copy of the array of favorite tweets or create  one if it doesn't exists
    NSMutableArray *favoriteTweets = [[defaults arrayForKey:@"FavoriteTweets"] mutableCopy];
    if (!favoriteTweets)
        favoriteTweets = [NSMutableArray array];//create the array
    
    // Create a shorter current tweet object in a simple NSDictionary
    NSDictionary *abridgedTweet = @{@"Text" : [self.currentTweet objectForKey:@"text"],
                                    @"User" : [self.currentTweet objectForKey:@"user"][@"name"],
                                    @"DateString" : [self.currentTweet objectForKey:@"created_at"]};
    
    // Add the current tweet to our favorite tweets array
    [favoriteTweets addObject:abridgedTweet];
    
    // Reset the FavoritesTweet array
    [defaults setObject:favoriteTweets forKey:@"FavoriteTweets"];
    [defaults synchronize];
    
    // Log it out for debugging
    NSLog(@"Defaults:%@",[defaults dictionaryRepresentation]);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Great"
                                                    message:@"This tweet has been added to your favorite menu." delegate:self cancelButtonTitle: @"OK" otherButtonTitles:nil, nil];
    [alert show];
}
@end
