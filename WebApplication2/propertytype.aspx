<%@ Page Title="Manage Property Types" Language="C#" MasterPageFile="~/adminmaster.Master" AutoEventWireup="true" CodeBehind="propertytype.aspx.cs" Inherits="WebApplication2.propertytype" %>

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
        .data-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 13px;
        }
        .data-table th, .data-table td {
            padding: 8px;
            text-align: left;
            border: 1px solid #ccc;
        }
        .data-table th {
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
                <td>Property Type</td>
                <td>
                    <asp:TextBox ID="TextBox1" runat="server" CssClass="form-control"></asp:TextBox>
                    <asp:HiddenField ID="hfTypeId" runat="server" />
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
                <table class="data-table" id="example">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Type</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
            </HeaderTemplate>
            <ItemTemplate>
                <tr>
                    <td><%# Eval("typeid") %></td>
                    <td><%# Eval("type") %></td>
                    <td><%# Eval("status") %></td>
                    <td>
                        <asp:LinkButton ID="lnkEdit" runat="server" CommandName="edit" CommandArgument='<%# Eval("typeid") %>' CssClass="btn-edit">Edit</asp:LinkButton>
                        |
                        <asp:LinkButton ID="lnkDelete" runat="server" CommandName="delete" CommandArgument='<%# Eval("typeid") %>' CssClass="btn-delete" OnClientClick="return confirm('Delete this property type?');">Delete</asp:LinkButton>
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