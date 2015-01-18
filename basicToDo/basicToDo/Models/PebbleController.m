//
//  PebbleController.m
//  basicToDo
//
//  Created by Akshay Bakshi on 1/17/15.
//  Copyright (c) 2015 akshaybakshi. All rights reserved.
//

#import "PebbleController.h"
#include "ToDoItem.h"
#import "Pomodoro.h"
#import "ToDoListTableViewController.h"
#import <PebbleKit/PebbleKit.h>

#define kLIST_REQUEST @"LIST_REQUEST"
#define kLIST_RESPONSE @"LIST_RESPONSE"
#define kTASK @"TASK"
#define kPOMO_COMPLETE @"POMO_COMPLETE"


@interface PebbleController() <PBPebbleCentralDelegate>
@property (nonatomic) BOOL isTargetSet;

@end
@implementation PebbleController
{
    PBWatch *_targetWatch;
}

-(void) initPB{
    self.isTargetSet = false;
    [[PBPebbleCentral defaultCentral] setDelegate:self];
    [self setTargetWatch:[[PBPebbleCentral defaultCentral] lastConnectedWatch]];
//    NSArray *watchArray = [[PBPebbleCentral defaultCentral] connectedWatches];
//    for(NSString *element in watchArray){
//        //NSLog(element);
//    }
    
}

-(void)setTargetWatch:(PBWatch*)watch {
    _targetWatch = watch;
    
    
    // Test if the Pebble's firmware supports AppMessages :
    [watch appMessagesGetIsSupported:^(PBWatch *watch, BOOL isAppMessagesSupported) {
        if (isAppMessagesSupported) {
        
            uint8_t bytes[16];
            
            NSUUID *uuid =[[NSUUID alloc] initWithUUIDString:APP_UUID];
            [uuid getUUIDBytes:bytes];
            
            NSData *data = [NSData dataWithBytes:bytes length:sizeof(bytes)];
            
            //Set UUID and register receiving method
            [[PBPebbleCentral defaultCentral] setAppUUID:data];
            [_targetWatch appMessagesAddReceiveUpdateHandler:^BOOL( PBWatch *watch , NSDictionary *update ){
                [self receivedMessage:update fromWatch:watch];
                return YES;
            }];
            
            
            NSString *message = [NSString stringWithFormat:@"Yay! %@ supports AppMessages :D", [watch name]];
            [[[UIAlertView alloc] initWithTitle:@"Connected!" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        } else {
            NSString *message = [NSString stringWithFormat:@"Blegh... %@ does NOT support AppMessages :'(", [watch name]];
            [[[UIAlertView alloc] initWithTitle:@"Connected..." message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
        
        self.isTargetSet = true;
    }];
}

- (void)receivedMessage:(NSDictionary *)message fromWatch:(PBWatch *)watch{
    NSLog(@"Received message: %@", message);
    
    NSString *type = [message objectForKey:@(0)];

    if([type isEqual: kLIST_REQUEST]){
        [self sendListResponse];
        ToDoListTableViewController *listController = [ToDoListTableViewController sharedList];
        
        for(ToDoItem *task in listController.toDoItems){
            NSDictionary *dict = @{ @(0) : kTASK ,
                                    @(1) : task.itemName,
                                    @(2) : [NSNumber numberWithInt:task.t_id],
                                    @(3) : [NSNumber numberWithInt:task.targetPomos],
                                    @(4) : [NSNumber numberWithInt:task.completedPomos]
                                    };
            [self sendMessageWithDict:dict];
            //pause ?
                                    
        }
    }
    else if([type isEqual: kPOMO_COMPLETE]){
        int taskId = [message objectForKey:@"1"];
        Pomodoro* pomo = [[Pomodoro alloc] init];
        [pomo setCompletionDate:[NSDate date]];
        [[ToDoListTableViewController sharedList] updateTaskAtIndex:taskId With:pomo];
    
        
    }
    else{
        NSLog(@"Unexpected value received for message");
    }
}

- (void) sendListResponse{
    int numOfMessages = [[ToDoListTableViewController sharedList] getNumberOfTasks];
    
    NSDictionary *dict = @{ @(0) : kLIST_RESPONSE, @(1) : @(numOfMessages) };
    [self sendMessageWithDict:dict];
    
}

-(void) sendMessageWithDict:(NSDictionary*)dict{
    
    
    [_targetWatch appMessagesPushUpdate:dict onSent:^(PBWatch *watch,
                                                        NSDictionary *update, NSError *error) {
        if(error){
            NSLog([error localizedDescription]);
        }
        else{
            NSLog(@"Update sent!");
        } 
    }];
}

/*
 *  PBPebbleCentral delegate methods
 */

- (void)pebbleCentral:(PBPebbleCentral*)central watchDidConnect:(PBWatch*)watch isNew:(BOOL)isNew {
    [self setTargetWatch:watch];
}

- (void)pebbleCentral:(PBPebbleCentral*)central watchDidDisconnect:(PBWatch*)watch {
    [[[UIAlertView alloc] initWithTitle:@"Disconnected!" message:[watch name] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    if (_targetWatch == watch || [watch isEqual:_targetWatch]) {
        [self setTargetWatch:nil];
    }
}

@end
