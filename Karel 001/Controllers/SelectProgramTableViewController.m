//
//  SelectProgramTableViewController.m
//  Karel 001
//
//  Created by Chen Zhibo on 12/26/14.
//  Copyright (c) 2014 Chen Zhibo. All rights reserved.
//

#import "SelectProgramTableViewController.h"
#import "ProgramManager.h"
#import "Compiler.h"

@interface SelectProgramTableViewController () <UIAlertViewDelegate, ProgramManagerNewProgramProtocol>

@property (strong, nonatomic) ProgramManager *manager;
@property (strong, nonatomic) Compiler *compiler;

@end

@implementation SelectProgramTableViewController
#pragma mark - lazy instantiation

- (ProgramManager *)manager
{
    return [ProgramManager sharedManager];
}

- (Compiler *)compiler
{
    return [Compiler sharedCompiler];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.manager.statementBlocks setObject:[NSMutableArray array] forKey:@"default program"];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return [self.manager.statementBlocks count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"program" forIndexPath:indexPath];
    
    cell.textLabel.text = [[self.manager.statementBlocks allKeys]objectAtIndex:indexPath.row];;
    
    return cell;
}
#pragma mark - IBActions
- (IBAction)newProgram:(UIBarButtonItem *)sender {
    [self.manager newProgram:self];
    
}

- (void)didAddProgram
{
    [self.tableView reloadData];
}

- (IBAction)didTapEditButton:(UIBarButtonItem *)sender {
    
    if (self.tableView.editing) {
        [self.tableView setEditing:NO animated:YES];
        sender.title = @"Edit";
        sender.style = UIBarButtonSystemItemDone;
        [self.tableView reloadData];
    } else {
        [self.tableView setEditing:YES animated:YES];
        sender.title = @"Done";
        sender.style = UIBarButtonSystemItemEdit;
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.compiler.statementBlock = [self.manager.statementBlocks objectForKey:[tableView cellForRowAtIndexPath:indexPath].textLabel.text];
    self.compiler.statementTitle = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    
}

#pragma mark - table view delegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.manager.statementBlocks removeObjectForKey:[tableView cellForRowAtIndexPath:indexPath].textLabel.text];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
#warning UITableViewCellEditingStyleInsert not implemented
    }
}


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    
    
}



- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return NO;
}

@end
