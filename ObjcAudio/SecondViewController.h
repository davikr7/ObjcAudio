//
//  SecondViewController.h
//  ObjcAudio
//
//  Created by David on 09.06.23.
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>

typedef NS_ENUM(NSInteger, RecordButtonState) {
    RecordButtonStateStartRecording,
    RecordButtonStateStopRecording,
    RecordButtonStatePlayRecording
};

typedef NS_ENUM(NSInteger, AudioButtonState) {
    AudioButtonStateStartPlaying,
    AudioButtonStateStopPlaying
};


@interface SecondViewController : UIViewController <AVAudioPlayerDelegate>
{
    AVAudioRecorder *recorder;
    AVPlayer *player;
}

@end
