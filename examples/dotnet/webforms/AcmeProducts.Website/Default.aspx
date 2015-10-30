<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="AcmeProducts.Website.Default" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <title>Acme Products</title>
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css" rel="stylesheet">
    <link href="./content/acme-style.css" rel="stylesheet">
        
    <script src="http://code.jquery.com/jquery-1.11.3.min.js" type="text/javascript"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js" type="text/javascript"></script>
    <script src="https://ps1.merchantware.net/ecommerce/scripts/cayan-0.1.0.js" type="text/javascript"></script>
</head>
<body>
	<div class="container">
		<div class="page-header">
			<h1>Acme Products <small>Checkout</small></h1>    
		</div>       
    </div>
    <div class="container margin-top-10 card-entry-form">
		<div class="panel panel-default">
			<!-- Default panel contents -->
			<div class="panel-heading">Order Details</div>
			<div class="panel-body">
				<asp:Label ID="ShoppingCartAmount" runat="server" />
			</div>
		</div>
        <asp:PlaceHolder ID="ResultsPlaceHolder" Visible="false" runat="server">
        <div id="ResponseMessageContainer" class="panel panel-success panel-success">
            <div class="panel-heading">Order Results</div>
                <div class="panel-body">
                <p><strong>Status: </strong><asp:Label ID="ResponseMessage" runat="server" /></p>
                <p><strong>Reference #: </strong><asp:Label ID="ReferenceNumber" runat="server" /></p>
            </div>
        </div>
        </asp:PlaceHolder>
        <asp:PlaceHolder ID="CheckoutPlaceHolder" runat="server">
		<div id="CheckoutPanel" class="panel panel-default">
			<!-- Default panel contents -->
			<div class="panel-heading">Card Information</div>
			<div class="panel-body">
				<div id="LoadingImage" class="form-loading" style="display:none;">
					<img src="content/wait24.gif" />
				</div>
                <form id="PaymentForm" runat="server" class="form-horizontal">
					<div class="form-group">
						<label for="CardHolder" id="CardholderLabel" class="control-label col-sm-3">Card Holder Name</label>
						<div class="col-sm-9">
							<input name="CardHolder" type="text" id="CardHolder" class="form-control" placeholder="Enter card holder name" data-cayan="cardholder" />
						</div>
					</div>
					<div class="form-group">
						<label for="CardNumber" id="CardLabel" class="control-label col-sm-3">Card Number</label>
						<div class="col-sm-9">
							<input name="CardNumber" type="text" id="CardNumber" class="form-control" placeholder="Enter card number" data-cayan="cardnumber" />
						</div>
					</div>
					<div class="form-group">
						<label for="ExpirationMonth" id="ExpirationDateLabel" class="control-label col-sm-3">Expiration Date</label>
						<div class="col-sm-4">
							<select name="ExpirationMonth" id="ExpirationMonth" data-cayan="expirationmonth" class="form-control">
								<option value="01">01 January</option>
								<option value="02">02 February</option>
								<option value="03">03 March</option>
								<option value="04">04 April</option>
								<option value="05">05 May</option>
								<option value="06">06 June</option>
								<option value="07">07 July</option>
								<option value="08">08 August</option>
								<option value="09">09 September</option>
								<option value="10">10 October</option>
								<option value="11">11 November</option>
								<option selected="selected" value="12">12 December</option>
							</select>
						</div>
						<div class="col-sm-5">
							<select name="ExpirationYear" id="ExpirationYear" data-cayan="expirationyear" class="form-control">
								<option value="15">2015</option>
								<option selected="selected" value="16">2016</option>
								<option value="17">2017</option>
								<option value="18">2018</option>
								<option value="19">2019</option>
								<option value="20">2020</option>
							</select>
						</div>
					</div>
					<div class="form-group">
						<label for="CVV" id="CVVLabel" class="control-label col-sm-3">CVV/CVS</label>
						<div class="col-sm-9">
							<input name="CVV" type="text" id="CVV" class="form-control" placeholder="Enter the 3 or 4 digit CVV/CVS code" data-cayan="cvv" />
						</div>
					</div>
					<div class="form-group">
						<label for="StreetAddress" id="StreetAddressLabel" class="control-label col-sm-3">Street Address</label>
						<div class="col-sm-9">
							<input name="StreetAddress" type="text" id="StreetAddress" class="form-control" placeholder="Enter street address" data-cayan="streetaddress" />
						</div>
					</div>
					<div class="form-group">
						<label for="ZipCode" id="ZipLabel" class="control-label col-sm-3">Zip code</label>
						<div class="col-sm-9">
							<input name="ZipCode" type="text" id="ZipCode" class="form-control" placeholder="Enter 5-digit zip-code" data-cayan="zipcode" />
						</div>    
					</div>
					<div class="form-actions">
                        <asp:Button ID="SubmitButton" Text="Complete Checkout" CssClass="btn btn-primary" OnClientClick="return false;" OnClick="SubmitButton_Click" UseSubmitBehavior="false" runat="server" />
					</div>

                    <!-- Hidden Element -->
                    <asp:TextBox runat="server" ID="TokenHolder" ClientIDMode="static" style="display:none;"/>
                </form>
            </div>
            </div>
        <a></a>
        </asp:PlaceHolder>
    </div>

</body>
<script>
    Cayan.setWebApiKey("pstest;22222222;22222-22222-22222-22222-22222");

    function clearTokenMessageContainer(tokenMessageContainer) {
        tokenMessageContainer.removeClass('alert-danger');
        tokenMessageContainer.removeClass('alert-success');
        tokenMessageContainer.removeClass('alert-info');
    }

    function toggleForm() {
        $("#PaymentForm").toggle();
        $("#LoadingImage").toggle();
    }

    // client defined callback to handle the successful token response
    function HandleTokenResponse(tokenResponse) {
        //toggleForm();
        var tokenHolder = $("#TokenHolder");
        if (tokenResponse.token !== "") {
            tokenHolder.val(tokenResponse.token);
        }

        __doPostBack("SubmitButton", "");
    }

    // client-defined callback to handle error responses
    function HandleErrorResponse(errorResponses) {
        toggleForm();
        var errorText = "";
        for (var key in errorResponses) {
            errorText += " error_code: " + errorResponses[key].error_code + " reason: " + errorResponses[key].reason + "\n";
        }
        alert(errorText);
    }

    $("#SubmitButton").click(function (ev) {
        toggleForm();
        Cayan.createPaymentToken({
            success: HandleTokenResponse,
            error: HandleErrorResponse
        });
        ev.preventDefault();
    });

</script>
</html>
