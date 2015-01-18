//
//  PebbleController.h
//  basicToDo
//
//  Created by Akshay Bakshi on 1/17/15.
//  Copyright (c) 2015 akshaybakshi. All rights reserved.
//

#import <Foundation/Foundation.h>

#define APP_UUID @"36519cda-0474-4324-a6b9-a44a5d052995"


@interface PebbleController : NSObject

@property (readonly, nonatomic) BOOL isTargetSet;
-(void) initPB ;

@end
