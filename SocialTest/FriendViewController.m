//
//  FriendViewController.m
//  SocialTest
//
//  Created by SDT-1 on 2014. 1. 21..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "FriendViewController.h"
#import <FacebookSDK/FacebookSDK.h>

#define FACEBOOK_APPID @"628059973914914"

@interface FriendViewController ()
@property (strong, nonatomic) ACAccount *facebookAccount;
@property (strong, nonatomic) NSArray *data;
@property (weak, nonatomic) IBOutlet UITableView *table;

@end

@implementation FriendViewController

//-(void)showFriends{
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
//            [self requestFriends];
//        }else{
//            NSLog(@"권한 승인 실패 ");
//        }
//    }];
//}
//-(void)requestFriends{
//    NSString *serviceType = SLServiceTypeFacebook;
//    SLRequestMethod method = SLRequestMethodGET;
//    
//    NSURL *url = [NSURL URLWithString:@"https://graph.facebook.com/me/friends"];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FRIEND_CELL" forIndexPath:indexPath];
    
    NSDictionary *one = self.data[indexPath.row];
    
    NSString *contents;
    NSArray *name = one[@"name"];
    
    contents = [NSString stringWithFormat:@"%@", name];
    
    cell.textLabel.text = contents;
    
    return cell;
}
-(void)showFriend{
    FBRequest* friendsRequest = [FBRequest requestForMyFriends];
    [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                  NSDictionary* result,
                                                  NSError *error) {
        self.data = [result objectForKey:@"data"];
        [self.table reloadData];
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [self showFriend];
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
