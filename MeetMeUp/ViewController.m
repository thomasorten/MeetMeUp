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
    
    [self getDataFromUrl:@"https://api.meetup.com/2/open_events.json?zip=60604&text=mobile&time=,1w&key=f1a5c85e506367585e7f4b2e6931"];
}

- (IBAction)onSearchPressed:(id)sender
{
    if (self.searchTextField.text.length > 0) {
        NSString *url = [[@"https://api.meetup.com/2/open_events.json?zip=60604&text=" stringByAppendingString: self.searchTextField.text] stringByAppendingString:@"&time=,1w&key=f1a5c85e506367585e7f4b2e6931"];
        [self getDataFromUrl: url];
        [self.searchTextField resignFirstResponder];
    }
}

- (void)getThumbnailsFromUrl:(NSString *)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&connectionError];
            NSDictionary *resultDictionary = [result objectForKey:@"results"][0];
            NSDictionary *groupPhoto = [resultDictionary objectForKey:@"group_photo"];
            NSString *imageUrl = [groupPhoto objectForKey:@"thumb_link"];
            NSLog(@"%@", imageUrl);
//            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
//            if (image == nil) {
//                image = [UIImage imageNamed:@"logo-2x"];
//            }
        
    }];
}

- (void)getDataFromUrl:(NSString *)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *resultsDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&connectionError];
        self.meetupsArray = [resultsDictionary objectForKey:@"results"];
        for (NSMutableDictionary *meetupDictionary in self.meetupsArray) {
            NSDictionary *group = [meetupDictionary objectForKey:@"group"];
            NSString *groupId = [[group objectForKey:@"id"] stringValue];
            NSString *groupUrl = [[@"https://api.meetup.com/2/groups?&sign=true&group_id=" stringByAppendingString: groupId] stringByAppendingString:@"&page=20&key=f1a5c85e506367585e7f4b2e6931"];
            [self getThumbnailsFromUrl:groupUrl];
            //[meetupDictionary setObject:[self getThumbnailsFromUrl:groupUrl] forKey:@"groupImage"];
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
    cell.imageView.image = [event objectForKey:@"groupImage"];
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DetailViewController *nextController = segue.destinationViewController;
    NSIndexPath *indexPath = [self.meetupsTableView indexPathForSelectedRow];
    nextController.event = [self.meetupsArray objectAtIndex:indexPath.row];
}

@end
