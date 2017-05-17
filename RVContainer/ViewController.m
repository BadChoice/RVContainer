//
//  ViewController.m
//  RVContainer
//
//  Created by Badchoice on 17/5/17.
//  Copyright © 2017 Revo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

+ (void)initialize {
    if (self == [ViewController self]) {
        NSLog(@"Initializing.. %@",self);
    }
}

-(void)awakeFromNib{
    [super awakeFromNib];
}


-(void)wire{
    NSLog(@"Hello");
}

- (void)viewDidLoad {
    [super viewDidLoad];   
}



@end
