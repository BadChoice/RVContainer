#import <Foundation/Foundation.h>
#import "RVContainer.h"

#define inject(CLASS)               CLASS<RVInjectedClass>
#define injectProtocol(PROTOCOL)    RVInjectedProtocol<PROTOCOL>

@protocol RVInjectedClass <NSObject>
@end

@interface RVInjectedProtocol : NSObject
@end

@interface RVAutoInject : NSObject

@property (weak, nonatomic) RVContainer* container;
@property (weak, nonatomic) NSObject* object;

+(void)autoInject:(id)object;
+(void)autoInject:(id)object container:(RVContainer*)container;
-(void)autoinject:(NSObject*)object;


@end
