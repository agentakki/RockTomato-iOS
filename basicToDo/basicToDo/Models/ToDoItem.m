//
//  ToDoItem.m
//  basicToDo
//
//  Created by Akshay Bakshi on 1/17/15.
//  Copyright (c) 2015 akshaybakshi. All rights reserved.
//

#import "ToDoItem.h"

@implementation ToDoItem

- (void)markAsCompleted:(BOOL)isComplete {
    self.completed = isComplete;
    [self setCompletionDate];
}
- (void)setCompletionDate {
    if (self.completed) {
        self.completionDate = [NSDate date];
    } else {
        self.completionDate = nil;
    }
}
@end
