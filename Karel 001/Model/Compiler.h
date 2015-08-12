//
//  Compiler.h
//  Karel 001
//
//  Created by Chen Zhibo on 12/26/14.
//  Copyright (c) 2014 Chen Zhibo. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface Compiler : NSObject

+ (Compiler *)sharedCompiler;

@property (strong, nonatomic) NSMutableArray *statementBlock;
@property (strong, nonatomic) NSString *statementTitle;

@end
