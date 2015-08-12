//
//  NewCammandTableViewController.m
//  Karel 001
//
//  Created by Chen Zhibo on 12/26/14.
//  Copyright (c) 2014 Chen Zhibo. All rights reserved.
//

#import "NewCammandTableViewController.h"
#import "Compiler.h"
#import "Statement.h"
#import "PickTableViewController.h"
@interface NewCammandTableViewController () <UIAlertViewDelegate, PickResult>



@property (strong, nonatomic) Compiler *compiler;

@property (nonatomic) BOOL isCommandSpecified;

@property (nonatomic) BOOL isConditionSpecified;

@end

@implementation NewCammandTableViewController
#pragma mark - instances
- (Compiler *)compiler
{
    return [Compiler sharedCompiler];
}

@synthesize condition = _condition;

- (NSString *)condition
{
    if (self.isConditionSpecified) {
        return _condition;
    } else {
        return @"Please select a condition...";
    }
}

- (void)setCondition:(NSString *)condition
{
    self.isConditionSpecified = YES;
    _condition = condition;
    [self.tableView reloadData];
}

@synthesize command = _command;

- (NSString *)command
{
    if (self.isCommandSpecified) {
        return _command;
    } else {
        return @"Please select a command...";
    }
}

- (void)setCommand:(NSString *)command
{
    self.isCommandSpecified = YES;
    _command = command;
    [self.tableView reloadData];
}
#pragma mark - view controller life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
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
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (self.userDesiredCommand == UserDesiredCommandIf||self.userDesiredCommand == UserDesiredCommandWhile) {
        return 4;
    } else
    {
        if (self.isConditionSpecified) {
            return 4;
        }
        return 3;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"command identifier" forIndexPath:indexPath];
    if (self.userDesiredCommand == UserDesiredCommandIf) {
        switch (indexPath.row) {
            
            case 2:
                cell.textLabel.text = @"Then execute the following command:";
                break;
            
            default:
                break;
        }
    } else if (self.userDesiredCommand == UserDesiredCommandWhile)
    {
        switch (indexPath.row) {
            case 2:
                cell.textLabel.text = @"Then repeat executing following command:";
                break;
                
            default:
                break;
        }
    }
    
    if (self.userDesiredCommand == UserDesiredCommandIf || self.userDesiredCommand == UserDesiredCommandWhile) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"If the following statement is true:";
                break;
            case 1:
                cell.textLabel.text = self.condition;
                cell.textLabel.textColor = cell.tintColor;
                break;
            case 3:
                cell.textLabel.text = self.command;
                cell.textLabel.textColor = cell.tintColor;
                break;
            default:
                break;
        }
    }
    
    if (self.userDesiredCommand == UserDesiredCommandFor) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Execute the following command";
                break;
            case 1:
                cell.textLabel.text = self.command;
                cell.textLabel.textColor = cell.tintColor;
                break;
            case 2:
                cell.textLabel.textColor = cell.tintColor;
                cell.textLabel.text = @"for how many times?";
                break;
            case 3:
                if (self.isConditionSpecified) {
                    cell.textLabel.text = self.condition;
                }
            default:
                break;
        }
    }
    
    // Configure the cell...
    
    return cell;
}

#pragma mark - IBAction

- (IBAction)userDidHitConfirmButton:(UIBarButtonItem *)sender {
    if ([self isCommandSpecified]&&[self isConditionSpecified]) {
        [self.compiler.statementBlock addObject:[[Statement alloc] initWithIdentifier:[self userDesiredCommandString]]];
        [self.compiler.statementBlock addObject:[[Statement alloc] initWithIdentifier:self.condition]];
        [self.compiler.statementBlock addObject:[[Statement alloc] initWithIdentifier:self.command]];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Can't add statement" message:@"Make sure you have selected both condition and command" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
    }
   
}

- (NSString *)userDesiredCommandString
{
    switch (self.userDesiredCommand) {
        case UserDesiredCommandIf:
            return @"if";
            break;
        case UserDesiredCommandFor:
            return @"for";
            break;
        case UserDesiredCommandWhile:
            return @"while";
            break;
            
        default:
            break;
    }
}

#define CANCEL @"Cancel"
#define OK @"OK"
#define ALERT_TITLE_PLEASE_ENTER_A_VALUE @"Please enter a value"

#pragma mark - delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row ==2 && self.userDesiredCommand == UserDesiredCommandFor) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ALERT_TITLE_PLEASE_ENTER_A_VALUE message:@"Any integer is acceptable" delegate:self cancelButtonTitle:CANCEL otherButtonTitles:OK, nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alert textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.title isEqualToString:ALERT_TITLE_PLEASE_ENTER_A_VALUE]) {
        if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:OK]) {
            self.condition = [alertView textFieldAtIndex:0].text;
        }
    }
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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


#pragma mark - Navigation
#define SEGUE_IDENTIFIER_PICK @"pick"
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:SEGUE_IDENTIFIER_PICK])
    {
        if ([segue.destinationViewController isKindOfClass:[PickTableViewController class]]) {
            PickTableViewController *ptvc = (PickTableViewController *)segue.destinationViewController;
            NSIndexPath *path = [self.tableView indexPathForCell:sender];
            if (path.row == 3 &&
                (self.userDesiredCommand == UserDesiredCommandIf||
                 (self.userDesiredCommand == UserDesiredCommandWhile))) {
                ptvc.pickResultType = PickResultTypeCommand;
            } else if (path.row == 1)
            {
                if (self.userDesiredCommand == UserDesiredCommandFor) {
                    ptvc.pickResultType  = PickResultTypeCommand;
                    
                } else {
                    ptvc.pickResultType = PickResultTypeCondition;
                }
            }
            ptvc.title = ((UITableViewCell *)sender).textLabel.text;
            ptvc.resultViewController = self;
        }
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:SEGUE_IDENTIFIER_PICK]) {
        NSIndexPath *path = [self.tableView indexPathForCell:sender];
        if (path.row == 2 && self.userDesiredCommand == UserDesiredCommandFor) {
            return NO;
        }
        if ([((UITableViewCell *)sender).textLabel.textColor isEqual:((UITableViewCell *)sender).tintColor] ) {
            return YES;
        }
    }
    return NO;
}


@end
