//
//  TCBioEditAvatarViewController.m
//  individual
//
//  Created by 穆康 on 2016/11/2.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCBioEditAvatarViewController.h"
#import "TCPhotoPicker.h"

@interface TCBioEditAvatarViewController () <TCPhotoPickerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

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
    TCLog(@"保存图片");
    
}

- (IBAction)handleClickCancelButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TCPhotoPickerDelegate

- (void)photoPicker:(TCPhotoPicker *)photoPicker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    TCLog(@"do something...");
    [photoPicker dismissPhotoPicker];
}

- (void)photoPickerDidCancel:(TCPhotoPicker *)photoPicker {
    TCLog(@"photoPickerDidCancel");
    [photoPicker dismissPhotoPicker];
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
