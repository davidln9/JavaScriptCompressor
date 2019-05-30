/*
 * The MIT License (MIT)
 *
 * Copyright (c) 2014 by Bart Kiers (original author) and Alexandre Vitorelli (contributor -> ported to CSharp)
 * Copyright (c) 2017 by Ivan Kochurkin (Positive Technologies):
    added ECMAScript 6 support, cleared and transformed to the universal grammar.
 * Copyright (c) 2018 by Juan Alvarez (contributor -> ported to Go)
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */
parser grammar JavaScriptParser;


options {
    tokenVocab=JavaScriptLexer;
    superClass=JavaScriptBaseParser;
}


program
    : sourceElements? EOF
    ;

sourceElement
    : Export? statement
    ;

statement
    : block												
    | variableStatement									
    | emptyStatement									
    | classDeclaration									
    | expressionStatement								
    | ifStatement										
    | iterationStatement								
    | continueStatement									
    | breakStatement									
    | returnStatement									
    | withStatement										
    | labelledStatement									
    | switchStatement									
    | throwStatement									
    | tryStatement										
    | debuggerStatement									
    | functionDeclaration								
    ;

block
    : OpenBrace statementList? CloseBrace
    ;

statementList
    : statement+
    ;


variableStatement
    : varModifier variableDeclarationList eos
    ;


variableDeclarationList
    : variableDeclaration (Comma variableDeclaration)*
    ;

variableDeclaration
    : (Identifier | arrayLiteral | objectLiteral) (Assign singleExpression)? // ECMAScript 6: Array & Object Matching
    ;

emptyStatement
    : SemiColon
    ;

expressionStatement
    : {this.notOpenBraceAndNotFunction()}? expressionSequence eos
    ;

ifStatement
    : If OpenParen expressionSequence CloseParen statement (Else statement)?
    ;


iterationStatement
    : Do statement While OpenParen expressionSequence CloseParen eos                                                         # DoStatement
    | While OpenParen expressionSequence CloseParen statement                                                                # WhileStatement
    | For OpenParen expressionSequence? SemiColon expressionSequence? SemiColon expressionSequence? CloseParen statement                 # ForStatement
    | For OpenParen varModifier variableDeclarationList SemiColon expressionSequence? SemiColon expressionSequence? CloseParen
          statement                                                                                             # ForVarStatement
    | For OpenParen singleExpression (In | Identifier{this.p("of")}?) expressionSequence CloseParen statement                # ForInStatement
    | For OpenParen varModifier variableDeclaration (In | Identifier{this.p("of")}?) expressionSequence CloseParen statement # ForVarInStatement
    ;

varModifier  // let, const - ECMAScript 6
    : Var
    | Let
    | Const
    ;

continueStatement
    : Continue ({this.notLineTerminator()}? Identifier)? eos
    ;

breakStatement
    : Break ({this.notLineTerminator()}? Identifier)? eos
    ;

returnStatement
    : Return ({this.notLineTerminator()}? expressionSequence)? eos
    ;

withStatement
    : With OpenParen expressionSequence CloseParen statement
    ;

switchStatement
    : Switch OpenParen expressionSequence CloseParen caseBlock
    ;

caseBlock
    : OpenBrace caseClauses? (defaultClause caseClauses?)? CloseBrace
    ;

caseClauses
    : caseClause+
    ;

caseClause
    : Case expressionSequence Colon statementList?
    ;

defaultClause
    : Default Colon statementList?
    ;

labelledStatement
    : Identifier Colon statement
    ;

throwStatement
    : Throw {this.notLineTerminator()}? expressionSequence eos
    ;

tryStatement
    : Try block (catchProduction finallyProduction? | finallyProduction)
    ;

catchProduction
    : Catch OpenParen Identifier CloseParen block
    ;

finallyProduction
    : Finally block
    ;

debuggerStatement
    : Debugger eos
    ;

functionDeclaration
    : Function Identifier OpenParen formalParameterList? CloseParen OpenBrace functionBody CloseBrace
    ;

