//
//  RVContainer.h
//  RVContainer
//
//  Created by Badchoice on 17/5/17.
//  Copyright © 2017 Revo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RVContainer : NSObject

@property(strong,nonatomic) NSMutableDictionary * bindings;

-(void)bind:(Class)class closure:(id (^)(void))closure;
-(void)bind:(Class)class resolver:(Class)resolver;

-(void)bindProtocol:(Protocol*)protocol closure:(id (^)(void))closure;
-(void)bindProtocol:(Protocol*)protocol resolver:(Class)resolver;

-(void)instance:(Class)class object:(id)object;
-(void)singleton:(Class)class closure:(id (^)(void))closure;

-(id)resolve:(Class)class;
-(id)resolveProtocol:(Protocol*)protocol;
@end
