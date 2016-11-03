//
//  TCShippingAddressViewController.m
//  individual
//
//  Created by 穆康 on 2016/11/2.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCShippingAddressViewController.h"
#import "TCShippingAddressEditViewController.h"

#import "TCShippingAddressViewCell.h"

@interface TCShippingAddressViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation TCShippingAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"收货地址";
    
    [self setupSubviews];
}

- (void)setupSubviews {
    self.tableView.estimatedRowHeight = 115;
    UINib *nib = [UINib nibWithNibName:@"TCShippingAddressViewCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"TCShippingAddressViewCell"];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCShippingAddressViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCShippingAddressViewCell" forIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate

#pragma mark - actions

- (IBAction)handleClickAddNewShippingAddressButton:(UIButton *)sender {
    TCShippingAddressEditViewController *vc = [[TCShippingAddressEditViewController alloc] initWithNibName:@"TCShippingAddressEditViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:vc animated:YES];
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
