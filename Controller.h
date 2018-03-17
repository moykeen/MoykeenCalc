//
//  Controller.h
//  MoykeenCalc
//
//  Created by makoto on 11/04/03.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#include "muParser.h"

@interface Controller : NSObject <NSTextViewDelegate>{
	IBOutlet NSTextView *text;
	IBOutlet NSTextField *field;
	mu::Parser *parser;
}

//プロパティを使う練習として。
@property(assign) mu::Parser *parser;



@end
