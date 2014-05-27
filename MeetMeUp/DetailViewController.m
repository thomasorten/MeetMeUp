//
//  DetailViewController.m
//  MeetMeUp
//
//  Created by Thomas Orten on 5/27/14.
//  Copyright (c) 2014 Orten, Thomas. All rights reserved.
//

#import "DetailViewController.h"
#import "WebViewController.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *rsvpCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *hostingGroupLabel;
@property (weak, nonatomic) IBOutlet UITextView *eventDescriptionTextView;

@end

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSDictionary *group = [self.event objectForKey:@"group"];
    NSNumber *rsvpCount = [self.event objectForKey:@"yes_rsvp_count"];
    
    self.title = [self.event objectForKey:@"name"];
    self.rsvpCountLabel.text = [rsvpCount stringValue];
    self.hostingGroupLabel.text = [group objectForKey:@"name"];
     self.eventDescriptionTextView.text = [self stripTags:[self.event objectForKey:@"description"]];
}

- (NSString *) stripTags:(NSString *)str
{
    NSMutableString *ms = [NSMutableString stringWithCapacity:[str length]];
    
    NSScanner *scanner = [NSScanner scannerWithString:str];
    [scanner setCharactersToBeSkipped:nil];
    NSString *s = nil;
    while (![scanner isAtEnd])
    {
        [scanner scanUpToString:@"<" intoString:&s];
        if (s != nil)
            [ms appendString:s];
        [scanner scanUpToString:@">" intoString:NULL];
        if (![scanner isAtEnd])
            [scanner setScanLocation:[scanner scanLocation]+1];
        s = nil;
    }
    
    return ms;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    WebViewController *nextController = segue.destinationViewController;
    nextController.url = [self.event objectForKey:@"event_url"];
}

@end
