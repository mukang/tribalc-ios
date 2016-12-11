//
//  TCShoppingCartViewController.m
//  individual
//
//  Created by WYH on 16/11/5.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCShoppingCartViewController.h"
#import "TCBuluoApi.h"
#import "TCImageURLSynthesizer.h"
#import "TCShoppingCartWrapper.h"
#import "TCPlaceOrderViewController.h"
#import "TCSelectStandardView.h"


@interface TCShoppingCartViewController () {
    UITableView *cartTableView;
    UIButton *navRightBtn;
    UIView *bottomView;
    UILabel *totalPriceLab;
    TCShoppingCartWrapper *shoppingCartWrapper;
    UIButton *selectAllBtn;
    
    BOOL isEdit;
    
}

@end

@implementation TCShoppingCartViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    isEdit = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"购物车";
    // Do any additional setup after loading the view.
    

    
    [self initShoppingCartData];
    [self initialNavigationBar];
    
    
}


- (void)initShoppingCartData {
    [[TCBuluoApi api] fetchShoppingCartWrapperWithSortSkip:nil result:^(TCShoppingCartWrapper *wrapper, NSError *error) {
        shoppingCartWrapper = wrapper;
        [self initialTableView];
        [self setupBottomViewWithFrame:CGRectMake(0, self.view.height - 48, self.view.width, 49)];
        [self setupNavigationRightBarButton];
    }];
}

- (void)initialTableView {
    cartTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 98 / 2) style:UITableViewStyleGrouped];
    cartTableView.backgroundColor  =[UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    cartTableView.delegate = self;
    cartTableView.dataSource = self;
    cartTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cartTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self.view addSubview:cartTableView];
}


