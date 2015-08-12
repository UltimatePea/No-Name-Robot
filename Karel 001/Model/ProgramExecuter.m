//
//  ProgramExecuter.m
//  Karel 001
//
//  Created by Chen Zhibo on 12/26/14.
//  Copyright (c) 2014 Chen Zhibo. All rights reserved.
//

#import "ProgramExecuter.h"
#import "Statement.h"
#import "ProgramManager.h"
#import "StatementWithConditionAndCommand.h"


typedef enum : NSUInteger {
    ProgramExecuterTypeGlobal,
    ProgramExecuterTypeSubsequent,
} ProgramExecuterType;

typedef enum : NSUInteger {
    FWTypeNone,
    FWTypeFor,
    FWTypeWhile,
} FWType;



@interface ProgramExecuter () <ProgramExecuterProtocol>

@property (strong, nonatomic) NSMutableArray *statementBlock;
@property (weak, nonatomic) ProgramExecuter *parent;
@property (weak, nonatomic) id<ProgramExecuterDelegate> delegate;
@property (nonatomic) NSTimeInterval inteval;
@property (nonatomic) NSUInteger currentStatement;
@property (nonatomic) ProgramExecuterType type;
@property (nonatomic) ProgramExecuter *subsequentExcuter;
@property (strong, nonatomic) NSString *condition;
@property (nonatomic) FWType fwType;


@end


@implementation ProgramExecuter


- (instancetype)initWithDelegate:(id<ProgramExecuterDelegate>)delegate statementBlock:(NSMutableArray *)block withSpeed:(NSTimeInterval)inteval
{
    return [self initWithDelegate:delegate statementBlock:block withSpeed:inteval withType:ProgramExecuterTypeGlobal withParent:nil];
}

- (instancetype)initWithDelegate:(id<ProgramExecuterDelegate>)delegate statementBlock:(NSMutableArray *)block withSpeed:(NSTimeInterval)inteval withType:(ProgramExecuterType)type withParent:(ProgramExecuter *)parent
{
    return [self initWithDelegate:delegate statementBlock:block withSpeed:inteval withType:type withParent:parent withCondition:nil withFWType:FWTypeNone];
}

- (instancetype)initWithDelegate:(id<ProgramExecuterDelegate>)delegate statementBlock:(NSMutableArray *)block withSpeed:(NSTimeInterval)inteval withType:(ProgramExecuterType)type withParent:(ProgramExecuter *)parent withCondition:(NSString *)condition withFWType:(FWType)fwType
{
    self = [super init];
    if (self) {
        self.statementBlock = block;
        self.delegate = delegate;
        self.inteval = inteval;
        self.currentStatement = 0;
        self.type = type;
        self.parent = parent;
        self.condition = condition;
        self.fwType = fwType;
        
    }
    return self;
}

- (void)start//stops every statement to complete animation
{
    
    
    NSLog(@"start");
    
    switch (self.fwType) {
        case FWTypeFor:
            if (self.currentStatement < ([self.condition integerValue])) {
#warning works for the this time, but find out why there is minus 1
                self.currentStatement++;
                [self handleStatement:[self.statementBlock objectAtIndex: 0]];
                break;
            } else {
                [self.parent start];
            }
            
            break;
        case FWTypeWhile:
            
            if ([self isConditionTrue:self.condition]) {
                [self handleStatement:[self.statementBlock objectAtIndex:0]];
                break;
            } else {
                [self.parent start];
            }
            
            break;
        case FWTypeNone:
            
            if (![self isEnded]) {//if self is not ended, execute self
                Statement *statement = [self getCurrentStatement];
                self.currentStatement++;
                [self handleStatement:statement];
            } else //if self is ended and i am the global, i am responsible to send to my delegate that the program has finished
            {
                switch (self.type) {
                    case ProgramExecuterTypeGlobal:
                        [self.delegate programEnded];
                        break;
                    case ProgramExecuterTypeSubsequent://otherwise just let my parent continue

                        [self.parent start];
                        break;
                    default:
                        break;
                }
            }
            
        default:
            break;
    }
    
    
}

- (Statement *)getCurrentStatement
{
    id obj = [self.statementBlock objectAtIndex:self.currentStatement];
    
    Statement *statement = (Statement *)obj;
    return statement;
}

