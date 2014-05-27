//
//  ViewController.m
//  MeetMeUp
//
//  Created by Thomas Orten on 5/27/14.
//  Copyright (c) 2014 Orten, Thomas. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>
@property NSArray *meetupsArray;
@property (weak, nonatomic) IBOutlet UITableView *meetupsTableView;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSURL *url = [NSURL URLWithString:@"https://api.meetup.com/2/open_events.json?zip=60604&text=mobile&time=,1w&key=f1a5c85e506367585e7f4b2e6931"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *resultsDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&connectionError];
        self.meetupsArray = [resultsDictionary objectForKey:@"results"];
        [self.meetupsTableView reloadData];
    }];
	
    // Do any additional setup after loading the view, typically from a nib.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.meetupsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *event = [self.meetupsArray objectAtIndex:indexPath.row];
    NSDictionary *venue = [event objectForKey:@"venue"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MeetupCellID"];
    
    cell.textLabel.text = [event objectForKey:@"name"];
    cell.detailTextLabel.text = [venue objectForKey:@"address_1"];
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DetailViewController *nextController = segue.destinationViewController;
    NSIndexPath *indexPath = [self.meetupsTableView indexPathForSelectedRow];
    nextController.event = [self.meetupsArray objectAtIndex:indexPath.row];
}

@end
