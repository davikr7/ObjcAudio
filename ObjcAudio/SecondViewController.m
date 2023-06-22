//
//  SecondViewController.m
//  ObjcAudio
//
//  Created by David on 09.06.23.
//

#import "SecondViewController.h"
#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "AudioRecorder.h"


@interface SecondViewController ()

@property (nonatomic, strong) UIView *imageView;
@property (nonatomic, strong) UIImageView *logoView;
@property (nonatomic, strong) UILabel *audioLabel;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UILabel *recordLabel;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIButton *recordButton;
@property (nonatomic, strong) UIButton *playRecordButton;
@property (nonatomic, strong) UIButton *makeNewRecordButton;
@property (nonatomic, assign) RecordButtonState recordButtonState;
@property (nonatomic, assign) AudioButtonState audioButtonState;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *resultView;
@property (nonatomic, strong) UIButton *redButton;
@property (nonatomic, strong) UIButton *greenButton;
@property (nonatomic, strong) UILabel *timerLabel;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger seconds;

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) AVAudioRecorder *audioRecorder;
@property (nonatomic, assign) BOOL isRecording;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configImageView];
    [self configAudioTrackLabel];
    [self configProgressView];
    [self configPlayButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeGesture];
}

- (void)handleSwipeGesture:(UISwipeGestureRecognizer *)gesture {
    if (gesture.direction == UISwipeGestureRecognizerDirectionRight) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)configImageView {
    self.imageView = [[UIView alloc] init];
    self.imageView.backgroundColor = [UIColor whiteColor];
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.imageView];
    self.imageView.layer.borderWidth = 1.0;
    self.imageView.layer.borderColor = [UIColor colorWithRed:0.855 green:0.855 blue:0.855 alpha:1.0].CGColor;
    
    [NSLayoutConstraint activateConstraints:@[
        [self.imageView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.imageView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.imageView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.imageView.heightAnchor constraintEqualToConstant:64]
    ]];
    
    [self configImage];
}

-(void)configImage {
    self.logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    self.logoView.contentMode = UIViewContentModeScaleAspectFill;
    self.logoView.clipsToBounds = YES;
    self.logoView.translatesAutoresizingMaskIntoConstraints = NO;
    self.logoView.transform = CGAffineTransformMakeScale(1.5, 1.5);
    [self.imageView addSubview:self.logoView];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.logoView.centerXAnchor constraintEqualToAnchor:self.imageView.centerXAnchor],
        [self.logoView.centerYAnchor constraintEqualToAnchor:self.imageView.centerYAnchor]
    ]];
}

-(void)configAudioTrackLabel {
    self.audioLabel = [[UILabel alloc] init];
    self.audioLabel.text = @"Audio Track";
    self.audioLabel.font = [UIFont systemFontOfSize:16];
    self.audioLabel.textAlignment = NSTextAlignmentCenter;
    self.audioLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.audioLabel];

    [NSLayoutConstraint activateConstraints:@[
        [self.audioLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.audioLabel.topAnchor constraintEqualToAnchor:self.imageView.bottomAnchor constant:32]
    ]];
}

- (void)configProgressView {
    self.progressView = [[UIProgressView alloc] init];
    self.progressView.translatesAutoresizingMaskIntoConstraints = NO;
    self.progressView.progressTintColor = [UIColor blueColor];
    self.progressView.trackTintColor = [UIColor lightGrayColor];
    [self.view addSubview:self.progressView];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.progressView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:38],
        [self.progressView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-38],
        [self.progressView.topAnchor constraintEqualToAnchor:self.audioLabel.bottomAnchor constant:32],
        [self.progressView.heightAnchor constraintEqualToConstant:4]
    ]];
}

- (void)updateProgressView {
    if (self.audioPlayer && self.audioPlayer.duration > 0) {
        float progress = self.audioPlayer.currentTime / self.audioPlayer.duration;
        [self.progressView setProgress:progress animated:YES];
    } else {
        [self.progressView setProgress:0 animated:NO];
    }
}

-(void)configPlayButton {
    self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.playButton.backgroundColor = [UIColor colorWithRed:0.855 green:0.855 blue:0.855 alpha:1.0];
    self.playButton.layer.cornerRadius = 74/2;
    self.playButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.playButton addTarget:self action:@selector(playButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.playButton];
    
    [self changePlayButtonIconToPlay];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.playButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.playButton.topAnchor constraintEqualToAnchor:self.progressView.bottomAnchor constant:32],
        [self.playButton.widthAnchor constraintEqualToConstant:74],
        [self.playButton.heightAnchor constraintEqualToConstant:76]
    ]];
    
}

