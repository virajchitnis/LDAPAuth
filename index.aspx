<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="index.aspx.cs" Inherits="LDAPAuth.index" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>

    <link href='http://fonts.googleapis.com/css?family=Ubuntu:300' rel='stylesheet' type='text/css'>

    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap-theme.min.css">
    <link rel="stylesheet" href="http://cdnjs.cloudflare.com/ajax/libs/highlight.js/8.4/styles/default.min.css">

    <style>
        * {
            font-family: 'Ubuntu', 'HelveticaNeue-Thin', 'Helvetica Neue Thin', 'Helvetica Neue', Helvetica, Arial, 'Lucida Grande', sans-serif;
            line-height: 1.5;
        }

        body {
            max-width: 22cm;
            margin: 0 auto !important;
            float: none !important;
        }

        pre {
            background-color: #f0f0f0;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div id="divLogin" runat="server" style="position: fixed; top: 0; left: 0; width: 100%; height: 100%; z-index: 10; background-color: white;">
            <div class="page-header" style="max-width: 22cm; margin: 0 auto !important; float: none !important;">
                <h1>LDAPAuth.cs <small>by Viraj Chitnis</small></h1>
            </div>
            <div class="panel panel-default" style="position: fixed; top: 200px; left: calc(50% - 150px); width: 300px;">
                <div class="panel-body">
                    <div class="form-group">
                        <label for="txtUsername">TU Accessnet</label>
                        <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" placeholder="Enter TU Accessnet id"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label for="txtPassword">Password</label>
                        <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" placeholder="Enter password" TextMode="Password"></asp:TextBox>
                    </div>
                    <asp:Button ID="btnLogin" runat="server" Text="Login" CssClass="btn btn-primary" Style="float: right;" OnClick="btnLogin_Click" />
                    <asp:Label ID="lblError" runat="server" Text="" style="clear: both; width: 100%; text-align: center;"></asp:Label>
                </div>
            </div>
            <div style="width: 100%; text-align: center; position: fixed; bottom: 0; left: 0;">
                <h5><small>Copyright &copy; 2015 Viraj Chitnis. All Rights Reserved.</small></h5>
            </div>
        </div>

        <div id="divMain" class="container-fluid" runat="server">
            <div class="page-header">
                <a class="btn btn-success" href="https://raw.githubusercontent.com/virajchitnis/LDAPAuth/master/LDAPAuth.cs" role="button" style="float: right;" download><span class="glyphicon glyphicon-download" aria-hidden="true"></span>&nbsp;Download LDAPAuth.cs</a>
                <h1>LDAPAuth.cs <small>by Viraj Chitnis</small></h1>
            </div>

            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title">LDAP attributes associated with your account</h3>
                </div>
                <div class="panel-body">
                    <table class="table table-striped table-hover">
                        <thead>
                            <tr>
                                <th>Key</th>
                                <th>Values</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="rptAttributes" runat="server">
                                <ItemTemplate>
                                    <tr>
                                        <td><%# DataBinder.Eval((System.Collections.Generic.KeyValuePair<string, string>)Container.DataItem,"Key") %></td>
                                        <td><%# DataBinder.Eval((System.Collections.Generic.KeyValuePair<string, string>)Container.DataItem,"Value") %></td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title">Using LDAPAuth.cs in your project</h3>
                </div>
                <div class="panel-body">
                    <h3>Setup</h3>
                    <p>
                        1. Add this class to your project and change its 'namespace' to match your namespace (usually same as project name).
                        <br />
                        2. Right click on you project in the solution explorer and select 'Add Reference...'.
                        <br />
                        3. Use the search bar on the top right corner of the 'Reference Manager' window to search for 'directory'.
                        <br />
                        4. From the search results, checkmark 'System.DirectoryServices' and 'System.DirectoryServices.Protocols'.
                        <br />
                        5. Click 'Ok' at the bottom fo the window to finish.
                        <br />
                        6. Add 'using System.Collections.Generic;' to top of the C# code which you wish to use this class in.
                    </p>
                    <br />
                    <h3>Declaration</h3>
                    <pre><code>LDAPAuth auth = new LDAPAuth(username, password);</code></pre>
                    <br />
                    <h3>Methods</h3>
                    <p>
                        All methods take a reference to a string variable as a parameter. If there is an error during the LDAP connection,
                        the error message will be put into this variable. You may use this error message in your implementation of LDAPAuth.cs
                        as you see fit.
                    </p>
                    <br />
                    <h4>TryLogin(out string errMessage)*</h4>
                    <p>Simply login without any verification of attributes. If the entered tuaccessnet username and password is correct, this type of login will succeed.</p>
                    <pre><code id="tryLoginWithoutParaCode"></code></pre>
                    <br />
                    <h4 id="tryLoginWithParaHeader"></h4>
                    <p>
                        This method accepts a dictionary of fields and values that should be verified before successfule login.
                        If on the of provided fields does not exists, the login fails.
                        As long as at least one of the value provided for each field matches, the login is successful.
                    </p>
                    <pre><code id="tryLoginCode"></code></pre>
                    <br />
                    <h4>TryLoginAndGetAllAttributes(out string errMessage)</h4>
                    <p>
                        Simply login without any verification of attributes. If the entered tuaccessnet username and password
                        is correct, this type of login will succeed. This method also returns all the LDAP attributes of the user as a
                        dictionary that can be used in your code as you see fit.
                    </p>
                    <pre><code id="tryLoginAndGetAllAttributesCode"></code></pre>
                    <br />
                    <hr />
                    <h5><small>* Method returns 'success' for successful logins, and 'failure' for failed logins.</small></h5>
                </div>
            </div>

            <hr />
            <div style="width: 100%; text-align: center;">
                <h5><small>Copyright &copy; 2015 Viraj Chitnis. All Rights Reserved.</small></h5>
            </div>
        </div>
    </form>

    <script src="http://cdnjs.cloudflare.com/ajax/libs/highlight.js/8.4/highlight.min.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>
    <script>
        $(document).ready(function () {
            var tryLoginWithoutParaCode = "string errMessage = \"\"; // If there is an error, the error message will be put into this variable\nstring successOrNot = auth.TryLogin(out errMessage);";
            $("#tryLoginWithoutParaCode").text(tryLoginWithoutParaCode);

            var tryLoginWithParaHeader = "TryLogin(Dictionary<string, string[]> LDAPFieldsAndValuesToVerify, out string errMessage)*";
            $("#tryLoginWithParaHeader").text(tryLoginWithParaHeader);

            var tryLoginCode = "string errMessage = \"\"; // If there is an error, the error message will be put into this variable\n"
                + "Dictionary<string, string[]> fieldsToCheck = new Dictionary<string, string[]>(); // Declare dictionary"
                + "\nstring[] edupersonaffiliation = { \"student\", \"member\" }; // Array of values for field 'edupersonaffiliation'"
                + "\nfieldsToCheck.Add(\"edupersonaffiliation\", edupersonaffiliation); // Add field and value to dictionary"
                + "\nstring successOrNot = auth.TryLogin(fieldsToCheck, out errMessage); // Call TryLogin method with dictionary as parameter";
            $("#tryLoginCode").text(tryLoginCode);

            var tryLoginAndGetAllAttributesCode = "string errMessage = \"\"; // If there is an error, the error message will be put into this variable\n"
                + "Dictionary<string, string[]> LDAPAttributes = auth.TryLoginAndGetAllAttributes(out errMessage);";
            $("#tryLoginAndGetAllAttributesCode").text(tryLoginAndGetAllAttributesCode);

            $('pre code').each(function (i, block) {
                hljs.highlightBlock(block);
            });
        });
    </script>
</body>
</html>
