//
//  TaskList.m
//  basicToDo
//
//  Created by Akshay Bakshi on 1/18/15.
//  Copyright (c) 2015 akshaybakshi. All rights reserved.
//

#import "TaskList.h"
#import "ToDoItem.h"

static TaskList *sharedList ;

@implementation TaskList

+ (TaskList*)sharedList {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedList = [[self alloc] init];
    });
    return sharedList;
}

- (id)init {
    if (self = [super init]) {
        //init properties
        //[self loadInitialData];
    }
    return self;
}

-(id) initPrivate {
    if(self = [super init]){
        
    }
    return self;
}

- (NSMutableArray *) toDoItems{
    if(!_toDoItems){
        _toDoItems = [[NSMutableArray alloc] init];
    }
    return _toDoItems;
}

- (void) updateTaskAtIndex:(int)index With:(Pomodoro*) pomo{
    if(index < 0 || index >= [self getNumberOfTasks]){
        NSLog(@"indec invalid so task not updated");
        return;
    }
    ToDoItem *task = [self.toDoItems objectAtIndex:index];
    task.completedPomos++;
    [task.pomoArray addObject:pomo];
}

- (NSUInteger) getNumberOfTasks{
    return [self.toDoItems count];
}



@end