-(void)changePlayButtonIconToStop {
    UIImage *playIconImage = [[UIImage imageNamed:@"stop-icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImageView *playIconImageView = [[UIImageView alloc] initWithImage:playIconImage];
    playIconImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.playButton addSubview:playIconImageView];
    
    [NSLayoutConstraint activateConstraints:@[
        [playIconImageView.widthAnchor constraintEqualToConstant:12],
        [playIconImageView.heightAnchor constraintEqualToConstant:10],
        [playIconImageView.centerXAnchor constraintEqualToAnchor:self.playButton.centerXAnchor],
        [playIconImageView.centerYAnchor constraintEqualToAnchor:self.playButton.centerYAnchor]
    ]];
}

-(void)changePlayButtonIconToPlay {
    UIImage *playIconImage = [[UIImage imageNamed:@"play-icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImageView *playIconImageView = [[UIImageView alloc] initWithImage:playIconImage];
    playIconImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.playButton addSubview:playIconImageView];
    
    [NSLayoutConstraint activateConstraints:@[
        [playIconImageView.widthAnchor constraintEqualToConstant:12],
        [playIconImageView.heightAnchor constraintEqualToConstant:10],
        [playIconImageView.centerXAnchor constraintEqualToAnchor:self.playButton.centerXAnchor],
        [playIconImageView.centerYAnchor constraintEqualToAnchor:self.playButton.centerYAnchor]
    ]];
}

- (void)playButtonTapped {
    switch (self.audioButtonState) {
        case AudioButtonStateStartPlaying:
            [self changePlayButtonIconToStop];
            [self playAudioTrack];
            self.audioButtonState = AudioButtonStateStopPlaying;
            break;
        case AudioButtonStateStopPlaying:
            [self changePlayButtonIconToPlay];
            [self stopAudioTrack];
            self.audioButtonState = AudioButtonStateStartPlaying;
            break;
    }
}

- (void)playAudioTrack {
    NSString *audioFilePath = [[NSBundle mainBundle] pathForResource:@"audio_track" ofType:@"mp3"];
    NSURL *audioFileURL = [NSURL fileURLWithPath:audioFilePath];
    NSError *error;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioFileURL error:&error];
    self.audioPlayer.delegate = self;
    self.audioPlayer.volume = 1.0;
    
    if (error) {
        NSLog(@"Failed to initialize audio player: %@", error.localizedDescription);
        return;
    }
    
    [self.audioPlayer play];
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateProgressView) userInfo:nil repeats:YES];
}

- (void)stopAudioTrack {
    [self.audioPlayer stop];
    //[self configPlayButton]; //
    [self changePlayButtonIconToPlay];
    [self configureBottomView];
    self.audioPlayer = nil;
    [self updateProgressView];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [self stopAudioTrack];
    //[self configPlayButton]; //
    [self changePlayButtonIconToPlay];
    [self configureBottomView];
}

-(void)configRecordLabel {
    self.recordLabel = [[UILabel alloc] init];
    self.recordLabel.text = @"Record any words with your voice";
    self.recordLabel.font = [UIFont systemFontOfSize:16];
    self.recordLabel.textAlignment = NSTextAlignmentCenter;
    self.recordLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.recordLabel];

    [NSLayoutConstraint activateConstraints:@[
        [self.recordLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.recordLabel.topAnchor constraintEqualToAnchor:self.audioLabel.bottomAnchor constant:160]
    ]];
}

