//
//  TCGoods.h
//  individual
//
//  Created by 穆康 on 2016/11/16.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCGoods : NSObject

/** 商品ID */
@property (copy, nonatomic) NSString *ID;
/** 商品名称 */
@property (copy, nonatomic) NSString *name;
/** 创建时间 */
@property (nonatomic) NSInteger creatTime;
/** 细分类别 */
@property (copy, nonatomic) NSString *category;
/** 商品品牌 */
@property (copy, nonatomic) NSString *brand;
/** 商品主图 */
@property (copy, nonatomic) NSString *mainPicture;
/** 商品图片数组 */
@property (copy, nonatomic) NSArray *pictures;
/** 列表缩略图 */
@property (copy, nonatomic) NSString *thumbnail;
/** 图文详情 */
@property (copy, nonatomic) NSString *detailURL;
/** 原始价格 */
@property (nonatomic) CGFloat originalPrice;
/** 销售价格 */
@property (nonatomic) CGFloat salePrice;
/** 库存量{规格:库存量} */
@property (copy, nonatomic) NSDictionary *standardRepertory;
/** 总销量 */
@property (nonatomic) NSInteger saleQuantity;
/** 简短说明 */
@property (copy, nonatomic) NSString *note;
/** 标签 */
@property (copy, nonatomic) NSArray *tags;
/** 原产国 */
@property (copy, nonatomic) NSString *originCountry;
/** 发货地 */
@property (copy, nonatomic) NSString *dispatch;

@end
