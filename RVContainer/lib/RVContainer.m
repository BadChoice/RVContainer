#import <objc/runtime.h>
#import "RVContainer.h"

@implementation RVContainer

//=======================================================
#pragma mark - Singleton
//=======================================================
+ (RVContainer*) container {
    static RVContainer *container = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        container = [[self alloc] init];
    });
    return container;
}

- (id)init{
    if (self = [super init]) {
        self.bindings = NSMutableDictionary.new;
    }
    return self;
}

//=======================================================
#pragma mark - Bind
//=======================================================
- (void)bind:(Class)class closure:(id (^)(void))closure{
    NSString * className     = NSStringFromClass(class);
    self.bindings[className] = closure;
}

- (void)bind:(Class)class resolver:(Class)resolver{
    NSString * className     = NSStringFromClass(class);
    NSString * resolverName  = NSStringFromClass(resolver);
    self.bindings[className] = resolverName;
}

- (void)instance:(Class)class object:(id)object{
    NSString * className     = NSStringFromClass(class);
    self.bindings[className] = object;
}

- (void)singleton:(Class)class closure:(id (^)(void))closure{
    [self instance:class object:closure()];
}

- (void)bindProtocol:(Protocol*)protocol closure:(id (^)(void))closure{
    NSString * protocolName     = NSStringFromProtocol(protocol);
    self.bindings[protocolName] = closure;
}

- (void)bindProtocol:(Protocol*)protocol resolver:(Class)resolver{
    NSString * protocolName     = NSStringFromProtocol(protocol);
    NSString * resolverName     = NSStringFromClass(resolver);
    self.bindings[protocolName] = resolverName;
}

- (void)bindProtocol:(Protocol*)protocol instance:(id)instance{
    NSString * protocolName     = NSStringFromProtocol(protocol);
    self.bindings[protocolName] = instance;
}

//=======================================================
#pragma mark - Resolve
//=======================================================
- (id)make:(Class)class{
    id resolver = [self resolverFor:class];
    return resolver ? ([resolver isKindOfClass:NSString.class] ? NSClassFromString(resolver) : resolver) : class;
}

- (id)makeProtocol:(Protocol*)protocol{
    id resolver = [self resolverForProtocol:protocol];
    if (! resolver) {
        return nil;
        //[NSException raise:@"No implementation" format:@"A protocol can't be instantiated without a implementation"];
    }
    return [self makeWithResolver:resolver];
}

-(Class)resolverFor:(Class)class{
    NSString * className = NSStringFromClass(class);
    id resolver          = self.bindings[className];
    return resolver ? NSClassFromString(resolver) : class;
}

-(Class)resolverForProtocol:(Protocol*)protocol{
    NSString * protocolName = NSStringFromProtocol(protocol);
    return self.bindings[protocolName];
}

//=======================================================
#pragma mark - Private
//=======================================================
- (id)makeWithResolver:(id)resolver{
    if ([resolver isKindOfClass:NSString.class]) {
        return [NSClassFromString(resolver) new];
    }
    
    if ([resolver isKindOfClass:NSClassFromString(@"NSBlock")]) {
        id(^block)(void) = resolver;
        return block();
    }
    
    if (class_isMetaClass(object_getClass(resolver))){
        return [resolver new];
    }
    
    return resolver;
}

@end
