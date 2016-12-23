//
//  TCOpenDoorController.m
//  individual
//
//  Created by 王帅锋 on 16/12/20.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCOpenDoorController.h"
#import "Masonry.h"
#import "TCBuluoApi.h"
#import "LinphoneManager.h"
#import "TCLinphoneUtils.h"
#import "TCSipAPI.h"

@interface TCOpenDoorController ()

@property (nonatomic, strong) UIButton *openBtn;

@property (nonatomic, strong) CAShapeLayer *pulseLayer;

@property (nonatomic, strong) CAReplicatorLayer *replicatorLayer;

@property (nonatomic, strong) CABasicAnimation *opacityAnima;

@property (nonatomic, strong) CABasicAnimation *scaleAnima;

@property (nonatomic, strong) CAAnimationGroup *groupAnima;
@end

@implementation TCOpenDoorController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];

    [self setUpUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openSuccessed) name:@"opend" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(end) name:@"end" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fail) name:@"openFailed" object:nil];
    
}

- (void)fail {
    [_openBtn setTitle:@"开锁失败" forState:UIControlStateNormal];
    _openBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self close];
}

- (void)end {
    [self close];
    [_openBtn setImage:nil forState:UIControlStateNormal];
    [_openBtn setTitle:@"开锁" forState:UIControlStateNormal];
    _openBtn.titleLabel.font = [UIFont systemFontOfSize:21];
}

- (void)openSuccessed {
    [_openBtn setImage:[UIImage imageNamed:@"opened"] forState:UIControlStateNormal];
    [_openBtn setTitle:@"" forState:UIControlStateNormal];
    [self close];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self close];
}

- (void)setUpUI {
    
    UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"openDoorBg"]];
    [self.view addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
    }];
    
    UIButton *openBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [openBtn setBackgroundColor:[UIColor whiteColor]];
    [openBtn setTitle:@"开锁" forState:UIControlStateNormal];
    [openBtn setTitleColor:TCRGBColor(88, 191, 200) forState:UIControlStateNormal];
    openBtn.titleLabel.font = [UIFont systemFontOfSize:21];
    CGFloat scale = self.view.bounds.size.width/375.0;
    [self.view addSubview:openBtn];
    [openBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-115*scale);
        make.width.height.equalTo(@(94*scale));
    }];
    openBtn.layer.cornerRadius = 47.0*scale;
    openBtn.layer.borderWidth = 5.0;
    openBtn.layer.borderColor = [UIColor colorWithRed:124/255.0 green:211/255.0 blue:211/255.0 alpha:0.8].CGColor;
    _openBtn = openBtn;
    [openBtn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-20*scale);
        make.width.equalTo(@50);
        make.height.equalTo(@30);
    }];
    [backBtn setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
}


- (void)click {
    
    [_openBtn setTitle:@"开锁中" forState:UIControlStateNormal];
    
    if (_pulseLayer == nil) {
        CAShapeLayer *pulseLayer = [CAShapeLayer layer];
        pulseLayer.frame = _openBtn.layer.bounds;
        pulseLayer.path = [UIBezierPath bezierPathWithOvalInRect:pulseLayer.bounds].CGPath;
        pulseLayer.fillColor = [UIColor clearColor].CGColor;//填充色
        pulseLayer.strokeColor = [UIColor whiteColor].CGColor;
        pulseLayer.lineWidth = 0.5;
        pulseLayer.opacity = 0; // 层的透明度
        _pulseLayer = pulseLayer;
    }
    
    
    // 图层复制类
    if (_replicatorLayer == nil) {
        CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
        replicatorLayer.frame = _openBtn.layer.bounds;
        replicatorLayer.instanceCount = 8;//创建副本的数量,包括源对象。
        replicatorLayer.instanceDelay = 0.5;//复制副本之间的延迟
        [replicatorLayer addSublayer:_pulseLayer];
        [_openBtn.layer addSublayer:replicatorLayer];
        _replicatorLayer = replicatorLayer;
    }
    
    if (_opacityAnima == nil) {
        CABasicAnimation *opacityAnima = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnima.fromValue = @(0.5);
        opacityAnima.toValue = @(0.0);
        _opacityAnima = opacityAnima;
    }
    
    if (_scaleAnima == nil) {
        CABasicAnimation *scaleAnima = [CABasicAnimation animationWithKeyPath:@"transform"];
        scaleAnima.fromValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 0.0, 0.0, 0.0)];
        scaleAnima.toValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 5, 5, 0.0)];
        _scaleAnima = scaleAnima;
    }
    
    
    if (_groupAnima == nil) {
        CAAnimationGroup *groupAnima = [CAAnimationGroup animation];
        groupAnima.animations = @[_opacityAnima, _scaleAnima];
        groupAnima.duration = 4.0;
        groupAnima.autoreverses = NO;
        groupAnima.repeatCount = HUGE;
        _groupAnima = groupAnima;
    }
    
    [_pulseLayer addAnimation:_groupAnima forKey:@"groupAnimation"];
    
    [self openDoor];
}


