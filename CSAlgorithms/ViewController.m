//
//  ViewController.m
//  CSAlgorithms
//
//  Created by Miguel Ángel Adán on 2/6/17.
//

#import "ViewController.h"
#import "SortViewController.h"
#import "AlgorithmNameTableViewCell.h"
#import "Definitions.h"
#import "Sort.h"
#import "SimpleHeaderView.h"
#import "NSObject+ClassName.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray<Sort *> *sortingAlgorithms;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 50.0;
    [self.tableView registerNib:[UINib nibWithNibName:[SimpleHeaderView className] bundle:nil] forHeaderFooterViewReuseIdentifier:[SimpleHeaderView className]];
    
    self.sortingAlgorithms = @[
        [[Sort alloc] initWithName:@"Sort using comparator" type:kSortTypeComparator],
        [[Sort alloc] initWithName:@"Bubble sort" type:kSortTypeBubbleSort],
        [[Sort alloc] initWithName:@"Selection sort" type:kSortTypeSelectionSort],
        [[Sort alloc] initWithName:@"Insertion sort" type:kSortTypeInsertionSort],
        [[Sort alloc] initWithName:@"Merge sort" type:kSortTypeMergeSort],
        [[Sort alloc] initWithName:@"Quick sort" type:kSortTypeQuickSort]
    ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toSortViewController"]) {
        NSIndexPath *indexPath = (NSIndexPath *) sender;
        SortViewController *sortViewController = segue.destinationViewController;
        sortViewController.title = self.sortingAlgorithms[indexPath.row].name;
        sortViewController.sortAlgorithm = self.sortingAlgorithms[indexPath.row];
    }
}


#pragma mark UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sortingAlgorithms.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AlgorithmNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[AlgorithmNameTableViewCell className] forIndexPath:indexPath];
    cell.algorithmName.text = self.sortingAlgorithms[indexPath.row].name;
    
    return cell;
}

#pragma mark UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self performSegueWithIdentifier:@"toSortViewController" sender:indexPath];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    SimpleHeaderView *headerView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:[SimpleHeaderView className]];
    headerView.headerTitle.text = @"SORTING";
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}



@end