- (void)initialNavigationBar {
    self.navigationItem.titleView = [TCGetNavigationItem getTitleItemWithText:@"购物车"];
    
    UIButton *backBtn = [TCGetNavigationItem getBarButtonWithFrame:CGRectMake(0, 10, 0, 17) AndImageName:@"back"];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [backBtn addTarget:self action:@selector(touchBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = backItem;
    
}


- (void)setupNavigationRightBarButton {
    UIButton *editBtn = [TCGetNavigationItem getBarButtonWithFrame:CGRectMake(0, 0, 40, 30) AndImageName:@""];
    [editBtn addTarget:self action:@selector(touchEditBar:) forControlEvents:UIControlEventTouchUpInside];
    if (isEdit) {
        [editBtn setTitle:@"完成" forState:UIControlStateNormal];
    } else {
        [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    }
    editBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    editBtn.titleLabel.textColor = [UIColor whiteColor];
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];

    self.navigationItem.rightBarButtonItem = editItem;
}

- (UIView *)getBottomViewWithText:(NSString *)text AndAction:(SEL)action AndFrame:(CGRect)frame{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    UIView *topLineView = [TCComponent createGrayLineWithFrame:CGRectMake(0, 0, self.view.width, 0.5)];
    [view addSubview:topLineView];
    
    selectAllBtn = [TCComponent createImageBtnWithFrame:CGRectMake(20, view.height / 2 - 8, 16, 16) AndImageName:@"car_unselected"];
    [selectAllBtn addTarget:self action:@selector(touchSelectAllBtn:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:selectAllBtn];
    
    UILabel *selectAllLab = [TCComponent createLabelWithFrame:CGRectMake(selectAllBtn.x + selectAllBtn.width + 20, 0, 30, view.height) AndFontSize:14 AndTitle:@"全选"];
    [view addSubview:selectAllLab];
    
    UIButton *titleBtn = [TCComponent createButtonWithFrame:CGRectMake(self.view.width - 111, 0, 111, view.height) AndTitle:text AndFontSize:14 AndBackColor:[UIColor colorWithRed:81/255.0 green:199/255.0 blue:209/255.0 alpha:1] AndTextColor:[UIColor whiteColor]];
    [view addSubview:titleBtn];
    [titleBtn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return view;
}

- (UIView *)getStoreViewWithFrame:(CGRect)frame AndSection:(NSInteger)section{
    UIView *storeInfoView = [[UIView alloc] initWithFrame:frame];
    TCListShoppingCart *listShoppingCart = shoppingCartWrapper.content[section];
    TCMarkStore *storeInfo = listShoppingCart.store;
    storeInfoView.backgroundColor = [UIColor whiteColor];
    UIButton *selectedBtn = [TCComponent createImageBtnWithFrame:CGRectMake(20, storeInfoView.height / 2 - 8, 16, 16) AndImageName:@""];
    [selectedBtn setImage:[self getSelectImageWithGoodsList:listShoppingCart.goodsList] forState:UIControlStateNormal];
    selectedBtn.tag = section;
    [selectedBtn addTarget:self action:@selector(touchSelectStoreBtn:) forControlEvents:UIControlEventTouchUpInside];
    [storeInfoView addSubview:selectedBtn];
    
    UILabel *storeTitleLab = [TCComponent createLabelWithFrame:CGRectMake(selectedBtn.x + selectedBtn.width + 20, 0, self.view.width - selectedBtn.x - selectedBtn.width - 20, storeInfoView.height) AndFontSize:12 AndTitle:storeInfo.name AndTextColor:[UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1]];
    [storeInfoView addSubview:storeTitleLab];
    
    return storeInfoView;
}

- (void)setuptotalPriceLab {
    float price = 0;
    
    NSArray *contentArr = shoppingCartWrapper.content;
    for (int i = 0; i < contentArr.count; i++) {
        TCListShoppingCart *shoppingCart = contentArr[i];
        NSArray *goodList = shoppingCart.goodsList;
        for (int j = 0; j < goodList.count; j++) {
            TCOrderItem *orderItem = goodList[j];
            if (orderItem.select) {
                TCGoods *good = orderItem.goods;
                price += good.salePrice;
            }
        }
    }
    totalPriceLab.text = [NSString stringWithFormat:@"￥%@", @([NSString stringWithFormat:@"%f", price].floatValue)];

}

- (void)setupOrderItemSelected:(BOOL)select {
    NSArray *contentArr = shoppingCartWrapper.content;
    for (int i = 0; i < contentArr.count; i++) {
        TCListShoppingCart *shoppingCart = contentArr[i];
        NSArray *goodList = shoppingCart.goodsList;
        for (int j = 0; j < goodList.count; j++) {
            TCOrderItem *orderItem = goodList[j];
            orderItem.select = select;
        }
    }
}

- (void)setupOrderItemSelected:(BOOL)select Section:(NSInteger)section {
    NSArray *contentArr = shoppingCartWrapper.content;
    TCListShoppingCart *shoppingCart = contentArr[section];
    NSArray *goodList = shoppingCart.goodsList;
    for (int i = 0; i < goodList.count; i++) {
        TCOrderItem *orderItem = goodList[i];
        orderItem.select = select;
    }
}

- (void)setupBottomViewWithFrame:(CGRect)frame {
    [bottomView removeFromSuperview];
    bottomView = [self getBottomViewWithText:@"结算" AndAction:@selector(touchPayButton) AndFrame:frame];
    UILabel *totalLab = [TCComponent createLabelWithFrame:CGRectMake(99, bottomView.height / 2 - 14 / 2 - 2, 45, 16) AndFontSize:16 AndTitle:@"合计 :"];
    totalPriceLab = [TCComponent createLabelWithFrame:CGRectMake(totalLab.x + totalLab.width, 0, self.view.width - 111 - totalLab.x - totalLab.width, bottomView.height) AndFontSize:14 AndTitle:@"￥0" AndTextColor:[UIColor redColor]];
    [bottomView addSubview:totalLab];
    [bottomView addSubview:totalPriceLab];
    [self.view addSubview:bottomView];
}

- (void)setupEditBottomViewWithFrame:(CGRect)frame  {
    [bottomView removeFromSuperview];
    bottomView = [self getBottomViewWithText:@"删除" AndAction:@selector(touchDeleteButton) AndFrame:frame];
    
    [self.view addSubview:bottomView];
}




- (UIImage *)getSelectImageWithGoodsList:(NSArray *)goodsList {
    for (int i = 0; i < goodsList.count; i++) {
        TCOrderItem *orderItem = goodsList[i];
        if (!orderItem.select) {
            return [UIImage imageNamed:@"car_unselected"];
        }
    }
    
    return [UIImage imageNamed:@"car_selected"];
}

- (UIImage *)getSelectImageWithOrderItem:(TCOrderItem *)orderItem {
    if (orderItem.select) {
        return [UIImage imageNamed:@"car_selected"];
    } else {
        return [UIImage imageNamed:@"car_unselected"];
    }
    
}


# pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSArray *contentArr = shoppingCartWrapper.content;
    return contentArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *contentArr = shoppingCartWrapper.content;
    TCListShoppingCart *listShoppingCart = contentArr[section];
    NSArray *goodsList = listShoppingCart.goodsList;
    return goodsList.count;
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *identifier = [NSString stringWithFormat:@"%li", (long)section];
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (!headerView) {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:identifier];
        headerView.frame = CGRectMake(0, 0, self.view.width, 39);
    }
    UIView *storeView = [self getStoreViewWithFrame:CGRectMake(0, 8, self.view.width, 39 - 8) AndSection:section];
    [headerView addSubview:storeView];
    
    return headerView;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TCShoppingCartTableViewCell *cell;
    if (isEdit) {
        cell = [self getEditTableViewCellWithIndexPath:indexPath AndTableView:tableView];
    } else {
        cell = [self getNormalTableViewCellWithIndexPath:indexPath AndTableView:tableView];
    }
    cell.delegate = self;
    
    TCListShoppingCart *listShoppingCart = shoppingCartWrapper.content[indexPath.section];
    TCOrderItem *orderItem = listShoppingCart.goodsList[indexPath.row];
    [cell.selectedBtn setImage:[self getSelectImageWithOrderItem:orderItem] forState:UIControlStateNormal];
    [cell.selectedBtn setTitle:[NSString stringWithFormat:@"%ld|%ld", (long)indexPath.section, (long)indexPath.row] forState:UIControlStateNormal];
    [cell.selectedBtn addTarget:self action:@selector(touchSelectGoodBtn:) forControlEvents:UIControlEventTouchUpInside];
    TCGoods *goods = orderItem.goods;
    cell.baseInfoView.titleLab.text = goods.name;
    [cell.leftImgView sd_setImageWithURL:[TCImageURLSynthesizer synthesizeImageURLWithPath:goods.mainPicture] placeholderImage:[UIImage imageNamed:@"home_image_place"]];
    [cell.baseInfoView setupStandard:goods.standardSnapshot];
    
    return cell;
}

#pragma mark - MGSwipeTableCellDelegate
- (NSArray<UIView *> *)swipeTableCell:(MGSwipeTableCell *)cell swipeButtonsForDirection:(MGSwipeDirection)direction swipeSettings:(MGSwipeSettings *)swipeSettings expansionSettings:(MGSwipeExpansionSettings *)expansionSettings {
    if (direction == MGSwipeDirectionRightToLeft) {
        TCShoppingCartTableViewCell *selectCell = (TCShoppingCartTableViewCell *)cell;
        return [self getCellLeftButtonWithSelectTag: selectCell.selectTag];
        
    }
    
    return nil;
}


- (NSArray *)getCellLeftButtonWithSelectTag:(NSString *)selectTag {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 150, 139)];
    UIButton *editBtn = [TCComponent createButtonWithFrame:CGRectMake(0, 0, button.width, 139 / 2) AndTitle:@"编辑" AndFontSize:16 AndBackColor:[UIColor lightGrayColor] AndTextColor:[UIColor whiteColor]];
    [editBtn addTarget:self action:@selector(touchGoodEditBtn:) forControlEvents:UIControlEventTouchUpInside];
    [button addSubview:editBtn];
    UIButton *deleteBtn = [TCComponent createButtonWithFrame:CGRectMake(0, editBtn.y + editBtn.height, button.width, 139 / 2) AndTitle:@"删除" AndFontSize:16 AndBackColor:[UIColor redColor] AndTextColor:[UIColor whiteColor]];
    [deleteBtn addTarget:self action:@selector(touchGoodDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
    [button addSubview:deleteBtn];
    [editBtn setTitle:selectTag forState:UIControlStateSelected];
    [deleteBtn setTitle:selectTag forState:UIControlStateSelected];
    
    return @[button];
}


- (TCShoppingCartTableViewCell *)getNormalTableViewCellWithIndexPath:(NSIndexPath *)indexPath AndTableView:(UITableView *)tableView{
    TCListShoppingCart *listShoppingCart = shoppingCartWrapper.content[indexPath.section];
    TCOrderItem *orderItem = listShoppingCart.goodsList[indexPath.row];
    NSString *tag = [NSString stringWithFormat:@"%ld|%ld", (long)indexPath.section, (long)indexPath.row];
    
    NSString *identifier = [NSString stringWithFormat:@"normal%li%li", indexPath.section, indexPath.row];
    TCShoppingCartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TCShoppingCartTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier AndSelectTag:tag AndGoodsId:orderItem.goods.ID];
    }
    NSString *notifiName = [NSString stringWithFormat:@"changeStandard%@", tag];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cellGoodStandardChange:) name:notifiName object:nil];

    
    [cell.baseInfoView setupAmountLab:orderItem.amount];
    [cell.baseInfoView setupNormalPriceLab:orderItem.goods.salePrice];

    return cell;

}

