//
//  Sort.h
//  CSAlgorithms
//
//  Created by Miguel Angel Adan Roman on 3/6/17.
//  Copyright © 2017 Avantiic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Definitions.h"

typedef void (^SortCompletionBlock)(NSArray *sorted);

@interface Sort : NSObject

@property (nonatomic) SortType type;
@property (strong, nonatomic) NSString *name;

-(instancetype) initWithName:(NSString *) name type: (SortType) type;

-(NSArray *) sortUsingComparator:(NSArray *) arrayToSort;
-(void) sortUsingComparator:(NSArray *) arrayToSort completed:(SortCompletionBlock) completed;
-(NSArray *) bubblesort: (NSArray *) arrayToSort;
-(void) bubblesort: (NSArray *) arrayToSort completed: (SortCompletionBlock) completion;
-(NSArray *) selectionsort: (NSArray *) arrayToSort;
-(void) selectionsort: (NSArray *) arrayToSort completed:(SortCompletionBlock) completed;

-(NSArray *) insertionsort: (NSArray *) arrayToSort;
-(NSArray *) mergesort: (NSArray *) arrayToSort;
-(NSArray *) quicksort: (NSArray *) arrayToSort;
-(NSArray *) quicksort: (NSArray *) arrayToSort queue:(dispatch_queue_t) queue;

@end
