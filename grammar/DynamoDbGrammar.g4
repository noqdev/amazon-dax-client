/*
 * Copyright 2017 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License"). You may not
 * use this file except in compliance with the License. A copy of the License
 * is located at
 *
 *    http://aws.amazon.com/apache2.0/
 *
 * or in the "license" file accompanying this file. This file is distributed on
 * an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
 * express or implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */
/**
 * Parse rules for DynamoDB Grammar
 */
grammar DynamoDbGrammar;
import Tokens;

@parser::members {
def validateRedundantParentheses(self, redundantParens):
    if redundantParens:
        raise Exception('RedundantParenthesesException')
}

/** Projection specific rules */
projection_ : projection EOF;    // append EOF to start rules to avoid antlr bug
projection
  : path (',' path)*
  ;


/** Condition specific rules */
condition_ : condition EOF;    // append EOF to start rules to avoid antlr bug
condition returns [ boolean hasOuterParens=False ]
  : operand comparator_symbol operand    # Comparator
  | operand IN '(' operand (',' operand)* ')'    # In
  | operand BETWEEN operand AND operand    # Between
  | func    # FunctionCondition
  | '(' c=condition ')'
        {
self.validateRedundantParentheses($c.hasOuterParens)
$hasOuterParens=True
        }   # ConditionGrouping
  | NOT condition    # Negation
  | condition AND <assoc=right> condition    # And
  | condition OR <assoc=right> condition    # Or
  ;

comparator_symbol
  : ('=' | '<>' | '<' | '<=' | '>' | '>=')
  ;



/** Update specific rules */
update_ : update EOF;    // append EOF to start rules to avoid antlr bug
update
  : (set_section | add_section | delete_section | remove_section)+
  ;

set_section
  : SET set_action (',' set_action)*
  ;

set_action
  : path '=' set_value
  ;

add_section
  : ADD add_action (',' add_action)*
  ;

add_action
  : path literal
  ;

delete_section
  : DELETE delete_action (',' delete_action)*
  ;

delete_action
  : path literal
  ;

remove_section
  : REMOVE remove_action (',' remove_action)*
  ;

remove_action
  : path
  ;



/** Base rules */
set_value
  : operand    # OperandValue
  | arithmetic    # ArithmeticValue
  ;

arithmetic returns [ boolean hasOuterParens=False ]
  : operand ('+'|'-') operand    # PlusMinus
  | '(' a=arithmetic ')'
        {
self.validateRedundantParentheses($a.hasOuterParens)
$hasOuterParens=True
        }    # ArithmeticParens
  ;

operand returns [ boolean hasOuterParens=False ]
  : path    # PathOperand
  | literal    # LiteralOperand
  | func    # FunctionOperand
  | '(' o=operand ')'
        {
self.validateRedundantParentheses($o.hasOuterParens)
$hasOuterParens=True
        }    # ParenOperand
  ;

func
  : ID '(' operand (',' operand)* ')'    # FunctionCall
  ;

path
  : id_ (dereference)*
  ;

id_
  : (ID | ATTRIBUTE_NAME_SUB)
  ;

dereference
  : '.' id_    # MapAccess
  | '[' INDEX ']'    # ListAccess
  ;

literal
  : LITERAL_SUB    # LiteralSub
  ;

expression_attr_names_sub
  : ATTRIBUTE_NAME_SUB EOF
  ;

expression_attr_values_sub
  : LITERAL_SUB EOF
  ;

unknown
  : UNKNOWN+
  ;
