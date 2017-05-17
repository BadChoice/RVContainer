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

+(void)autoInject:(id)object container:(RVContainer*)container{
    
    NSDictionary* propertiesToInject = [self.class findPropertiesToInject:object];
    
    for( NSString* property in propertiesToInject.allKeys ){
        NSString* className = propertiesToInject[property];
        
        if([className containsString:@"<RVInjectedClass>"]){
            [self.class injectObject:object className:className property:property container:container];
        }
        else{
            [self.class injectProtocol:object className:className property:property container:container];
        }

    }
}

+(void)injectObject:(id)object className:(NSString*)className property:(NSString*)property container:(RVContainer*)container{
    className = [className stringByReplacingOccurrencesOfString:@"<RVInjectedClass>" withString:@""];
    [object setValue:[container resolve:NSClassFromString(className)]
              forKey:property];
}

+(void)injectProtocol:(id)object className:(NSString*)className property:(NSString*)property container:(RVContainer*)container{
    className = [className stringByReplacingOccurrencesOfString:@"RVInjectedProtocol<" withString:@""];
    className = [className stringByReplacingOccurrencesOfString:@">" withString:@""];
    [object setValue:[container resolveProtocol:NSProtocolFromString(className)]
              forKey:property];
}



+(NSDictionary*)findPropertiesToInject:(id)object{
    
    NSMutableDictionary* propertiesToInject = [NSMutableDictionary new];
    
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([object class], &outCount);
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
