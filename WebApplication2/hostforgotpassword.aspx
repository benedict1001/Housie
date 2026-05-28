<%@ Page Title="Reset Password" Language="C#" MasterPageFile="~/hostmasterpage.Master" AutoEventWireup="true" CodeBehind="hostforgotpassword.aspx.cs" Inherits="WebApplication2.hostforgotpassword" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .forgot-container {
            max-width: 450px;
            margin: 80px auto;
            padding: 30px;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0px 10px 25px rgba(0,0,0,0.1);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            text-align: center;
        }
        .forgot-container h2 { color: #333; margin-bottom: 20px; font-weight: 600; }
        .forgot-container p { color: #666; font-size: 14px; margin-bottom: 20px; }
        .form-group { text-align: left; margin-bottom: 15px; }
        .form-control {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 6px;
            box-sizing: border-box;
        }
        .btn-action {
            width: 100%;
            padding: 12px;
            border: none;
            border-radius: 6px;
            font-weight: bold;
            cursor: pointer;
            transition: 0.3s;
        }
        .btn-primary { background-color: #007bff; color: white; }
        .btn-success { background-color: #28a745; color: white; }
        .btn-warning { background-color: #ffc107; color: #333; }
        .btn-action:hover { opacity: 0.9; transform: translateY(-1px); }
        .msg-label { display: block; margin-bottom: 15px; font-size: 14px; font-weight: 500; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="forgot-container">
        <h2>Reset Password</h2>
        
        <asp:Label ID="lblMsg" runat="server" CssClass="msg-label" ForeColor="Red"></asp:Label>

        <asp:Panel ID="pnlEmail" runat="server">
            <p>Please enter your registered email address to receive a verification code.</p>
            <div class="form-group">
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="example@mail.com"></asp:TextBox>
            </div>
            <asp:Button ID="btnCheckEmail" runat="server" Text="Send OTP" OnClick="btnCheckEmail_Click" CssClass="btn-action btn-primary" />
        </asp:Panel>

        <asp:Panel ID="pnlOTP" runat="server" Visible="false">
            <p>We've sent a 6-digit code to your email. Enter it below to verify your identity.</p>
            <div class="form-group">
                <asp:TextBox ID="txtEnteredOTP" runat="server" CssClass="form-control" placeholder="000000" MaxLength="6" style="text-align:center; font-size: 20px; letter-spacing: 5px;"></asp:TextBox>
            </div>
            <asp:Button ID="btnVerify" runat="server" Text="Verify Identity" OnClick="btnVerify_Click" CssClass="btn-action btn-success" />
        </asp:Panel>

        <asp:Panel ID="pnlReset" runat="server" Visible="false">
            <p>Identity verified! Please choose a strong new password for your account.</p>
            <div class="form-group">
                <asp:TextBox ID="txtNewPass" runat="server" TextMode="Password" placeholder="New Password" CssClass="form-control"></asp:TextBox>
            </div>
            <div class="form-group">
                <asp:TextBox ID="txtConfirmPass" runat="server" TextMode="Password" placeholder="Confirm New Password" CssClass="form-control"></asp:TextBox>
            </div>
            <asp:Button ID="btnUpdate" runat="server" Text="Update Password" OnClick="btnUpdate_Click" CssClass="btn-action btn-warning" />
        </asp:Panel>

        <div style="margin-top: 20px;">
            <a href="hostloginform.aspx" style="text-decoration:none; color:#007bff; font-size: 13px;">← Back to Login</a>
        </div>
    </div>
</asp:Content>