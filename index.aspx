<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="index.aspx.cs" Inherits="LDAPAuth.index" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>

    <link href='http://fonts.googleapis.com/css?family=Ubuntu:300' rel='stylesheet' type='text/css'>

    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap-theme.min.css">

    <style>
        * {
            font-family: 'Ubuntu', 'HelveticaNeue-Thin', 'Helvetica Neue Thin', 'Helvetica Neue', Helvetica, Arial, 'Lucida Grande', sans-serif;
            line-height: 1.5;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div id="login_div" runat="server" style="position: fixed; top: 0; left: 0; width: 100%; height: 100%;">
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
                    <asp:Button ID="btnLogin" runat="server" Text="Login" CssClass="btn btn-primary" Style="float: right;" />
                </div>
            </div>
        </div>
    </form>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>
</body>
</html>