- (TCShoppingCartTableViewCell *)getEditTableViewCellWithIndexPath:(NSIndexPath *)indexPath AndTableView:(UITableView *)tableView {
    TCListShoppingCart *listShoppingCart = shoppingCartWrapper.content[indexPath.section];
    TCOrderItem *orderItem = listShoppingCart.goodsList[indexPath.row];
    NSString *tag = [NSString stringWithFormat:@"%ld|%ld", (long)indexPath.section, (long)indexPath.row];
    
    NSString *identifier = [NSString stringWithFormat:@"edit%li%li", indexPath.section, indexPath.row];
    TCShoppingCartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TCShoppingCartTableViewCell alloc] initEditCellStyle:UITableViewCellStyleDefault reuseIdentifier:identifier AndSelectTag:tag AndGoodsId:orderItem.goods.ID];
    }
    
    NSString *notifiName = [NSString stringWithFormat:@"changeStandard%@", tag];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cellGoodStandardChange:) name:notifiName object:nil];
    
    cell.baseInfoView.goodsId = orderItem.goods.ID;
    [cell.baseInfoView setupEditAmount:orderItem.amount];
    [cell.baseInfoView setupEditPriceLab:orderItem.goods.salePrice];
    
    return cell;
}



- (void)cellGoodStandardChange:(NSNotification *)notification {
    NSDictionary *changeDic = [notification object];
    NSArray *selectTagArr = [changeDic[@"selectTag"] componentsSeparatedByString:@"|"];
    NSInteger section = [selectTagArr[0] integerValue];;
    NSInteger row = [selectTagArr[1] integerValue];
    NSString *goodsId = changeDic[@"goodsId"];
    NSInteger newNumber = [changeDic[@"number"] integerValue];
    TCListShoppingCart *oldListShoppingCart = shoppingCartWrapper.content[section];
    TCOrderItem *oldOrderItem = oldListShoppingCart.goodsList[row];
    [self changeGoodStandardWithShoppingCartId:oldListShoppingCart.ID oldGoodId:oldOrderItem.goods.ID newGoodId:goodsId amount:newNumber AndSection:section AndRow:row];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:[NSString stringWithFormat:@"changeStandard%@", changeDic[@"selectTag"]] object:nil];
    
}


