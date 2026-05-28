<%@ Page Title="Host Approval" Language="C#" MasterPageFile="~/adminmaster.Master" AutoEventWireup="true" CodeBehind="hostapprovel.aspx.cs" Inherits="WebApplication2.hostapprovel" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .approval-container { 
            width: 95%; 
            margin: 20px auto; 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
        }
        
        .approval-table { 
            width: 100%; 
            border-collapse: collapse; 
            background-color: #fff; 
            box-shadow: 0 2px 5px rgba(0,0,0,0.1); 
        }
        
        .approval-table th, .approval-table td { 
            padding: 12px; 
            border: 1px solid #eee; 
            text-align: left; 
            vertical-align: middle;
        }
        
        .approval-table th { 
            background-color: #343a40; 
            color: white; 
            text-transform: uppercase;
            font-size: 13px;
        }

        .host-img {
            width: 50px; 
            height: 50px; 
            border-radius: 50%; 
            object-fit: cover;
            border: 1px solid #ddd;
        }

        .btn { 
            padding: 8px 15px; 
            border-radius: 4px; 
            text-decoration: none; 
            font-weight: bold; 
            font-size: 12px; 
            display: inline-block; 
            transition: background 0.3s;
        }

        .btn-approve { 
            background-color: #2563eb; 
            color: white; 
        }

        .btn-approve:hover { 
            background-color: #1d4ed8; 
            color: white;
        }

        .no-data { 
            padding: 30px; 
            text-align: center; 
            color: #888; 
            font-style: italic; 
        }
        
        h2 {
            color: #333;
            margin-bottom: 20px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="approval-container">
        <h2>Pending Host Approvals</h2>
        
        <asp:Repeater ID="Repeater1" runat="server" OnItemDataBound="Repeater1_ItemDataBound">
            <HeaderTemplate>
                <table class="approval-table">
                    <thead>
                        <tr>
                            <th>Image</th>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Phone</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
            </HeaderTemplate>
            
            <ItemTemplate>
                <tr>
                    <td>
                        <img src='<%# Eval("himage") != DBNull.Value ? "data:image/jpg;base64," + Convert.ToBase64String((byte[])Eval("himage")) : "images/default-profile.png" %>' 
                             class="host-img" alt="Profile" />
                    </td>
                    <td style="font-weight: 600;">
                        <%# Eval("fname") %> <%# Eval("lname") %>
                    </td>
                    <td><%# Eval("email") %></td>
                    <td><%# Eval("phno") %></td>
                    <td>
                        <a href='hostdetailsview.aspx?hid=<%# Eval("hid") %>' class="btn btn-approve">View Profile</a>
                    </td>
                </tr>
            </ItemTemplate>
            
            <FooterTemplate>
                <asp:Label ID="lblNoData" runat="server" Visible="false">
                    <tr><td colspan="5" class="no-data">No pending requests found.</td></tr>
                </asp:Label>
                    </tbody>
                </table>
            </FooterTemplate>
        </asp:Repeater>
    </div>
</asp:Content>