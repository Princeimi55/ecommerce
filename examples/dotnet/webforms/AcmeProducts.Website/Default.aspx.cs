namespace AcmeProducts.Website
{

    using System;
    using System.Web.UI;
    using Merchantware;

    public partial class Default : Page
    {

        private string Amount = "1.65";

        protected void Page_Load(object sender, EventArgs e)
        {
            this.ShoppingCartAmount.Text = Amount;
        }

        protected void SubmitButton_Click(object sender, EventArgs e)
        {

            var token = this.TokenHolder.Text;

            using (var service = new CreditSoapClient())
            {
                var response = service.SaleVault(
                    merchantName: "TEST",
                    merchantSiteId: "XXXXXXXX",
                    merchantKey: "XXXXX-XXXXX-XXXXX-XXXXX-XXXXX",
                    invoiceNumber: "123",
                    amount: this.Amount,
                    vaultToken: token,
                    forceDuplicate: "true",
                    registerNumber: "123",
                    merchantTransactionId: "1234");

                if (response.ApprovalStatus.Equals("approved", StringComparison.OrdinalIgnoreCase))
                {
                    this.CheckoutPlaceHolder.Visible = false;
                }

                this.ResponseMessage.Text = response.ApprovalStatus;
                this.ReferenceNumber.Text = response.Token;

                this.TokenHolder.Text = string.Empty;
                this.ResultsPlaceHolder.Visible = true;
            }

        }

    }

}
