<%@ Page Language="C#" AutoEventWireup="true" %>
<%@ Import Namespace="Sitecore" %>
<%@ Import Namespace="Sitecore.Data" %>
<%@ Import Namespace="Sitecore.Data.Items" %>
<%@ Import namespace="System.Threading.Tasks" %>

    <script runat="server">

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void ExecQuery(object sender, EventArgs e)
        {
            Task t = Task.Run(() =>
            {
                try
                {
                    var database = Sitecore.Configuration.Factory.GetDatabase(databaseName.SelectedItem.Text);
                    var items = database.SelectItems(query.Text);
                    StringBuilder sb = new StringBuilder();

                    sb.AppendLine("Count: " + items.Count());
                    foreach (var item in items)
                    {
                        sb.AppendLine(item.Name);
                    }

                    result.Text = sb.ToString();
                }
                catch (Exception exp)
                {
                    result.Text = exp.ToString();
                }
            });

            TimeSpan ts = TimeSpan.FromMilliseconds(30000);
            if (!t.Wait(ts))
                result.Text = "The timeout interval elapsed.";
        }
    </script>

<!DOCTYPE html>

<html>

<head runat="server">
    <title>Test sitecore query</title>
</head>
<body>
<form runat="server" id="form">
    <b>Database:</b>
    <p>
        <asp:DropDownList ID="databaseName" runat="server">
            <asp:ListItem>master</asp:ListItem>
            <asp:ListItem>web</asp:ListItem>
        </asp:DropDownList>
    </p>
    <b>Query Text:</b>
    <p>
    <asp:TextBox ID="query" runat="server" Height="243px" TextMode="MultiLine" Width="100%"></asp:TextBox>
    </p>
    <b>Result:</b>
    <p>
        <asp:TextBox ID="result" runat="server" Height="243px" TextMode="MultiLine" Width="100%"></asp:TextBox>
    </p>
    <p>
    <asp:Button
    runat="server"
    ID="exec"
    Text="Execute query"
    OnClick="ExecQuery"/>
    </p>
</form>
</body>
</html>