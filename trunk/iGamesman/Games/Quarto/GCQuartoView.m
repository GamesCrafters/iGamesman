//
//  GCQuartoView.m
//  iGamesman
//
//  Created by Kevin Jorgensen on 2/7/12.
//  Copyright (c) 2012 GamesCrafters. All rights reserved.
//

#import "GCQuartoView.h"

#import "GCUtilities.h"
#import "GCQuartoPiece.h"
#import "GCQuartoPosition.h"


@interface GCQuartoView ()

- (NSArray *) boardRects;
- (NSArray *) pieceRects;

@end



@implementation GCQuartoView

@synthesize delegate = _delegate;


- (id) initWithFrame: (CGRect) frame
{
    self = [super initWithFrame: frame];
    
    if (self)
    {
        [self setOpaque: NO];
        
        _acceptingTouches = NO;
    }
    
    return self;
}


#pragma mark - Touch handling

- (void) startReceivingTouches
{
    _acceptingTouches = YES;
}


- (void) stopReceivingTouches
{
    _acceptingTouches = NO;
}


- (void) touchesBegan: (NSSet *) touches withEvent: (UIEvent *) event
{
    if (!_acceptingTouches)
        return;
    
    GCQuartoPosition *position = [_delegate position];
    
    CGPoint location = [[touches anyObject] locationInView: self];
    
    NSArray *cellRects = [self boardRects];
    NSUInteger i = 0;
    for (NSValue *value in cellRects)
    {
        CGRect cell = [value CGRectValue];
        
        if (CGRectContainsPoint(cell, location) && (([position phase] == GCQ_LEFT_PLACE) || ([position phase] == GCQ_RIGHT_PLACE)) )
        {
            [_delegate userPlacedPiece: i];
            return;
        }
        
        i += 1;
    }
    
    NSArray *pieceRects = [self pieceRects];
    NSUInteger j = 0;
    for (NSValue *value in pieceRects)
    {
        CGRect piece = [value CGRectValue];
        
        if (CGRectContainsPoint(piece, location) && (([position phase] == GCQ_LEFT_CHOOSE) || ([position phase] == GCQ_RIGHT_CHOOSE)) )
        {
            BOOL white  = ((j & 8) > 0);
            BOOL hollow = ((j & 4) > 0);
            BOOL square = ((j & 2) > 0);
            BOOL tall   = ((j & 1) > 0);
            
            GCQuartoPiece *piece = [GCQuartoPiece pieceWithTall: tall square: square hollow: hollow white: white];
            if ([[position pieces] containsObject: piece])
                [_delegate userChosePiece: piece];
            
            return;
        }
        
        j += 1;
    }
}


#pragma mark - Drawing

- (NSArray *) boardRects
{
    CGFloat width  = [self bounds].size.width;
    CGFloat height = [self bounds].size.height;
    
    CGFloat maxCellWidth  = width / (4 + 2);
    CGFloat maxCellHeight = height / 4;
    
    CGFloat cellSize = MIN(maxCellWidth, maxCellHeight);
    
    CGFloat minX = CGRectGetMinX([self bounds]) + 20;
    CGFloat minY = CGRectGetMinY([self bounds]) + (height - 4 * cellSize) / 2.0f;
    
    CGRect boardRect = CGRectMake(minX, minY, 4 * cellSize, 4 * cellSize);
    
    CGFloat circleRadius = 2 * cellSize;
    CGPoint boardCenter = CGPointMake(CGRectGetMidX(boardRect), CGRectGetMidY(boardRect));
    
    CGFloat squareHeight = sqrt(2 * circleRadius * circleRadius);
    
    CGRect square = CGRectMake(boardCenter.x - squareHeight / 2.0f, boardCenter.y - squareHeight / 2.0f, squareHeight, squareHeight);
    CGFloat stretchX = 0.02f * squareHeight;
    CGFloat stretchY = 0.02f * squareHeight;
    square = CGRectInset(square, -stretchX, -stretchY);
    
    CGFloat boardMinX = CGRectGetMinX(square);
    CGFloat boardMinY = CGRectGetMinY(square);
    CGFloat slotSize = (squareHeight + 2 * stretchX) / 4.0f;
    
    
    NSMutableArray *rects = [[NSMutableArray alloc] initWithCapacity: 16];
    
    for (NSUInteger row = 0; row < 4; row += 1)
    {
        for (NSUInteger column = 0; column < 4; column += 1)
        {
            CGFloat cellCenterX = boardMinX + (column + 0.5f) * slotSize;
            CGFloat cellCenterY = boardMinY + (row + 0.5f) * slotSize;
            
            /* Translate the board center to the origin */
            cellCenterX -= boardCenter.x;
            cellCenterY -= boardCenter.y;
            
            /* Rotate by 45 degrees about the origin */
            CGFloat rotX = cos(M_PI_4) * cellCenterX - sin(M_PI_4) * cellCenterY;
            CGFloat rotY = sin(M_PI_4) * cellCenterX + cos(M_PI_4) * cellCenterY;
            cellCenterX = rotX;
            cellCenterY = rotY;
            
            /* Translate back */
            cellCenterX += boardCenter.x;
            cellCenterY += boardCenter.y;
            
            CGFloat cellOriginX = cellCenterX - (slotSize / 2.0f);
            CGFloat cellOriginY = cellCenterY - (slotSize / 2.0f);
            
            CGRect cellRect = CGRectMake(cellOriginX, cellOriginY, slotSize, slotSize);
            
            [rects addObject: [NSValue valueWithCGRect: cellRect]];
        }
    }
    
    return rects;
}


