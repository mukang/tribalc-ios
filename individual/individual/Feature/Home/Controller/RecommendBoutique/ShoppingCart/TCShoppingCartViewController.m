//
//  TCShoppingCartViewController.m
//  individual
//
//  Created by WYH on 16/11/5.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCShoppingCartViewController.h"

@interface TCShoppingCartViewController () {
    NSMutableArray *cartInfoArray;
    UITableView *cartTableView;
    UIButton *navRightBtn;
    UIView *bottomView;
    UILabel *totalPriceLab;
    
}

@end

@implementation TCShoppingCartViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"购物车";
    // Do any additional setup after loading the view.
    
    [self forgeShoppingCartInfoData];
    
    
    [self initialNavigationBar];
    [self initialTableView];
    [self initBottomView];
    
}


- (void)initialNavigationBar {
    self.navigationItem.titleView = [TCGetNavigationItem getTitleItemWithText:@"购物车"];
    
    UIButton *backBtn = [TCGetNavigationItem getBarButtonWithFrame:CGRectMake(0, 10, 0, 17) AndImageName:@"back"];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [backBtn addTarget:self action:@selector(touchBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = backItem;
    
    UIBarButtonItem *editItem = [self getRightBarButtonItem:@"编辑" AndAction:@selector(touchEditBar:)];
    self.navigationItem.rightBarButtonItem = editItem;
}

- (UIBarButtonItem *)getRightBarButtonItem:(NSString *)text AndAction:(SEL)action {
    UIButton *editBtn = [TCGetNavigationItem getBarButtonWithFrame:CGRectMake(0, 0, 40, 30) AndImageName:@""];
    [editBtn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [editBtn setTitle:text forState:UIControlStateNormal];
    editBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    editBtn.titleLabel.textColor = [UIColor whiteColor];
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
    return editItem;
}


- (UIView *)getBottomViewWithText:(NSString *)text AndAction:(SEL)action{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - 64 - 48, self.view.width, 49)];
    UIView *topLineView = [TCComponent createGrayLineWithFrame:CGRectMake(0, 0, self.view.width, 0.5)];
    [view addSubview:topLineView];
    
    UIButton *selectBtn = [TCComponent createImageBtnWithFrame:CGRectMake(20, view.height / 2 - 8, 16, 16) AndImageName:@"car_unselected"];
    [selectBtn addTarget:self action:@selector(touchSelectAllBtn:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:selectBtn];
    
    UILabel *selectAllLab = [TCComponent createLabelWithFrame:CGRectMake(selectBtn.x + selectBtn.width + 20, 0, 30, view.height) AndFontSize:14 AndTitle:@"全选"];
    [view addSubview:selectAllLab];
    
    UIButton *titleBtn = [TCComponent createButtonWithFrame:CGRectMake(self.view.width - 111, 0, 111, view.height) AndTitle:text AndFontSize:14 AndBackColor:[UIColor colorWithRed:81/255.0 green:199/255.0 blue:209/255.0 alpha:1] AndTextColor:[UIColor whiteColor]];
    [view addSubview:titleBtn];
    [titleBtn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return view;
}

- (UIView *)getStoreViewWithFrame:(CGRect)frame AndSection:(NSInteger)section{
    UIView *storeInfoView = [[UIView alloc] initWithFrame:frame];
    NSDictionary *storeInfo = cartInfoArray[section];
    storeInfoView.backgroundColor = [UIColor whiteColor];
    UIButton *selectedBtn = [TCComponent createImageBtnWithFrame:CGRectMake(20, storeInfoView.height / 2 - 8, 16, 16) AndImageName:@"car_unselected"];
    
    [selectedBtn addTarget:self action:@selector(touchSelectStoreBtn:) forControlEvents:UIControlEventTouchUpInside];
    [storeInfoView addSubview:selectedBtn];
    
    UILabel *storeTitleLab = [TCComponent createLabelWithFrame:CGRectMake(selectedBtn.x + selectedBtn.width + 20, 0, self.view.width - selectedBtn.x - selectedBtn.width - 20, storeInfoView.height) AndFontSize:12 AndTitle:storeInfo[@"store"] AndTextColor:[UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1]];
    [storeInfoView addSubview:storeTitleLab];
    
    return storeInfoView;
}

- (void)changeAllSelected {
    for (int i = 0; i < cartInfoArray.count; i++) {
        NSArray *contentArr = cartInfoArray[i][@"content"];
        for (int j = 0; j < contentArr.count; j++) {
            NSNumber *isSelected = contentArr[i][@"select"];
            if ([isSelected isEqual:[NSNumber numberWithBool:YES]]) {
                contentArr[i][@"select"] = [NSNumber numberWithBool:NO];
            } else {
                contentArr[i][@"select"] = [NSNumber numberWithBool:YES];
            }
        }
    }
}


- (void)initBottomView {
    bottomView = [self getBottomViewWithText:@"结算" AndAction:@selector(touchPayButton)];
    UILabel *totalLab = [TCComponent createLabelWithFrame:CGRectMake(99, bottomView.height / 2 - 14 / 2 - 2, 45, 16) AndFontSize:16 AndTitle:@"合计 :"];
    totalPriceLab = [TCComponent createLabelWithFrame:CGRectMake(totalLab.x + totalLab.width, 0, self.view.width - 111 - totalLab.x - totalLab.width, bottomView.height) AndFontSize:14 AndTitle:@"￥0" AndTextColor:[UIColor redColor]];
    [bottomView addSubview:totalLab];
    [bottomView addSubview:totalPriceLab];
    [self.view addSubview:bottomView];
}

- (void)initialTableView {
    cartTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 98 / 2 - 64) style:UITableViewStyleGrouped];
    cartTableView.backgroundColor  =[UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    cartTableView.delegate = self;
    cartTableView.dataSource = self;
    cartTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cartTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self.view addSubview:cartTableView];
}


# pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return cartInfoArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *contentArr = cartInfoArray[section][@"content"];
    return contentArr.count;
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *identifier = [NSString stringWithFormat:@"%li", (long)section];
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (!headerView) {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:identifier];
        headerView.frame = CGRectMake(0, 0, self.view.width, 39);
        UIView *storeView = [self getStoreViewWithFrame:CGRectMake(0, 8, self.view.width, 39 - 8) AndSection:section];
        [headerView addSubview:storeView];
    }
    
    return headerView;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier = [NSString stringWithFormat:@"%li%li", (long)indexPath.section, (long)indexPath.row];
    TCShoppingCartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TCShoppingCartTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSArray *contentArr = cartInfoArray[indexPath.section][@"content"];
    NSDictionary *contentDic = contentArr[indexPath.row];
    if ([contentDic[@"select"] isEqual:[NSNumber numberWithBool:YES]]) {
        [cell.selectedBtn setImage: [UIImage imageNamed:@"car_selected"] forState:UIControlStateNormal];
    } else {
        [cell.selectedBtn setImage: [UIImage imageNamed:@"car_unselected"] forState:UIControlStateNormal];
    }
    [cell setCount:3];
    
    [cell.selectedBtn addTarget:self action:@selector(touchSelectGoodBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self initTableViewCell:cell AndContent:contentDic];
    
    return cell;
}


