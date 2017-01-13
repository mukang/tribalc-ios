//
//  TCCallVideoViewController.m
//  individual
//
//  Created by 王帅锋 on 17/1/10.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCCallVideoViewController.h"
#import <Masonry.h>
#import "LinphoneManager.h"
#import "TCLinphoneUtils.h"
#import "TCSipAPI.h"
#import "UIImage+Category.h"


@interface TCCallVideoViewController ()

@property (strong, nonatomic) UIView *videoView;

@end


@implementation TCCallVideoViewController

+ (instancetype)shareInstance {
    static TCCallVideoViewController *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[TCCallVideoViewController alloc] init];
    });
    return shareInstance;
}

- (void)handleClickBackButton:(UIBarButtonItem *)sender {
    [self refuse];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"开锁";
    
    UIImage *bgImage = [UIImage imageWithColor:TCARGBColor(255, 255, 255, 0.01)];
    [self.navigationController.navigationBar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
    
    // Do any additional setup after loading the view.
    _videoView = [[UIView alloc] init];
    [self.view addSubview:_videoView];
    
    @WeakObj(self)
    [_videoView mas_makeConstraints:^(MASConstraintMaker *make) {
        @StrongObj(self)
        make.top.left.right.height.equalTo(self.view);
    }];
    
    UIButton *refuseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [refuseBtn setTitle:@"挂断" forState:UIControlStateNormal];
    [refuseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:refuseBtn];
    [refuseBtn setImage:[UIImage imageNamed:@"openD"] forState:UIControlStateNormal];
    [refuseBtn addTarget:self action:@selector(refuse) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *openDoorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [openDoorBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [openDoorBtn setTitle:@"开锁" forState:UIControlStateNormal];
    [self.view addSubview:openDoorBtn];
    [openDoorBtn setImage:[UIImage imageNamed:@"hangUp"] forState:UIControlStateNormal];
    [openDoorBtn addTarget:self action:@selector(open) forControlEvents:UIControlEventTouchUpInside];
    
    [refuseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.bottom.equalTo(self.view).offset(-35);
        make.height.equalTo(@40);
        make.width.equalTo(@60);
    }];
    
    [openDoorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-20);
        make.bottom.width.height.equalTo(refuseBtn);
    }];
    
    
}

- (void)end {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)opend {
//    [self refuse];
    [self.navigationController popToRootViewControllerAnimated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[TCSipAPI api] close];
    });
}



- (void)refuse {
    [[TCSipAPI api] close];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
//    linphone_core_terminate_call(LC, linphone_core_get_current_call(LC));
}

- (void)open {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TCOPENDOOR" object:nil];
}

//- (void)onCurrentCallChange {
//    LinphoneCall *call = linphone_core_get_current_call(LC);
//    
//    const LinphoneAddress *addr = linphone_call_get_remote_address(call);
//    char *uri = linphone_address_as_string_uri_only(addr);
//    ms_free(uri);
//}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [self onCurrentCallChange];
    
    self.navigationController.navigationBar.translucent = YES;
    
    LinphoneManager.instance.nextCallIsTransfer = NO;
    
    linphone_core_set_native_video_window_id(LC, (__bridge void *)(_videoView));
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(opend) name:@"opend" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(end) name:@"end" object:nil];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    LinphoneCall *call = linphone_core_get_current_call(LC);
//    LinphoneCallState state = (call != NULL) ? linphone_call_get_state(call) : 0;
//    [self callUpdate:call state:state animated:FALSE];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
//    [self disableVideoDisplay:TRUE animated:NO];
    self.navigationController.navigationBar.translucent = NO;
    // Remove observer
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