classDeclaration
    : Class Identifier classTail
    ;

classTail
    : (Extends singleExpression)? OpenBrace classElement* CloseBrace
    ;

classElement
    : (Static | {n("static")}? Identifier)? methodDefinition
    | emptyStatement
    ;

methodDefinition
    : propertyName OpenParen formalParameterList? CloseParen OpenBrace functionBody CloseBrace
    | getter OpenParen CloseParen OpenBrace functionBody CloseBrace
    | setter OpenParen formalParameterList? CloseParen OpenBrace functionBody CloseBrace
    | generatorMethod
    ;

generatorMethod
    : Multiply? Identifier OpenParen formalParameterList? CloseParen OpenBrace functionBody CloseBrace
    ;

formalParameterList
    : formalParameterArg (Comma formalParameterArg)* (Comma lastFormalParameterArg)?
    | lastFormalParameterArg
    | arrayLiteral                            // ECMAScript 6: Parameter Context Matching
    | objectLiteral                           // ECMAScript 6: Parameter Context Matching
    ;

formalParameterArg
    : Identifier (Assign singleExpression)?      // ECMAScript 6: Initialization
    ;

lastFormalParameterArg                        // ECMAScript 6: Rest Parameter
    : Ellipsis Identifier
    ;

functionBody
    : sourceElements?
    ;

sourceElements
    : sourceElement+
    ;

arrayLiteral
    : OpenBracket Comma* elementList? Comma* CloseBracket
    ;

elementList
    : singleExpression (Comma+ singleExpression)* (Comma+ lastElement)?
    | lastElement
    ;

lastElement                      // ECMAScript 6: Spread Operator
    : Ellipsis Identifier
    ;

objectLiteral
    : OpenBrace (propertyAssignment (Comma propertyAssignment)*)? Comma? CloseBrace
    ;

propertyAssignment
    : propertyName (Colon |Assign) singleExpression       # PropertyExpressionAssignment
    | OpenBracket singleExpression CloseBracket Colon singleExpression  # ComputedPropertyExpressionAssignment
    | getter OpenParen CloseParen OpenBrace functionBody CloseBrace            # PropertyGetter
    | setter OpenParen Identifier CloseParen OpenBrace functionBody CloseBrace # PropertySetter
    | generatorMethod                                # MethodProperty
    | Identifier                                     # PropertyShorthand
    ;

propertyName
    : identifierName
    | StringLiteral
    | numericLiteral
    ;

arguments
    : OpenParen(
          singleExpression (Comma singleExpression)* (Comma lastArgument)? |
          lastArgument
       )?CloseParen
    ;

lastArgument                                  // ECMAScript 6: Spread Operator
    : Ellipsis Identifier
    ;

expressionSequence
    : singleExpression (Comma singleExpression)*
    ;

