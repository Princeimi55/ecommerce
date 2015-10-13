#Introduction

The Merchantware Ecommerce library is designed as a method for easily processing credit cards from your website and remaining in PCI compliance while retaining your site's own custom look and feel.  The process is simple and requires a minimal amount of integration on your part.

1. Include the Merchantware Ecommerce library on your web page to collect payment information.
2. Convert the payment information into a single-use token.
3. Use the token in place of the payment information to perform a transaction on Cayan's Merchantware Gateway.

```
+--------------------------------+  +--------------------------------+
| Client / Web:                  |  | Remote Server:                 |
|                                |  |                                |
| User fills in card Information |--| Ecommerce library sends        |
|                                |  | cardholder data to Cayan which |
|                                |  | returns a one-time token.      |
+--------------------------------+  +--------------------------------+
                                                    |
               +------------------------------------+
               |
+--------------------------------+  +--------------------------------+
| *INFO*                         |  | Client / Server:               |
|                                |  |                                |
| Token is submitted to the      |--| Merchant processes the         
| Merchant's Servers.            |  | transaction using the token    |
|                                |  | against the Merchant Gateway   |
+--------------------------------+  +--------------------------------+
                                                    |
               +------------------------------------+
               |
+--------------------------------+
| Client / Web:                  |
|                                |
| Results are displayed to the   |
| user.                          |
|                                |
+--------------------------------+
```

#Requirements

The Merchantware Ecommerce library is designed to work on a large number of devices and browsers.  At this time, we require that users have Internet Explorer 8+, Chrome, Firefox, or Safari.

> At this time, we have not tested against mobile browsers which may be officially supported in the future.

#Getting Started Tutorial

To begin using the Merchantware Ecommerce library, create a checkout page that has a form which includes space for a credit card number, a CVV code, an expiration date month, and an expiration date year.  You can use any HTML name or ID attributes you want for these fields.

##Setting up the Payment Form

On each of the relevant form elements, add a special `data-cayan` attribute that is used to identify the purpose of the element to the library.  You can see a full list of the attributes supported in the reference section of this document.

```html
<form method="post" id="paymentForm">
    <div>
        <span id="error_message"></span>
    </div>
    <div>
        <label for="formcardnumber">Card Number</label>
        <input type="text" size="20" name="formcardnumber" data-cayan="cardnumber">
    </div>
    <div>
        <label for="formcvv">CVV</label>
        <input type="text" size="4" name="formcvv" data-cayan="cvv">
    </div>
    <div>
        <label for="formexpiremonth">Expiration Month</label>
        <input type="text" size="2" name="formexpiremonth" data-cayan="expirationmonth" title="MM">
    </div>
    <div>
        <label for="form-expireyear">Expiration Year</label>
        <input type="text" size="2" name="formexpireyear" data-cayan="expirationyear" title="YY">
    </div>
    <div>
        <input type="hidden" name="paymentToken" value="">
        <button type="button" id="submitPayment">Submit Payment</button>
    </div>
</form>
```

As you can see on this form, we have four required elements.  The card number, the CVV code, and the expiration date broken up by month and year.  This form is meant to serve as a simple reference, and you may choose to configure it to use a dropdown instead of text boxes for the expiration month and year.

Next, you will need to include a reference to the JavaScript library.

```html
<script type="text/javascript" src="https://ps1.merchantware.net/ecommerce/scripts/cayan-0.1.0.js"></script>
```
> Currently, the script is available underneath the `ps1.merchantware.net` domain, but the final version may be found at a different URL.

Finally, you need to set the Web API key for the merchant account you wish to use for processing.  This is done by calling the `Cayan.setWebApiKey()` JavaScript method. Each merchant account will have a unique key which serves as a very limited set of credentials.  The key can only be used to turn payment information into a single-use token, and can never be used for any other purpose.  You can obtain a Web API key by contacting our technical support staff.  This should be placed within a separate script block.

```
<script type="text/javascript">
   Cayan.setWebApiKey("PSTest;22222222;22222-22222-22222-22222-22222");
</script>
```

> For the moment, we are still in the process of building the authentication process.  For the interim time, please use the Merchantware credentials supplied to you in the form of `<NAME>;<SITE_ID>;<MERCHANT_KEY>`.  **DO NOT** use this with live credentials at any time as it may expose you to risk.

##Creating a Single-Use Token

You are now completely ready to begin the process of turning the payment data into a single-use token.  The token expires two minutes after its creation.  To do this, you will need to intercept the click event of a button, or the submit action of a form.  For this example, we are going to use the latest version of jQuery but you can use any framework you wish.  

```javascript
$(document).ready(function () {
    $('#submitPayment').click(function () {

        // Prevent the user from double-clicking
        $(this).prop('disabled', true);

        // Create the payment token
        Cayan.createPaymentToken({
            success: successCallback,
            error: failureCallback
        })

    });
});
```

When `submitButton` is clicked by the user, the button is first disabled to prevent them from submitting multiple times.  Then the `Cayan.createPaymentToken()` function is called.

The function takes an object with two fields, `success` and `error`, which are callbacks that handle the responses from the JavaScript library. 

The success callback receives an object containing information about the token that looks something like this:

```
{
   token: "ECTDLT1KSFBNOZB381037S",
   created: " 2015-09-02T00:08:38.8686925Z",
   expires: " 2015-09-02T00:10:38.8686925Z"
}
```

The error callback receives an array of error objects, which represent one or more errors.

```
[{ error_code: "VALIDATION", reason": "cardnumber" }]
```

In this example, the error code describes the type of error, while the reason represents the reason the error was triggered.  For validation or required field errors, the callback function should alert the user as to the fields which have problems.

