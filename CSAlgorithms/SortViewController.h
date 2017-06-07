//
//  SortViewController.h
//  CSAlgorithms
//
//  Created by Miguel Angel Adan Roman on 2/6/17.
//

#import <UIKit/UIKit.h>
#import "Definitions.h"
#import "Sort.h"

@interface SortViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) Sort *sortAlgorithm;

@end
