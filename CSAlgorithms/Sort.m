//
//  Sort.m
//  CSAlgorithms
//
//  Created by Miguel Angel Adan Roman on 3/6/17.
//  Copyright © 2017 Avantiic. All rights reserved.
//

#import "Sort.h"

@implementation Sort

-(instancetype)initWithName:(NSString *)name type:(SortType)type {
    
    self = [super init];
    if(self) {
        self.name = name;
        self.type = type;
    }
    
    return self;
}

-(void) sortUsingComparator:(NSArray *) arrayToSort completed:(SortCompletionBlock) completed {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSArray *sorted = [self sortUsingComparator:arrayToSort];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(completed) {
                completed(sorted);
            }
        });
    });
}

-(NSArray *) sortUsingComparator:(NSArray *) arrayToSort {
    NSArray *sorted = [arrayToSort sortedArrayUsingComparator:^NSComparisonResult(NSNumber *number1, NSNumber *number2) {
        if(number1.integerValue < number2.integerValue) {
            return NSOrderedAscending;
        } else if(number1.integerValue > number2.integerValue) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    }];
    
    return sorted;
}

-(NSArray *) bubblesort: (NSArray *) arrayToSort {
    
    NSMutableArray<NSNumber *> *sorted = [[NSMutableArray alloc] initWithArray:arrayToSort];
    
    NSInteger totalIterations = 0;
    
    for (NSInteger i = 0; i < arrayToSort.count; i++ ) {
        for (NSInteger j=0; j < arrayToSort.count-1; j++) {
            totalIterations += 1;
            
            NSNumber *tmp;
            if (sorted[j+1].integerValue < sorted[j].integerValue) {
                tmp = sorted[j];
                sorted[j] = sorted[j+1];
                sorted[j+1] = tmp;
            }
        }
    }
    
    return sorted;
}

-(void) bubblesort:(NSArray *) arrayToSort completed:(SortCompletionBlock) completed {
    NSMutableArray<NSNumber *> *sorted = [[NSMutableArray alloc] initWithArray:arrayToSort];
    
    dispatch_queue_t dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //With this we send the global iteration to de background.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        for (NSInteger i = 0; i < arrayToSort.count; i++ ) {
            
            //With this we take advantage of multiple cores if available
            dispatch_async(dispatchQueue, ^{
                for (NSInteger j=0; j < arrayToSort.count-1; j++) {
                    NSNumber *tmp;
                    if (sorted[j+1].integerValue < sorted[j].integerValue) {
                        tmp = sorted[j];
                        sorted[j] = sorted[j+1];
                        sorted[j+1] = tmp;
                    }
                }
            });
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completed) {
                completed(sorted);
            }
        });
    });
}

-(void) selectionsort: (NSArray *) arrayToSort completed:(SortCompletionBlock) completed {
    NSMutableArray *sorted = [[NSMutableArray alloc] initWithArray:arrayToSort];
    
    dispatch_queue_t dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        for (NSInteger i=0; i<arrayToSort.count; i++) {
            
            dispatch_async(dispatchQueue, ^{
            
                NSNumber *min = sorted[i];
                NSNumber *minIndex = @(-1);
                
                for (NSInteger j=i+1; j<arrayToSort.count; j++) {
                    if (sorted[j] < min) {
                        min = sorted[j];
                        minIndex = @(j);
                    }
                }
                
                if(minIndex.integerValue != -1) {
                    sorted[minIndex.integerValue] = sorted[i];
                    sorted[i] = min;
                }
            });
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completed) {
                completed(sorted);
            }
        });
    });
}


-(NSArray *) selectionsort: (NSArray *) arrayToSort {
    
    NSMutableArray *sorted = [[NSMutableArray alloc] initWithArray:arrayToSort];
    
    for (NSInteger i=0; i<arrayToSort.count; i++) {
        NSNumber *min = sorted[i];
        NSNumber *minIndex = @(-1);
        for (NSInteger j=i+1; j<arrayToSort.count; j++) {
            if (sorted[j] < min) {
                min = sorted[j];
                minIndex = @(j);
            }
        }
        
        if(minIndex.integerValue != -1) {
            sorted[minIndex.integerValue] = sorted[i];
            sorted[i] = min;
        }
    }
    
    return sorted;
}