Once the token information is returned, you can proceed to submit the form to your server.  Any sensitive cardholder information such as the PAN and CVV values are removed automatically by the library for security reasons so they are never submitted to the server.  Here is an example of a very simple success callback function in JavaScript:

```javascript
function successCallback(tokenResponse) {
    // Populate a hidden field with the single-use token
    $("input[name='paymentToken'").val(tokenResponse.token);

    // Submit the form
    $('#paymentForm').submit();
}
```

##Performing a Sale with the Single-Use Token

Now that the server has submitted the form, you can retrieve the single-use token from the form data and process the transaction.  The token is stored in the Merchantware Vault allowing you to use the token with the standard Vault-based Preauthorization, Sale, or Level 2 Sale transactions.

```C#
// Retrieve the payment token from the form
var singleUseToken = Request.Form["paymentToken"];
            
// Create a new SOAP client used to call Merchantware
var client = new CreditSoapClient();
            
// Perform a sale using the single-use token stored in the Vault
var result = client.SaleVault(
    merchantName: "pstest",
    merchantSiteId: "22222222",
    merchantKey: "22222-22222-22222-22222-22222",
    invoiceNumber: "",
    amount: "1.35",
    vaultToken: singleUseToken,
    forceDuplicate: "true",
    registerNumber: "",
    merchantTransactionId: ""
);
            
// ... Handle the result

```

For more information about the transactions using the Vault can be found at:  

https://ps1.merchantware.net/merchantware/documentation40/standard/credit_SaleVault.aspx
https://ps1.merchantware.net/merchantware/documentation40/standard/credit_Level2SaleVault.aspx
https://ps1.merchantware.net/merchantware/documentation40/standard/credit_PreAuthorizationVault.aspx

#JavaScript API Reference

##Functions

###Cayan.setWebApiKey(apiKey)
This function is used to set the merchant account used to tokenize the payment information.

Parameter | Type | Description
--------- | ---- | -----------
apiKey | String | A string containing the Web API key used to identify the merchant account.

Example:

```javascript
Cayan.setWebApiKey("PSTest;22222222;22222-22222-22222-22222-22222");
```

###Cayan.createPaymentToken(handlers)
This function is used to create a single-use token from the payment information on the current HTML page.

Parameter | Type | Description
--------- | ---- | -----------
handlers | Object (handers) | A set of key/value pairs used to configure the behavior of the method creating the single-use tokens.

Example:

```javascript
Cayan.createPaymentToken({
   success: successCallback,
   error: failureCallback
});
```

##Objects

###Handlers

A set of key/value pairs used to configure the behavior for the `Cayan.createPaymentToken()` function.  Both the `success` and the `error` functions are required.

Field | Type | Description
----- | ---- | -----------
success | Function | Function (TokenResponse data)<br><br>A function that is called when the payment information was successfully converted into a single-use token.  The data contains basic information about the token including when it was created, and when it expires.<br><br>This is a required field.
error | Function | Function (ErrorResponse[] error)<br><br>A function that is called when there was an error creating the single-use token from the payment data.  The error response contains a list of error codes and responses related to that error code.<br><br>This is a required field.

###TokenResponse
The token response object is returned by the `success` callback of the `Cayan.createPaymentToken()` method.

Field | Type | Description
----- | ---- | -----------
token | String | A single-use token that can be used to perform a transaction using the Merchantware gateway.
created | Date (UTC) | A value that represents the date the token was created by the server.
expires | Date (UTC) | A value that represents the date the token will expire on the server and no longer be available to process a transaction.  A single-use token will expire two minutes from the creation time.

Example:

```
{
   token: "ECTDLT1KSFBNOZB381037S",
   created: " 2015-09-02T00:08:38.8686925Z",
   expires: " 2015-09-02T00:10:38.8686925Z"
}
```

###ErrorResponse

The error response object is returned by the `error` callback of the `Cayan.createPaymentToken()` method.

Field | Type | Description
----- | ---- | -----------
error_code | String | A value that contains a unique error code representing the type of error that occurred when processing the payment information.
reason | String | A scenario-specific reason for the failure represented by the `error_code` value.

Example:

```
[
    {
        error_code: "VALIDATION",
        reason: "cardnumber"
    },
    {
        error_code: "REQUIRED",
        reason: "cvv"
    }
]
```

#Error Code Reference 


Error_Code | Reason | Description
---------- | ------ | -----------
NOT_FOUND | {data-cayan-element} | A required form field is missing from the page and/or could not be found.
REQUIRED | {data-cayan-element} | A required field contains an empty value.
VALIDATION | {data-cayan-element} | A field contains data that is invalid
SERVER | UNEXPECTED | An unexpected error occurred on the server and the request was not processed.
SERVER | UNAVAILABLE | The server is currently unavailable for tokenizing payment information.
SERVER | UNAUTHORIZED | The server rejected the Web API key supplied.
SERVER | PAYMENT_NOT_SUPPORTED | The payment method is not supported by the merchant.
SERVER_REQUIRED | <data-cyan> | The server did not receive a field which is required to create a single-use token.<br><br>This should not occur under normal circumstances, as all required fields are validated in the JavaScript library.
SERVER_VALIDATION | {data-cayan-element} | The server received a field which failed validation.<br><br>This should not occur under normal circumstances, as all required fields are validated in the JavaScript library.

#Supported Data-Cayan Form Elements

Value | Required | Description
----- | -------- | -----------
cardholder | No | The name of the cardholder as it appears on the front of the card.
cardnumber | Yes | The credit card number
expirationmonth | Yes | The two-digit expiration month.
expirationyear | Yes | The two-digit expiration year.
cvv | Yes | The three or four digit CVV/CVC code on the card.
streetaddress | No | The street address for the card used for AVS checks.
zipcode | No | The zip code associated with the card used for AVS checks.


