//
//  TCBioEditAvatarViewController.m
//  individual
//
//  Created by 穆康 on 2016/11/2.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCBioEditAvatarViewController.h"
#import "TCPhotoPicker.h"

#import "TCBuluoApi.h"
#import "TCImageURLSynthesizer.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface TCBioEditAvatarViewController () <TCPhotoPickerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic, getter=isAvatarChanged) BOOL avatarChanged;
@property (strong, nonatomic) UIImage *avatarImage;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *takePhotoButtonTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *albumButtonTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *saveButtonTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelButtonTopConstraint;

@property (strong, nonatomic) TCPhotoPicker *photoPicker;

@end

@implementation TCBioEditAvatarViewController {
    __weak TCBioEditAvatarViewController *weakSelf;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    weakSelf = self;
    
    [self setupSubviews];
    [self setupConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)setupSubviews {
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    NSString *avatar = [[TCBuluoApi api] currentUserSession].userInfo.picture;
    if (avatar) {
        NSURL *URL = [TCImageURLSynthesizer synthesizeImageURLWithPath:avatar];
        [self.imageView sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"profile_default_avatar_icon"] options:SDWebImageRetryFailed];
    } else {
        [self.imageView setImage:[UIImage imageNamed:@"profile_default_avatar_icon"]];
    }
    
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

#pragma mark - Actions

- (IBAction)handleClickTakePhotoButton:(UIButton *)sender {
    TCPhotoPicker *photoPicker = [[TCPhotoPicker alloc] initWithSourceController:self];
    photoPicker.delegate = self;
    [photoPicker showPhotoPikerWithSourceType:UIImagePickerControllerSourceTypeCamera];
    self.photoPicker = photoPicker;
}

- (IBAction)handleClickAlbumButton:(UIButton *)sender {
    TCPhotoPicker *photoPicker = [[TCPhotoPicker alloc] initWithSourceController:self];
    photoPicker.delegate = self;
    [photoPicker showPhotoPikerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    self.photoPicker = photoPicker;
}

- (IBAction)handleClickSaveButton:(UIButton *)sender {
    if (!self.isAvatarChanged || !self.avatarImage) {
        [self handleClickCancelButton:nil];
        return;
    }
    
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] uploadImage:self.avatarImage progress:nil result:^(BOOL success, TCUploadInfo *uploadInfo, NSError *error) {
        if (success) {
            [weakSelf changeUserAvatarWithName:uploadInfo.objectKey];
        } else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"保存失败，%@", reason]];
        }
    }];
}

- (void)changeUserAvatarWithName:(NSString *)name {
    NSString *imagePath = [TCImageURLSynthesizer synthesizeImagePathWithName:name source:kTCImageSourceOSS];
    [[TCBuluoApi api] changeUserAvatar:imagePath result:^(BOOL success, NSError *error) {
        if (success) {
            [MBProgressHUD hideHUD:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:TCBuluoApiNotificationUserInfoDidUpdate object:nil];
            [weakSelf handleClickCancelButton:nil];
        } else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"保存失败，%@", reason]];
        }
    }];
}

- (IBAction)handleClickCancelButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TCPhotoPickerDelegate

- (void)photoPicker:(TCPhotoPicker *)photoPicker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    if (info[UIImagePickerControllerEditedImage]) {
        self.avatarImage = info[UIImagePickerControllerEditedImage];
    } else {
        self.avatarImage = info[UIImagePickerControllerOriginalImage];
    }
    self.imageView.image = self.avatarImage;
    self.avatarChanged = YES;
    
    [photoPicker dismissPhotoPicker];
    self.photoPicker = nil;
}

- (void)photoPickerDidCancel:(TCPhotoPicker *)photoPicker {
    TCLog(@"photoPickerDidCancel");
    [photoPicker dismissPhotoPicker];
    self.photoPicker = nil;
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
