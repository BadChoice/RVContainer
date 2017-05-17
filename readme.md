# RVContainer

This is a simple and lightweigh IoC Container for Objective-c based on Laravel's one.

#### Installation

```
pod 'RVContainer'
```

#### Usage

There are two options to use it, creating a new `RVContainer` instance and storing it wherever you can access from any part you could need it, or using the singleton provided.

When using the singleton there are two ways to use it

```
[RVContainer container]
````

or simply using `IOC` marco that shortens the above call.

```
IOC
```

To bind your classes to the container there are several methods


##### Basic binding
```
[IOC bind:AwesomeClass.class resolver:SubAwesomeClass.class];
````

```
[IOC bind:AwesomeClass.class closure: ^(id){
    return [SubAwesomeClass new];
}];
```

You can bind an instance, so the container will allways return it when asking for that class

``` 
SubAwesomeClass * instance = [SubAwesomeClass new];
[IOC instance:AwesomeClass.class object:instance];
```

And similar to the previous one, you can register a singleton that will always be returned when asking for it
```
[IOC singleton:AwesomeClass.class closure:^id{
    return [SubAwesomeClass new];
}];
````

Another imporant feature is to bind contracts (or protocols in objective-c).

```
[IOC bindProtocol:@protocol(aProtocol) resolver:ClassThatImplementsTheProtocol.class];
````

#### Resolve
If you try to resolve a class not in the container, it will return a new instance of the class requested

```
AwesomeClass * object  = [IOC make:SubAwesomeClass.class];
```

```
ClassThatImplementsTheProtocol * object  = [IOC makeProtocol:@protocol(aProtocol)];
``` 

### Autoinject
If you don't want to clutter your classes with container resolving things you can use autoinject
It will automatically inject the dependencies to you object properties

You need to declare the properties to be injected like the following:

```
#import "RVAutoInject.h"

@interface ClassWithObjectsToBeInjected : NSObject

@property(strong,nonatomic) inject(AwesomeClass) *subtest;
@property(strong,nonatomic) TestClass *test;
@property(strong,nonatomic) injectProtocol(aProtocol) *testProtocol;

@end
```

And then in your init method call

```
[RVAutoInject autoInject:self];
```

> I'm not really happy with this Autoinject call but I don't know how to make it automatically

### Contributing
I really welcome any issue and PR so feel free to post them