- (NSArray *) pieceRects
{
    CGFloat width  = [self bounds].size.width;
    CGFloat height = [self bounds].size.height;
    
    CGFloat maxCellWidth  = width / (4 + 2);
    CGFloat maxCellHeight = height / 4;
    
    CGFloat cellSize = MIN(maxCellWidth, maxCellHeight);
    
    CGFloat minX = CGRectGetMinX([self bounds]) + 20;
    CGFloat minY = CGRectGetMinY([self bounds]) + (height - 4 * cellSize) / 2.0f;
    
    CGRect boardRect = CGRectMake(minX, minY, 4 * cellSize, 4 * cellSize);
    CGFloat platformX = CGRectGetMaxX(boardRect);
    CGFloat platformY = CGRectGetMidY(boardRect) - (cellSize / 2.0f);
    
    CGRect upperRect = CGRectMake(platformX, minY, width - platformX, platformY - minY);
    CGRect lowerRect = CGRectMake(platformX, platformY + cellSize, width - platformX, platformY - minY);
    
    
    CGFloat upperWidth  = upperRect.size.width / 4.0f;
    CGFloat upperHeight = upperRect.size.height / 2.0f;
    CGFloat upperSize = MIN(upperWidth, upperHeight);
    CGFloat lowerWidth  = lowerRect.size.width / 4.0f;
    CGFloat lowerHeight = lowerRect.size.height / 2.0f;
    CGFloat lowerSize = MIN(lowerWidth, lowerHeight);
    
    
    NSMutableArray *rects = [[NSMutableArray alloc] initWithCapacity: 16];
    
    for (NSUInteger i = 0; i < 4; i += 1)
    {
        CGRect rect = CGRectMake(upperRect.origin.x + i * upperSize, upperRect.origin.y + upperRect.size.height - 2 * upperSize, upperSize, upperSize);
        [rects addObject: [NSValue valueWithCGRect: rect]];
        
        rect = CGRectMake(upperRect.origin.x + i * upperSize, upperRect.origin.y + upperRect.size.height - upperSize, upperSize, upperSize);
        [rects addObject: [NSValue valueWithCGRect: rect]];
    }
    
    
    for (NSUInteger i = 0; i < 4; i += 1)
    {
        CGRect rect = CGRectMake(lowerRect.origin.x + i * lowerSize, lowerRect.origin.y, lowerSize, lowerSize);
        [rects addObject: [NSValue valueWithCGRect: rect]];
        
        rect = CGRectMake(lowerRect.origin.x + i * lowerSize, lowerRect.origin.y + lowerSize, lowerSize, lowerSize);
        [rects addObject: [NSValue valueWithCGRect: rect]];
    }
    
    return rects;
}


