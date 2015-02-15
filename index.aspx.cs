using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace LDAPAuth
{
    public partial class index : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            divMain.Visible = false;
            divLogin.Visible = true;
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            Dictionary<string, string[]> attributes = new Dictionary<string, string[]>();
            string[] testAttributeValues = { "student", "member" };
            attributes.Add("edupersonaffiliation", testAttributeValues);

            rptAttributes.DataSource = attributes;
            rptAttributes.DataBind();

            divLogin.Visible = false;
            divMain.Visible = true;
        }
    }
}