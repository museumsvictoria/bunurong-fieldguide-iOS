//
//  CustomSearchViewController.m
//  Field Guide 2010
//
//  Created by Simon Sherrin on 10/01/11.
/*
 Copyright (c) 2011 Museum Victoria
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
//

#import "DataFetcher.h"
#import "Group.h"
#import "Speci.h"
#import "Image.h"
#import "CustomSearchViewController.h"
#import "DetailViewController.h"
#import "iPhoneDetailViewController.h"


@implementation CustomSearchViewController

	@synthesize searchBar;
	@synthesize tableView;
	@synthesize searchResults;
	@synthesize rightViewReference;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	 [super viewDidLoad];
	searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    searchBar.placeholder = NSLocalizedString(@"Search for an item", @"Search for an item");
	
   
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	self.navigationController.navigationBar.translucent	= NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	self.navigationController.navigationBar.translucent	= NO;
}

#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)mytableView {
    // Return the number of sections.
	mytableView.rowHeight = 75;
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.

	if (self.searchResults == nil) {
	//	NSLog(@"Search Count = 1");
		return 0;
		
	}else {
	//	NSLog(@"SearchResults:%d", [self.searchResults count]);
		return [self.searchResults count];
		//	return 1;	
	}
	
	
	
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)thistableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   // NSLog(@"Cell for Row");
	
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [thistableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
	NSLog(@"Search Results in Cell: %d", [self.searchResults count]);
		if (self.searchResults != nil){
	 // Configure the cell...
	 NSLog(@"In Cell configuration");
	 Speci *managedSpeci = (Speci *)[self.searchResults objectAtIndex:indexPath.row] ;
            [cell textLabel].text = [managedSpeci label];
            [cell textLabel].font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
            [cell textLabel].textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
            [cell detailTextLabel].text = [managedSpeci sublabel];
            if ([managedSpeci.labelStyle isEqualToString:@"italic"]) {
                [cell textLabel].font = [UIFont fontWithName:@"Helvetica-Oblique" size:16];
            }
            NSLog(@"SubLabelStyle:%@",managedSpeci.sublabelStyle);
            if ([managedSpeci.sublabelStyle isEqualToString:@"italic"]) {
                NSLog(@"italicSection");
                [cell detailTextLabel].font = [UIFont fontWithName:@"Helvetica-Oblique" size:14];
                [cell detailTextLabel].textColor = [UIColor colorWithRed:0.258 green:.258 blue:.258 alpha:1];	
            } else
            {
                [cell detailTextLabel].font = [UIFont fontWithName:@"Helvetica" size:14];
                [cell detailTextLabel].textColor = [UIColor colorWithRed:0.258 green:.258 blue:.258 alpha:1];	
            }
            
            NSString *path = [[NSBundle mainBundle] pathForResource:[managedSpeci.squareThumbnail stringByDeletingPathExtension] ofType:@"jpg"];
            
            UIImage *theImage;
            if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                theImage = [UIImage imageWithContentsOfFile:path];
                
            } else {
                theImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"missingthumbnail" ofType:@"jpg"]];
            }
            
            
            cell.imageView.image = theImage;  	 }
	 else {
         // NSLog(@"Initial Search Cell");
         cell.textLabel.text = NSLocalizedString(@"Search for items",@"Search for items");
	}
	
	return cell;
}

#pragma mark -
#pragma mark Table view delegate

-(NSIndexPath *) tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//	NSLog(@"WillSelectRow");
	if (letUserSelectRow) {
		return indexPath;
	}else {
		return nil;
	}
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //This Controller used by iPad and iPhone interfaces -
    //iPhone Pops on the Navigation Controller, iPad puts the Animal into the right view reference.
	Speci *tmpSpeci  = (Speci *)[self.searchResults objectAtIndex:indexPath.row];	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		
	{

		rightViewReference.detailSpeci = tmpSpeci;
		
	}	else{

		//New iPhone View
		iPhoneDetailViewController *detailViewController = [[iPhoneDetailViewController alloc] initWithNibName:@"iPhoneDetailViewController" bundle:nil];
		detailViewController.detailSpeci = tmpSpeci;
		detailViewController.title = tmpSpeci.label;
		[self.navigationController pushViewController:detailViewController animated:YES];
		[detailViewController release];
	}
	
	
}
#pragma mark -
#pragma mark SearchHandling

-(void) searchBarTextDidBeginEditing: (UISearchBar *) theSearchBar
{
	NSLog(@"SearchBarTextDidBeginEditing");
	searching = YES;
	letUserSelectRow = YES;
	self.tableView.scrollEnabled = YES;
	[self.searchBar setShowsCancelButton:YES animated:YES];
}

- (void) searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText{
	NSLog(@"Search Text Did Change");
	//[searchResults removeAllObjects];
	
	if ([searchText length] > 0) {
		searching = YES;
		letUserSelectRow = YES;
		[self searchSpeci];
	}
	else {
		searching = NO;
		letUserSelectRow = NO;
		self.tableView.scrollEnabled = YES;
		self.searchResults = [NSArray array];
	}
	
	[self.tableView reloadData];
}


- (void) searchBarSearchButtonClicked:(UISearchBar *) theSearchBar{

	[theSearchBar setShowsCancelButton:NO animated:YES];
	[searchBar resignFirstResponder];
	letUserSelectRow = YES;
	searching = NO;
	self.tableView.scrollEnabled = YES;
	
}

-(void) searchBarCancelButtonClicked:(UISearchBar *) theSearchBar{
	[theSearchBar setShowsCancelButton:NO animated:YES];
	[searchBar resignFirstResponder];
	letUserSelectRow = YES;
	searching = NO;
	self.tableView.scrollEnabled = YES;
	
}
- (void) searchSpeci {
	
    
    
	NSArray *searchTerms = [[searchBar.text stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@" "]] componentsSeparatedByString:@" "];
	NSMutableString *searchString = [NSMutableString stringWithCapacity:1];
    
    //Potentially better search can be constructed. Need to search across Name, Common Names, Genus and Species for an Animal
    //Searches is always "AND" for words in the search list.
    //	NSLog(@"searchTerms Count:%d", [searchTerms count]);
	
    
   [searchString appendString: [NSString stringWithFormat:@"(searchText MATCHES[c] \"(.* )?%@.*\"", [[searchTerms objectAtIndex:0]stringByReplacingOccurrencesOfString:@"\"" withString:@" "]]];
    //[searchString appendString: [NSString stringWithFormat:@"(searchText CONTAINS[c] \" %@\"", [[searchTerms objectAtIndex:0] stringByReplacingOccurrencesOfString:@"\"" withString:@" "]]];
	if ([searchTerms count] > 1) {
		//build or statements
		for (int i = 1; i < [searchTerms count]; i++) {
			[searchString appendString: [NSString stringWithFormat:@" AND searchText MATCHES[c] \"(.* )?%@.*\"", [[searchTerms objectAtIndex:i]stringByReplacingOccurrencesOfString:@"\"" withString:@" "]]];
         //   [searchString appendString: [NSString stringWithFormat:@" AND searchText CONTAINS[c] \" %@\"", [[searchTerms objectAtIndex:i] stringByReplacingOccurrencesOfString:@"\"" withString:@" "]]];
		}
	}
	
	[searchString appendString:@")"];
	
	
	
	NSString *searchTerm = [NSString stringWithString:searchString];
	NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:searchTerm];

	self.searchResults = [[DataFetcher sharedInstance] fetchManagedObjectsForEntity:@"Speci" withPredicate:searchPredicate withSortField:@"label"];

}

- (void) doneSearching_Clicked:(id) sender{
	NSLog(@"doneSearching");

	[searchBar resignFirstResponder];
	letUserSelectRow = YES;
	searching = NO;

	self.tableView.scrollEnabled = YES;
	

	
}

- (CGSize)contentSizeForViewInPopover{
	
	return CGSizeMake(320,480);		
}

#pragma mark -

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
