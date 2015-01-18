//
//  ToDoListTableViewController.m
//  basicToDo
//
//  Created by Akshay Bakshi on 1/17/15.
//  Copyright (c) 2015 akshaybakshi. All rights reserved.
//

#import "ToDoListTableViewController.h"
#import "ToDoItem.h"
#import "TaskList.h"
#import "AddToDoItemViewController.h"

static ToDoListTableViewController *sharedList;

@interface ToDoListTableViewController ()
{
}
@end

@implementation ToDoListTableViewController

#pragma mark Singleton Methods

+ (ToDoListTableViewController*)sharedList {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedList = [[self alloc] init];
    });
    return sharedList;
}

- (id)init {
    if (self = [super init]) {
        //init properties
        [self loadInitialData];
    }
    return self;
}
#pragma mark State Methods

- (IBAction)unwindToList:(UIStoryboardSegue *)segue {
    AddToDoItemViewController *source = [segue sourceViewController];
    ToDoItem *item = source.toDoItem;
    if (item != nil) {
        [[TaskList sharedList].toDoItems addObject:item];
        [self.tableView reloadData];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [ToDoListTableViewController sharedList];
    //self.toDoItems = [[NSMutableArray alloc] init];
    [self loadInitialData];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (void)loadInitialData {
    NSArray *mockTasksArray = [NSArray arrayWithObjects:@"Buy milk" ,@"Buy eggs", @"Read a book",nil];
   
    for(int i=0; i<mockTasksArray.count ; i++){
        
        ToDoItem *task = [[ToDoItem alloc] init];
        task.itemName = mockTasksArray[i];
        task.t_id = [[TaskList sharedList] getNumberOfTasks];
        task.completed = false;
        task.targetPomos = task.completedPomos = 0;
        [[TaskList sharedList].toDoItems addObject:task];
    }
    
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[TaskList sharedList] getNumberOfTasks];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListPrototypeCell" forIndexPath:indexPath];
    
    ToDoItem *toDoItem = [[TaskList sharedList].toDoItems objectAtIndex:indexPath.row];
    [toDoItem setCompletionDate:[NSDate date]];
    cell.textLabel.text = toDoItem.itemName;
    
    if(toDoItem.completed){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
//Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Table view delegate 

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ToDoItem *tappedItem = [[TaskList sharedList].toDoItems objectAtIndex:indexPath.row];
    
    //reverse completion state
    tappedItem.completed = !tappedItem.completed;
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];

    
}

@end
