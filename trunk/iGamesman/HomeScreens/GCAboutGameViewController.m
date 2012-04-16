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
    
    BOOL _showsDoneButton;
    
    CGRect _viewFrame;
}

@end



@implementation GCAboutGameViewController

#pragma mark -

- (void) done
{
    [self dismissModalViewControllerAnimated: YES];
}


/**
 * Populate the scroll view with game information
 */
- (void) populateScreen
{
    if (!_scroller)
        return;
    
    NSString *title = [NSString stringWithFormat: @"About %@", [_gameData objectForKey: @"name"]];
    [[self navigationItem] setTitle: title];
    
    
    CGFloat contentHeight = 20;
    CGFloat headerInset = 20;
    CGFloat detailInset = 40;
    CGFloat headerHeight = 20;
    CGFloat headerWidth = [[self view] bounds].size.width - 2 * headerInset;
    CGFloat detailWidth = [[self view] bounds].size.width - detailInset - headerInset;
    
    UIFont *headerFont = [UIFont boldSystemFontOfSize: 18.0f];
    UIFont *detailFont = [UIFont systemFontOfSize: 16.0f];
    UIColor *backgroundColor = [UIColor clearColor];
    UIColor *headerColor = [UIColor colorWithRed: 1.0f green: 214.0f / 255.0f blue: 0.0f alpha: 1.0f];
    UIColor *detailColor = [UIColor whiteColor];
    
    
    /* History */
    if ([[_gameData objectForKey: @"history"] isKindOfClass: [NSString class]])
    {
        UILabel *historyLabel = [[UILabel alloc] initWithFrame: CGRectMake(headerInset, contentHeight, headerWidth, headerHeight)];
        [historyLabel setBackgroundColor: backgroundColor];
        [historyLabel setTextColor: headerColor];
        [historyLabel setFont: headerFont];
        [historyLabel setText: @"History"];
        [_scroller addSubview: historyLabel];
        [historyLabel release];
        
        contentHeight += (headerHeight + 1);
        
        
        NSString *historyString = [_gameData objectForKey: @"history"];
        CGSize historySize = [historyString sizeWithFont: detailFont
                                       constrainedToSize: CGSizeMake(detailWidth, 10000)];
        UILabel *historyDetail = [[UILabel alloc] initWithFrame: CGRectMake(detailInset, contentHeight, detailWidth, historySize.height)];
        [historyDetail setBackgroundColor: backgroundColor];
        [historyDetail setTextColor: detailColor];
        [historyDetail setFont: detailFont];
        [historyDetail setLineBreakMode: UILineBreakModeWordWrap];
        [historyDetail setNumberOfLines: 1000];
        [historyDetail setText: historyString];
        [_scroller addSubview: historyDetail];
        [historyDetail release];
        
        contentHeight += (historySize.height + 10);
    }
    
    
    /* Board */
    if ([[_gameData objectForKey: @"board"] isKindOfClass: [NSString class]])
    {
        UILabel *boardLabel = [[UILabel alloc] initWithFrame: CGRectMake(headerInset, contentHeight, headerWidth, headerHeight)];
        [boardLabel setBackgroundColor: backgroundColor];
        [boardLabel setTextColor: headerColor];
        [boardLabel setFont: headerFont];
        [boardLabel setText: @"The Board"];
        [_scroller addSubview: boardLabel];
        [boardLabel release];
        
        contentHeight += (headerHeight + 1);
        
        
        NSString *boardString = [_gameData objectForKey: @"board"];
        CGSize boardSize = [boardString sizeWithFont: detailFont
                                   constrainedToSize: CGSizeMake(detailWidth, 10000)];
        UILabel *boardDetail = [[UILabel alloc] initWithFrame: CGRectMake(detailInset, contentHeight, detailWidth, boardSize.height)];
        [boardDetail setBackgroundColor: backgroundColor];
        [boardDetail setTextColor: detailColor];
        [boardDetail setFont: detailFont];
        [boardDetail setLineBreakMode: UILineBreakModeWordWrap];
        [boardDetail setNumberOfLines: 1000];
        [boardDetail setText: boardString];
        [_scroller addSubview: boardDetail];
        [boardDetail release];
        
        contentHeight += (boardSize.height + 10);
    }
    
    
    /* Pieces */
    if ([[_gameData objectForKey: @"pieces"] isKindOfClass: [NSString class]])
    {
        UILabel *piecesLabel = [[UILabel alloc] initWithFrame: CGRectMake(headerInset, contentHeight, headerWidth, headerHeight)];
        [piecesLabel setBackgroundColor: backgroundColor];
        [piecesLabel setTextColor: headerColor];
        [piecesLabel setFont: headerFont];
        [piecesLabel setText: @"The Pieces"];
        [_scroller addSubview: piecesLabel];
        [piecesLabel release];
        
        contentHeight += (headerHeight + 1);
        
        
        NSString *piecesString = [_gameData objectForKey: @"pieces"];
        CGSize piecesSize = [piecesString sizeWithFont: detailFont
                                     constrainedToSize: CGSizeMake(detailWidth, 10000)];
        UILabel *piecesDetail = [[UILabel alloc] initWithFrame: CGRectMake(detailInset, contentHeight, detailWidth, piecesSize.height)];
        [piecesDetail setBackgroundColor: backgroundColor];
        [piecesDetail setTextColor: detailColor];
        [piecesDetail setFont: detailFont];
        [piecesDetail setLineBreakMode: UILineBreakModeWordWrap];
        [piecesDetail setNumberOfLines: 1000];
        [piecesDetail setText: piecesString];
        [_scroller addSubview: piecesDetail];
        [piecesDetail release];
        
        contentHeight += (piecesSize.height + 10);
    }
    
    
    /* Rules */
    {
        UILabel *rulesLabel = [[UILabel alloc] initWithFrame: CGRectMake(headerInset, contentHeight, headerWidth, headerHeight)];
        [rulesLabel setBackgroundColor: backgroundColor];
        [rulesLabel setTextColor: headerColor];
        [rulesLabel setFont: headerFont];
        [rulesLabel setText: @"The Rules"];
        [_scroller addSubview: rulesLabel];
        [rulesLabel release];
        
        contentHeight += (headerHeight + 1);
        
        
        NSString *toMoveString = [NSString stringWithFormat: @"To move: %@", [_gameData objectForKey: @"tomove"]];
        CGSize toMoveSize = [toMoveString sizeWithFont: detailFont
                                     constrainedToSize: CGSizeMake(detailWidth, 10000)
                                         lineBreakMode: UILineBreakModeWordWrap];
        UILabel *toMoveLabel = [[UILabel alloc] initWithFrame: CGRectMake(detailInset, contentHeight, detailWidth, toMoveSize.height)];
        [toMoveLabel setBackgroundColor: backgroundColor];
        [toMoveLabel setTextColor: detailColor];
        [toMoveLabel setFont: detailFont];
        [toMoveLabel setLineBreakMode: UILineBreakModeWordWrap];
        [toMoveLabel setNumberOfLines: 1000];
        [toMoveLabel setText: toMoveString];
        [_scroller addSubview: toMoveLabel];
        [toMoveLabel release];
        
        contentHeight += (toMoveSize.height + 5);
        
        
        NSString *toWinString = [NSString stringWithFormat: @"To win: %@", [_gameData objectForKey: @"towin"]];
        CGSize toWinSize = [toWinString sizeWithFont: detailFont
                                   constrainedToSize: CGSizeMake(detailWidth, 10000)
                                         lineBreakMode: UILineBreakModeWordWrap];
        UILabel *toWinLabel = [[UILabel alloc] initWithFrame: CGRectMake(detailInset, contentHeight, detailWidth, toWinSize.height)];
        [toWinLabel setBackgroundColor: backgroundColor];
        [toWinLabel setTextColor: detailColor];
        [toWinLabel setFont: detailFont];
        [toWinLabel setLineBreakMode: UILineBreakModeWordWrap];
        [toWinLabel setNumberOfLines: 1000];
        [toWinLabel setText: toWinString];
        [_scroller addSubview: toWinLabel];
        [toWinLabel release];
        
        contentHeight += (toWinSize.height + 5);
        
        
        NSString *rulesString = [_gameData objectForKey: @"rules"];
        CGSize rulesSize = [rulesString sizeWithFont: detailFont
                                   constrainedToSize: CGSizeMake(detailWidth, 10000)
                                       lineBreakMode: UILineBreakModeWordWrap];
        UILabel *rulesDetail = [[UILabel alloc] initWithFrame: CGRectMake(detailInset, contentHeight, detailWidth, rulesSize.height)];
        [rulesDetail setBackgroundColor: backgroundColor];
        [rulesDetail setTextColor: detailColor];
        [rulesDetail setFont: detailFont];
        [rulesDetail setLineBreakMode: UILineBreakModeWordWrap];
        [rulesDetail setNumberOfLines: 1000];
        [rulesDetail setText: rulesString];
        [_scroller addSubview: rulesDetail];
        [rulesDetail release];
        
        contentHeight += (rulesSize.height + 10);
    }
    
    
    /* Strategies */
    id strategies = [_gameData objectForKey: @"strategies"];
    
    if ([strategies isKindOfClass: [NSDictionary class]] && ([strategies count] > 0))
    {
        UILabel *strategiesLabel = [[UILabel alloc] initWithFrame: CGRectMake(headerInset, contentHeight, headerWidth, headerHeight)];
        [strategiesLabel setBackgroundColor: backgroundColor];
        [strategiesLabel setTextColor: headerColor];
        [strategiesLabel setFont: headerFont];
        [strategiesLabel setText: @"Strategies"];
        [_scroller addSubview: strategiesLabel];
        [strategiesLabel release];
        
        contentHeight += (headerHeight + 1);
        
        
        for (NSString *key in strategies)
        {
            NSDictionary *strategy = [strategies objectForKey: key];
            NSString *strategyString = [NSString stringWithFormat: @"%@: %@", [strategy objectForKey: @"name"], [strategy objectForKey: @"description"]];
            CGSize strategySize = [strategyString sizeWithFont: detailFont
                                             constrainedToSize: CGSizeMake(detailWidth, 10000)
                                                 lineBreakMode: UILineBreakModeWordWrap];
            
            UILabel *strategyDetail = [[UILabel alloc] initWithFrame: CGRectMake(detailInset, contentHeight, detailWidth, strategySize.height)];
            [strategyDetail setBackgroundColor: backgroundColor];
            [strategyDetail setTextColor: detailColor];
            [strategyDetail setFont: detailFont];
            [strategyDetail setLineBreakMode: UILineBreakModeWordWrap];
            [strategyDetail setNumberOfLines: 1000];
            [strategyDetail setText: strategyString];
            [_scroller addSubview: strategyDetail];
            [strategyDetail release];
            
            contentHeight += (strategySize.height + 5);
        }
        
        contentHeight += 5;
    }
    
    
    /* Variants */
    id variants = [_gameData objectForKey: @"variants"];
    
    if ([variants isKindOfClass: [NSDictionary class]] && ([variants count] > 0))
    {
        UILabel *variantsLabel = [[UILabel alloc] initWithFrame: CGRectMake(headerInset, contentHeight, headerWidth, headerHeight)];
        [variantsLabel setBackgroundColor: backgroundColor];
        [variantsLabel setTextColor: headerColor];
        [variantsLabel setFont: headerFont];
        [variantsLabel setText: @"Variants"];
        [_scroller addSubview: variantsLabel];
        [variantsLabel release];
        
        contentHeight += (headerHeight + 1);
        
        
        for (NSString *key in variants)
        {
            NSDictionary *variant = [variants objectForKey: key];
            NSString *variantString = [NSString stringWithFormat: @"%@: %@", [variant objectForKey: @"name"], [variant objectForKey: @"description"]];
            CGSize variantSize = [variantString sizeWithFont: detailFont
                                           constrainedToSize: CGSizeMake(detailWidth, 10000)
                                               lineBreakMode: UILineBreakModeWordWrap];
            UILabel *variantDetail = [[UILabel alloc] initWithFrame: CGRectMake(detailInset, contentHeight, detailWidth, variantSize.height)];
            [variantDetail setBackgroundColor: backgroundColor];
            [variantDetail setTextColor: detailColor];
            [variantDetail setFont: detailFont];
            [variantDetail setLineBreakMode: UILineBreakModeWordWrap];
            [variantDetail setNumberOfLines: 1000];
            [variantDetail setText: variantString];
            [_scroller addSubview: variantDetail];
            [variantDetail release];
            
            contentHeight += (variantSize.height + 5);
        }
        
        contentHeight += 5;
    }
    
    
    /* Alternate Names */
    id alternates = [_gameData objectForKey: @"alternates"];
    
    if ([alternates isKindOfClass: [NSDictionary class]] && ([alternates count] > 0))
    {
        UILabel *alternateNamesLabel = [[UILabel alloc] initWithFrame: CGRectMake(headerInset, contentHeight, headerWidth, headerHeight)];
        [alternateNamesLabel setBackgroundColor: backgroundColor];
        [alternateNamesLabel setTextColor: headerColor];
        [alternateNamesLabel setFont: headerFont];
        [alternateNamesLabel setText: @"Alternate Names"];
        [_scroller addSubview: alternateNamesLabel];
        [alternateNamesLabel release];
        
        contentHeight += (headerHeight + 1);
        
        
        for (NSString *key in alternates)
        {
            NSString *alternateString = [NSString stringWithFormat: @"• %@", [alternates objectForKey: key]];
            CGSize alternateSize = [alternateString sizeWithFont: detailFont
                                               constrainedToSize: CGSizeMake(detailWidth, 10000)
                                                   lineBreakMode: UILineBreakModeWordWrap];
            UILabel *alternateDetail = [[UILabel alloc] initWithFrame: CGRectMake(detailInset, contentHeight, detailWidth, alternateSize.height)];
            [alternateDetail setBackgroundColor: backgroundColor];
            [alternateDetail setTextColor: detailColor];
            [alternateDetail setFont: detailFont];
            [alternateDetail setLineBreakMode: UILineBreakModeWordWrap];
            [alternateDetail setNumberOfLines: 1000];
            [alternateDetail setText: alternateString];
            [_scroller addSubview: alternateDetail];
            [alternateDetail release];
            
            contentHeight += (alternateSize.height + 5);
        }
        
        contentHeight += 5;
    }
    
    
    /* References */
    id references = [_gameData objectForKey: @"references"];
    
    if ([references isKindOfClass: [NSDictionary class]] && ([references count] > 0))
    {
        UILabel *referencesLabel = [[UILabel alloc] initWithFrame: CGRectMake(headerInset, contentHeight, headerWidth, headerHeight)];
        [referencesLabel setBackgroundColor: backgroundColor];
        [referencesLabel setTextColor: headerColor];
        [referencesLabel setFont: headerFont];
        [referencesLabel setText: @"References"];
        [_scroller addSubview: referencesLabel];
        [referencesLabel release];
        
        contentHeight += (headerHeight + 1);
        
        
        for (NSString *key in references)
        {
            NSString *referenceString = [NSString stringWithFormat: @"• %@", [references objectForKey: key]];
            CGSize referenceSize = [referenceString sizeWithFont: detailFont
                                               constrainedToSize: CGSizeMake(detailWidth, 10000)
                                                   lineBreakMode: UILineBreakModeWordWrap];
            UILabel *referenceDetail = [[UILabel alloc] initWithFrame: CGRectMake(detailInset, contentHeight, detailWidth, referenceSize.height)];
            [referenceDetail setBackgroundColor: backgroundColor];
            [referenceDetail setTextColor: detailColor];
            [referenceDetail setFont: detailFont];
            [referenceDetail setLineBreakMode: UILineBreakModeWordWrap];
            [referenceDetail setNumberOfLines: 1000];
            [referenceDetail setText: referenceString];
            [_scroller addSubview: referenceDetail];
            [referenceDetail release];
            
            contentHeight += (referenceSize.height + 5);
        }
        
        contentHeight += 5;
    }
    
    
    /* Links */
    id links = [_gameData objectForKey: @"links"];
    
    if ([links isKindOfClass: [NSDictionary class]] && ([links count] > 0))
    {
        UILabel *linksLabel = [[UILabel alloc] initWithFrame: CGRectMake(headerInset, contentHeight, headerWidth, headerHeight)];
        [linksLabel setBackgroundColor: backgroundColor];
        [linksLabel setTextColor: headerColor];
        [linksLabel setFont: headerFont];
        [linksLabel setText: @"Links"];
        [_scroller addSubview: linksLabel];
        [linksLabel release];
        
        contentHeight += (headerHeight + 1);
        
        
        for (NSString *key in links)
        {
            NSDictionary *link = [links objectForKey: key];
            NSString *linkString = [NSString stringWithFormat: @"%@: %@", [link objectForKey: @"description"], [link objectForKey: @"url"]];
            CGSize linkSize = [linkString sizeWithFont: detailFont
                                     constrainedToSize: CGSizeMake(detailWidth, 10000)];
            UITextView *linkDetail = [[UITextView alloc] initWithFrame: CGRectMake(detailInset, contentHeight, detailWidth, 2 * linkSize.height)];
            [linkDetail setBackgroundColor: backgroundColor];
            [linkDetail setTextColor: detailColor];
            [linkDetail setFont: detailFont];
            [linkDetail setText: linkString];
            [linkDetail setEditable: NO];
            [_scroller addSubview: linkDetail];
            [linkDetail setDataDetectorTypes: UIDataDetectorTypeAll];
            [linkDetail release];
            
            contentHeight += (2 * linkSize.height);
        }
        
        contentHeight += 5;
    }
    
    
    /* GamesCrafters */
    id gamesCrafters = [_gameData objectForKey: @"gamescrafters"];
    
    if ([gamesCrafters isKindOfClass: [NSDictionary class]] && ([gamesCrafters count] > 0))
    {
        UILabel *gamesCraftersLabel = [[UILabel alloc] initWithFrame: CGRectMake(headerInset, contentHeight, headerWidth, headerHeight)];
        [gamesCraftersLabel setBackgroundColor: backgroundColor];
        [gamesCraftersLabel setTextColor: headerColor];
        [gamesCraftersLabel setFont: headerFont];
        [gamesCraftersLabel setText: @"GamesCrafters"];
        [_scroller addSubview: gamesCraftersLabel];
        [gamesCraftersLabel release];
        
        contentHeight += (headerHeight + 1);
        
        
        for (NSString *key in gamesCrafters)
        {
            NSString *gamesCrafterString = [NSString stringWithFormat: @"• %@", [gamesCrafters objectForKey: key]];
            CGSize gamesCrafterSize = [gamesCrafterString sizeWithFont: detailFont
                                                     constrainedToSize: CGSizeMake(detailWidth, 10000)
                                                         lineBreakMode: UILineBreakModeWordWrap];
            UILabel *gamesCrafterDetail = [[UILabel alloc] initWithFrame: CGRectMake(detailInset, contentHeight, detailWidth, gamesCrafterSize.height)];
            [gamesCrafterDetail setBackgroundColor: backgroundColor];
            [gamesCrafterDetail setTextColor: detailColor];
            [gamesCrafterDetail setFont: detailFont];
            [gamesCrafterDetail setLineBreakMode: UILineBreakModeWordWrap];
            [gamesCrafterDetail setNumberOfLines: 1000];
            [gamesCrafterDetail setText: gamesCrafterString];
            [_scroller addSubview: gamesCrafterDetail];
            [gamesCrafterDetail release];
            
            contentHeight += (gamesCrafterSize.height + 5);
        }
        
        contentHeight += 5;
    }
    
    
    [_scroller setContentSize: CGSizeMake([[self view] bounds].size.width, contentHeight)];
}


