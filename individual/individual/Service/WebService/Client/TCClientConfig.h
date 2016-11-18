//
//  TCClientConfig.h
//  individual
//
//  Created by 穆康 on 2016/10/26.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef _TCClientConfig_h
#define _TCClientConfig_h

#if DEBUG
#define TCCLIENT_API_HOST    @"app-services.buluo-gs.com:10086"
#else
#define TCCLIENT_API_HOST    @"app-services.buluo-gs.com:10086"
#endif

#define TCCLIENT_BASE_URL    @"http://" TCCLIENT_API_HOST "/tribalc/v1.0"

#define TCCLIENT_RESOURCES_BASE_URL    @"http://app-services.buluo-gs.com/resources"

#endif
