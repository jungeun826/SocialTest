//
//  StreamViewController.m
//  SocialTest
//
//  Created by SDT-1 on 2014. 1. 21..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "StreamViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#define FACEBOOK_APPID @"628059973914914"

@interface StreamViewController ()
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) ACAccount *facebookAccount;
@property (strong, nonatomic) NSArray *data;
@end

@implementation StreamViewController
//-(void)showTimeline{
//    ACAccountStore *accountStore = [[ACAccountStore alloc]init];
//    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
//    
//    NSDictionary *options = @{ACFacebookAppIdKey:FACEBOOK_APPID, ACFacebookPermissionsKey:@[@"read_stream"/*,@"basic_info"*/], ACFacebookAudienceKey:ACFacebookAudienceEveryone};
//    
//    [accountStore requestAccessToAccountsWithType:accountType options:options completion:^(BOOL granted, NSError *error){
//        if(error)
//            NSLog(@"Error : %@", error);
//        if(granted){
//            NSLog(@"권한 승인 성공");
//            NSArray *accounts = [accountStore accountsWithAccountType:accountType];
//            self.facebookAccount = [accounts lastObject];
//            
//            [self requestFeed];
//        }else{
//            NSLog(@"권한 승인 실패 ");
//        }
//    }];
//}
//-(void)requestFeed{
//    NSString *serviceType = SLServiceTypeFacebook;
//    SLRequestMethod method = SLRequestMethodGET;
//    
//    NSURL *url = [NSURL URLWithString:@"https://graph.facebook.com/me/feed"];
//    NSDictionary *param = nil;
//    
//    SLRequest *request = [SLRequest requestForServiceType:serviceType requestMethod:method URL:url parameters:param];
//    request.account = self.facebookAccount;
//    
//    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
//        if(error != nil){
//            NSLog(@"뉴스 피드 정보 얻기 실패 :%@", error);
//            return;
//        }
//        
//        __autoreleasing NSError *parseError = nil;
//        NSDictionary *resualt = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&parseError];
//        
//        self.data = resualt[@"data"];
//        
//        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//            [self.table reloadData];
//        }];
//    }];
//}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.data count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FEED_CELL" forIndexPath:indexPath];
    
    NSDictionary *one = self.data[indexPath.row];
    
    NSString *contents;
    if(one[@"message"]){
        NSDictionary *likes = one[@"likes"];
        NSArray *data = likes[@"data"];
//        NSLog(@"message likes : %@ ~ %@",likes, count)
        contents = [NSString stringWithFormat:@"%@ ...(%d)", one[@"message"], [data count]];
    }else{
        contents = one[@"story"];
        cell.indentationLevel = 2;
    }
    
    cell.textLabel.text = contents;
    
    return cell;
}
-(void)showTimeLine{
    FBRequest* friendsRequest = [FBRequest requestForGraphPath:@"me/feed"];
    [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                  NSDictionary* result,
                                                  NSError *error) {
        self.data = [result objectForKey:@"data"];
        [self.table reloadData];
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [self showTimeLine];
}
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
    self.data = [[NSArray alloc]init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
