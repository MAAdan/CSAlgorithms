//
//  SortViewController.m
//  CSAlgorithms
//
//  Created by Miguel Angel Adan Roman on 2/6/17.
//

#import <Foundation/Foundation.h>
#import "SortViewController.h"
#import "SortedTableViewCell.h"
#import "NSObject+ClassName.h"

@interface SortViewController ()

@property (weak, nonatomic) IBOutlet UITextField *totalElementsInput;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UISegmentedControl *syncOrAsync;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSNumberFormatter *numberFormatter;

@property (strong, nonatomic) NSArray<NSNumber *> *sortedArray;
@property (weak, nonatomic) IBOutlet UILabel *completedInTime;

@end

@implementation SortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.numberFormatter = [[NSNumberFormatter alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {
    NSLog(@"SortViewController dealloc");
}

- (IBAction)didSelectCreateAndSortButton:(id)sender {
    
    [self.activityIndicator startAnimating];
    
    if (self.syncOrAsync.selectedSegmentIndex == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Warning" message:@"Sorting asynchronously will block the main thread" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Continue" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self createElementsArrayAndSort];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.activityIndicator stopAnimating];
        }];
        
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        [self createElementsArrayAndSort];
    }
}

- (void) sortAlgorithmCompleted:(NSDate *) startedDate {
    NSDate *endedDate = [NSDate date];
    self.completedInTime.text = [NSString stringWithFormat:@"Sorted in: %.03fs", [endedDate timeIntervalSinceDate:startedDate]];
    
    [self.activityIndicator stopAnimating];
    [self.tableView reloadData];
}

- (void)createElementsArrayAndSort {
    
    NSNumber *formatedNumber = [self.numberFormatter numberFromString:self.totalElementsInput.text];
    
    if (formatedNumber) {
        NSArray *arrayToSort = [self createRandomArrayWithTotalElements:formatedNumber.integerValue];
        
        NSDate *startedDate = [NSDate date];
        
        BOOL async = (self.syncOrAsync.selectedSegmentIndex == 1);
        
        switch (self.sortAlgorithm.type) {
            case kSortTypeComparator: {
                if(async) {
                    [self.sortAlgorithm sortUsingComparator:arrayToSort completed:^(NSArray *sorted) {
                        self.sortedArray = sorted;
                        [self sortAlgorithmCompleted:startedDate];
                    }];
                } else {
                    self.sortedArray = [self.sortAlgorithm sortUsingComparator:arrayToSort];
                    [self sortAlgorithmCompleted:startedDate];
                }
                break;
            }
            case kSortTypeBubbleSort: {
                if(async) {
                    [self.sortAlgorithm bubblesort:arrayToSort completed:^(NSArray *sorted) {
                        self.sortedArray = sorted;
                        [self sortAlgorithmCompleted:startedDate];
                    }];
                } else{
                    self.sortedArray = [self.sortAlgorithm bubblesort:arrayToSort];
                    [self sortAlgorithmCompleted:startedDate];
                }
                break;
            }
            case kSortTypeSelectionSort: {
                if (async) {
                    [self.sortAlgorithm selectionsort:arrayToSort completed:^(NSArray *sorted) {
                        self.sortedArray = sorted;
                        [self sortAlgorithmCompleted:startedDate];
                    }];
                } else {
                    self.sortedArray = [self.sortAlgorithm selectionsort:arrayToSort];
                    [self sortAlgorithmCompleted:startedDate];
                }
                break;
            }
            case kSortTypeInsertionSort:
                NSLog(@"Insertion");
                break;
            case kSortTypeMergeSort:
                if (async) {
                    
                } else {
                    self.sortedArray = [self.sortAlgorithm mergesort:arrayToSort];
                    [self sortAlgorithmCompleted:startedDate];
                }
                break;
            case kSortTypeQuickSort:
                if (async) {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        self.sortedArray = [self.sortAlgorithm quicksort:arrayToSort];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self sortAlgorithmCompleted:startedDate];
                        });
                    });
                } else {
                    self.sortedArray = [self.sortAlgorithm quicksort:arrayToSort];
                    [self sortAlgorithmCompleted:startedDate];
                }
                break;
            default:
                break;
        }
    }
}

-(NSArray *) createRandomArrayWithTotalElements: (NSInteger) totalElements {
    
    NSMutableArray *arrayToSort = [NSMutableArray array];
    for (NSInteger i=0; i<totalElements; i++) {
        NSInteger rand = arc4random_uniform(100000);
        [arrayToSort addObject:@(rand)];
    }
    
    return arrayToSort;
}

#pragma mark UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sortedArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SortedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[SortedTableViewCell className] forIndexPath:indexPath];
    cell.sortedValue.text = [NSString stringWithFormat:@"%ld", self.sortedArray[indexPath.row].integerValue];
    
    return cell;
    
}

#pragma mark UITableViewDelegate

@end
