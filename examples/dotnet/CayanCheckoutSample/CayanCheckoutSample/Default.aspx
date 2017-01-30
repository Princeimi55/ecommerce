<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" MasterPageFile="Site.Master" ClientIDMode="Static" Inherits="CayanCheckoutSample.CartPage" %>

<asp:content ContentPlaceHolderID="ContentPlaceHolder1" runat="server" id="DefaultPage">

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Cayan ECommerce Shopping Cart</title>

    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css" rel="stylesheet">
    <link href="./content/cayan-style.css" rel="stylesheet">
        
    <script src="https://code.jquery.com/jquery-1.11.3.min.js" type="text/javascript"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js" type="text/javascript"></script>
</head>
<body>
    <div class="container">
        <div class="page-header">
            <h1>Cayan Checkout <small>Shopping Cart</small></h1>
        </div>
    </div>
    <div class="container margin-top-10 card-entry-form">
        <asp:PlaceHolder ID="ItemSelectPlaceHolder" runat="server">
            <div id="ItemSelectPanel" class="panel panel-default">
                <!-- Default panel contents -->
                <div class="panel-heading">Select Products</div>
                <div class="panel-body">
                    <div class="form-actions">
                        <button onclick="itemButtonPress(99.99, 'Watch')" type="submit" class="btn btn-default"><img src="Images/Watch-64x64.png" alt="Submit">$99.99</button>
                        <button onclick="itemButtonPress(89.99, 'Jacket')" type="submit" class="btn btn-default"><img src="Images/Jacket-64x64.png" alt="Submit">$89.99</button>
                        <button onclick="itemButtonPress(59.99, 'Hoodie')" type="submit" class="btn btn-default"><img src="Images/Hoodie-64x64.png" alt="Submit">$59.99</button>
                        <button onclick="itemButtonPress(39.99, 'Hat')" type="submit" class="btn btn-default"><img src="Images/Hat-64x64.png" alt="Submit">$39.99</button>
                        <br />
                        <br />
                        <button onclick="itemButtonPress(19.99, 'T-Shirt')" type="submit" class="btn btn-default"><img src="Images/T-Shirt-64x64.png" alt="Submit">$19.99</button>
                        <button onclick="itemButtonPress(49.99, 'Pants')" type="submit" class="btn btn-default"><img src="Images/Pants-64x64.png" alt="Submit">$49.99</button>
                        <button onclick="itemButtonPress(29.99, 'Shorts')" type="submit" class="btn btn-default"><img src="Images/Shorts-64x64.png" alt="Submit">$29.99</button>
                        <button onclick="itemButtonPress(29.99, 'Skirt')" type="submit" class="btn btn-default"><img src="Images/Skirt-64x64.png" alt="Submit">$29.99</button>
                    </div>
                </div>
            </div>
            <a></a>
        </asp:PlaceHolder>

        <asp:PlaceHolder ID="ShoppingCartContainer" runat="server">
            <div id="ShoppingCartPanel" class="panel panel-default">
            <div class="panel-heading">Shopping Cart</div>
            <div class="panel-body">
                <form id="CartForm" runat="server" class="form-horizontal">
                    <div class="form-group">
                        <label><strong>Shopping Cart Total:</strong> $</label>
                        <asp:Label ID="TestLabel" runat="server">0.00</asp:Label>
                        <input type="hidden" id="txtHidData" runat="server" />
                        <br />
                        <br />
                        <table id="ItemTable" class="table table-striped">
                            <tr>
                                <th>Quantity</th>
                                <th>Item</th>
                                <th>Price</th>
                            </tr>
                        </table>
                    </div>
                    <div class="form-actions">
                        <asp:Button ID="SubmitCartButton" Text="Move to Checkout" CssClass="btn btn-primary" OnClick="SubmitCartButton_Click" UseSubmitBehavior="false" runat="server" />
                        <button onclick="ClearCart()" type="submit" class="btn btn-primary">Clear Cart</button>
                    </div>
                </form>
            </div>
                </div>
        </asp:PlaceHolder>
    </div>
    <footer id="footer">
        <p>Icon images created by Popcic: https://www.iconfinder.com/popcic</p>
    </footer>
</body>


    <script>

        cartAmt = 0.00;

        function itemButtonPress(amt, item) {
            addToList(amt, item);
            addToTotal(amt);
        }

        function addToTotal(amt) {
            cartAmt += amt;
            cartDispAmt = cartAmt.toFixed(2);
            var str = "Shopping Cart Total: ";
            var boldStr = str.bold();
            document.getElementById("TestLabel").innerHTML = cartDispAmt;
            document.getElementById("txtHidData").value = cartDispAmt;
        }

        function addToList(amountATL, itemATL) {
            var table = document.getElementById("ItemTable");
            var row = table.insertRow(-1);
            var cell1 = row.insertCell(0);
            var cell2 = row.insertCell(1);
            var cell3 = row.insertCell(2);
            cell1.innerHTML = "1";
            cell2.innerHTML = itemATL;
            cell3.innerHTML = amountATL;
        }

        function ClearCart() {
            var table = document.getElementById("ItemTable");
            var length = table.getAttribute.length;

            for (i = 1; i < length; i++){
                table.deleteRow(i);
            }
            
            document.getElementById("txtHidData").value = '0.00';
            
        }
    </script>
</html>

</asp:content>
