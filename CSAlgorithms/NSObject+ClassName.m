//
//  NSObject+ClassName.m
//  CSAlgorithms
//
//  Created by Miguel Angel Adan Roman on 7/6/17.
//  Copyright © 2017 Avantiic. All rights reserved.
//

#import "NSObject+ClassName.h"

@implementation NSObject (ClassName)

+(NSString *) className {
    return NSStringFromClass([self class]);
}

@end
