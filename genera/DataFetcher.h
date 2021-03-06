
/*
 Copyright (c) 2011 Museum Victoria
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import <Foundation/Foundation.h>


@interface DataFetcher : NSObject {
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
}

// Returns the 'singleton' instance of this class
+ (id)sharedInstance;


// Checks to see if any database exists on disk
- (BOOL)databaseExists;

// Returns the NSManagedObjectContext for inserting and fetching objects into the store
- (NSManagedObjectContext *)managedObjectContext;

// Returns an array of objects from the database for the given Entity Name and Predicate
- (NSArray *)fetchManagedObjectsForEntity:(NSString*)entityName withPredicate:(NSPredicate*)predicate;

// Returns a array of objects from the database for the given Entity Name and Predicate, sorted on the a given field
- (NSArray *)fetchManagedObjectsForEntity:(NSString*)entityName withPredicate:(NSPredicate*)predicate withSortField:(NSString*)sortField;

// Returns an NSFetchedResultsController for a given Entity Name and Predicate
- (NSFetchedResultsController *)fetchedResultsControllerForEntity:(NSString*)entityName withPredicate:(NSPredicate*)predicate sortField:(NSString*) fieldName;

//Returns an NSFetchedResultsController for a given Entity Name, Predicate and sectionNameKeyPath 
- (NSFetchedResultsController *)fetchedResultsControllerForEntity:(NSString*)entityName withPredicate:(NSPredicate*)predicate sortField:(NSString*)fieldName sectionNameKeyPath:(NSString*)keyPath;

- (void)deleteDatabase; 

@end
