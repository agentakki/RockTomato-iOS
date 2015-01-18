//
//  Pomodoro.m
//  basicToDo
//
//  Created by Akshay Bakshi on 1/17/15.
//  Copyright (c) 2015 akshaybakshi. All rights reserved.
//

#import "Pomodoro.h"

@implementation Pomodoro

- (void)setCompletionDate {
   
    if(self.completionDate == nil)
        self.completionDate = [NSDate date];
    else
    {
        NSLog(@"Can't set date for already set pomo");
    }
}

@end
