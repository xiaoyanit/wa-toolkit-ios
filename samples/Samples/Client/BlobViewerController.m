/*
 Copyright 2010 Microsoft Corp
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import "BlobViewerController.h"
#import "Azure_Storage_ClientAppDelegate.h"

@implementation BlobViewerController

@synthesize blobImageView;
@synthesize blob;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [blobImageView release];
	[storageClient release];
	[blob release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{

	Azure_Storage_ClientAppDelegate		*appDelegate = (Azure_Storage_ClientAppDelegate *)[[UIApplication sharedApplication] delegate];

    [super viewDidLoad];

	storageClient = [[WACloudStorageClient storageClientWithCredential:appDelegate.authenticationCredential] retain];
	if ([blob.name hasSuffix:@"png"] || [blob.name hasSuffix:@"jpg"] || [blob.name hasSuffix:@"jpeg"])
	{
		[storageClient fetchBlobData:self.blob withCompletionHandler:^(NSData *imgData, NSError *error)
		{
			UIImage *blobImage = [UIImage imageWithData:imgData];
			self.blobImageView.image = blobImage;
		}];
	}
}

- (void)viewWillDisappear:(BOOL)animated
{
    storageClient.delegate = nil;
}

- (void)viewDidUnload
{
    self.blobImageView = nil;;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