//- (void)callUpdate:(LinphoneCall *)call state:(LinphoneCallState)state animated:(BOOL)animated {
////    [self updateBottomBar:call state:state]
//    
//    static LinphoneCall *currentCall = NULL;
//    if (!currentCall || linphone_core_get_current_call(LC) != currentCall) {
//        currentCall = linphone_core_get_current_call(LC);
//        [self onCurrentCallChange];
//    }
//    
//    // Fake call update
//    if (call == NULL) {
//        return;
//    }
//    
//    BOOL shouldDisableVideo =
//    (!currentCall || !linphone_call_params_video_enabled(linphone_call_get_current_params(currentCall)));
//    if (!shouldDisableVideo) {
//        [self displayVideoCall:animated];
//    } else {
//        [self displayAudioCall:animated];
//    }
// 
//    
//    if (state != LinphoneCallPausedByRemote) {
//    }
//    
//    switch (state) {
//        case LinphoneCallIncomingReceived:
//        case LinphoneCallOutgoingInit:
//        case LinphoneCallConnected:
//        case LinphoneCallStreamsRunning: {
//            // check video
//            if (!linphone_call_params_video_enabled(linphone_call_get_current_params(call))) {
//                const LinphoneCallParams *param = linphone_call_get_current_params(call);
//                const LinphoneCallAppData *callAppData =
//                (__bridge const LinphoneCallAppData *)(linphone_call_get_user_pointer(call));
//                if (state == LinphoneCallStreamsRunning && callAppData->videoRequested &&
//                    linphone_call_params_low_bandwidth_enabled(param)) {
//                    // too bad video was not enabled because low bandwidth
//                    UIAlertController *errView = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Low bandwidth", nil)
//                                                                                     message:NSLocalizedString(@"Video cannot be activated because of low bandwidth "
//                                                                                                               @"condition, only audio is available",
//                                                                                                               nil)
//                                                                              preferredStyle:UIAlertControllerStyleAlert];
//                    
//                    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Continue", nil)
//                                                                            style:UIAlertActionStyleDefault
//                                                                          handler:^(UIAlertAction * action) {}];
//                    
//                    [errView addAction:defaultAction];
//                    [self presentViewController:errView animated:YES completion:nil];
//                    callAppData->videoRequested = FALSE; /*reset field*/
//                }
//            }
//            break;
//        }
//        case LinphoneCallUpdatedByRemote: {
//            const LinphoneCallParams *current = linphone_call_get_current_params(call);
//            const LinphoneCallParams *remote = linphone_call_get_remote_params(call);
//            
//            /* remote wants to add video */
//            if (linphone_core_video_display_enabled(LC) && !linphone_call_params_video_enabled(current) &&
//                linphone_call_params_video_enabled(remote) &&
//                !linphone_core_get_video_policy(LC)->automatically_accept) {
//                linphone_core_defer_call_update(LC, call);
//                [self displayAskToEnableVideoCall:call];
//            } else if (linphone_call_params_video_enabled(current) && !linphone_call_params_video_enabled(remote)) {
//                [self displayAudioCall:animated];
//            }
//            break;
//        }
//        case LinphoneCallPausing:
//        case LinphoneCallPaused:
//            [self displayAudioCall:animated];
//            break;
//        case LinphoneCallPausedByRemote:
//            [self displayAudioCall:animated];
//            if (call == linphone_core_get_current_call(LC)) {
////                _pausedByRemoteView.hidden = NO;
//            }
//            break;
//        case LinphoneCallEnd:
//        case LinphoneCallError:
//        default:
//            break;
//    }
//}

- (void)displayAskToEnableVideoCall:(LinphoneCall *)call {
    if (linphone_core_get_video_policy(LC)->automatically_accept)
        return;
    
//    NSString *username = [FastAddressBook displayNameForAddress:linphone_call_get_remote_address(call)];
//    NSString *title = [NSString stringWithFormat:NSLocalizedString(@"%@ would like to enable video", nil), username];
//    UIConfirmationDialog *sheet = [UIConfirmationDialog ShowWithMessage:title
//                                                          cancelMessage:nil
//                                                         confirmMessage:NSLocalizedString(@"ACCEPT", nil)
//                                                          onCancelClick:^() {
//                                                              LOGI(@"User declined video proposal");
//                                                              if (call == linphone_core_get_current_call(LC)) {
//                                                                  LinphoneCallParams *params = linphone_core_create_call_params(LC,call);
//                                                                  linphone_core_accept_call_update(LC, call, params);
//                                                                  linphone_call_params_destroy(params);
//                                                                  [videoDismissTimer invalidate];
//                                                                  videoDismissTimer = nil;
//                                                              }
//                                                          }
//                                                    onConfirmationClick:^() {
//                                                        LOGI(@"User accept video proposal");
//                                                        if (call == linphone_core_get_current_call(LC)) {
//                                                            LinphoneCallParams *params = linphone_core_create_call_params(LC,call);
//                                                            linphone_call_params_enable_video(params, TRUE);
//                                                            linphone_core_accept_call_update(LC, call, params);
//                                                            linphone_call_params_destroy(params);
//                                                            [videoDismissTimer invalidate];
//                                                            videoDismissTimer = nil;
//                                                        }
//                                                    }
//                                                           inController:self];
//    videoDismissTimer = [NSTimer scheduledTimerWithTimeInterval:30
//                                                         target:self
//                                                       selector:@selector(dismissVideoActionSheet:)
//                                                       userInfo:sheet
//                                                        repeats:NO];
}


//- (void)disableVideoDisplay:(BOOL)disabled animated:(BOOL)animation {
//
//    
//    if (!disabled) {
//#ifdef TEST_VIDEO_VIEW_CHANGE
//        [NSTimer scheduledTimerWithTimeInterval:5.0
//                                         target:self
//                                       selector:@selector(_debugChangeVideoView)
//                                       userInfo:nil
//                                        repeats:YES];
//#endif
//        // [self batteryLevelChanged:nil];
//
//        
//        LinphoneCall *call = linphone_core_get_current_call(LC);
//        // linphone_call_params_get_used_video_codec return 0 if no video stream enabled
//        if (call != NULL && linphone_call_params_get_used_video_codec(linphone_call_get_current_params(call))) {
//            linphone_call_set_next_video_frame_decoded_callback(call, hideSpinner, (__bridge void *)(self));
//        }
//    }
//}

//static void hideSpinner(LinphoneCall *call, void *user_data) {
//
//}
//
//- (void)displayVideoCall:(BOOL)animated {
//    [self disableVideoDisplay:FALSE animated:animated];
//}
//
//- (void)displayAudioCall:(BOOL)animated {
//    [self disableVideoDisplay:TRUE animated:animated];
//}

- (void)dealloc {
    _videoView = nil;
    TCLog(@"TCCallVideoViewController -- dealloc");
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