-(NSArray *) insertionsort: (NSArray *) arrayToSort {
    
    return @[];
}


-(NSArray *) mergesort: (NSArray *) arrayToSort {
    if (arrayToSort.count < 2) {
        return arrayToSort;
    }
    
    NSInteger middle = arrayToSort.count/2;
    NSArray *left = [arrayToSort subarrayWithRange:NSMakeRange(0, middle)];
    NSArray *right = [arrayToSort subarrayWithRange:NSMakeRange(middle, arrayToSort.count-middle)];
    
    NSArray *leftArray = [self mergesort:left];
    NSArray *rightArray = [self mergesort:right];
    
    NSArray *mergedArray = [self mergeLeftArray: leftArray rightArray:rightArray];
    
    return mergedArray;
    
}

-(NSArray *) mergeLeftArray:(NSArray<NSNumber *> *) leftArray rightArray:(NSArray<NSNumber *> *) rightArray {
    NSMutableArray *result = [NSMutableArray array];
    NSInteger right = 0;
    NSInteger left = 0;
    while (left < leftArray.count && right < rightArray.count) {
        if (leftArray[left].integerValue < rightArray[right].integerValue) {
            [result addObject:leftArray[left++]];
        } else {
            [result addObject:rightArray[right++]];
        }
    }
    
    NSRange leftRange = NSMakeRange(left, leftArray.count - left);
    NSRange rightRange = NSMakeRange(right, rightArray.count - right);
    
    NSArray *newRight = [rightArray subarrayWithRange:rightRange];
    NSArray *newLeft = [leftArray subarrayWithRange:leftRange];
    
    newLeft = [result arrayByAddingObjectsFromArray:newLeft];
    
    NSArray *mergedArray = [newLeft arrayByAddingObjectsFromArray:newRight];
    
    return mergedArray;
}

-(NSArray *) quicksort: (NSArray *) arrayToSort queue:(dispatch_queue_t) queue {
    
    if (arrayToSort.count <= 1) {
        return arrayToSort;
    }
    
    NSMutableArray *mutableToSort = [[NSMutableArray alloc] initWithArray:arrayToSort];
    
    NSNumber *pivot = arrayToSort[arrayToSort.count / 2];
    [mutableToSort removeObjectAtIndex:arrayToSort.count / 2];
    
    
    NSMutableArray *less = [NSMutableArray array];
    NSMutableArray *greater = [NSMutableArray array];
    
    for (NSNumber *v in mutableToSort) {
        if(v.integerValue < pivot.integerValue) {
            [less addObject:v];
        } else {
            [greater addObject:v];
        }
    }
    
    NSMutableArray *sorted = [NSMutableArray array];
    [sorted addObjectsFromArray:[self quicksort:less queue:queue]];
    [sorted addObject:pivot];
    [sorted addObjectsFromArray:[self quicksort:greater queue:queue]];
    
    return sorted;
}

-(NSArray *) quicksort: (NSArray *) arrayToSort {
    
    if (arrayToSort.count <= 1) {
        return arrayToSort;
    }
    
    NSMutableArray *mutableToSort = [[NSMutableArray alloc] initWithArray:arrayToSort];
    
    NSNumber *pivot = arrayToSort[arrayToSort.count / 2];
    [mutableToSort removeObjectAtIndex:arrayToSort.count / 2];
    
    NSMutableArray *less = [NSMutableArray array];
    NSMutableArray *greater = [NSMutableArray array];
    for (NSNumber *v in mutableToSort) {
        if(v.integerValue < pivot.integerValue) {
            [less addObject:v];
        } else {
            [greater addObject:v];
        }
    }
    
    NSMutableArray *sorted = [NSMutableArray array];
    [sorted addObjectsFromArray:[self quicksort:less]];
    [sorted addObject:pivot];
    [sorted addObjectsFromArray:[self quicksort:greater]];
    
    return sorted;
}

//https://stackoverflow.com/questions/5394647/asynchronously-dispatched-recursive-blocks
dispatch_block_t RecursiveBlock(void (^block)(dispatch_block_t recurse)) {
    return ^{ block(RecursiveBlock(block)); };
}


@end
