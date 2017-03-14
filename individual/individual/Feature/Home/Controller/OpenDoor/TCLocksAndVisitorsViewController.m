//
//  TCLocksAndVisitorsViewController.m
//  individual
//
//  Created by 王帅锋 on 17/3/9.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCLocksAndVisitorsViewController.h"
#import <Masonry.h>
#import "UIImage+Category.h"
#import "TCVisitorLocksCell.h"
#import "TCLockOrVisitorSectionHeader.h"
#import "TCBuluoApi.h"

#define kTCLocksCellID @"TCLocksCell"
#define kTCVisitorLockCellID @"TCVisitorLocksCell"
#define kTCVisitorLockSectionHeaderID @"TCLockOrVisitorSectionHeader"

@interface TCLocksAndVisitorsViewController ()<UITableViewDelegate,UITableViewDataSource,TCVisitorLocksCellDelegate>

@property (assign, nonatomic) TCLocksOrVisitors locksOrVisitors;

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) UIImageView *imageView;

@property (strong, nonatomic) UIButton *addBtn;

@property (strong, nonatomic) UIImageView *btnImageView;

@property (strong, nonatomic) UILabel *btnLabel;

@property (copy, nonatomic) NSArray *lockArr;

@end

@implementation TCLocksAndVisitorsViewController

- (instancetype)initWithType:(TCLocksOrVisitors)locksOrVisitors {
    if (self = [super init]) {
        _locksOrVisitors = locksOrVisitors;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpViews];
    [self setupNavBar];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)setupNavBar {
    self.hideOriginalNavBar = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    [navBar setShadowImage:[UIImage imageNamed:@"TransparentPixel"]];
    [self.view addSubview:navBar];
    
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"选择门锁"];
    navBar.titleTextAttributes = @{
                                        NSFontAttributeName : [UIFont systemFontOfSize:16],
                                        NSForegroundColorAttributeName : TCRGBColor(42, 42, 42)
                                        };
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back_item_black"]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(pop)];
    navItem.leftBarButtonItem = leftItem;
    [navBar setTintColor:TCRGBColor(42, 42, 42)];
    [navBar setBackgroundImage:[UIImage imageWithColor:TCARGBColor(42, 42, 42, 0.0)] forBarMetrics:UIBarMetricsDefault];
    [navBar setItems:@[navItem]];
}

- (void)pop {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)loadData {
    if (self.locksOrVisitors == TCLocks) {
        [[TCBuluoApi api] fetchMyLockListResult:^(NSArray *lockList, NSError *error) {
            if ([lockList isKindOfClass:[NSArray class]]) {
                self.lockArr = lockList;
                [self.tableView reloadData];
            }else {
                NSString *reason = error.localizedDescription ?: @"请稍后再试";
                [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"获取数据失败，%@", reason]];
            }
        }];
    }else {
        [[TCBuluoApi api] fetchMyLockKeysResult:^(NSArray *lockKeysList, NSError *error) {
            if ([lockKeysList isKindOfClass:[NSArray class]]) {
                self.lockArr = lockKeysList;
                [self.tableView reloadData];
            }else {
                NSString *reason = error.localizedDescription ?: @"请稍后再试";
                [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"获取数据失败，%@", reason]];
            }
        }];
    }
}

- (void)setUpViews {
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.addBtn];
    [self.addBtn addSubview:self.btnImageView];
    [self.addBtn addSubview:self.btnLabel];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-30);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@(TCRealValue(40)));
        make.height.equalTo(@(TCRealValue(60)));
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.bottom.equalTo(self.addBtn.mas_top).offset(-10);
        make.height.equalTo(@(TCRealValue(260)));
    }];
    
    [self.btnImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.addBtn);
        make.top.equalTo(self.addBtn).offset(10);
        make.width.height.equalTo(@(TCRealValue(30)));
    }];
    
    [self.btnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.addBtn);
        make.top.equalTo(self.btnImageView.mas_bottom).offset(5);
    }];
    
}