- (void) setShowsDoneButton: (BOOL) showsDone
{
    _showsDoneButton = showsDone;
}


#pragma mark - Memory lifecycle

- (id) initWithXMLPath: (NSString *) pathToXML
             viewFrame: (CGRect) frame
{
    self = [super init];
    
    if (self)
    {
        _showsDoneButton = YES;
        
        NSString *string = [[[NSString alloc] initWithContentsOfFile: pathToXML encoding: NSUTF8StringEncoding error: nil] autorelease];
        NSData *xmlData = [[string dataUsingEncoding: NSUTF8StringEncoding] retain];
        
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData: xmlData];
        [parser setDelegate: self];
        
        [parser parse];
        
        _scroller = nil;
        
        _viewFrame = frame;
    }
    
    return self;
}


- (void) dealloc
{
    [super dealloc];
}


#pragma mark - View lifecycle

- (void) loadView
{
    [self setView: [[[UIView alloc] initWithFrame: _viewFrame] autorelease]];
    
    [[self view] setBackgroundColor: [UIColor colorWithRed: 0.0f green: 0.0f blue: 102.0f / 255.0f alpha: 1.0f]];
}


- (void) viewDidLoad
{
    [super viewDidLoad];
    
    if (_showsDoneButton)
    {
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone target: self action: @selector(done)];
        [[self navigationItem] setLeftBarButtonItem: doneButton];
        [doneButton release];
    }
    
    
    _scroller = [[UIScrollView alloc] initWithFrame: [[self view] bounds]];
    [[self view] addSubview: _scroller];
    
    [self populateScreen];
}


- (void) viewDidUnload
{
    [super viewDidUnload];
    
    [_scroller release];
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
    
    [_dictionaryStack release];
    [_tagStack release];
    
    [self populateScreen];
}

@end
