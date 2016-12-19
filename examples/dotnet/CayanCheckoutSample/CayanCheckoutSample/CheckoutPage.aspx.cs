using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CayanCheckoutSample.MWareCredit;

namespace CayanCheckoutSample
{
    using System.Text.RegularExpressions;

    public partial class Default : System.Web.UI.Page
    {

        private string Amount = "";

        protected void Page_Load(object sender, EventArgs e)
        {
            Amount = this.Request.QueryString["Amount"] ?? String.Empty;

            decimal dec;

            if (Decimal.TryParse(Amount, out dec))
            {
                string encodeAmount = HttpUtility.HtmlEncode(Amount);
                this.ShoppingCartAmount.Text = "$" + encodeAmount;
            }
            else
            {
                Response.Redirect("Error.aspx", true);
            }
        }

        protected void SubmitButton_Click(object sender, EventArgs e)
        {

            var token = this.TokenHolder.Text;

            var tokenRegex = new Regex(@"^[a-zA-Z0-9_]{1,40}$");

            if (tokenRegex.IsMatch(token))
            {
                using (var service = new CreditSoapClient())
                {

                    var response = service.SaleVault(
                        //Replace "YOUR MERCHANTNAME HERE" with provided merchantName
                        merchantName: "YOUR MERCHANTNAME HERE",
                        //Replace "YOUR SITEID HERE" with provided siteID
                        merchantSiteId: "YOUR SITEID HERE",
                        //Replace "YOUR KEY HERE" with provided key
                        merchantKey: "YOUR KEY HERE",
                        invoiceNumber: "123",
                        amount: this.Amount,
                        vaultToken: token,
                        forceDuplicate: "false",
                        registerNumber: "123",
                        merchantTransactionId: "1234");

                    if (response.ApprovalStatus.Equals("approved", StringComparison.OrdinalIgnoreCase))
                    {
                        this.CheckoutPlaceHolder.Visible = false;
                    }

                    var error = response.ErrorMessage;

                    string encodeApprovalStatus = HttpUtility.HtmlEncode(response.ApprovalStatus);
                    string encodeToken = HttpUtility.HtmlEncode(response.Token);

                    this.ResponseMessage.Text = encodeApprovalStatus;
                    this.ReferenceNumber.Text = encodeToken;

                    this.TokenHolder.Text = string.Empty;
                    this.ResultsPlaceHolder.Visible = true;
                }
            }
            else
            {
                Response.Redirect("Error.aspx", true);
            }

        }
    }

}