- (void) drawPiece: (GCQuartoPiece *) piece inRect: (CGRect) rect withInset: (CGFloat) inset value: (GCGameValue *) value
{
    if ([piece blank])
        return;
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    BOOL tall   = [piece tall];
    BOOL square = [piece square];
    BOOL hollow = [piece hollow];
    BOOL white  = [piece white];
    
    
    CGFloat alpha = (tall ? 1 : 0.5f);
    
    if (white)
        CGContextSetRGBFillColor(ctx, 1, 1, 1, alpha);
    else
        CGContextSetRGBFillColor(ctx, 0, 0, 0, alpha);
    
    CGRect pieceRect = CGRectInset(rect, inset, inset);
    
    CGFloat width = pieceRect.size.width;
    
    CGRect innerRect = CGRectInset(pieceRect, width / 3, width / 3);
    
    CGFloat valueAlpha = 1;
    if ([_delegate isShowingDeltaRemoteness])
        valueAlpha = 1.0f / log((random() % 16) + 1);
    
    if (square)
    {
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, pieceRect);
        if (hollow)
        {
            CGPathAddRect(path, NULL, innerRect);
        }
        
        CGContextAddPath(ctx, path);
        CGContextEOFillPath(ctx);
        
        CGPathRelease(path);
        
        if ([value isEqualToString: GCGameValueUnknown])
        {
            if (!tall)
            {
                if (white)
                    CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1);
                else
                    CGContextSetRGBStrokeColor(ctx, 0, 0, 0, 1);
                
                CGFloat lineWidth = 4;
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                    lineWidth = 6;
                CGContextSetLineWidth(ctx, lineWidth);
                
                CGContextStrokeRect(ctx, CGRectInset(pieceRect, lineWidth / 2, lineWidth / 2));
            }
        }
        else
        {
            GCColor color = {0.0f, 0.0f, 0.0f};
            if ([value isEqualToString: GCGameValueWin])
                color = [GCConstants winColor];
            else if ([value isEqualToString: GCGameValueLose])
                color = [GCConstants loseColor];
            else
                color = [GCConstants tieColor];
            
            CGContextSetRGBFillColor(ctx, color.red, color.green, color.blue, valueAlpha);
            
            CGFloat lineWidth = 4;
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                lineWidth = 6;
            CGContextSetLineWidth(ctx, lineWidth);
            
            CGContextStrokeRect(ctx, CGRectInset(pieceRect, lineWidth / 2, lineWidth / 2));
        }
    }
    else
    {
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddEllipseInRect(path, NULL, pieceRect);
        if (hollow)
        {
            CGPathAddEllipseInRect(path, NULL, innerRect);
        }
        
        CGContextAddPath(ctx, path);
        CGContextEOFillPath(ctx);
        
        CGPathRelease(path);
        
        if ([value isEqualToString: GCGameValueUnknown])
        {
            if (!tall)
            {
                if (white)
                    CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1);
                else
                    CGContextSetRGBStrokeColor(ctx, 0, 0, 0, 1);
                
                CGFloat lineWidth = 4;
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                    lineWidth = 6;
                CGContextSetLineWidth(ctx, lineWidth);
                
                CGContextStrokeEllipseInRect(ctx, CGRectInset(pieceRect, lineWidth / 2, lineWidth / 2));
            }
        }
        else
        {
            GCColor color = {0.0f, 0.0f, 0.0f};
            if ([value isEqualToString: GCGameValueWin])
                color = [GCConstants winColor];
            else if ([value isEqualToString: GCGameValueLose])
                color = [GCConstants loseColor];
            else
                color = [GCConstants tieColor];
            
            CGContextSetRGBFillColor(ctx, color.red, color.green, color.blue, valueAlpha);
            
            CGFloat lineWidth = 4;
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                lineWidth = 6;
            CGContextSetLineWidth(ctx, lineWidth);
            
            CGContextStrokeEllipseInRect(ctx, CGRectInset(pieceRect, lineWidth / 2, lineWidth / 2));
        }
    }
}


- (void) drawRect: (CGRect) rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
#ifdef DEMO
    CGContextSetRGBFillColor(ctx, 1, 0, 0, 1);
    CGContextSetRGBFillColor(ctx, 0, 0, 0, 0.5f);
    CGContextFillRect(ctx, [self bounds]);
