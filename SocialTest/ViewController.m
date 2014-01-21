//
//  ViewController.m
//  SocialTest
//
//  Created by SDT-1 on 2014. 1. 21..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "ViewController.h"
#import <Social/Social.h>
@interface ViewController ()

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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
