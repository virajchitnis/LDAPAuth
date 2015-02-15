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
            if (String.IsNullOrEmpty(txtUsername.Text))
            {
                lblError.Text = "Error: username cannot be blank";
                return;
            }

            if (String.IsNullOrEmpty(txtPassword.Text))
            {
                lblError.Text = "Error: password cannot be blank";
                return;
            }

            //LDAPAuth auth = new LDAPAuth(txtUsername.Text, txtPassword.Text);
            //Dictionary<string, string[]> attributes = auth.TryLoginAndGetAllAttributes();

            Dictionary<string, string[]> attributes = new Dictionary<string, string[]>();
            string[] testAttributeValues = { "student", "member" };
            attributes.Add("edupersonaffiliation", testAttributeValues);

            if (attributes.Count > 0)
            {
                Dictionary<string, string> repeaterData = new Dictionary<string, string>();
                foreach (KeyValuePair<string, string[]> attribute in attributes)
                {
                    string elements = arrayToString(attribute.Value);
                    repeaterData.Add(attribute.Key, elements);
                }

                rptAttributes.DataSource = repeaterData;
                rptAttributes.DataBind();

                divLogin.Visible = false;
                divMain.Visible = true;
            }
            else
            {
                lblError.Text = "Invalid username or password";
            }
        }

        private String arrayToString(string[] arr)
        {
            string ret = string.Join(", ", arr);
            return ret;
        }
    }
}