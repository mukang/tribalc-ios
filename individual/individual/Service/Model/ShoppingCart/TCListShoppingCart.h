//
//  TCListShoppingCart.h
//  individual
//
//  Created by WYH on 16/12/8.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCModelImport.h"

@interface TCListShoppingCart : NSObject

@property (copy, nonatomic) NSString *ID;

@property (copy, nonatomic) NSArray *goodsList;

@property (nonatomic) TCMarkStore *store;

@end