- (TCOrderItem *)getOrderItemWithSection:(NSInteger)section AndRow:(NSInteger)row {
    TCListShoppingCart *listShoppingCart = shoppingCartWrapper.content[section];
    TCOrderItem *orderItem = listShoppingCart.goodsList[row];
    return orderItem;
}

- (void)changeGoodStandardWithShoppingCartId:(NSString *)shoppingCartID oldGoodId:(NSString *)oldGoodId newGoodId:(NSString *)newGoodId amount:(NSInteger)amount AndSection:(NSInteger)section AndRow:(NSInteger)row{
    
    [[TCBuluoApi api] changeShoppingCartWithShoppingCartId:shoppingCartID AndGoodsId:oldGoodId AndNewGoodsId:newGoodId AndAmount:amount result:^(TCOrderItem *result, NSError *error) {
        if (result) {
            TCOrderItem *orderItem = [self getOrderItemWithSection:section AndRow:row];
            orderItem.goods = result.goods;
            orderItem.amount = result.amount;
            NSString *tag = [NSString stringWithFormat:@"%ld|%ld", (long)section, (long)row];
            [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"changeGoodAmount%@", tag] object:[NSNumber numberWithInteger:result.amount]];
        }
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
        [cartTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
    }];
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


- (NSMutableArray *)getSelectedGoodsInfo {
    NSMutableArray *selectArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < shoppingCartWrapper.content.count; i++) {
        TCListShoppingCart *listShoppingCart = shoppingCartWrapper.content[i];
        for (int j = 0; j < listShoppingCart.goodsList.count; j++) {
            TCOrderItem *orderItem = listShoppingCart.goodsList[j];
            if (orderItem.select) {
                [selectArr addObject:@{ @"shoppingCartId":listShoppingCart.ID, @"goodsId":orderItem.goods.ID }];
            }
        }
    }
    
    return selectArr;
}

- (NSMutableArray *)getSelectListShoppingCartArr {
    NSMutableArray *selectArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < shoppingCartWrapper.content.count; i++) {
        TCListShoppingCart *listShoppingCart = shoppingCartWrapper.content[i];
        [selectArr addObject:listShoppingCart];
    }
    
    return selectArr;
}

# pragma mark - click

- (void)touchBackBtn:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchDeleteButton {
    NSArray *goodsArr = [[NSArray alloc] initWithArray:[self getSelectedGoodsInfo]];
    [[TCBuluoApi api] deleteShoppingCartWithShoppingCartArr:goodsArr result:^(BOOL result, NSError *error) {
        
    }];
    
}

