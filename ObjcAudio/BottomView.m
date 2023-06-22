//
//  BottomView.m
//  ObjcAudio
//
//  Created by David on 19.06.23.
//

#import "BottomView.h"
#import "SecondViewController.h"

@implementation BottomView

- (instancetype)init {
    self = [super init];
    if (self) {
        // Выполнение настроек для вашей кастомной вьюхи
        [self configureBottomView];
    }
    return self;
}

- (void)configureBottomView {
    self.bottomView = [[UIView alloc] init];
    self.bottomView.backgroundColor = [UIColor colorWithRed:0.855 green:0.855 blue:0.855 alpha:1.0];
    self.bottomView.translatesAutoresizingMaskIntoConstraints = NO;
    [self configureRedButton];
    [self configureGreenButton];
    
}

- (void)configureRedButton {
    // Дополнительные настройки для вашей красной кнопки
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

@end
