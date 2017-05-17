//
//  TestAutoinject.h
//  RVContainer
//
//  Created by Badchoice on 17/5/17.
//  Copyright © 2017 Revo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SubTestClass.h"
#import "RVAutoInject.h"

@interface TestAutoinject : NSObject

@property(strong,nonatomic) inject(SubTestClass) *subtest;
@property(strong,nonatomic) TestClass *test;
@property(strong,nonatomic) injectProtocol(TesteProtocol) *testProtocol;

@end
