//
//  SelectCommandTableViewController.m
//  Karel 001
//
//  Created by Chen Zhibo on 12/26/14.
//  Copyright (c) 2014 Chen Zhibo. All rights reserved.
//

#import "SelectCommandTableViewController.h"
#import "StatementIdentifier.h"
#import "Compiler.h"
#import "Statement.h"
#import "ProgramManager.h"
#import "NewCammandTableViewController.h"
@interface SelectCommandTableViewController ()

@property (strong, nonatomic) ProgramManager *manager;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barItem;

@end

@implementation SelectCommandTableViewController

#pragma mark - lazy instantiation

- (ProgramManager *)manager{
    return [ProgramManager sharedManager];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if (section == 0) {
        return [[StatementIdentifier supportedIdentifiers] count];
    } else if (section == 1)
    {
        return [self.manager.statementBlocks count];;
    }
    return 0;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"command" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        
        
        cell.textLabel.text = [[StatementIdentifier supportedIdentifiers] objectAtIndex:indexPath.row];
        
        
    } else if (indexPath.section == 1)
    {
        
        cell.textLabel.text = [[self.manager.statementBlocks allKeys] objectAtIndex:indexPath.row];
        
    }
    
    return cell;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Basic Command";
    } else if (section == 1)
    {
        return @"Custom Command";
    }
    return @"Error";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSString *text = [self.tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    if (!([text isEqualToString:@"if"]||[text isEqualToString:@"for" ]||[text isEqualToString:@"while"])) {
        [[Compiler sharedCompiler].statementBlock addObject:[[Statement alloc] initWithIdentifier:[self.tableView cellForRowAtIndexPath:indexPath].textLabel.text]];
        self.barItem.title = [NSString stringWithFormat:@"Command added: %@", text];
    }
    
    
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
     NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    if (indexPath.section ==0) {
        if (indexPath.row == 2||indexPath.row == 3||indexPath.row == 4) {
            return YES;
        }
    }
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segue to new Command if for while"]) {
        if ([segue.destinationViewController isKindOfClass:[NewCammandTableViewController class]]) {
            NewCammandTableViewController *nctvc = (NewCammandTableViewController *)segue.destinationViewController;
            NSString *text = ((UITableViewCell *)sender).textLabel.text;
            if ([text isEqualToString: @"if"]) {
                nctvc.userDesiredCommand = UserDesiredCommandIf;
            } else if ([text isEqualToString:@"for"]){
                nctvc.userDesiredCommand = UserDesiredCommandFor;
            } else if ([text isEqualToString:@"while"]){
                nctvc.userDesiredCommand = UserDesiredCommandWhile;
            }
            nctvc.title = text;
        }
    }
}


@end
