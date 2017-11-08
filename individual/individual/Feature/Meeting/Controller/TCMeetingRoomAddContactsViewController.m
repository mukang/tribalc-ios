//
//  TCMeetingRoomAddContactsViewController.m
//  individual
//
//  Created by 穆康 on 2017/11/3.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCMeetingRoomAddContactsViewController.h"

#import "TCMeetingRoomAddContactsViewCell.h"

#import <TCCommonLibs/TCCommonButton.h>
#import <TCCommonLibs/TCFunctions.h>
#import <AddressBook/AddressBook.h>
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
#import <Contacts/Contacts.h>
#endif

@interface TCMeetingRoomAddContactsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *participantArray;

@property (weak, nonatomic) UITableView *tableView;

@end

@implementation TCMeetingRoomAddContactsViewController {
    __weak TCMeetingRoomAddContactsViewController *weakSelf;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    weakSelf = self;
    self.navigationItem.title = @"添加参会人";
    self.participantArray = [NSMutableArray array];
    
    [self setupSubviews];
    if ([UIDevice currentDevice].systemVersion.floatValue < 9.0) {
        [self requestAddressBook];
    } else {
        [self requestContacts];
    }
}

#pragma mark - Private Methods

- (void)setupSubviews {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.backgroundColor = TCBackgroundColor;
    tableView.separatorColor = TCSeparatorLineColor;
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[TCMeetingRoomAddContactsViewCell class] forCellReuseIdentifier:@"TCMeetingRoomAddContactsViewCell"];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    TCCommonButton *saveButton = [TCCommonButton buttonWithTitle:@"确  定"
                                                           color:TCCommonButtonColorPurple
                                                          target:self
                                                          action:@selector(handleClickSaveButton)];
    [self.view addSubview:saveButton];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(saveButton.mas_top);
    }];
    [saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(49);
        make.bottom.left.right.equalTo(self.view);
    }];
}

- (void)requestAddressBook {
    [self.participantArray removeAllObjects];
    
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    if (status == kABAuthorizationStatusAuthorized) {
        // 用户已经授权给你的程序对通讯录进行访问
        [self loadAddressBook];
    } else if (status == kABAuthorizationStatusNotDetermined) {
        // 用户还没有决定是否授权你的程序进行访问
        ABAddressBookRef bookRef = ABAddressBookCreate();
        ABAddressBookRequestAccessWithCompletion(bookRef, ^(bool granted, CFErrorRef error) {
            if (granted) { //授权成功
                TC_CALL_ASYNC_MQ({
                    [weakSelf loadAddressBook];
                });
            }else{
                TC_CALL_ASYNC_MQ({
                    [MBProgressHUD showHUDWithMessage:@"授权失败，请稍后重试。"];
                });
            }
            CFRelease(bookRef);
        });
    } else if (status == kABAuthorizationStatusRestricted || status == kABAuthorizationStatusDenied) {
        // iOS 设备上一些许可配置阻止程序与通讯录数据库进行交互 或 用户明确的拒绝了你的程序对通讯录的访问
        [MBProgressHUD showHUDWithMessage:@"您的通讯录暂未允许访问，请去设置->隐私里面授权。"];
    }
    
    
    /*
     // 这个变量用于记录授权是否成功，即用户是否允许我们访问通讯录
     int __block tip = 0;
     //声明一个通讯簿的引用
     ABAddressBookRef addBook = nil;
     //创建通讯簿的引用
     addBook = ABAddressBookCreateWithOptions(NULL, NULL);
     //创建一个出事信号量为0的信号
     dispatch_semaphore_t sema = dispatch_semaphore_create(0);
     //申请访问权限
     ABAddressBookRequestAccessWithCompletion(addBook, ^(bool granted, CFErrorRef error) {
     //granted 为YES 是表示用户允许，否则为不允许
     if (!granted) {
     tip = 1;
     }
     //发送一次信号
     dispatch_semaphore_signal(sema);
     });
     
     //等待信号触发
     dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
     if (tip) {
     //用户没有允许访问通讯录的提示
     [MBProgressHUD showHUDWithMessage:@"您未允许访问通讯录"];
     return;
     }
     
     //获取所有联系人的数组
     CFArrayRef allLinkPeople = ABAddressBookCopyArrayOfAllPeople(addBook);
     //获取联系人总数
     CFIndex peopleNumber = ABAddressBookGetPersonCount(addBook);
     for (int i = 0; i < peopleNumber; i++) {
     //获取联系人对象的引用
     ABRecordRef people = CFArrayGetValueAtIndex(allLinkPeople, i);
     //获取当前联系人名字
     NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(people, kABPersonFirstNameProperty));
     //获取当前联系人姓氏
     NSString *lastName = (__bridge NSString *)(ABRecordCopyValue(people, kABPersonLastNameProperty));
     
     ABMultiValueRef phones = ABRecordCopyValue(people, kABPersonPhoneProperty);
     for (NSInteger j = 0; j < ABMultiValueGetCount(phones); j++) {
     NSString *phone = (__bridge NSString *)(ABMultiValueCopyValueAtIndex(phones, j));
     
     TCMeetingParticipant *participant = [[TCMeetingParticipant alloc] init];
     participant.name = [NSString stringWithFormat:@"%@%@", lastName, firstName];
     participant.phone = phone;
     
     [self.participantArray addObject:participant];
     }
     //读取照片
     //        NSData *image = (__bridge NSData *)(ABPersonCopyImageData(people));
     }
     
     [weakSelf.tableView reloadData];
     */
}

