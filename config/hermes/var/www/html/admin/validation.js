var originalCssClasses = new Array();
var originalCssClassesInitialized = new Array();
function NOF_isRequired( formField ) {
if ( formField.type != undefined ) {
if ( (formField.type).indexOf("checkbox") != -1 ) {
if ( formField.checked ) {
return true;
}
} else if ( (formField.type).indexOf("radio") != -1 ) {
if ( formField.checked ) {
return true;
}
} else if ( (formField.type).indexOf("select") != -1 ) {
for ( var i = 0; i < formField.length; i++ ) {
if ( formField[ i ].selected && formField[ i ].value != "" ) {
return true;
}
}
} else {
if ( formField.value != null && formField.value != "" ) {
return true;
}
}
} else {
if ( formField.length > 1 ) {
for ( var i = 0; i < formField.length; i++ ) {
if ( (formField[ i ].type).indexOf("select") != -1 ) {
if ( formField[ i ].selected && formField[ i ].value != "" ) {
return true;
}
}
else {
if ( formField[ i ].checked ) {
return true;
}
}
}
} else {
if ( formField[ 0 ].selected ) {
return true;
}
}
}
return false;
}
function NOF_isEmailAddress( formField ) {
var emailRe = /^(\w[-\w\.]*)?\w(@|%40)\w([\-\.]?\w)*\.[a-z]{2,5}$/i;
return ( ( formField.value != "" ) ? ( NOF_isRequired( formField ) && emailRe.test( formField.value ) ) : true );
}
function NOF_isDomainName( formField ) {
var domainRe = /^\w([\-\.]?\w)*\.[a-z]{2,5}$/i;
return ( ( formField.value != "" ) ? ( NOF_isRequired( formField ) && domainRe.test( formField.value ) ) : true );
}
function NOF_isNumber( formField ) {
var numberRe = /^\d+(\.?\d+)*$/;
return ( ( formField.value != "" ) ? (NOF_isRequired( formField ) && numberRe.test( formField.value ) ) : true );
}
function NOF_isInRange( formField, min, max ) {
var value = NOF_isRequired( formField ) ? parseFloat( formField.value ) : NaN;
var minValue = parseFloat( min );
var maxValue = parseFloat( max );
return ( ( formField.value != "" ) ? (!isNaN( value ) && value >= minValue && value <= maxValue ) : true );
}
function NOF_isLengthInRange( formField, min, max ) {
return ( ( formField.value != "" ) ? (NOF_isRequired( formField ) && formField.value.length >= min && formField.value.length <= max ) : true );
}
function NOF_isPhoneNumber( formField, mask ) {
var newPhoneNumber = "";
if ( formField.value == "" ) { return true; }
for ( var i = 0; i < mask.length; i++ ) {
if ( mask.charAt(i).toLowerCase() == "d" ) {
if ( i < formField.value.length ) {
newPhoneNumber = newPhoneNumber + formField.value.charAt(i);
}
else {
newPhoneNumber = newPhoneNumber + mask.charAt(i);
}
}
else {
newPhoneNumber = newPhoneNumber + mask.charAt(i);
}
}
return ( NOF_isRequired( formField ) && ( newPhoneNumber == formField.value ) );
}
function NOF_isValidCreditCard( formField, cardType ) {
if ( formField.value == "" ) { return true; }
var ccType = cardType.toLowerCase();
var ccNumber = NOF_isRequired( formField ) ? formField.value : "";
var ccNumberLength = ccNumber.length;
var firstChar = ccNumber.charAt( 0 );
var secondChar = ccNumber.charAt( 1 );
if ( ccType == "visa" ) {
return ( ( ccNumberLength == 16 || ccNumberLength == 13 ) && firstChar == "4" );
}
else if ( ccType == "mastercard" ) {
return ( ccNumberLength == 16 && firstChar == "5" && parseInt( secondChar ) >= 1 && parseInt( secondChar ) <= 5 );
}
else if ( ccType == "american express" ) {
return ( ccNumberLength == 15 && firstChar == "3" && ( secondChar == "4" || secondChar == "7" ) );
}
else if ( ccType == "discover" ) {
return ( ccNumberLength == 16 && ccNumber.substring( 0, 4 ) == "6011" );
}
return false;
}
function NOF_isValidDate( formField, mask ) {
if ( formField.value == "" ) { return true; }
var dateParts = new Array();
var currDate = new Date();
var currYear = currDate.getYear();
var strDate = NOF_isRequired( formField ) ? formField.value : "";
var delimitationChar = "/";
var monthMask = "mm", dayMask = "dd", yearMask = "yyyy";
var monthPos = 0, dayPos = 1, yearPos = 2;
if ( mask.substring(0,1).toLowerCase() == "m" ) {
var re = new RegExp("([mM]{2,3})([\/\s\-\|\.])([dD]{2})([\/\s\-\|\.])([yY]{4}|[yY]{2})");
var m = re.exec(mask);
if (m == null) {
return false;
} else {
if ( m.length == 6 ) {
delimitationChar = m[2];
if ( delimitationChar == m[4] ) {
monthMask = m[1];
dayMask = m[3];
yearMask = m[5];
}
else {
}
}
else {
}
}
}
else if ( mask.substring(0,1).toLowerCase() == "d" ) {
var re = new RegExp("([dD]{2})([\/\s\-\|\.])([mM]{2,3})([\/\s\-\|\.])([yY]{4}|[yY]{2})");
var m = re.exec(mask);
monthPos = 1;
dayPos = 0;
yearPos = 2;
if (m == null) {
alert("No match");
} else {
if ( m.length == 6 ) {
delimitationChar = m[2];
if ( delimitationChar == m[4] ) {
dayMask = m[1];
monthMask = m[3];
yearMask = m[5];
}
else {
}
}
else {
}
}
}
else {
}
if ( currYear.toString().length < 4 ) {
currYear = currYear + 1900;
}
if ( strDate.indexOf( delimitationChar ) > 0) {
dateParts = strDate.split( delimitationChar );
if ( dateParts.length != 3 ) {
return false;
}
for ( var i = 0; i < dateParts.length; i++ ) {
if ( isNaN( dateParts[ i ] ) ) {
return false;
}
}
var month = parseInt( dateParts[ monthPos ], 10);
if ( month < 1 || month > 12 ) {
return false;
}
var day = parseInt( dateParts[ dayPos ], 10);
if ( day < 1 || day > 31 ) {
return false;
}
var year = parseInt( dateParts[ yearPos ], 10);
if ( yearMask.length == 2 ) {
if ( dateParts[ yearPos ].length != 2 ) {
return false;
}
}
else {
if ( year < currYear - 200 || year > currYear + 200 ) {
return false;
}
}
return true;
}
return false;
}
function NOF_validateForm( formObj, validationInfo, showAllErrors, errorOutput, errMessage ) {
var errMsg = "";
var fieldLabelId;
var fieldId;
if ( originalCssClassesInitialized[formObj.name] == null )
{
originalCssClassesInitialized[formObj.name] = false;
}
if ( originalCssClasses[formObj.name] == null )
{
originalCssClasses[formObj.name] = new Array;
}
if ( !originalCssClassesInitialized[formObj.name] ) {
for ( var elementName in validationInfo ) {
fieldId = NOF_getElementId( formObj.elements[ elementName ] );
fieldLabelId = NOF_getElementLabelObj( fieldId );
originalCssClasses[formObj.name][ elementName ] = new Array();
originalCssClasses[formObj.name][ elementName ][ "label" ] = new Array();
for ( var i = 0; i < fieldLabelId.length; i++ ) {
originalCssClasses[formObj.name][ elementName ][ "label" ][ i ] = NOF_getElementProperty( fieldLabelId[ i ], "className" );
}
originalCssClasses[formObj.name][ elementName ][ "field" ] = NOF_getElementProperty( fieldId, "className" );
}
originalCssClassesInitialized[formObj.name] = true;
}
else {
for ( var i in originalCssClasses[formObj.name] ) {
fieldId = NOF_getElementId( formObj.elements[ i ] );
fieldLabelId = NOF_getElementLabelObj( fieldId );
for ( var j = 0; j < fieldLabelId.length; j++ ) {
NOF_setElementProperty( fieldLabelId[j], "className", originalCssClasses[formObj.name][ i ][ "label" ][ j ] );
}
NOF_setElementProperty( fieldId, "className", originalCssClasses[formObj.name][ i ][ "field" ] );
}
}
for ( var i in validationInfo ) {
var errorFound = false;
for ( var j = 0; j < validationInfo[ i ].length; j++ ) {
var validationRecord = validationInfo[ i ][ j ];
var functionName = validationRecord[ 0 ];
var functionArgs = validationRecord[ 1 ];
var errorMessage = validationRecord[ 2 ];
var errorLabelCss = validationRecord[ 3 ];
var errorFieldCss = validationRecord[ 4 ];
if ( functionArgs.length
? eval( "!" + functionName + "(formObj.elements['" + i + "'],'" + functionArgs.join("','") + "')" )
: eval( "!" + functionName + "(formObj.elements['" + i + "'])") ) {
errorFound = true;
errMsg += "\n" + errorMessage;
fieldId = NOF_getElementId( formObj.elements[ i ] );
fieldLabelId = NOF_getElementLabelObj( fieldId );
for ( var k = 0; k < fieldLabelId.length; k++ ) {
fieldLabelId[k].className = errorLabelCss;
NOF_setElementProperty( fieldLabelId[j], "className", errorLabelCss );
}
NOF_setElementProperty( fieldId,"className", errorFieldCss );
}
if ( errorFound && !showAllErrors ) {
break;
}
}
}
if ( errMsg != "" ) {
if ( errMessage == null || errMessage == "" ) {
errMessage = "";
} else {
errMessage = errMessage + "\n";
}
if ( errorOutput == null || errorOutput == "" ) {
alert( errMessage + errMsg );
} else {
NOF_setElementProperty( errorOutput, "innerHTML", (errMessage + errMsg).split("\n").join("<BR>") );
}
return false;
} else {
if ( errorOutput != null || errorOutput != "" ) {
NOF_setElementProperty( errorOutput, "innerHTML", "" );
}
}
return true;
}
function NOF_getElementId( element ) {
if ( element.id == undefined ) {
if ( element.length > 1 && element[ 0 ] != undefined ) {
return ( element[ 0 ].id != undefined ) ? element[ 0 ].id : "";
}
return "";
}
return element.id;
}
function NOF_getElementProperty( element, property ) {
if ( typeof element != "string" ) {
if ( element.property != undefined ) {
return eval("element." + property);
} else {
return "";
}
} else {
if ( document.getElementById ) {
if ( document.getElementById( element ) != null ) {
return eval( "document.getElementById('" + element + "')." + property );
}
} else {
if ( document.layers[ element ] != undefined ) {
}
}
}
return "";
}
function NOF_getElementLabelObj( element ) {
var labelArray = new Array();
if ( element != "" ) {
if ( document.getElementById ) {
if ( document.getElementById( element ) != null ) {
for ( var i = 0; i < document.getElementsByTagName( "label" ).length; i++ ) {
if ( document.getElementsByTagName( "label" )[ i ].htmlFor == document.getElementById( element ).id ) {
labelArray[ labelArray.length ] = document.getElementsByTagName( "label" )[ i ];
}
}
}
} else {
alert(element + " : " + document.layers[ element ]);
if ( document.layers[ element ] != undefined ) {
alert('NOF_getElementLabelObj_: ' + document.ids[element]);
}
}
}
return labelArray;
}
function NOF_setElementProperty( element, property, value ) {
if ( document.getElementById ) {
if ( document.getElementById( element ) != null ) {
eval( "document.getElementById('" + element + "')." + property + "= value;" );
}
} else {
if ( document.layers[ element ] != undefined ) {
if ( property == "innerHTML" ) {
with ( document.layers[ element ].document ) {
open();
write( "<font class='lbErr'>" + value + "</font>" );
close();
}
}
}
}
}

