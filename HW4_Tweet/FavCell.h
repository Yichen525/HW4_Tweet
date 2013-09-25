//
//  FavCell.h
//  HW4_Tweet
//
//  Created by Yu Yichen on 9/24/13.
//  Copyright (c) 2013 Yu Yichen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *favAuthor;
@property (weak, nonatomic) IBOutlet UILabel *favDate;
@property (weak, nonatomic) IBOutlet UILabel *favText;

@end
