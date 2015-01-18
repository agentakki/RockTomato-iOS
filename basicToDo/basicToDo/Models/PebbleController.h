//
//  PebbleController.h
//  basicToDo
//
//  Created by Akshay Bakshi on 1/17/15.
//  Copyright (c) 2015 akshaybakshi. All rights reserved.
//

#import <Foundation/Foundation.h>

#define APP_UUID @"6c86cc1e-4bb1-46ee-8947-4bd45a27e113"


@interface PebbleController : NSObject

@property (readonly, nonatomic) BOOL isTargetSet;
-(void) initPB ;

@end
