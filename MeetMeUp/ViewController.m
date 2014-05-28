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
@property NSMutableArray *meetupsArray;
@property (weak, nonatomic) IBOutlet UITableView *meetupsTableView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self getDataFromSearchString:@"mobile"];
}

- (IBAction)onSearchPressed:(id)sender
{
    if (self.searchTextField.text.length > 0) {
        [self getDataFromSearchString: self.searchTextField.text];
        [self.searchTextField resignFirstResponder];
    }
}

- (UIImage *)getImageFromUrl:(NSString *)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    if (image == nil) {
        image = [UIImage imageNamed:@"logo-2x"];
    }
    return image;
}

- (void)getDataFromSearchString:(NSString *)searchTerm
{
    NSString *urlString = [NSString stringWithFormat:@"https://api.meetup.com/2/open_events.json?zip=60604&text=%@&time=,1w&key=f1a5c85e506367585e7f4b2e6931&fields=group_photo", [searchTerm stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *resultsDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&connectionError];
        self.meetupsArray = [resultsDictionary objectForKey:@"results"];
        for (NSMutableDictionary *meetupDictionary in self.meetupsArray) {
            NSString *groupThumb = [[[meetupDictionary objectForKey:@"group"] objectForKey:@"group_photo"] objectForKey:@"thumb_link"];
            [meetupDictionary setObject:[self getImageFromUrl:groupThumb] forKey:@"group_photo"];
        }
        [self.meetupsTableView reloadData];
    }];
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
    cell.imageView.image = [event objectForKey:@"group_photo"];
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DetailViewController *nextController = segue.destinationViewController;
    NSIndexPath *indexPath = [self.meetupsTableView indexPathForSelectedRow];
    nextController.event = [self.meetupsArray objectAtIndex:indexPath.row];
}

@end