- (void)touchPayButton {
    NSLog(@"点击结算按钮");
    TCPlaceOrderViewController *placeOrderViewController = [[TCPlaceOrderViewController alloc] initWithListShoppingCartArr:[self getSelectListShoppingCartArr]];
    [self.navigationController pushViewController:placeOrderViewController animated:YES];
}

- (void)touchSelectGoodBtn:(UIButton *)button {
    NSString *buttonTag = [button titleForState:UIControlStateNormal];
    NSArray *tagArr = [buttonTag componentsSeparatedByString:@"|"];
    NSInteger row = [tagArr[1] integerValue];
    NSInteger section = [tagArr[0] integerValue];
    TCListShoppingCart *listShoppingCart = shoppingCartWrapper.content[section];
    TCOrderItem *orderItem = listShoppingCart.goodsList[row];
    orderItem.select = !orderItem.select;
    [button setImage:[self getSelectImageWithOrderItem:orderItem] forState:UIControlStateNormal];
    [self refreshTableViewWithSection:section];
    [self setuptotalPriceLab];
    
}


- (void)touchSelectStoreBtn:(UIButton *)button {
    NSInteger section = button.tag;
    if ([[button imageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"car_selected"]]) {
        [button setImage:[UIImage imageNamed:@"car_unselected"] forState:UIControlStateNormal];
        [self setupOrderItemSelected:NO Section:section];
    } else {
        [button setImage:[UIImage imageNamed:@"car_selected"] forState:UIControlStateNormal];
        [self setupOrderItemSelected:YES Section:section];
    }
    
    [self refreshTableViewWithSection:section];
    [self setuptotalPriceLab];
    
}

- (void)touchSelectAllBtn:(UIButton *)button {
    if ([[selectAllBtn imageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"car_selected"]]) {
        [selectAllBtn setImage:[UIImage imageNamed:@"car_unselected"] forState:UIControlStateNormal];
        [self setupOrderItemSelected:NO];
    } else {
        [selectAllBtn setImage:[UIImage imageNamed:@"car_selected"] forState:UIControlStateNormal];
        [self setupOrderItemSelected:YES];
    }
    
    [cartTableView reloadData];
    [self setuptotalPriceLab];
}

- (void)touchEditBar:(UIButton *)btn {
    isEdit = !isEdit;
    CGRect bottomFrame = CGRectMake(0, self.view.height - 48, self.view.width, 49);
    if (isEdit) {
        [self setupEditBottomViewWithFrame:bottomFrame];
    } else {
        [self setupBottomViewWithFrame:bottomFrame];
    }
    [self setupOrderItemSelected:NO];
    [cartTableView reloadData];
    [self setuptotalPriceLab];
    [self setupNavigationRightBarButton];
}


- (void)touchGoodEditBtn:(UIButton *)button {
    NSString *selectTag = [button titleForState:UIControlStateSelected];
    NSArray *selectArr = [selectTag componentsSeparatedByString:@"|"];
    NSInteger section = [selectArr[0] integerValue];
    NSInteger row = [selectArr[1] integerValue];
    TCListShoppingCart *listShoppingCart = shoppingCartWrapper.content[section];
    TCOrderItem *orderItem = listShoppingCart.goodsList[row];
    TCSelectStandardView *standardView = [[TCSelectStandardView alloc] initWithGoodsId:orderItem.goods.ID AndSelectTag:selectTag];
    [[UIApplication sharedApplication].keyWindow addSubview:standardView];
}

- (void)touchGoodDeleteBtn:(UIButton *)button {
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)refreshTableViewWithSection:(NSInteger)section {
    if ([self judgeIsSelectedAllOrderItem]) {
        [selectAllBtn setImage:[UIImage imageNamed:@"car_selected"] forState:UIControlStateNormal];
        [cartTableView reloadData];
    } else {
        NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:section];
        [cartTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        
        if ([[selectAllBtn imageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"car_selected"]]) {
            [selectAllBtn setImage:[UIImage imageNamed:@"car_unselected"] forState:UIControlStateNormal];
        }
    }
    
}


- (BOOL)judgeIsSelectedAllOrderItem {
    NSArray *contentArr = shoppingCartWrapper.content;
    for (int i = 0; i < contentArr.count; i++) {
        TCListShoppingCart *shoppingCart = contentArr[i];
        NSArray *goodList = shoppingCart.goodsList;
        for (int j = 0; j < goodList.count; j++) {
            TCOrderItem *orderItem = goodList[j];
            if (!orderItem.select) {
                return false;
            }
        }
    }
    
    return true;
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