- (void)loadAddressBook {
    // 创建通讯录对象
    ABAddressBookRef bookRef = ABAddressBookCreate();
    // 获取通讯录中所有的联系人
    CFArrayRef arrayRef = ABAddressBookCopyArrayOfAllPeople(bookRef);
    
    // 遍历所有联系人
    CFIndex count = CFArrayGetCount(arrayRef);
    for (int i = 0; i < count; i++){
        ABRecordRef record = CFArrayGetValueAtIndex(arrayRef, i);
        
        // 获取姓名
        NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(record, kABPersonFirstNameProperty);
        NSString *lastName = (__bridge_transfer NSString *)ABRecordCopyValue(record, kABPersonLastNameProperty);
        
        // 获取电话号码
        ABMultiValueRef multiValue = ABRecordCopyValue(record, kABPersonPhoneProperty);
        CFIndex phoneCount = ABMultiValueGetCount(multiValue);
        for (int j = 0; j < phoneCount; j ++){
//            NSString *label = (__bridge_transfer NSString *)ABMultiValueCopyLabelAtIndex(multiValue, j);
            NSString *phone = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(multiValue, j);
            
            TCMeetingParticipant *participant = [[TCMeetingParticipant alloc] init];
            participant.name = [NSString stringWithFormat:@"%@%@", lastName, firstName];
            participant.phone = [weakSelf formatPhoneNum:phone];
            
            [self.participantArray addObject:participant];
        }
        
        CFRelease(multiValue);
    }
    
    CFRelease(bookRef);
    CFRelease(arrayRef);
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0

- (void)requestContacts {
    [self.participantArray removeAllObjects];
    
    //用户允许访问数据
    //判断是否授权
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (status == CNAuthorizationStatusAuthorized) {
        // 用户已经授权给你的程序对通讯录进行访问
        [self loadContacts];
    } else if (status == CNAuthorizationStatusNotDetermined){
        // 用户还没有决定是否授权你的程序进行访问
        CNContactStore *store = [[CNContactStore alloc] init];
        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) { //授权成功
                TC_CALL_ASYNC_MQ({
                    [weakSelf loadContacts];
                });
            }else{
                TC_CALL_ASYNC_MQ({
                    [MBProgressHUD showHUDWithMessage:@"授权失败，请稍后重试。"];
                });
            }
        }];
    }else if (status == CNAuthorizationStatusRestricted || status == CNAuthorizationStatusDenied){
        // iOS 设备上一些许可配置阻止程序与通讯录数据库进行交互 或 用户明确的拒绝了你的程序对通讯录的访问
        [MBProgressHUD showHUDWithMessage:@"您的通讯录暂未允许访问，请去设置->隐私里面授权。"];
    }
}

- (void)loadContacts {
    [MBProgressHUD showHUD:YES];
    //获取联系人仓库
    CNContactStore *store = [[CNContactStore alloc]init];
    //创建联系人信息的请求对象
    NSArray *keys = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey];
    //根据请求key，获取请求对象
    CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:keys];
    //发送请求
    [store enumerateContactsWithFetchRequest:request error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        //获取姓名
        NSString *givenName = contact.givenName;
        NSString *familyName = contact.familyName;
        
        //获取电话
        NSArray *phoneArray = contact.phoneNumbers;
        for (CNLabeledValue *labelValue in phoneArray) {
            CNPhoneNumber *number = labelValue.value;
            
            TCMeetingParticipant *participant = [[TCMeetingParticipant alloc] init];
            participant.name = [NSString stringWithFormat:@"%@%@", familyName, givenName];
            participant.phone = [weakSelf formatPhoneNum:number.stringValue];
            
            [weakSelf.participantArray addObject:participant];
        }
    }];
    [MBProgressHUD hideHUD:YES];
    [weakSelf.tableView reloadData];
}

#endif

- (NSString *)formatPhoneNum:(NSString *)originPhoneNum {
    originPhoneNum = [originPhoneNum stringByReplacingOccurrencesOfString:@"+86" withString:@""];
    
    NSMutableCharacterSet *charSet = [[NSMutableCharacterSet alloc] init];
    [charSet formUnionWithCharacterSet:[NSCharacterSet whitespaceCharacterSet]];
    [charSet formUnionWithCharacterSet:[NSCharacterSet punctuationCharacterSet]];
    [charSet formUnionWithCharacterSet:[NSCharacterSet symbolCharacterSet]];
    NSArray *arrayWithNumbers = [originPhoneNum componentsSeparatedByCharactersInSet:charSet];
    NSString *phoneNum = [arrayWithNumbers componentsJoinedByString:@""];
    
    return phoneNum;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.participantArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCMeetingRoomAddContactsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCMeetingRoomAddContactsViewCell" forIndexPath:indexPath];
    TCMeetingParticipant *participant = self.participantArray[indexPath.row];
    cell.participant = participant;
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TCMeetingParticipant *participant = self.participantArray[indexPath.row];
    participant.selected = !participant.isSelected;
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - Actions

- (void)handleClickSaveButton {
    if ([self.delegate respondsToSelector:@selector(meetingRoomAddContactsViewController:didClickSaveButtonWithParticipantArray:)]) {
        NSMutableArray *temp = [NSMutableArray array];
        for (TCMeetingParticipant *participant in self.participantArray) {
            if (participant.isSelected) {
                [temp addObject:participant];
            }
        }
        
        [self.delegate meetingRoomAddContactsViewController:self didClickSaveButtonWithParticipantArray:[temp copy]];
    }
    
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