-(void)configMakeNewRecordButton {
    self.makeNewRecordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.makeNewRecordButton.backgroundColor = [UIColor whiteColor];
    [self.makeNewRecordButton setTitle:@"Make a new record" forState:UIControlStateNormal];
    [self.makeNewRecordButton setTitleColor:[UIColor colorWithRed:64.0/255.0 green:180.0/255.0 blue:195.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    self.makeNewRecordButton.titleLabel.font = [UIFont systemFontOfSize:16];
    self.makeNewRecordButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.makeNewRecordButton addTarget:self action:@selector(makeNewRecordButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    self.makeNewRecordButton.layer.borderWidth = 1;
    self.makeNewRecordButton.layer.cornerRadius = 5;
    self.makeNewRecordButton.layer.borderColor = [UIColor colorWithRed:64.0/255.0 green:180.0/255.0 blue:195.0/255.0 alpha:1.0].CGColor;
    [self.view addSubview:self.makeNewRecordButton];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.makeNewRecordButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.makeNewRecordButton.topAnchor constraintEqualToAnchor:self.audioLabel.bottomAnchor constant:160],
        [self.makeNewRecordButton.widthAnchor constraintEqualToConstant:170],
        [self.makeNewRecordButton.heightAnchor constraintEqualToConstant:40]
    ]];
}

-(void)makeNewRecordButtonTapped {
    [self recordButtonTapped];
    self.makeNewRecordButton.hidden = YES;
}

-(void)configRecordButton {
    self.recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.recordButton.backgroundColor = [UIColor colorWithRed:0.855 green:0.855 blue:0.855 alpha:1.0];
    self.recordButton.layer.cornerRadius = 74/2;
    self.recordButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.recordButton addTarget:self action:@selector(recordButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.recordButton];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.recordButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.recordButton.topAnchor constraintEqualToAnchor:self.timerLabel.bottomAnchor constant:16],
        [self.recordButton.widthAnchor constraintEqualToConstant:74],
        [self.recordButton.heightAnchor constraintEqualToConstant:76]
    ]];
    
    UIView *redDot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
    redDot.backgroundColor = [UIColor redColor];
    redDot.layer.cornerRadius = 5;
    redDot.center = CGPointMake(self.recordButton.bounds.size.width / 2, self.recordButton.bounds.size.height / 2);
    redDot.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.recordButton addSubview:redDot];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(recordButtonTapped)];
    [redDot addGestureRecognizer:tapGesture];
    redDot.userInteractionEnabled = YES;
}

- (void)recordButtonTapped {
    switch (self.recordButtonState) {
        case RecordButtonStateStartRecording:
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
            self.recordLabel.hidden = YES;
            self.recordButton.backgroundColor = [UIColor blueColor];
            [self startRecording];
            self.recordButtonState = RecordButtonStateStopRecording;
            break;
            
        case RecordButtonStateStopRecording:
            self.makeNewRecordButton.hidden = YES;
            [self.timer invalidate];
            self.timer = nil;
            self.seconds = 0;
            self.timerLabel.text = @"";
            self.recordButton.backgroundColor = [UIColor redColor];
            [self stopRecording];
            self.recordButtonState = RecordButtonStatePlayRecording;
            break;
            
        case RecordButtonStatePlayRecording:
            self.recordButton.backgroundColor = [UIColor colorWithRed:0.855 green:0.855 blue:0.855 alpha:1.0];
            [self playRecording];
            self.audioRecorder = nil;
            self.recordButtonState = RecordButtonStateStartRecording;
            break;
    }
}

-(void) startRecording {
    NSArray *path = [NSArray arrayWithObjects:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject], @"myRecording.wav", nil];
    NSURL *url = [NSURL fileURLWithPathComponents:path];
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    NSMutableDictionary *setting = [[NSMutableDictionary alloc] init];
    [setting setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    [setting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [setting setValue:[NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey];
    
    recorder = [[AVAudioRecorder alloc] initWithURL:url settings:setting error:nil];
    recorder.meteringEnabled = YES;
    [recorder prepareToRecord];
    [recorder record];
}

-(void) stopRecording {
    [recorder stop];
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:NO error:nil];
    [self configMakeNewRecordButton];
}

-(void) playRecording {
    if (!recorder.recording) {
        player = [[AVPlayer alloc] initWithURL:recorder.url];
        [player play];
    }
}

-(void)configTimerLabel {
    self.timerLabel = [[UILabel alloc] init];
    self.timerLabel.font = [UIFont systemFontOfSize:12];
    self.timerLabel.textAlignment = NSTextAlignmentCenter;
    self.timerLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.timerLabel];

    [NSLayoutConstraint activateConstraints:@[
        [self.timerLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.timerLabel.topAnchor constraintEqualToAnchor:self.recordLabel.bottomAnchor constant:32]
    ]];
}

