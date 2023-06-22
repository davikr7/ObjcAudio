//
//  AudioRecorder.h
//  ObjcAudio
//
//  Created by David on 19.06.23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AudioRecorder : NSObject

@property NSString *testName;

-(id)init;
-(void)start;
-(void)stop;

@end

NS_ASSUME_NONNULL_END
