//
//  ToDoItem.h
//  basicToDo
//
//  Created by Akshay Bakshi on 1/17/15.
//  Copyright (c) 2015 akshaybakshi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToDoItem : NSObject

@property (nonatomic) int t_id;
@property (nonatomic, strong) NSString *itemName;
@property BOOL completed;
@property (nonatomic, strong) NSDate *completionDate;
@property (nonatomic) int targetPomos;
@property (nonatomic) int completedPomos;
@property (nonatomic, strong) NSMutableArray *pomoArray;

- (void)markAsCompleted:(BOOL)isComplete;

@end
