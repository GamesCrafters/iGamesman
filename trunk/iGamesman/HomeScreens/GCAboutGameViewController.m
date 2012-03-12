//
//  GCAboutGameViewController.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 1/4/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import "GCAboutGameViewController.h"


@interface GCAboutGameViewController ()
{
    /* Private XML parsing variables */
    NSMutableArray *_dictionaryStack;
    NSMutableArray *_tagStack;
    NSString *_currentText;
}

@end



@implementation GCAboutGameViewController

#pragma mark -

- (void) done
{
    [self dismissModalViewControllerAnimated: YES];
}


- (void) populateScreen
{
    NSString *title = [NSString stringWithFormat: @"About %@", [_gameData objectForKey: @"name"]];
    [[self navigationItem] setTitle: title];
}


#pragma mark - Memory lifecycle

- (id) initWithXMLPath: (NSString *) pathToXML
{
    self = [super init];
    
    if (self)
    {
        NSString *string = [[[NSString alloc] initWithContentsOfFile: pathToXML encoding: NSUTF8StringEncoding error: nil] autorelease];
        NSData *xmlData = [string dataUsingEncoding: NSUTF8StringEncoding];
        
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData: xmlData];
        [parser setDelegate: self];
        
        [parser parse];
    }
    
    return self;
}


- (void) dealloc
{
    [super dealloc];
}


#pragma mark - View lifecycle

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone target: self action: @selector(done)];
    [[self navigationItem] setLeftBarButtonItem: doneButton];
    [doneButton release];
}


- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}


#pragma mark - NSXMLParserDelegate

- (void) addObject: (id) object asChildOfDictionary: (NSMutableDictionary *) parent forKey: (NSString *) key
{
    if ([[parent allKeys] containsObject: key])
    {
        for (int i = 1; ; i += 1)
        {
            NSString *newKey = [NSString stringWithFormat: @"%@-%d", key, i];
            if (![[parent allKeys] containsObject: newKey])
            {
                [parent setObject: object forKey: newKey];
                break;
            }
        }
    }
    else
    {
        [parent setObject: object forKey: key];
    }
}


- (void) parserDidStartDocument: (NSXMLParser *) parser
{
    _dictionaryStack = [[NSMutableArray alloc] init];
    [_dictionaryStack addObject: [NSMutableDictionary dictionary]];
    _tagStack = [[NSMutableArray alloc] init];
}


- (void) parser: (NSXMLParser *) parser 
didStartElement: (NSString *) elementName
   namespaceURI: (NSString *) namespaceURI
  qualifiedName: (NSString *) qName
     attributes: (NSDictionary *) attributeDict
{
    [_dictionaryStack addObject: [NSMutableDictionary dictionary]];
    [_tagStack addObject: elementName];
    _currentText = @"";
}


- (void) parser: (NSXMLParser *) parser foundCharacters: (NSString *) string
{
    string = [string stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    _currentText = [_currentText stringByAppendingString: string];
}


- (void) parser: (NSXMLParser *) parser
  didEndElement: (NSString *) elementName
   namespaceURI: (NSString *) namespaceURI
  qualifiedName: (NSString *) qName
{
    if ([_currentText isEqualToString: @""])
    {
        NSDictionary *currentDictionary = [[_dictionaryStack lastObject] retain];
        [_dictionaryStack removeLastObject];
        
        NSMutableDictionary *parentDictionary = [_dictionaryStack lastObject];
        [self addObject: currentDictionary asChildOfDictionary: parentDictionary forKey: elementName];
        
        [currentDictionary release];
    }
    else
    {
        [_dictionaryStack removeLastObject];
        
        NSMutableDictionary *parentDictionary = [_dictionaryStack lastObject];
        [self addObject: _currentText asChildOfDictionary: parentDictionary forKey: elementName];
    }
    
    [_tagStack removeLastObject];
    
    _currentText = @"";
}


- (void) parserDidEndDocument: (NSXMLParser *) parser
{
    [parser release];
    
    _gameData = [[[_dictionaryStack lastObject] objectForKey: @"game"] retain];
    
    NSLog(@"%@", _gameData);
    
    [_dictionaryStack release];
    [_tagStack release];
    
    [self populateScreen];
}

@end