- (void)initTableViewCell:(TCShoppingCartTableViewCell *)cell AndContent:(NSDictionary *)contentDic {
    cell.titleLab.text = contentDic[@"title"];
    cell.leftImgView.image = [UIImage imageNamed:@"home_image_place"];
    [cell setStandard:contentDic[@"standard"]];
    [cell setPrice:309.2];

}





# pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 139;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 39;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



# pragma mark - click

- (void)touchBackBtn:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchPayButton {
    NSLog(@"点击结算按钮");
}

- (void)touchSelectGoodBtn:(UIButton *)button {
    NSLog(@"点击选择商品");
}

- (void)touchSelectStoreBtn:(UIButton *)button {
    NSLog(@"点击选择商店按钮");
}

- (void)touchSelectAllBtn:(UIButton *)button {
//    [self changeAllSelected];
    
    [cartTableView reloadData];
}

- (void)touchEditBar:(UIButton *)btn {

}

- (void)touchAddBtn:(UIButton *)btn {
    NSLog(@"点击增加");
}

- (void)touchSubBtn:(UIButton *)btn {
    NSLog(@"点击减少");
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


- (void)viewWillDisappear:(BOOL)animated {
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:42/255.0 green:42/255.0 blue:42/255.0 alpha:1];
    UIImageView *barImageView = self.navigationController.navigationBar.subviews.firstObject;
    barImageView.backgroundColor =[UIColor colorWithRed:42/255.0 green:42/255.0 blue:42/255.0 alpha:1];
    barImageView.alpha = 1;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)forgeShoppingCartInfoData {
    NSDictionary *info1 = @{
                            @"store":@"Zara官方旗舰店",
                            @"content":@[
                                          @{
                                              @"title":@"飞行员夹克",
                                              @"select":@NO,
                                              @"price":@309,
                                              @"count":@3,
                                              @"standard":@{
                                                      @"primary":@{
                                                              @"label":@"颜色",
                                                              @"types":@"浅蓝"
                                                              },
                                                      @"secondary":@{
                                                              @"label":@"尺寸",
                                                              @"types":@"M"
                                                              }
                                               }
                                            },
                                          @{
                                              @"title":@"印花连衣裙dwadwadwa",
                                              @"price":@309,
                                              @"select":@NO,
                                              @"count":@1,
                                              @"standard":@{
                                                      @"primary":@{
                                                              @"label":@"颜色",
                                                              @"types":@"橘红"
                                                              },
                                                      @"secondary":@{
                                                              @"label":@"尺寸",
                                                              @"types":@"XXXL"
                                                              }
                                                      }
                                              }
                                        ]
                            };
    NSDictionary *info2 = @{
                            @"store":@"百丽官方旗舰店",
                            @"content":@[
                                    @{
                                        @"title":@"女装 户外长袖衬衫",
                                        @"price":@309,
                                        @"count":@3,
                                        @"select":@NO,
                                        @"standard":@{
                                                @"primary":@{
                                                        @"label":@"颜色",
                                                        @"types":@"玫红"
                                                        },
                                                @"secondary":@{
                                                        @"label":@"尺寸",
                                                        @"types":@"XL"
                                                        }
                                                }
                                        }
                                    ]
                            };
    
    NSDictionary *info3 = @{
                            @"store":@"Zara官方旗舰店",
                            @"content":@[
                                    @{
                                        @"title":@"飞行员夹克",
                                        @"price":@309,
                                        @"count":@3,
                                        @"select":@NO,
                                        @"standard":@{
                                                @"primary":@{
                                                        @"label":@"颜色",
                                                        @"types":@"绿色"
                                                        },
                                                @"secondary":@{
                                                        @"label":@"尺寸",
                                                        @"types":@"XXXL"
                                                        }
                                                }
                                        },
                                    @{
                                        @"title":@"印花连衣裙dwadwadwa",
                                        @"price":@309,
                                        @"count":@1,
                                        @"select":@NO,
                                        @"standard":@{
                                                @"primary":@{
                                                        @"label":@"颜色",
                                                        @"types":@"橘红"
                                                        },
                                                @"secondary":@{
                                                        @"label":@"尺寸",
                                                        @"types":@"XXXL"
                                                        }
                                                }
                                        }
                                    ]
                            };


    
    NSMutableDictionary *dic1 = [[NSMutableDictionary alloc] initWithDictionary:info1];
    NSMutableDictionary *dic2 = [[NSMutableDictionary alloc] initWithDictionary:info2];
    NSMutableDictionary *dic3 = [[NSMutableDictionary alloc] initWithDictionary:info3];
    NSMutableDictionary *dic4 = [[NSMutableDictionary alloc] initWithDictionary:info1];

    cartInfoArray = [[NSMutableArray alloc] initWithObjects:dic1, dic2, dic3, dic4, nil];
    
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