- (void)updateTimer {
    self.seconds++;
    // Обновление отображения времени, например:
    self.timerLabel.text = [self formattedTimeFromSeconds:self.seconds];
}

- (NSString *)formattedTimeFromSeconds:(NSInteger)seconds {
    NSInteger minutes = (seconds / 60) % 60;
    NSInteger remainingSeconds = seconds % 60;
    return [NSString stringWithFormat:@"%02ld:%02ld", (long)minutes, (long)remainingSeconds];
}

- (void)configureBottomView {
    self.bottomView.hidden = YES;
    self.bottomView = [[UIView alloc] init];
    self.bottomView.backgroundColor = [UIColor colorWithRed:0.855 green:0.855 blue:0.855 alpha:1.0];
    self.bottomView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.bottomView];
    [self configureRedButton];
    [self configureGreenButton];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.bottomView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.bottomView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.bottomView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        [self.bottomView.heightAnchor constraintEqualToConstant:90]
    ]];
}

- (void)configureRedButton {
    self.redButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.redButton.layer.cornerRadius = 25;
    self.redButton.layer.borderWidth = 4;
    self.redButton.layer.borderColor = [UIColor redColor].CGColor;
    self.redButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.redButton addTarget:self action:@selector(redButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.redButton];
    
    UIImage *buttonImage = [UIImage imageNamed:@"result-cmn-error"];
    [self.redButton setImage:buttonImage forState:UIControlStateNormal];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.redButton.leadingAnchor constraintEqualToAnchor:self.bottomView.leadingAnchor constant:28],
        [self.redButton.centerYAnchor constraintEqualToAnchor:self.bottomView.centerYAnchor],
        [self.redButton.widthAnchor constraintEqualToConstant:50],
        [self.redButton.heightAnchor constraintEqualToConstant:50]
    ]];
}

- (void)redButtonTapped {
    [self configureResultView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (void)configureResultView {
    self.resultView = [[UIView alloc] init];
    self.resultView.backgroundColor = [UIColor grayColor];
    self.resultView.translatesAutoresizingMaskIntoConstraints = NO;
    self.resultView.layer.cornerRadius = 16;
    self.resultView.alpha = 0.8;
    [self.view addSubview:self.resultView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"result-error"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    imageView.tintColor = [UIColor redColor];
    [self.resultView addSubview:imageView];

    [NSLayoutConstraint activateConstraints:@[
        [self.resultView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.resultView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        [self.resultView.heightAnchor constraintEqualToConstant:141],
        [self.resultView.widthAnchor constraintEqualToConstant:141],
        [imageView.centerXAnchor constraintEqualToAnchor:self.resultView.centerXAnchor],
        [imageView.centerYAnchor constraintEqualToAnchor:self.resultView.centerYAnchor],
        [imageView.widthAnchor constraintEqualToConstant:77],
        [imageView.heightAnchor constraintEqualToConstant:74]
    ]];
}

- (void)configureGreenButton {
    self.greenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.greenButton.layer.cornerRadius = 25;
    self.greenButton.layer.borderWidth = 4;
    self.greenButton.layer.borderColor = [UIColor colorWithRed:0.0/255.0 green:222.0/255.0 blue:121.0/255.0 alpha:1.0].CGColor;
    self.greenButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.greenButton addTarget:self action:@selector(greenButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.greenButton];
    
    UIImage *buttonImage = [[UIImage imageNamed:@"result-cmn-ok"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.greenButton setImage:buttonImage forState:UIControlStateNormal];
    [self.greenButton setTintColor:[UIColor colorWithRed:0.0/255.0 green:222.0/255.0 blue:121.0/255.0 alpha:1.0]];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.greenButton.trailingAnchor constraintEqualToAnchor:self.bottomView.trailingAnchor constant:-28],
        [self.greenButton.centerYAnchor constraintEqualToAnchor:self.bottomView.centerYAnchor],
        [self.greenButton.widthAnchor constraintEqualToConstant:50],
        [self.greenButton.heightAnchor constraintEqualToConstant:50]
    ]];
}

- (void)greenButtonTapped {
    self.bottomView.hidden = YES;
    self.progressView.hidden = YES;

    if(self.audioPlayer.play) {
        [self.audioPlayer stop];
    }
    
    self.playButton.hidden = YES;

    [self configRecordLabel];
    [self configTimerLabel];
    [self configRecordButton];
}

@end
