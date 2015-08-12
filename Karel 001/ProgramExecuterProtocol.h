//
//  ProgramExecuterProtocol.h
//  Karel 001
//
//  Created by Chen Zhibo on 12/28/14.
//  Copyright (c) 2014 Chen Zhibo. All rights reserved.
//

#ifndef Karel_001_ProgramExecuterProtocol_h
#define Karel_001_ProgramExecuterProtocol_h


#endif

@protocol ProgramExecuterProtocol <NSObject>

@required

- (void)start;

@end


@protocol ProgramExecuterDelegate <NSObject>

@required
- (void)karelMove:(id<ProgramExecuterProtocol>)sender;
- (void)karelTurnLeft:(id<ProgramExecuterProtocol>)sender;
- (void)programEncounteredAnError:(NSString *)error;

- (BOOL)isKarelFrontBlocked;
- (BOOL)isKarelFrontClear;

- (void)karelPickBeeper:(id<ProgramExecuterProtocol>)sender;
- (void)karelPutBeeper:(id<ProgramExecuterProtocol>)sender;

@optional
- (void)programEnded;

@end

