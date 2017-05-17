//
//  RVAutoinjectTest.m
//  RVContainer
//
//  Created by Badchoice on 17/5/17.
//  Copyright © 2017 Revo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TestAutoinject.h"
#import "RVAutoInject.h"

@interface RVAutoinjectTest : XCTestCase

@end

@implementation RVAutoinjectTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)test_can_autoinject {
    RVContainer* container  = [RVContainer new];
    [container bindProtocol:@protocol(TesteProtocol) closure:^id{
        return [TestClass new];
    }];
    TestAutoinject* test    = [TestAutoinject new];
    
    [RVAutoInject autoInject:test container:container];
    
    XCTAssertNotNil ( test.subtest );
    XCTAssertEqual  ( test.subtest.class, SubTestClass.class);
    XCTAssertNil    ( test.test );
    XCTAssertNotNil ( test.testProtocol );
    XCTAssertEqual  ( test.testProtocol.class, TestClass.class);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
