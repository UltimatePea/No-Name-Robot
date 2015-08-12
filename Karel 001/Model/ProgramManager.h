//
//  ProgramManager.h
//  Karel 001
//
//  Created by Chen Zhibo on 12/27/14.
//  Copyright (c) 2014 Chen Zhibo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ProgramManagerNewProgramProtocol <NSObject>

@required
-(void)didAddProgram;

@end

@interface ProgramManager : NSObject


+ (ProgramManager *)sharedManager;

@property (strong, nonatomic) NSMutableDictionary *statementBlocks;

- (void)newProgram:(id<ProgramManagerNewProgramProtocol>)sender;

- (NSUInteger)linesOfCode;

@end