- (void)close {
    
    [_pulseLayer removeAllAnimations];
    
    LinphoneCall *currentcall = linphone_core_get_current_call(LC);
    if (linphone_core_is_in_conference(LC) ||										   // In conference
        (linphone_core_get_conference_size(LC) > 0) // Only one conf
        ) {
        linphone_core_terminate_conference(LC);
    } else if (currentcall != NULL) { // In a call
        linphone_core_terminate_call(LC, currentcall);
    } else {
        const MSList *calls = linphone_core_get_calls(LC);
        if (bctbx_list_size(calls) == 1) { // Only one call
            linphone_core_terminate_call(LC, (LinphoneCall *)(calls->data));
        }
    }
}


- (void)openDoor {

    // Update on show
    LinphoneManager *mgr = LinphoneManager.instance;
    LinphoneCall *call = linphone_core_get_current_call(LC);
    LinphoneCallState state = (call != NULL) ? linphone_call_get_state(call) : 0;
    [[TCSipAPI api] callUpdate:call state:state];
    
    if (IPAD) {
        BOOL videoEnabled = linphone_core_video_display_enabled(LC);
        BOOL previewPref = [mgr lpConfigBoolForKey:@"preview_preference"];
        
        if (videoEnabled && previewPref) {
            
            if (!linphone_core_video_preview_enabled(LC)) {
                linphone_core_enable_video_preview(LC, TRUE);
            }
            
        } else {
            linphone_core_set_native_preview_window_id(LC, NULL);
            linphone_core_enable_video_preview(LC, FALSE);
            
        }
    } else {
        linphone_core_enable_video_preview(LC, FALSE);
    }
    [LinphoneManager.instance shouldPresentLinkPopup];
    
    
    LinphoneAddress *addr = [LinphoneUtils normalizeSipOrPhoneAddress:@"gate_01"];
    [LinphoneManager.instance call:addr];
    if (addr)
        linphone_address_destroy(addr);
    
    
    
    

//    [[TCBuluoApi api] openDoorWithResult:^(BOOL isSuccessed, NSError *err) {
//        if (isSuccessed) {
//            
//            [_openBtn setImage:[UIImage imageNamed:@"opened"] forState:UIControlStateNormal];
//            [_openBtn setTitle:@"" forState:UIControlStateNormal];
//        }else {
//            [_openBtn setTitle:@"开锁失败" forState:UIControlStateNormal];
//            _openBtn.titleLabel.font = [UIFont systemFontOfSize:18];
//
//        }
//        [_pulseLayer removeAllAnimations];
//    }];
}


- (void)dealloc {
    TCLog(@"TCOpenDoorController--dealloc");
}


- (void)back {
    
    [self close];
    
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.myBlock) {
            self.myBlock();
        }
    }];
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
