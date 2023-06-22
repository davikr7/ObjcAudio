//
//  ViewController.m
//  ObjcAudio
//
//  Created by David on 09.06.23.
//

#import "ViewController.h"
#import "SecondViewController.h"
#import "AudioRecorder.h"

@interface ViewController ()

@property (nonatomic, assign) BOOL isComparisonVoiceSelected;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5; // Количество элементов в таблице
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    //self.showResultCircle = NO;
    
    
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Vibro";
            break;
        case 1:
            cell.textLabel.text = @"Loud Speaker";
            break;
        case 2:
            cell.textLabel.text = @"Speaker";
            break;
        case 3:
            cell.textLabel.text = @"Comparison Voice";
            break;
        case 4:
            cell.textLabel.text = @"Microphones";
            break;
        default:
            break;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) { // Comparison Voice
        SecondViewController *secondViewController = [[SecondViewController alloc] init];
        [self.navigationController pushViewController:secondViewController animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
