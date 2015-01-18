//
//  ToDoListTableViewController.h
//  basicToDo
//
//  Created by Akshay Bakshi on 1/17/15.
//  Copyright (c) 2015 akshaybakshi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pomodoro.h"

@interface ToDoListTableViewController : UITableViewController

@property (nonatomic, readonly) NSMutableArray *toDoItems;


+(id) sharedList;
- (IBAction)unwindToList:(UIStoryboardSegue *)segue;
- (void) updateTaskAtIndex:(int)index With:(Pomodoro*) pomo;
- (NSUInteger) getNumberOfTasks;

@end
