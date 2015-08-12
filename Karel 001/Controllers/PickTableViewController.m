//
//  PickTableViewController.m
//  Karel 001
//
//  Created by Chen Zhibo on 12/28/14.
//  Copyright (c) 2014 Chen Zhibo. All rights reserved.
//

#import "PickTableViewController.h"
#import "StatementIdentifier.h"
#import "ProgramManager.h"
#import "KarelWorldMapManager.h"
@interface PickTableViewController ()<ProgramManagerNewProgramProtocol>

@property (strong, nonatomic) ProgramManager *manager;

@end

@implementation PickTableViewController

- (ProgramManager *)manager
{
    return [ProgramManager sharedManager];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    if (self.pickResultType == PickResultTypeCondition||self.pickResultType == PickResultTypeProgram||self.pickResultType == PickResultTypeMap) {
        return 1;
    } else {
        return 2;//condiiton command
    }

}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.pickResultType == PickResultTypeCommand) {
        if (section == 0) {
            return @"Basic Command";
        } else if (section == 1)
        {
            return @"Custom Command";
        }
    }
    
    return [super tableView:tableView titleForHeaderInSection:section];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if (self.pickResultType == PickResultTypeCommand) {
        if (section == 0) {
           return [[StatementIdentifier supportedIdentifiersOfTypeCommand] count];
        }
        if (section == 1) {
           return [self.manager.statementBlocks count];
        }
    } else if (self.pickResultType == PickResultTypeCondition){//type == condition
        return [[StatementIdentifier supportedIdentifiersOfTypeCondition] count];
    } else if (self.pickResultType == PickResultTypeMap){
        return [[[KarelWorldMapManager sharedManager] supportedSerials] count];
        
    }
    else
    
    {//type == program
        return [self.manager.statementBlocks count];
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"command or condition" forIndexPath:indexPath];
    
    // Configure the cell...
    NSString *text;
    if (self.pickResultType == PickResultTypeCommand) {
        if (indexPath.section == 0) {
            text =  [[StatementIdentifier supportedIdentifiersOfTypeCommand] objectAtIndex:indexPath.row];
        }
        if (indexPath.section == 1) {
            text = [[self.manager.statementBlocks allKeys] objectAtIndex:indexPath.row];
        }
    } else if (self.pickResultType == PickResultTypeCondition){//type == condition
        text = [[StatementIdentifier supportedIdentifiersOfTypeCondition] objectAtIndex:indexPath.row];
        
    } else if (self.pickResultType == PickResultTypeMap){
        text = [[[KarelWorldMapManager sharedManager] supportedSerials] objectAtIndex:indexPath.row];
    
    } else {//type == programd
        text = [[self.manager.statementBlocks allKeys] objectAtIndex:indexPath.row];
    }
    cell.textLabel.text = text;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (self.pickResultType == PickResultTypeCommand||self.pickResultType == PickResultTypeProgram) {
        self.resultViewController.command = cell.textLabel.text;
    } else {//type == condition type == map
        self.resultViewController.condition = cell.textLabel.text;
        
    }
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - IBActions
- (IBAction)newProgram:(UIBarButtonItem *)sender {
    [self.manager newProgram:self];
    
}

- (void)didAddProgram
{
    [self.tableView reloadData];
}

@end