#pragma mark TCVisitorLocksCellDelegate 
- (void)deleteEquip:(UITableViewCell *)cell {
    if ([cell isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        TCLockWrapper *lockWrapper = self.lockArr[indexPath.section];
        
        NSArray *arr = lockWrapper.keys;
        
        if ([arr isKindOfClass:[NSArray class]]) {
            TCLockKey *lockKey = arr[indexPath.row];
            
            [[TCBuluoApi api] deleteLockKeyWithID:lockKey.equipId result:^(BOOL success, NSError *error) {
                if (success) {
                    
                    if (arr.count == 1) {
                        
                        NSMutableArray *mutabelA = [NSMutableArray arrayWithArray:self.lockArr];
                        [mutabelA removeObject:lockWrapper];
                        self.lockArr = mutabelA;
                        
                    }else {
                        NSMutableArray *mutableArr = [NSMutableArray arrayWithArray:lockWrapper.keys];
                        [mutableArr removeObjectAtIndex:indexPath.row];
                        lockWrapper.keys = mutableArr;
                    }
                    [self.tableView reloadData];
                }
            }];
        }
        
    }
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.locksOrVisitors == TCLocks) {
        return 1;
    }
    return self.lockArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.locksOrVisitors == TCLocks) {
        return self.lockArr.count;
    }
    
    TCLockWrapper *lockWrapper = self.lockArr[section];
    if ([lockWrapper.keys isKindOfClass:[NSArray class]]) {
        return lockWrapper.keys.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.locksOrVisitors == TCLocks) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTCLocksCellID];
        cell.imageView.image = [UIImage imageNamed:@"locks"];
        
        TCLockEquip *lockE = self.lockArr[indexPath.row];
        cell.textLabel.text = lockE.name;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else {
        
        TCVisitorLocksCell *cell = [tableView dequeueReusableCellWithIdentifier:kTCVisitorLockCellID];
        cell.imageView.image = [UIImage imageNamed:@"locks"];
        cell.delegate = self;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        TCLockWrapper *wrapper = self.lockArr[indexPath.section];
        if ([wrapper.keys isKindOfClass:[NSArray class]]) {
            TCLockKey *key = wrapper.keys[indexPath.row];
            cell.textLabel.text = key.equipName;
        }
        
        return cell;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    TCLockWrapper *wrapper = self.lockArr[section];
    
    TCLockOrVisitorSectionHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kTCVisitorLockSectionHeaderID];
    header.name = wrapper.name;
    return header;
}


- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        if (self.locksOrVisitors == TCLocks) {
            _imageView.image = [UIImage imageNamed:@"openDoorBg"];
        }else {
            _imageView.image = [UIImage imageNamed:@"visitor"];
        }
    }
    return _imageView;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.layer.cornerRadius = 5.0;
        _tableView.layer.borderColor = TCRGBColor(186, 186, 186).CGColor;
        CGFloat scale = TCScreenWidth > 375.0 ? 3 : 2;
        _tableView.layer.borderWidth = 1 / scale;
        _tableView.clipsToBounds = YES;
        _tableView.rowHeight = 40.0;
        if (self.locksOrVisitors == TCLocks) {
            _tableView.sectionHeaderHeight = 0.0;
        }else {
            _tableView.sectionHeaderHeight = 40.0;
        }
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kTCLocksCellID];
        [_tableView registerClass:[TCVisitorLocksCell class] forCellReuseIdentifier:kTCVisitorLockCellID];
        [_tableView registerClass:[TCLockOrVisitorSectionHeader class] forHeaderFooterViewReuseIdentifier:kTCVisitorLockSectionHeaderID];
    }
    return _tableView;
}

- (UIButton *)addBtn {
    if (_addBtn == nil) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addBtn addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
        if (self.locksOrVisitors == TCLocks) {
            _addBtn.hidden = YES;
        }else {
            _addBtn.hidden = NO;
        }
    }
    return _addBtn;
}

- (void)addClick {
    NSLog(@"---------");
}

- (UIImageView *)btnImageView {
    if (_btnImageView == nil) {
        _btnImageView = [[UIImageView alloc] init];
        _btnImageView.image = [UIImage imageNamed:@"addVisitor"];
    }
    return _btnImageView;
}

- (UILabel *)btnLabel {
    if (_btnLabel == nil) {
        _btnLabel = [[UILabel alloc] init];
        _btnLabel.font = [UIFont systemFontOfSize:12];
        _btnLabel.textColor = TCRGBColor(42, 42, 42);
        _btnLabel.textAlignment = NSTextAlignmentCenter;
        _btnLabel.text = @"添加";
    }
    return _btnLabel;
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
