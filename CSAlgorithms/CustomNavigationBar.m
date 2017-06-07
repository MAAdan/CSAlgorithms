//
//  CustomNavigationBar.m
//  CSAlgorithms
//
//  Created by Miguel Ángel Adán on 2/6/17.
//

#import "CustomNavigationBar.h"

@implementation CustomNavigationBar

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        self.shadowImage = [[UIImage alloc] init];
        self.tintColor = [UIColor whiteColor];
    }
    
    return self;
}

@end
