//
//  AudioRecorder.m
//  ObjcAudio
//
//  Created by David on 19.06.23.
//

#import <Foundation/Foundation.h>
#import "AudioRecorder.h"
#import <AVFoundation/AVFoundation.h>

@interface AudioRecorder() <AVAudioRecorderDelegate> {
    AVAudioPlayer *player;
    AVAudioRecorder *recorder;
    AVPlayer *playRecord;
    
};

@end

@implementation AudioRecorder

- (id)init {
    self = [super init];
    if (self) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
        switch (authStatus) {
            case AVAuthorizationStatusNotDetermined:
                [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {}];
            default:
                break;
        }
    }
    return self;
}

- (void)start {
    NSURL* audioFilePath = [self createAudioFileURL: _testName];
    NSError* error;
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:&error];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey];

    recorder = [[AVAudioRecorder alloc] initWithURL:audioFilePath settings:recordSetting error:NULL];
    recorder.meteringEnabled = YES;
    recorder.delegate = self;
    [recorder prepareToRecord];
    [recorder record];
}

- (void)stop {
    [recorder stop];

    NSError *error;
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:NO error:&error];
}

-(void)play {
    if (!recorder.recording) {
        playRecord = [[AVPlayer alloc] initWithURL:recorder.url];
        [playRecord play];
    }
}

- (NSURL*)createAudioFileURL:(NSString*)name {
    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSString *fileName = [NSString stringWithFormat:@"%@.wav", name];
    documentsURL = [documentsURL URLByAppendingPathComponent: fileName];
    return documentsURL;
}

@end



//- (void)startRecording {
//    // Проверяем, доступно ли аудиоустройство
//    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
//    if (![audioSession isInputAvailable]) {
//        // Аудиоустройство не доступно
//        // Обработайте эту ситуацию по вашему усмотрению
//        return;
//    }
//
//    // Настройка параметров записи
//    NSError *error = nil;
//    NSDictionary *settings = @{
//        AVFormatIDKey: @(kAudioFormatMPEG4AAC),
//        AVSampleRateKey: @44100.0,
//        AVNumberOfChannelsKey: @2,
//        AVEncoderAudioQualityKey: @(AVAudioQualityHigh)
//    };
//
//    // Создание временного файла для записи звука
//    NSString *tempDir = NSTemporaryDirectory();
//    NSString *tempFilePath = [tempDir stringByAppendingPathComponent:@"temp_recording.m4a"];
//    NSURL *tempFileURL = [NSURL fileURLWithPath:tempFilePath];
//
//    // Создание объекта AVAudioRecorder
//    self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:tempFileURL settings:settings error:&error];
//    if (error) {
//        // Обработка ошибки создания AVAudioRecorder
//        NSLog(@"Error: %@", error.localizedDescription);
//        return;
//    }
//
//    // Запуск записи
//    if ([self.audioRecorder record]) {
//        // Успешно началась запись
//        self.isRecording = YES;
//        // Включение микрофона
//        // Добавьте соответствующий код здесь
//    } else {
//        // Запись не удалась
//        // Обработайте эту ситуацию по вашему усмотрению
//    }
//}
//
//- (void)stopRecording {
//    // Остановка записи
//    [self.audioRecorder stop];
//
//    // Очистка ресурсов
//    self.audioRecorder = nil;
//    self.isRecording = NO;
//
//    [self configMakeNewRecordButton];
//
//    // Выключение микрофона
//}

// По видео индуса

//-(void) startRecording {
//
//    NSArray *path = [NSArray arrayWithObjects:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject], @"myRecording.m4a", nil];
//    NSURL *url = [NSURL fileURLWithPathComponents:path];
//    AVAudioSession *session = [[AVAudioSession alloc] init];
//    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
//
//    NSMutableDictionary *setting = [[NSMutableDictionary alloc] init];
//    [setting setValue:[NSNumber numberWithInteger:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
//    [setting setValue:[NSNumber numberWithInteger:1] forKey:AVNumberOfChannelsKey];
//
//    recorder = [[AVAudioRecorder alloc] initWithURL:url settings:setting error:nil];
//    recorder.meteringEnabled = YES;
//    [recorder prepareToRecord];
//    [recorder record];
//}
//
//-(void) stopRecording {
//    [recorder stop];
//
//    AVAudioSession *session = [[AVAudioSession alloc] init];
//    [session setActive:NO error:nil];
//}
//
//-(void) playRecording {
//    if (!recorder.recording) {
//        player = [[AVPlayer alloc] initWithURL:recorder.url];
//        [player play];
//    }
//}
