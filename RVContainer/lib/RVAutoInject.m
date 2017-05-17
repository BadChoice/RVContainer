//
//  RVAutoInject.m
//  RVContainer
//
//  Created by Badchoice on 17/5/17.
//  Copyright © 2017 Revo. All rights reserved.
//

#import "RVAutoInject.h"
#import <objc/runtime.h>


@implementation RVAutoInject


//=======================================================
#pragma mark - Static calls
//=======================================================
+(void)autoInject:(id)object{
    [self.class autoInject:object container:nil];
}

+(void)autoInject:(id)object container:(RVContainer*)container{
    RVAutoInject * ai = [RVAutoInject new];
    ai.container = container;
    [ai autoinject:object];
}

//=======================================================
#pragma mark -
//=======================================================
-(void)autoinject:(NSObject*)object{
    self.object = object;
    NSDictionary* propertiesToInject = [self findPropertiesToInject];
    
    for( NSString* property in propertiesToInject.allKeys ){
        NSString* className = propertiesToInject[property];
        
        if([className containsString:@"<RVInjectedClass>"]){
            [self injectObject:property className:className];
        }
        else{
            [self injectProtocol:property className:className];
        }        
    }
}

-(RVContainer*)container{
    if( ! _container) _container = IOC;
    return _container;
}

-(void)injectObject:(NSString*)property className:(NSString*)className{
    className = [className stringByReplacingOccurrencesOfString:@"<RVInjectedClass>" withString:@""];
    [self.object setValue:[self.container make:NSClassFromString(className)]
              forKey:property];
}

-(void)injectProtocol:(NSString*)property className:(NSString*)className{
    className = [className stringByReplacingOccurrencesOfString:@"RVInjectedProtocol<" withString:@""];
    className = [className stringByReplacingOccurrencesOfString:@">" withString:@""];
    [self.object setValue:[self.container makeProtocol:NSProtocolFromString(className)]
              forKey:property];
}


//=======================================================
#pragma mark - Objective c runtime
//=======================================================
-(NSDictionary*)findPropertiesToInject{
    
    NSMutableDictionary* propertiesToInject = [NSMutableDictionary new];
    
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self.object class], &outCount);
    for(i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        if(propName) {
            const char *propType = getPropertyType(property);
            NSString *propertyName = [NSString stringWithCString:propName
                                                        encoding:[NSString defaultCStringEncoding]];
            NSString *propertyType = [NSString stringWithCString:propType
                                                        encoding:[NSString defaultCStringEncoding]];
            
            if([propertyType containsString:@"<RVInjectedClass>"]){
                propertiesToInject[propertyName] = propertyType;
            }
            if([propertyType containsString:@"RVInjectedProtocol"]){
                propertiesToInject[propertyName] = propertyType;
            }
        }
    }
    free(properties);
    return propertiesToInject;
}

static const char *getPropertyType(objc_property_t property) {
    const char *attributes = property_getAttributes(property);
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL) {
        if (attribute[0] == 'T') {
            if (strlen(attribute) <= 4) {
                break;
            }
            return (const char *)[[NSData dataWithBytes:(attribute + 3) length:strlen(attribute) - 4] bytes];
        }
    }
    return "@";
}


@end