singleExpression
    : Function Identifier? OpenParen formalParameterList? CloseParen OpenBrace functionBody CloseBrace # FunctionExpression
    | Class Identifier? classTail                                            # ClassExpression
    | singleExpression OpenBracket expressionSequence CloseBracket                            # MemberIndexExpression
    | singleExpression Dot identifierName                                    # MemberDotExpression
    | singleExpression arguments                                             # ArgumentsExpression
    | New singleExpression arguments?                                        # NewExpression
    | singleExpression {this.notLineTerminator()}? PlusPlus                      # PostIncrementExpression
    | singleExpression {this.notLineTerminator()}? MinusMinus                      # PostDecreaseExpression
    | Delete singleExpression                                                # DeleteExpression
    | Void singleExpression                                                  # VoidExpression
    | Typeof singleExpression                                                # TypeofExpression
    | PlusPlus singleExpression                                                  # PreIncrementExpression
    | MinusMinus singleExpression                                                  # PreDecreaseExpression
    | Plus singleExpression                                                   # UnaryPlusExpression
    | Minus singleExpression                                                   # UnaryMinusExpression
    | Minus singleExpression                                                   # BitNotExpression
    | Not singleExpression                                                   # NotExpression
    | singleExpression (Multiply | Divide | Modulus) singleExpression                    # MultiplicativeExpression
    | singleExpression (Plus | Minus) singleExpression                          # AdditiveExpression
    | singleExpression (LeftShiftArithmetic | RightShiftArithmetic | RightShiftLogical) singleExpression                # BitShiftExpression
    | singleExpression (LessThan | MoreThan | LessThanEquals | GreaterThanEquals) singleExpression            # RelationalExpression
    | singleExpression Instanceof singleExpression                           # InstanceofExpression
    | singleExpression In singleExpression                                   # InExpression
    | singleExpression (Equals | NotEquals | IdentityEquals | IdentityNotEquals) singleExpression        # EqualityExpression
    | singleExpression BitAnd singleExpression                                  # BitAndExpression
    | singleExpression BitXOr singleExpression                                  # BitXOrExpression
    | singleExpression BitOr singleExpression                                  # BitOrExpression
    | singleExpression And singleExpression                                 # LogicalAndExpression
    | singleExpression Or singleExpression                                 # LogicalOrExpression
    | singleExpression QuestionMark singleExpression Colon singleExpression             # TernaryExpression
    | singleExpression Assign singleExpression                                  # AssignmentExpression
    | singleExpression assignmentOperator singleExpression                   # AssignmentOperatorExpression
    | singleExpression TemplateStringLiteral                                 # TemplateStringExpression  // ECMAScript 6
    | This                                                                   # ThisExpression
    | Identifier                                                             # IdentifierExpression
    | Super                                                                  # SuperExpression
    | literal                                                                # LiteralExpression
    | arrayLiteral                                                           # ArrayLiteralExpression
    | objectLiteral                                                          # ObjectLiteralExpression
    | OpenParen expressionSequence CloseParen                                             # ParenthesizedExpression
    | arrowFunctionParameters ARROW arrowFunctionBody                         # ArrowFunctionExpression   // ECMAScript 6
    ;
    

arrowFunctionParameters
    : Identifier
    | OpenParen formalParameterList? CloseParen
    ;

arrowFunctionBody
    : singleExpression
    | OpenBrace functionBody CloseBrace
    ;


assignmentOperator
    : MultiplyAssign
    | DivideAssign
    | ModulusAssign
    | PlusAssign
    | MinusAssign
    | LeftShiftArithmeticAssign
    | RightShiftArithmeticAssign
    | RightShiftLogicalAssign
    | BitAndAssign
    | BitXorAssign
    | BitOrAssign
    ;


literal
    : NullLiteral
    | BooleanLiteral
    | StringLiteral
    | TemplateStringLiteral
    | RegularExpressionLiteral
    | numericLiteral
    ;

numericLiteral
    : DecimalLiteral
    | HexIntegerLiteral
    | OctalIntegerLiteral
    | OctalIntegerLiteral2
    | BinaryIntegerLiteral
    ;

identifierName
    : Identifier
    | reservedWord
    ;

reservedWord
    : keyword
    | NullLiteral
    | BooleanLiteral
    ;

keyword
    : Break
    | Do
    | Instanceof
    | Typeof
    | Case
    | Else
    | New
    | Var
    | Catch
    | Finally
    | Return
    | Void
    | Continue
    | For
    | Switch
    | While
    | Debugger
    | Function
    | This
    | With
    | Default
    | If
    | Throw
    | Delete
    | In
    | Try

    | Class
    | Enum
    | Extends
    | Super
    | Const
    | Export
    | Import
    | Implements
    | Let
    | Private
    | Public
    | Interface
    | Package
    | Protected
    | Static
    | Yield
    ;

getter
    : Identifier{this.p("get")}? propertyName
    ;

setter
    : Identifier{this.p("set")}? propertyName
    ;

eos
    : SemiColon
    | EOF
    | {this.lineTerminatorAhead()}?
    | {this.closeBrace()}?
    ;
