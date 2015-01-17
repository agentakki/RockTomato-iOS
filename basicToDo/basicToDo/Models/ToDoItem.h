//
//  ToDoItem.h
//  basicToDo
//
//  Created by Akshay Bakshi on 1/17/15.
//  Copyright (c) 2015 akshaybakshi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToDoItem : NSObject

@property (nonatomic) NSString *itemName;
@property BOOL completed;
@property (nonatomic) NSDate *completionDate;


// target number of pomos
// array of pomos
// mark pomo i as completed

- (void)markAsCompleted:(BOOL)isComplete;


@end
