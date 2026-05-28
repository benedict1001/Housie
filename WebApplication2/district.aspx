<%@ Page Title="Manage Districts" Language="C#" MasterPageFile="~/adminmaster.Master" AutoEventWireup="true" CodeBehind="district.aspx.cs" Inherits="WebApplication2.district" %>

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
        .district-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 13px;
        }
        .district-table th, .district-table td {
            padding: 8px;
            text-align: left;
            border: 1px solid #ccc;
        }
        .district-table th {
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
                <td>District Name</td>
                <td>
                    <asp:TextBox ID="TextBox1" runat="server" CssClass="form-control"></asp:TextBox>
                    <asp:HiddenField ID="hfDistrictId" runat="server" />
                </td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td>
                    <asp:Button ID="Button1" runat="server" OnClick="Button1_Click" Text="Insert" CssClass="btn-primary" />
                </td>
            </tr>
        </table>

        <asp:Repeater ID="Repeater1" runat="server" OnItemCommand="Repeater1_ItemCommand">
            <HeaderTemplate>
                <table class="district-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
            </HeaderTemplate>
            <ItemTemplate>
                <tr>
                    <td><%# Eval("did") %></td>
                    <td><%# Eval("dname") %></td>
                    <td><%# Eval("status") %></td>
                    <td>
                        <asp:LinkButton ID="lnkEdit" runat="server" CommandName="edit" CommandArgument='<%# Eval("did") %>' CssClass="btn-edit">Edit</asp:LinkButton>
                        |
                        <asp:LinkButton ID="lnkDelete" runat="server" CommandName="delete" CommandArgument='<%# Eval("did") %>' CssClass="btn-delete" OnClientClick="return confirm('Delete this district?');">Delete</asp:LinkButton>
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