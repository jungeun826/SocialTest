
//
//  ProfileViewController.m
//  SocialTest
//
//  Created by SDT-1 on 2014. 1. 21..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "ProfileViewController.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>

#define FACEBOOK_APPID @"628059973914914"
//#define FACEBOOK_PERMISSION @"user_about_me"

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UITextView *aboutView;
@property (weak, nonatomic) IBOutlet UILabel *linkLabel;
@property (weak, nonatomic) IBOutlet UILabel *updateLabel;

@property (strong, nonatomic) ACAccount *facebookAccount;
@end

@implementation ProfileViewController
- (void)viewWillAppear:(BOOL)animated{
    [self showMyProfile];
}
-(void)showMyProfile{
    ACAccountStore *accountStore = [[ACAccountStore alloc]init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    NSDictionary *options = @{ACFacebookAppIdKey:FACEBOOK_APPID, ACFacebookPermissionsKey:@[@"user_about_me",@"basic_info"], ACFacebookAudienceKey:ACFacebookAudienceEveryone};
    
    [accountStore requestAccessToAccountsWithType:accountType options:options completion:^(BOOL granted, NSError *error){
        if(granted){
            NSArray *accounts = [accountStore accountsWithAccountType:accountType];
            self.facebookAccount = [accounts lastObject];
            
            [self requestProfile];
        }else{
            NSLog(@"승인 실패 : %@", error);
        }
    }];
}
- (void)requestProfile{
    NSString *serviceType = SLServiceTypeFacebook;
    SLRequestMethod method = SLRequestMethodGET;
    
    NSURL *url = [NSURL URLWithString:@"https://graph.facebook.com/me"];
    //[NSString stringWithFormat:@"https://graph.facebook.com/%@",@"me"]
    NSDictionary *param = @{@"fields":@"picture,name,about,gender,link,updated_time"};
    SLRequest *request = [SLRequest requestForServiceType:serviceType requestMethod:method URL:url parameters:param];
    request.account = self.facebookAccount;
    
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if(error != nil){
            NSLog(@"프로필 정보 얻기 실패 :%@", error);
            return;
        }
        
        __autoreleasing NSError *parseError = nil;
        NSDictionary *resualt = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&parseError];
        
        NSDictionary *picture = resualt[@"picture"][@"data"];
        NSString *imageUrlStr = picture[@"url"];
        
        NSURL *url = [NSURL URLWithString:imageUrlStr];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.nameLabel.text = resualt[@"name"];
            self.aboutView.text = resualt[@"about"];
            self.genderLabel.text = resualt[@"gender"];
            self.updateLabel.text = resualt[@"updated_time"];
            self.linkLabel.text = resualt[@"link"];
            self.profileImage.image = image;
        }];
    }];
    
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
