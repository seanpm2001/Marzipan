﻿import Sugar
import Sugar.Collections
#if ECHOES
import System.Linq
#elseif COOPER
import com.remobjects.elements.linq
#endif

/* Expressions */

public class CGExpression: CGStatement {
}

public class CGRawExpression : CGExpression { // not language-agnostic. obviosuly.
	public var Lines: List<String>

	public init(_ lines: List<String>) {
		Lines = lines
	}
	public init(_ lines: String) {
		Lines = lines.Replace("\r", "").Split("\n").ToList()
	}
}

public class CGAssignedExpression: CGExpression {
	var Value: CGExpression
	
	public init(_ value: CGExpression) {
		Value = value
	}
}

public class CGSizeOfExpression: CGExpression {
	public var Expression: CGExpression

	public init(_ expression: CGExpression) {
		Expression = expression
	}
}

public class CGTypeOfExpression: CGExpression {
	public var Expression: CGExpression

	public init(_ expression: CGExpression) {
		Expression = expression
	}
}

public class CGDefaultExpression: CGExpression {
	public var `Type`: CGTypeReference

	public init(_ type: CGTypeReference) {
		`Type` = type
	}
}

public class CGSelectorExpression: CGExpression { /* Cocoa only */
	var SelectorName: String
	
	public init(_ selectorNameame: String) {
		SelectorName = selectorNameame;
	}
}

public class CGTypeCastExpression: CGExpression {
	public var Expression: CGExpression?
	public var TargetType: CGTypeReference?
	public var ThrowsException = false
	public var GuaranteedSafe = false // in Silver, this uses "as"

	public init(_ expression: CGExpression, _ targetType: CGTypeReference) {
		Expression = expression
		TargetType = targetType
	}
}

public class CGAwaitExpression: CGExpression {
	//incomplete
}

public class CGAnonymousMethodExpression: CGExpression {
	public var lambda = true
	//incomplete
}

public class CGAnonymousClassOrStructExpression: CGExpression {
	public var TypeDefinition: CGClassOrStructTypeDefinition
	
	public init(_ typeDefinition: CGClassOrStructTypeDefinition) {
		TypeDefinition = typeDefinition
	}
}

public class CGInheritedxpression: CGExpression {
	public var Expression: CGExpression

	public init(_ expression: CGExpression) {
		Expression = expression
	}
}

public class CGIfThenElseExpression: CGExpression { // aka Ternary operator
	public var Condition: CGExpression
	public var IfExpression: CGExpression
	public var ElseExpression: CGExpression?
	
	public init(_ condition: CGExpression, _ ifExpression: CGExpression, _ elseExpression: CGExpression?) {
		Condition = condition
		IfExpression= ifExpression
		ElseExpression = elseExpression
	}	
}

/*
public class CGSwitchExpression: CGExpression { //* Oxygene only */
	//incomplete
}

public class CGForToLoopExpression: CGExpression { //* Oxygene only */
	//incomplete
}

public class CGForEachLoopExpression: CGExpression { //* Oxygene only */
	//incomplete
}
*/

public class CGBinaryOperatorExpression: CGExpression {
	var LefthandValue: CGExpression
	var RighthandValue: CGExpression
	var Operator: CGOperatorKind? // for standard operators
	var OperatorString: String? // for custom operators
	
	public init(_ lefthandValue: CGExpression, _ righthandValue: CGExpression, _ `operator`: CGOperatorKind) {
		LefthandValue = lefthandValue
		RighthandValue = righthandValue
		Operator = `operator`;
	}
	public init(_ lefthandValue: CGExpression, _ righthandValue: CGExpression, _ operatorString: String) {
		LefthandValue = lefthandValue
		RighthandValue = righthandValue
		OperatorString = operatorString;
	}
}

public enum CGOperatorKind {
	case Addition
	case Subtraction
	case Multiplication
	case Division
	case LegacyPascalDivision // "div"
	case Modulus
	case Equals
	case NotEquals
	case LessThan
	case LessThanOrEquals
	case GreaterThan
	case GreatThanOrEqual
	case LogicalAnd
	case LogicalOr
	case LogicalXor
	case Shl
	case Shr
	case BitwiseAnd
	case BitwiseOr
	case BitwiseXor
	case Implies /* Oxygene only */
	case Is
	case IsNot
	case In /* Oxygene only */
	case NotIn
	/*case Assign
	case AssignAddition
	case AssignSubtraction
	case AssignMultiplication
	case AssignDivision
	case AssignModulus
	case AssignBitwiseAnd
	case AssignBitwiseOr
	case AssignBitwiseXor
	case AssignShl
	case AssignShr*/
}


/* Literal Expressions */

public class CGNamedIdentifierExpression: CGExpression { 
	var Name: String
	
	public init(_ name: String) {
		Name = name;
	}
}

public class CGSelfExpression: CGExpression { // "self" or "this"
}

public class CGNilExpression: CGExpression { // "nil" or "null"
}

public class CGPropertyValueExpression: CGExpression { /* "value" or "newValue" in C#/Swift */
}

