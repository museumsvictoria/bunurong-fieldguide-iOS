//
//  AudioListViewController.m
//  Field Guide 2010
//
//  Created by Simon Sherrin on 27/11/10.
/*
 Copyright (c) 2011 Museum Victoria
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
//

#import "AudioSoundboardViewController.h"
#import "Audio.h"
#import "Speci.h"
#import "iPhoneDetailViewController.h"
#import "DetailViewController.h"
@implementation AudioSoundboardViewController


@synthesize audioFilesArray;
@synthesize player, fileRowLocations, activeTrack, inactiveTrack;
@synthesize managedObjectContext  = _managedObjectContext;
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize rightViewReference = _rightViewReference;
#pragma mark -
#pragma mark View lifecycle



- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationController.navigationBar.translucent = NO;
	self.fileRowLocations = [NSMutableDictionary dictionaryWithCapacity:5];
	self.tableView.bounces = YES; //Stops scrolling of the contents

	inactiveTrack = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AudioTrackInactive.png"] highlightedImage:[UIImage imageNamed:@"AudioTrackHighlightInactive.png"]];
	

	UIImage *activeImageNormal = [UIImage imageNamed:@"AudioTrackActive3.png"];
	UIImage *activeImageHighlight = [UIImage imageNamed:@"AudioTrackHighlightActive3.png"];
	activeTrack = [[UIImageView alloc] initWithImage:activeImageNormal	highlightedImage:activeImageHighlight];
	//Animation

	UIImage *activeImageNormal1 = [UIImage imageNamed:@"AudioTrackActive1.png"];
	UIImage *activeImageHighlight1 = [UIImage imageNamed:@"AudioTrackHighlightActive1.png"];
	
	

	UIImage *activeImageNormal2 = [UIImage imageNamed:@"AudioTrackActive2.png"];
	UIImage *activeImageHighlight2 =[UIImage imageNamed:@"AudioTrackHighlightActive2.png"];
	
	
	NSArray *activeNormalAnimation = [NSArray arrayWithObjects:activeImageNormal1, activeImageNormal2, activeImageNormal, nil];
	NSArray *activeHighlightAnimation = [NSArray arrayWithObjects:activeImageHighlight1, activeImageHighlight2, activeImageHighlight, nil];
    NSLog(@"Active Normal Animation: %d", [activeNormalAnimation count]);
	NSLog(@"Active Highlight Animation: %d ", [activeHighlightAnimation count]);
	activeTrack.animationImages = activeNormalAnimation;
	activeTrack.highlightedAnimationImages = activeHighlightAnimation;

}


- (CGSize)contentSizeForViewInPopover{
	
	//return self.view.bounds.size;

	if ([audioFilesArray count] >0) {
			return CGSizeMake(320, [audioFilesArray count]*43);
		NSLog(@"Called contentsize for popover");
	}else{
	return CGSizeMake(320,160);		
	}

}


- (void)viewWillAppear:(BOOL)animated {
	[self.tableView reloadData];
    [super viewWillAppear:animated];
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
   // return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}



#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    tableView.rowHeight = 75;
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	NSLog(@"Audio: Number of Rows in Section");
    //return [audioFilesArray count];
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
		NSLog(@"Audio: Number of Cell at Indexpath");
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];

    }
    
    // Configure the cell...
    
   // Audio *cellAudio = (Audio *) [audioFilesArray objectAtIndex:indexPath.row];
	Audio *cellAudio = (Audio *) [self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell textLabel].text = [cellAudio object].label;
    [cell textLabel].font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    [cell textLabel].textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    [cell detailTextLabel].text = [NSString stringWithFormat:NSLocalizedString(@"Credit: %@",nil),cellAudio.credit];
	[cell detailTextLabel].font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
	//[cell detailTextLabel].text = cellAudio.credit;
	NSLog(@"cell credit:%@", cellAudio.credit);
	

	[cell setBackgroundColor:[UIColor colorWithRed:.8 green:1 blue:1 alpha:1]];
	cell.imageView.image = inactiveTrack.image;
	cell.imageView.highlightedImage = inactiveTrack.highlightedImage;
	cell.accessoryType =UITableViewCellAccessoryDetailDisclosureButton;
	
	return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{

	//NSArray *speciInSection = [sectionsArray objectAtIndex:indexPath.section];
	
	// Configure the cell with the time zone's name.
	Speci *tmpSpeci = (Speci *)[(Audio *)[self.fetchedResultsController objectAtIndexPath:indexPath] object];
	
    //Handler has been built to deal with being used in iPad or iPhone. Currently only used on iPhone.
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		
	{
		
		_rightViewReference.detailSpeci = tmpSpeci;
		
	}	else{
		
		//New iPhone View
		iPhoneDetailViewController *detailViewController = [[iPhoneDetailViewController alloc] initWithNibName:@"iPhoneDetailViewController" bundle:nil];
		detailViewController.detailSpeci = tmpSpeci;
		detailViewController.title = tmpSpeci.label;
		[self.navigationController pushViewController:detailViewController animated:YES];
		[detailViewController release];
	}
	

}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	//Play Audio if Row Selected
	//28th Nov One Audio player for view.

	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	cell.imageView.image = activeTrack.image;
	cell.imageView.highlightedImage = activeTrack.highlightedImage;
	cell.imageView.animationImages = activeTrack.animationImages;
	cell.imageView.highlightedAnimationImages = activeTrack.highlightedAnimationImages;
	cell.imageView.animationDuration = 1;
	[cell.imageView startAnimating];
	NSLog(@"AnimationCellCount:%d", [cell.imageView.animationImages count]);
	//Audio *selectedAudio = [audioFilesArray objectAtIndex:indexPath.row];
	Audio *selectedAudio = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSLog(@"selectedAudio:%@", selectedAudio.filename);
	[self.fileRowLocations setObject:indexPath forKey:selectedAudio.filename];
	NSLog(@"After fileRowLocations");
	 [self playAudio:selectedAudio];

}
#pragma mark -

#pragma mark AudioHandling
- (BOOL)playAudio:(Audio *) selectedAudio
{
	
	NSError *error;
	NSString *tmpAudioLocation;

		//Need to stop current audio being played multiple times
		
		tmpAudioLocation = [[NSBundle mainBundle] pathForResource:[[selectedAudio filename] stringByDeletingPathExtension] ofType:@"mp3"];
		if (![[NSFileManager defaultManager] fileExistsAtPath:tmpAudioLocation]) return NO;
		NSLog(@"Audio location %@", tmpAudioLocation);
		if (self.player !=nil) {
			//Exisiting player in place, set delegate to nil
			self.player.delegate = nil;
		}
		self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:tmpAudioLocation] error:&error];
		if (!self.player)
		{
			NSLog(@"Error: %@", [error localizedDescription]);
			return NO;
		}
		self.player.delegate = self;
		[self.player prepareToPlay];
		[self.player play];
		NSLog(@"After player prepare");
		return YES;
	
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)passedplayer successfully:(BOOL)flag
{
	NSLog(@"Player Finished Playing");
	NSURL *tmpURL = passedplayer.url;
	NSLog(@"Player URL:%@",[tmpURL lastPathComponent]);

	UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:(NSIndexPath *)[self.fileRowLocations objectForKey:[tmpURL lastPathComponent]]];
	[cell.imageView stopAnimating];
	cell.imageView.image = inactiveTrack.image;
	cell.imageView.highlightedImage = inactiveTrack.highlightedImage;
	[cell setNeedsDisplay];
}


- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    // Set up the fetched results controller.
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Audio" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"filename" ascending:YES] autorelease];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    
    //Set up predicate
 //   NSString *searchTerm = [NSString stringWithFormat:@"group.label ='%@'",__selectedGroup.label];
 //   NSLog(@"Seleced Group %@", __selectedGroup.label);
//	NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:searchTerm];
    
 //   [fetchRequest setPredicate:searchPredicate];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext  sectionNameKeyPath:nil cacheName:@"audiofiles"] autorelease];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	    /*
	     Replace this implementation with code to handle the error appropriately.
         
	     abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	     */
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}  



#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
	player.delegate = nil;
	NSLog(@"View did unload");
}


- (void)dealloc {
	NSLog(@"AudioListDealloc");
	player.delegate = nil;
	[fileRowLocations release];
	[activeTrack release];
	[inactiveTrack release];
	[audioFilesArray release];
	[player release];
    [super dealloc];
}


@end

