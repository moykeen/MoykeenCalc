//
//  Controller.m
//  MoykeenCalc
//
//  Created by makoto on 11/04/03.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Controller.h"
#include <cmath>

using namespace mu;
using namespace std;

@implementation Controller

@synthesize parser;

void resetParserConstants(Parser *parser)
{
	parser->ClearConst();
	parser->DefineConst("pi", M_PI);
	parser->DefineConst("e", exp(1));
}

- (id) init
{
	//パーサの準備
	[self setParser: new Parser];
	//	parser = new Parser;
	resetParserConstants(parser);
	
	return self;
}

- (void) dealloc
{
	delete parser;
	[super dealloc];
}

- (void) setTextFieldInvalid
{
	[field setStringValue:@""];
}

- (void)textDidChange:(NSNotification *)aNotification
{
	NSString *string = [text string];

	resetParserConstants(parser);

	
	NSArray *array = [string componentsSeparatedByString:@","];
	int constantCount = [array count] - 1, c = 0;
	for(NSString *s in array){
		if(c++ == constantCount)
			break;
		
		
		NSArray *a2 = [s componentsSeparatedByString:@"="];
		if([a2 count] != 2)//無効な定数定義の場合
			break;
		
		NSString *constantName = [[a2 objectAtIndex:0] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];//空白文字をトリムする
		if([constantName isEqualToString:@""]){//定数名が空文字
			[field setStringValue:@""];
			return;
		}
		char initial = [constantName UTF8String][0];//頭文字が数字でないかチェック
		if(initial > '0' && initial < '9'){
			[self setTextFieldInvalid];
			return;
		}
		
		NSString *eqForDefineTheConstant = [a2 objectAtIndex:1];
		const char *cString = [eqForDefineTheConstant UTF8String];
		parser->SetExpr(cString);
		double val = 0;
		try {
			val = parser->Eval();
		}
		catch (Parser::exception_type &e) {
			[self setTextFieldInvalid];
			return;
		}
		parser->DefineConst([constantName UTF8String], val);
		
		
		
		//NSLog(@"%@ %f", constantName, val);
	}
	

	NSString *eqExpression = [array lastObject];
	const char *cString = [eqExpression UTF8String];	
	parser->SetExpr(cString);
	double val = 0;
	
	
	
	//答えを求めてtextFieldに表示
	try {
		val = parser->Eval();
		[field setDoubleValue: val];
	}
	catch (Parser::exception_type &e) {
		[self setTextFieldInvalid];
	}


}

@end
