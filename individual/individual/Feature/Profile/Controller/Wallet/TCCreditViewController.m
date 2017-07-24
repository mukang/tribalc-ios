//
//  TCCreditViewController.m
//  individual
//
//  Created by 王帅锋 on 2017/7/21.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCCreditViewController.h"

@interface TCCreditViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) UIImageView *headerView;

@property (strong, nonatomic) UIBezierPath *trackPath;

@property (strong, nonatomic) UIBezierPath *progressPath;

@property (strong, nonatomic) CAShapeLayer *trackLayer;

@property (strong, nonatomic) CAShapeLayer *progressLayer;

@property (strong, nonatomic) CAGradientLayer *gradientLayer;

@end

@implementation TCCreditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpViews];
    [self setUpNav];
    [self createBezierPath:CGRectMake(0, -200, 150, 150)];
    
    
    
//    [self.view.layer addSublayer:self.gradientLayer];
//    
//    
//    
//    // 延时3秒执行，实现分割点动画（隐式动画）
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//        // 颜色分割点效果
//        
//        self.gradientLayer.locations = @[@(0.4), @(0.5), @(0.6)];
//        
//    });

}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else {
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.section == 0) {
        cell.textLabel.text = @"本期账单";
        cell.imageView.image = [UIImage imageNamed:@"currentBill"];
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"授信额度";
            cell.imageView.image = [UIImage imageNamed:@"creditLimit"];
        }else if (indexPath.row == 1) {
            cell.textLabel.text = @"账单日";
            cell.imageView.image = [UIImage imageNamed:@"billDay"];
        }else {
            cell.textLabel.text = @"还款日";
            cell.imageView.image = [UIImage imageNamed:@"repaymentDay"];
        }
    }
    
    return cell;
}

#pragma mark UITableViewDelegate

- (void)setUpViews {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)log {
    
}

- (void)setUpNav {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"历史账单" forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 60, 30);
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn addTarget:self action:@selector(log) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:TCBlackColor forState:UIControlStateNormal];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightBtn;
}



#pragma mark - Getter methods



- (CAGradientLayer *)gradientLayer {
    
    if (!_gradientLayer) {
        
        // 初始化并创建
        
        _gradientLayer             = [CAGradientLayer layer];
        
        _gradientLayer.frame       = CGRectMake(0, 0, 250, 250);
        
        _gradientLayer.position    = self.view.center;
        
        _gradientLayer.borderWidth = 1.f;
        
        
        // 设置颜色
        
        _gradientLayer.colors = @[(__bridge id)[UIColor redColor].CGColor,
                                  
                                  (__bridge id)[UIColor greenColor].CGColor,
                                  
                                  (__bridge id)[UIColor blueColor].CGColor];
        
        
        
        // 设置颜色渐变方向
        
        _gradientLayer.startPoint = CGPointMake(0, 0);
        
        _gradientLayer.endPoint   = CGPointMake(1, 0);
        
        
        
        // 设置颜色分割点
        
        _gradientLayer.locations  = @[@(0.25), @(0.5), @(0.75)];
        
    }
    
    return _gradientLayer;
    
}

//画两个圆形
-(void)createBezierPath:(CGRect)mybound
{
    //外圆
    _trackPath = [UIBezierPath bezierPathWithArcCenter:self.view.center radius:(mybound.size.width - 0.7)/ 2 startAngle:0 endAngle:M_PI * 2 clockwise:YES];;
    
    _trackLayer = [CAShapeLayer new];
    [self.tableView.tableHeaderView.layer addSublayer:_trackLayer];
    _trackLayer.fillColor = nil;
    _trackLayer.strokeColor=[UIColor grayColor].CGColor;
    _trackLayer.path = _trackPath.CGPath;
    _trackLayer.lineWidth=5;
    _trackLayer.frame = mybound;
    
    //内圆
    _progressPath = [UIBezierPath bezierPathWithArcCenter:self.view.center radius:(mybound.size.width - 0.7)/ 2 startAngle:- M_PI_2 endAngle:(M_PI * 2) * 0.7 - M_PI_2 clockwise:YES];
    
    _progressLayer = [CAShapeLayer new];
    [self.tableView.tableHeaderView.layer addSublayer:_progressLayer];
    _progressLayer.fillColor = nil;
    _progressLayer.strokeColor=[UIColor redColor].CGColor;
    _progressLayer.lineCap = kCALineCapRound;
    _progressLayer.path = _progressPath.CGPath;
    _progressLayer.lineWidth=10;
    _progressLayer.frame = mybound;
    
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.tableHeaderView = self.headerView;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionHeaderHeight = 8;
        _tableView.sectionFooterHeight = CGFLOAT_MIN;
        _tableView.rowHeight = 45;
        self.headerView.frame = CGRectMake(0, 0, TCScreenWidth, 200);
    }
    return _tableView;
}

- (UIImageView *)headerView {
    if (_headerView == nil) {
        _headerView = [[UIImageView alloc] init];
        _headerView.image = [UIImage imageNamed:@"creditHeader"];
    }
    return _headerView;
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
