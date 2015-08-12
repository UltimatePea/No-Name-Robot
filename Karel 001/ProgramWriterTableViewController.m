//
//  ProgramWriterTableViewController.m
//  Karel 001
//
//  Created by Chen Zhibo on 12/26/14.
//  Copyright (c) 2014 Chen Zhibo. All rights reserved.
//

#import "ProgramWriterTableViewController.h"
#import "Compiler.h"
#import "Statement.h"
#import "StatementIdentifier.h"
#import "ProgramManager.h"

@interface ProgramWriterTableViewController ()

@property (strong, nonatomic) Compiler *compiler;
@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation ProgramWriterTableViewController
#pragma mark - lazy instantiation

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView =  [[UIImageView alloc] initWithFrame:self.tableView.bounds];
        _imageView.image = [UIImage imageNamed:@"No Command"];
    }
    return _imageView;
}

- (Compiler *)compiler
{
    return [Compiler sharedCompiler];
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

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = self.compiler.statementTitle;
    
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
    if ([self.compiler.statementBlock count] == 0) {
        
        [self.tableView addSubview:self.imageView];
        
    } else {
        [self.imageView removeFromSuperview];
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    
    return [self.compiler.statementBlock count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"statement" forIndexPath:indexPath];
    Statement *statement = [self.compiler.statementBlock objectAtIndex:indexPath.row];
    cell.textLabel.text =  [NSString stringWithFormat:@"%ld: %@", indexPath.row, statement.identifier];
    
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.

    return [self canEditOrReorderCellAtIndexPath:indexPath];
    
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.compiler.statementBlock removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        [self.compiler.statementBlock insertObject:[[Statement alloc]initWithIdentifier:@"user defined"] atIndex:indexPath.row];
        
    }   
}



- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    Statement *s = [self.compiler.statementBlock objectAtIndex:fromIndexPath.row];
    [self.compiler.statementBlock removeObjectAtIndex:fromIndexPath.row];
    NSLog(@"moving object from indexpath %ld, to indexpath %ld", (long)fromIndexPath.row, (long)toIndexPath.row);
    [self.compiler.statementBlock insertObject:s atIndex:toIndexPath.row];
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return [self canEditOrReorderCellAtIndexPath:indexPath];
}

- (BOOL)canEditOrReorderCellAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row<1) {
        return YES;
    }
    if ([((Statement *)[self.compiler.statementBlock objectAtIndex:(indexPath.row - 1)]).identifier isEqualToString:@"if"]||[((Statement *)[self.compiler.statementBlock objectAtIndex:(indexPath.row - 1)]).identifier isEqualToString:@"for"]||[((Statement *)[self.compiler.statementBlock objectAtIndex:(indexPath.row - 1)]).identifier isEqualToString:@"while"]) {
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}



@end