#endif
    
    
    CGFloat width  = [self bounds].size.width;
    CGFloat height = [self bounds].size.height;
    
    CGFloat maxCellWidth  = width / (4 + 2);
    CGFloat maxCellHeight = height / 4;
    
    CGFloat cellSize = MIN(maxCellWidth, maxCellHeight);
    
    CGFloat minX = CGRectGetMinX([self bounds]) + 20;
    CGFloat minY = CGRectGetMinY([self bounds]) + (height - 4 * cellSize) / 2.0f;

    UIImage *boardBackground = [UIImage imageNamed: @"quartoBoard"];
    CGRect boardRect = CGRectMake(minX, minY, 4 * cellSize, 4 * cellSize);
    [boardBackground drawInRect: boardRect];
    
    CGContextSetRGBStrokeColor(ctx, 0, 0, 0, 1);
    CGFloat lineWidth = width * 0.005f;
    CGContextSetLineWidth(ctx, lineWidth);
    CGContextStrokeEllipseInRect(ctx, CGRectInset(boardRect, lineWidth, lineWidth));
    
    
    GCQuartoPosition *position = [_delegate position];
    
    
    NSArray *cellRects = [self boardRects];
    for (NSUInteger row = 0; row < 4; row += 1)
    {
        for (NSUInteger column = 0; column < 4; column += 1)
        {
            CGRect cellRect = [[cellRects objectAtIndex: column + 4 * row] CGRectValue];
            GCQuartoPiece *piece = [position pieceAtRow: row column: column];
            
            CGContextSetLineWidth(ctx, lineWidth);
            if (![piece isEqual: [GCQuartoPiece blankPiece]] || ([position phase] == GCQ_LEFT_CHOOSE) || ([position phase] == GCQ_RIGHT_CHOOSE) || ![_delegate isShowingMoveValues])
                CGContextSetRGBStrokeColor(ctx, 0, 0, 0, 1);
            else
            {
                CGFloat slotAlpha = 1;
                if ([_delegate isShowingDeltaRemoteness])
                    slotAlpha = 1.0f / log((random() % 16) + 1);
                
                GCGameValue *val = [[NSArray arrayWithObjects: GCGameValueWin, GCGameValueLose, GCGameValueTie, nil] objectAtIndex: random() % 3];
                GCColor color = {0.0f, 0.0f, 0.0f};
                if ([val isEqualToString: GCGameValueWin])
                    color = [GCConstants winColor];
                else if ([val isEqualToString: GCGameValueLose])
                    color = [GCConstants loseColor];
                else
                    color = [GCConstants tieColor];
                
                CGContextSetRGBFillColor(ctx, color.red, color.green, color.blue, slotAlpha);
            }
            CGContextStrokeEllipseInRect(ctx, CGRectInset(cellRect, cellSize * 0.03f, cellSize * 0.03f));
            
            [self drawPiece: piece inRect: cellRect withInset: cellRect.size.width / 5.0f value: GCGameValueUnknown];
        }
    }
    
    
    CGFloat platformX = CGRectGetMaxX(boardRect);
    CGFloat platformY = CGRectGetMidY(boardRect) - (cellSize / 2.0f);
    
    UIImage *platformImage = [UIImage imageNamed: @"quartoPlatform"];
    CGRect platformRect = CGRectMake(platformX, platformY, cellSize, cellSize);
    
    [platformImage drawInRect: platformRect];
    
    
    if ([position platformPiece])
    {
        [self drawPiece: [position platformPiece] inRect: platformRect withInset: platformRect.size.width / 5.0f value: GCGameValueUnknown];
    }
    
    
    NSString *player = @"";
    NSString *other = @"";
    if (([position phase] == GCQ_LEFT_PLACE) || ([position phase] == GCQ_LEFT_CHOOSE))
    {
        player = [_delegate leftPlayerName];
        other  = [_delegate rightPlayerName];
    }
    else if (([position phase] == GCQ_RIGHT_PLACE) || ([position phase] == GCQ_RIGHT_CHOOSE))
    {
        player = [_delegate rightPlayerName];
        other  = [_delegate leftPlayerName];
    }
    
    if ([position primitive] == nil)
    {
        NSString *action = @"";
        if (([position phase] == GCQ_LEFT_CHOOSE) || ([position phase] == GCQ_RIGHT_CHOOSE))
            action = [NSString stringWithFormat: @"choose a piece for %@", other];
        else if (([position phase] == GCQ_LEFT_PLACE) || ([position phase] == GCQ_RIGHT_PLACE))
            action = @"place the piece on the board";
        
        NSString *message = [NSString stringWithFormat: @"%@: %@.", player, action];
        
        CGRect messageRect = CGRectMake(platformX + cellSize + 5, platformY, width - platformX - cellSize - 10, cellSize);
        UIFont *font;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            font = [UIFont boldSystemFontOfSize: 12];
        else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            font = [UIFont boldSystemFontOfSize: 16];
        CGSize messageSize = [message sizeWithFont: font constrainedToSize: messageRect.size lineBreakMode: UILineBreakModeWordWrap];
        
        messageRect = CGRectOffset(messageRect, 0, (messageRect.size.height - messageSize.height) / 2.0f);
        
        CGContextSetRGBFillColor(ctx, 1, 1, 1, 1);
        [message drawInRect: messageRect withFont: font lineBreakMode: UILineBreakModeWordWrap alignment: UITextAlignmentCenter];
    }
    
    
    NSArray *pieceRects = [self pieceRects];
    NSUInteger i = 0;
    NSArray *pieces = [position pieces];
    for (NSValue *value in pieceRects)
    {
        CGRect pieceRect = [value CGRectValue];
        
        BOOL white  = ((i & 8) > 0);
        BOOL hollow = ((i & 4) > 0);
        BOOL square = ((i & 2) > 0);
        BOOL tall   = ((i & 1) > 0);
        
        GCQuartoPiece *piece = [GCQuartoPiece pieceWithTall: tall square: square hollow: hollow white: white];
        if ([pieces containsObject: piece])
        {
            GCGameValue *gameVal = GCGameValueUnknown;
            
            if ([_delegate isShowingMoveValues] && (([position phase] == GCQ_LEFT_CHOOSE) || ([position phase] == GCQ_RIGHT_CHOOSE)))
            {
                gameVal = [[NSArray arrayWithObjects: GCGameValueWin, GCGameValueLose, GCGameValueTie, nil] objectAtIndex: random() % 3];
            }
            
            [self drawPiece: piece inRect: pieceRect withInset: pieceRect.size.width / 10.0f value: gameVal];
        }
        
        i += 1;
    }
}

@end
