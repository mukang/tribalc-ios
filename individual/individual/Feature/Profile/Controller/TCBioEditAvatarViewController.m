//
//  TCBioEditAvatarViewController.m
//  individual
//
//  Created by 穆康 on 2016/11/2.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCBioEditAvatarViewController.h"

@interface TCBioEditAvatarViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeighConstraint;

@end

@implementation TCBioEditAvatarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupSubviews];
}

- (void)setupSubviews {
    UIImageView *avatarView = [[UIImageView alloc] init];
    [self.view addSubview:avatarView];
    
}

- (void)setupConstraints {
    
}

#pragma mark - actions

- (IBAction)handleClickTakePhotoButton:(UIButton *)sender {
}

- (IBAction)handleClickAlbumButton:(UIButton *)sender {
}

- (IBAction)handleClickSaveButton:(UIButton *)sender {
}

- (IBAction)handleClickCancelButton:(UIButton *)sender {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
