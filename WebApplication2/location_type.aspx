<%@ Page Title="Manage Location Types" Language="C#" MasterPageFile="~/adminmaster.Master" AutoEventWireup="true" CodeBehind="location_type.aspx.cs" Inherits="WebApplication2.location_type" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .management-container {
            width: 450px; 
            margin: 20px 0;
            font-family: Arial, sans-serif;
        }
        .form-table {
            width: 100%;
            margin-bottom: 20px;
        }
        .form-control {
            width: 200px;
            padding: 4px;
            border: 1px solid #ccc;
        }
        .location-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 13px;
        }
        .location-table th, .location-table td {
            padding: 8px;
            text-align: left;
            border: 1px solid #ccc;
        }
        .location-table th {
            background-color: #eee;
        }
        .btn-edit { color: #0000ff; text-decoration: none; font-weight: bold; margin-right: 5px; }
        .btn-delete { color: #ff0000; text-decoration: none; font-weight: bold; }
        .btn-primary { padding: 4px 12px; cursor: pointer; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="management-container">
        
        <table class="form-table">
            <tr>
                <td>Location Type</td>
                <td>
                    <asp:TextBox ID="txtLocationType" runat="server" CssClass="form-control" placeholder="e.g., Beachfront"></asp:TextBox>
                    <asp:HiddenField ID="hfLocationId" runat="server" />
                </td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td>
                    <asp:Button ID="btnSave" runat="server" OnClick="btnSave_Click" Text="Insert" CssClass="btn-primary" />
                </td>
            </tr>
        </table>

        <asp:Repeater ID="Repeater1" runat="server" OnItemCommand="Repeater1_ItemCommand">
            <HeaderTemplate>
                <table class="location-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Location Name</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
            </HeaderTemplate>
            <ItemTemplate>
                <tr>
                    <td><%# Eval("loc_id") %></td>
                    <td><%# Eval("loc_name") %></td>
                    <td><%# Eval("status") %></td>
                    <td>
                        <asp:LinkButton ID="lnkEdit" runat="server" CommandName="edit" CommandArgument='<%# Eval("loc_id") %>' CssClass="btn-edit">Edit</asp:LinkButton>
                        |
                        <asp:LinkButton ID="lnkDelete" runat="server" CommandName="delete" CommandArgument='<%# Eval("loc_id") %>' CssClass="btn-delete" OnClientClick="return confirm('Are you sure you want to delete this location type?');">Delete</asp:LinkButton>
                    </td>
                </tr>
            </ItemTemplate>
            <FooterTemplate>
                    </tbody>
                </table>
            </FooterTemplate>
        </asp:Repeater>
        
    </div>
</asp:Content>