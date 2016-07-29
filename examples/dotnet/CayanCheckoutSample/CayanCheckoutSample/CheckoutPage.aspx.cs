using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CayanCheckoutSample.MWareCredit;

namespace CayanCheckoutSample
{
    public partial class Default : System.Web.UI.Page
    {

        private string Amount = "";

        protected void Page_Load(object sender, EventArgs e)
        {
            Amount = this.Request.QueryString["Amount"];
            this.ShoppingCartAmount.Text = "$" + Amount;
        }

        protected void SubmitButton_Click(object sender, EventArgs e)
        {

            var token = this.TokenHolder.Text;

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

                this.ResponseMessage.Text = response.ApprovalStatus;
                this.ReferenceNumber.Text = response.Token;

                this.TokenHolder.Text = string.Empty;
                this.ResultsPlaceHolder.Visible = true;
            }

        }
    }

}