- (BOOL)isStarted
{
    if (self.type == ProgramExecuterTypeGlobal) {
        return self.currentStatement != 0;
    }
    return YES;
    
}

- (BOOL)isEnded
{
    return self.currentStatement == [self.statementBlock count];
}


- (void)handleStatement:(Statement *)statement
{
    if ([statement.identifier isEqualToString:@"turn left"]) {
        [self.delegate karelTurnLeft:self];
        
    } else if ([statement.identifier isEqualToString:@"move"])
    {
        [self.delegate karelMove:self];
    }
    else if ([statement.identifier isEqualToString:@"pick beeper"])
    {
        [self.delegate karelPickBeeper:self];
    }
    else if ([statement.identifier isEqualToString:@"put beeper"])
    {
        [self.delegate karelPutBeeper:self];
    }
    else if ([statement.identifier isEqualToString:@"if"])
    {
        
        
        if ([self isConditionTrue:((StatementWithConditionAndCommand *)statement).condition]) {
            //self.currentStatement ++;
            Statement *subStatement = [[Statement alloc] initWithIdentifier:((StatementWithConditionAndCommand *)statement).command];
            [self handleStatement:subStatement];
            //self.currentStatement ++;
        }
        
    }
    else if ([statement.identifier isEqualToString:@"for"])
    {
#warning redundant code begin 1
        /*
        NSString *condition = [self getCurrentStatement].identifier;
        NSLog(@"%@", condition);
        self.currentStatement++;
        NSMutableArray *block =[NSMutableArray arrayWithObjects:[self getCurrentStatement], nil];
        self.currentStatement++;*/
#warning redundant code end 1
        StatementWithConditionAndCommand *convertedStatement = (StatementWithConditionAndCommand *)statement;
        self.subsequentExcuter = [[ProgramExecuter alloc] initWithDelegate:self.delegate
                                                            statementBlock:[NSMutableArray arrayWithObjects:[[Statement alloc] initWithIdentifier:convertedStatement.command], nil]
                                                                 withSpeed:self.inteval
                                                                  withType:ProgramExecuterTypeSubsequent
                                                                withParent:self withCondition:convertedStatement.condition
                                                                withFWType:FWTypeFor];
        [self.subsequentExcuter start];
    }
    else if ([statement.identifier isEqualToString:@"while"])
    {
#warning redundant code begin 2
        /*
        NSString *condition = [self getCurrentStatement].identifier;
        self.currentStatement++;
        NSMutableArray *block =[NSMutableArray arrayWithObject: [self getCurrentStatement]];
        self.currentStatement++;
         */
#warning redundant code end 2
        StatementWithConditionAndCommand *convertedStatement = (StatementWithConditionAndCommand *)statement;
        self.subsequentExcuter = [[ProgramExecuter alloc] initWithDelegate:self.delegate
                                                            statementBlock:[NSMutableArray arrayWithObjects:[[Statement alloc] initWithIdentifier:convertedStatement.command] , nil]
                                                                 withSpeed:self.inteval
                                                                  withType:ProgramExecuterTypeSubsequent
                                                                withParent:self
                                                             withCondition:convertedStatement.condition
                                                                withFWType:FWTypeWhile];
        [self.subsequentExcuter start];
    } else if ([[ProgramManager sharedManager].statementBlocks objectForKey:statement.identifier]){
        //ProgramManager *manager = [ProgramManager sharedManager];
        self.subsequentExcuter = [[ProgramExecuter alloc] initWithDelegate:self.delegate statementBlock:[[ProgramManager sharedManager].statementBlocks objectForKey:statement.identifier] withSpeed:self.inteval withType:ProgramExecuterTypeSubsequent withParent:self];
        [self.subsequentExcuter start];
    }
     else {
        [self.delegate programEncounteredAnError:[NSString stringWithFormat:@"Unrecognized Error: %ld: %@", (long)self.currentStatement, statement.identifier]];
    }
}

- (BOOL)isConditionTrue:(NSString *)condition
{
    if ([condition isEqualToString:@"front is blocked"]) {
        return [self.delegate isKarelFrontBlocked];
    } else if ([self.condition isEqualToString:@"front is clear"]){
        return [self.delegate isKarelFrontClear];
    }
    return NO;
}

@end
