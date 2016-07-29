using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CayanCheckoutSample
{
    public partial class CartPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            this.TestLabel.Visible = true;
        }

        protected void SubmitCartButton_Click(object sender, EventArgs e)
        {
            string amt = this.txtHidData.Value;
            Response.Redirect("CheckoutPage.aspx?Amount=" + amt,true);
        }
    }
}