public class CGLiteralExpression: CGExpression {
}

public class CGLanguageAgnosticLiteralExpression: CGExpression {
	internal var StringRepresentation: String {
		assert(false, "StringRepresentation not implemented")
		return "###";
	}
}

public class CGStringLiteralExpression: CGLiteralExpression {
	var Value: String = ""
	
	public init() {
	}
	public init(_ value: String) {
		Value = value
	}	
}

public class CGCharacterLiteralExpression: CGLiteralExpression {
	var Value: Char = "\0"

	public init() {
	}
	public init(_ value: Char) {
		Value = value
	}	
}

public class CGIntegerLiteralExpression: CGLanguageAgnosticLiteralExpression {
	var Value: Int64 = 0

	public init() {
	}
	public init(_ value: Int64) {
		Value = value
	}

	override var StringRepresentation: String {
		return Value.ToString() 
	}
}

public class CGFloatLiteralExpression: CGLanguageAgnosticLiteralExpression {
	var Value: Double = 0
	
	public init() {
	}
	public init(_ value: Double) {
		Value = value
	}

	override var StringRepresentation: String {
		return Value.ToString() // todo: force dot into float literal?
	}
}

public class CGBooleanLiteralExpression: CGLanguageAgnosticLiteralExpression {
	var Value: Boolean = false
	
	var True: CGBooleanLiteralExpression { return CGBooleanLiteralExpression(true) }
	var False: CGBooleanLiteralExpression { return CGBooleanLiteralExpression(false) }
	
	public init() {
	}
	public init(_ bool: Boolean) {
		Value = bool
	}


	override var StringRepresentation: String {
		if Value {
			return "true"
		} else {
			return "false"
		}
	}
}

public class CGArrayLiteralExpression: CGExpression {
	public var Elements: List<CGExpression> 
	public var ArrayKind: CGArrayKind = .Dynamic
	
	public init() {
		Elements = List<CGExpression>()
	}
	public init(_ elements: List<CGExpression>) {
		Elements = elements
	}
}

public class CGDictionaryLiteralExpression: CGExpression { /* Swift only, currently */
	public var Keys: List<CGExpression> 
	public var Values: List<CGExpression> 
	
	public init() {
		Keys = List<CGExpression>()
		Values = List<CGExpression>()
	}
	public init(_ keys: List<CGExpression>, _ values: List<CGExpression>) {
		Keys = keys
		Values = values
	}
}

/* Calls */

public class CGConstructorCallExpression {
	public var `Type`: CGTypeReference
	public var Name: String? // an optionally be provided for languages that support named .ctors
	public var Parameters: List<CGMethodCallParameter>
	public var PropertyInitializers = List<CGMethodCallParameter>() // for Oxygene extnded .ctor calls

	public init(_ type: CGTypeReference) {
		`Type` = type
		Parameters = List<CGMethodCallParameter>()
	}
	public init(_ type: CGTypeReference, _ parameters: List<CGMethodCallParameter>?) {
		`Type` = type
		if let parameters = parameters {
			Parameters = parameters
		} else {
			Parameters = List<CGMethodCallParameter>()
		}
	}
}

public class CGMemberAccessExpression {
	public var CallSite: CGExpression? // can be nil to call a local or global function/variable. Should be set to CGSelfExpression for local methods.
	public var Name: String
	public var NilSafe: Boolean = false // true to use colon or elvis operator

	public init(_ callSite: CGExpression?, _ name: String) {
		CallSite = callSite
		Name = name
	}
}

public class CGFieldAccessExpression: CGMemberAccessExpression {
}

public class CGMethodCallExpression : CGMemberAccessExpression{
	public var Parameters: List<CGMethodCallParameter>

	public init(_ callSite: CGExpression?, _ name: String) {
		super.init(callSite, name)
		Parameters = List<CGMethodCallParameter>()
	}
	public init(_ callSite: CGExpression?, _ name: String, _ parameters: List<CGMethodCallParameter>?) {
		super.init(callSite, name)
		if let parameters = parameters {
			Parameters = parameters
		} else {
			Parameters = List<CGMethodCallParameter>()
		}   
	}
}

public class CGPropertyAccessExpression: CGMemberAccessExpression {
	public var Parameters: List<CGMethodCallParameter>

	public init(_ callSite: CGExpression?, _ name: String, _ parameters: List<CGMethodCallParameter>?) {
		super.init(callSite, name)
		if let parameters = parameters {
			Parameters = parameters
		} else {
			Parameters = List<CGMethodCallParameter>()
		}   
	}
}

public class CGMethodCallParameter: CGEntity {
	public var Name: String? // optional, for named parameters or prooperty initialziers
	public var Value: CGExpression
	public var Modifier: ParameterModifierKind = .In
	
	public init(_ value: CGExpression) {
		Value = value
	}
	public init(_ name: String?, _ value: CGExpression) {
		//public init(value) // 71582: Silver: delegating to a second .ctor doesn't properly detect that a field will be initialized
		Value = value
		Name = name
	}
}

