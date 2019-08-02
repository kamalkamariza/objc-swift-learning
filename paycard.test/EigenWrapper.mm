//
//  EigenWrapper.m
//  paycard.test
//
//  Created by jamie yew on 31/07/2019.
//  Copyright © 2019 mal. All rights reserved.
//
#import "Eigen/Core"
#import "EigenWrapper.h"

@implementation EigenWrapper

+ (NSString *)eigenVersionString {
    return [NSString stringWithFormat:@"Eigen Version %d.%d.%d",     EIGEN_WORLD_VERSION, EIGEN_MAJOR_VERSION, EIGEN_MINOR_VERSION];
}

@end
