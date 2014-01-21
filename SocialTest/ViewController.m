//
//  ViewController.m
//  SocialTest
//
//  Created by SDT-1 on 2014. 1. 21..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "ViewController.h"
#import <Social/Social.h>
#import <FacebookSDK/FacebookSDK.h>

@interface ViewController () <FBLoginViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *friendListBtn;
@property (weak, nonatomic) IBOutlet UIButton *newsFeedBtn;
@property (weak, nonatomic) IBOutlet UIButton *profileBtn;
@property (weak, nonatomic) IBOutlet UIButton *uploadBtn;
@property (weak, nonatomic) IBOutlet UIButton *airdropBtn;

@end

@implementation ViewController

- (IBAction)showSocialComposer:(id)sender {
    NSString *service = SLServiceTypeFacebook;
    //    BOOL isService = [SLComposeViewController isAvailableForServiceType:service];
    //    if(isService == YES){
    SLComposeViewController *composer = [SLComposeViewController composeViewControllerForServiceType:service];
    
    UIImage *image = [UIImage imageNamed:@"image.png"];
    [composer addImage:image];
    
    [composer setInitialText:@"소셜 프레임워크를 이용한 글쓰기 테스트 아이폰짱짱재밋닼ㅋㅋㅋㅋㅋ"];
    
    composer.completionHandler = ^(SLComposeViewControllerResult result){
        if(result == SLComposeViewControllerResultDone)
            NSLog(@"글 작성 완료");
        else
            NSLog(@"글 작성 취소");
    };
    
    [self presentViewController:composer animated:YES completion:nil];
    //    }
}
- (IBAction)showActivity:(id)sender{
    UIImage *image = [UIImage imageNamed:@"image.png"];
    NSArray *items = @[@"액티비티 뷰 컨트롤러 테스팅!", image];
    
    UIActivityViewController *vc = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    vc.completionHandler = ^(NSString *activityType, BOOL completed){
        NSLog(@"%@의 동작을 마쳤습니다.", activityType);
    };
    
    [self presentViewController:vc animated:YES completion:nil];
}

// This method will be called when the user information has been fetched
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    //self.profilePictureView.profileID = user.id;
    //self.nameLabel.text = user.name;
}

// Implement the loginViewShowingLoggedInUser: delegate method to modify your app's UI for a logged-in user experience
- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    self.friendListBtn.enabled = YES;
    self.newsFeedBtn.enabled = YES;
    self.profileBtn.enabled = YES;
    self.uploadBtn.enabled = YES;
    //self.statusLabel.text = @"You're logged in as";
}

// Implement the loginViewShowingLoggedOutUser: delegate method to modify your app's UI for a logged-out user experience
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    self.friendListBtn.enabled = NO;
    self.newsFeedBtn.enabled = NO;
    self.profileBtn.enabled = NO;
    self.uploadBtn.enabled = NO;
    //self.profilePictureView.profileID = nil;
    //self.nameLabel.text = @"";
    //self.statusLabel.text= @"You're not logged in!";
}

// You need to override loginView:handleError in order to handle possible errors that can occur during login
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    
    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures since that happen outside of the app.
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    FBLoginView *loginView = [[FBLoginView alloc] initWithReadPermissions:@[@"basic_info", @"email", @"user_likes",@"user_about_me"]];
    
    // Set this loginUIViewController to be the loginView button's delegate
    loginView.delegate = self;
    
    // Align the button in the center horizontally
    loginView.frame = CGRectMake(0, 20, 320, 100);
    
    // Add the button to the view
    [self.view addSubview:loginView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
