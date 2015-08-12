//
//  ProgramManager.m
//  Karel 001
//
//  Created by Chen Zhibo on 12/27/14.
//  Copyright (c) 2014 Chen Zhibo. All rights reserved.
//

#import "ProgramManager.h"
#import "Statement.h"
@import UIKit;

@interface ProgramManager () <UIAlertViewDelegate>

@property (weak, nonatomic) id<ProgramManagerNewProgramProtocol> delegate;
@end

@implementation ProgramManager



+ (ProgramManager *)sharedManager
{
    static dispatch_once_t onceProgramManager;
    static ProgramManager *sharedManager;
    dispatch_once(&onceProgramManager, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (NSMutableDictionary *)statementBlocks
{
    if (!_statementBlocks) {
        _statementBlocks = [[NSMutableDictionary alloc] init];
        [_statementBlocks setObject:[NSMutableArray array] forKey:@"default program"];//compiler sets it
    }
    return _statementBlocks;
}

- (void)newProgram:(id<ProgramManagerNewProgramProtocol>)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"New Program" message:@"What's its name?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    self.delegate = sender;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.title isEqualToString: @"New Program"]) {
        if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"OK"]) {
            [self.statementBlocks setObject:[[NSMutableArray alloc] init] forKey:[alertView textFieldAtIndex:0].text];
            [self.delegate didAddProgram];
        }
    }
}

- (NSUInteger)linesOfCode
{
    __block NSUInteger result = 0;
    [self.statementBlocks enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSMutableArray *statementBlock = obj;
        [statementBlock enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Statement *aStatement = obj;
            switch (aStatement.type) {
                case StatementTypeBasic:
                    result++;
                    break;
                case StatementTypeFunctionCall:
                    result++;
                    break;
                case StatementTypeFor:
                    result+=3;
                    break;
                case StatementTypeIf:
                    result+=3;
                    break;
                case StatementTypeWhile:
                    result+=3;
                    break;
                default:
                    break;
            }
        }];
    }];
    return result;
}


@end
