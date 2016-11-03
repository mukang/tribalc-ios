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

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *takePhotoButtonTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *albumButtonTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *saveButtonTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelButtonTopConstraint;

@end

@implementation TCBioEditAvatarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = YES;
    
    [self setupSubviews];
    [self setupConstraints];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)setupSubviews {
    UIImageView *avatarView = [[UIImageView alloc] init];
    [self.view addSubview:avatarView];
    
}

- (void)setupConstraints {
    self.imageViewHeightConstraint.constant = TCRealValue(463);
    self.buttonWidthConstraint.constant = TCRealValue(302);
    self.buttonHeightConstraint.constant = TCRealValue(31);
    self.takePhotoButtonTopConstraint.constant = TCRealValue(19);
    self.albumButtonTopConstraint.constant = TCRealValue(11.5);
    self.saveButtonTopConstraint.constant = TCRealValue(11.5);
    self.cancelButtonTopConstraint.constant = TCRealValue(28.5);
}

#pragma mark - actions

- (IBAction)handleClickTakePhotoButton:(UIButton *)sender {
    
}

- (IBAction)handleClickAlbumButton:(UIButton *)sender {
    
}

- (IBAction)handleClickSaveButton:(UIButton *)sender {
    TCLog(@"保存图片");
    
}

- (IBAction)handleClickCancelButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
