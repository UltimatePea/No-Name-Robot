//
//  SelectMapTableViewController.m
//  Karel 001
//
//  Created by Chen Zhibo on 12/31/14.
//  Copyright (c) 2014 Chen Zhibo. All rights reserved.
//

#import "SelectMapTableViewController.h"
#import "PickTableViewController.h"
#import "Compiler.h"
#import "KarelWorldViewController.h"

@interface SelectMapTableViewController () <PickResult>

@property (nonatomic) BOOL isProgramSpecified;
@property (nonatomic) BOOL isMapSpecified;

@end

@implementation SelectMapTableViewController
#pragma mark - lazy instantiation

- (void)setCommand:(NSString *)command
{
    _command = command;
    self.isProgramSpecified = YES;
}

- (void)setCondition:(NSString *)condition
{
    _condition = condition;
    self.isMapSpecified = YES;
}
#pragma mark - view controller life cycle

- (void)viewWillAppear:(BOOL)animated
{
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
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"Pick a program to execute";
            break;
            
        case 1:
            return @"Pick a map";
            break;
            
            
        default:
            
            break;
    }
    
    return nil;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pick a map vc reuse id" forIndexPath:indexPath];
#define SELECT @"Select..."
    if (indexPath.section == 0) {
        cell.textLabel.textColor = cell.tintColor;
        
        NSString * s = [Compiler sharedCompiler].statementTitle;
        
        if (self.isProgramSpecified){
            
                cell.textLabel.text = self.command;
            
            if ((![self.command isEqualToString:s])&&(s != nil)) {
                cell.textLabel.text = s;
            }
            
        } else if (s) {
            cell.textLabel.text = s;
        } else {
            cell.textLabel.text = SELECT;
        }
        
        
        
        
    }
    
    if (indexPath.section == 1) {
        cell.textLabel.textColor = cell.tintColor;
        
        if (self.isMapSpecified) {
            cell.textLabel.text = self.condition;
        } else {
            cell.textLabel.text = SELECT;
        }
        
    }
    
    
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 
    if ([segue.identifier isEqualToString:@"pick program"]) {
        if ([segue.destinationViewController isKindOfClass:[PickTableViewController class]]) {
            
            
            PickTableViewController *ptvc = segue.destinationViewController;
            
            NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
            switch (indexPath.section) {
                case 0:
                    ptvc.pickResultType = PickResultTypeProgram;
                    
                    break;
                    
                case 1:
                    ptvc.pickResultType = PickResultTypeMap;
                    
                    break;
                default:
                    break;
                    
            }
            
            ptvc.resultViewController = self;
            
        }
    }
    
    if ([segue.identifier isEqualToString:@"launch karel world segue"]) {
        if ([segue.destinationViewController isKindOfClass:[KarelWorldViewController class]]) {
            
            
            KarelWorldViewController *kwvc = (KarelWorldViewController *)segue.destinationViewController;
            NSString *cellText = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]].textLabel.text;
            kwvc.karelWorldMapSerial = cellText;
        }
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"launch karel world segue"]) {
       
            
            if (([[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]].textLabel.text isEqualToString:SELECT])||(!self.isMapSpecified)) {
                [[[UIAlertView alloc] initWithTitle:@"Can't Launch" message:@"Please specify maps or program." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
                return NO;
            }
        
    }
    return YES;
}

- (NSString *)textOfNumberToUI:(NSString *)text
{
    return [NSString stringWithFormat:@"Chapter %c, Level %@", (char)[text characterAtIndex:0], [NSString stringWithFormat:@"%c%c", (char)[text characterAtIndex:1], (char)[text characterAtIndex:2]]];
}

- (NSString *)textOfUIToNumber:(NSString *)text
{
    return [NSString stringWithFormat:@"%d%d%d", [text characterAtIndex:8], [text characterAtIndex:17], [text characterAtIndex:18]];
}



@end
