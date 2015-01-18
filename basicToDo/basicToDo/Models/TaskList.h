//
//  TaskList.h
//  basicToDo
//
//  Created by Akshay Bakshi on 1/18/15.
//  Copyright (c) 2015 akshaybakshi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Pomodoro.h"

@interface TaskList : NSObject

@property (nonatomic, strong) NSMutableArray *toDoItems;

- (void) updateTaskAtIndex:(int)index With:(Pomodoro*) pomo;
- (NSUInteger) getNumberOfTasks;

+(TaskList *) sharedList;
@end
