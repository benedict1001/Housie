<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="adminlogin.aspx.cs" Inherits="WebApplication2.adminlogin" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Admin Login - Housie</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=Inter:wght@400;500;600&display=swap" rel="stylesheet"/>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet"/>

    <style>
        body {
            font-family: 'Inter', sans-serif;
            margin: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            background-color: #f6f6f6;
            background-image: 
                radial-gradient(at 0% 0%, rgba(185, 0, 56, 0.15) 0px, transparent 50%),
                radial-gradient(at 100% 0%, rgba(106, 70, 174, 0.15) 0px, transparent 50%),
                radial-gradient(at 50% 100%, rgba(255, 116, 131, 0.1) 0px, transparent 50%);
            background-attachment: fixed;
            color: #2d2f2f;
        }

        .login-container {
            background: linear-gradient(135deg, rgba(255, 255, 255, 0.9) 0%, rgba(240, 240, 240, 0.7) 100%);
            backdrop-filter: blur(25px);
            -webkit-backdrop-filter: blur(25px);
            border: 1px solid rgba(255, 255, 255, 0.8);
            border-radius: 24px;
            padding: 40px;
            width: 100%;
            max-width: 400px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.08), inset 2px 2px 10px rgba(255,255,255,0.5);
            text-align: center;
            margin: 20px;
        }

        .admin-icon {
            font-size: 48px;
            color: #b90038;
            margin-bottom: 20px;
        }

        .title {
            font-family: 'Plus Jakarta Sans', sans-serif;
            font-size: 28px;
            font-weight: 800;
            margin-bottom: 8px;
            color: #2d2f2f;
            letter-spacing: -0.02em;
        }

        .subtitle {
            font-size: 14px;
            color: #5a5c5c;
            margin-bottom: 30px;
        }

        .form-group {
            margin-bottom: 20px;
            text-align: left;
        }

        .form-control {
            width: 100%;
            padding: 14px 16px;
            border-radius: 12px;
            border: 1px solid #cbd5e1;
            background: rgba(255, 255, 255, 0.9);
            font-family: 'Inter', sans-serif;
            font-size: 15px;
            color: #334155;
            box-sizing: border-box;
            transition: all 0.2s;
        }

        .form-control:focus {
            outline: none;
            border-color: #b90038;
            box-shadow: 0 0 0 3px rgba(185, 0, 56, 0.15);
        }

        .btn-login {
            width: 100%;
            background: linear-gradient(135deg, #d90448 0%, #b90038 100%);
            color: white;
            border: none;
            padding: 14px;
            border-radius: 12px;
            font-family: 'Plus Jakarta Sans', sans-serif;
            font-weight: 700;
            font-size: 16px;
            cursor: pointer;
            transition: 0.2s;
            margin-top: 10px;
        }

        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(185, 0, 56, 0.3);
        }

        .error-msg {
            color: #b90038;
            font-size: 14px;
            font-weight: 600;
            margin-top: 15px;
            display: block;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="login-container">
            <i class="fas fa-user-shield admin-icon"></i>
            <div class="title">Admin Portal</div>
            <div class="subtitle">Secure access to Housie management</div>

            <div class="form-group">
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="Admin Email" TextMode="Email"></asp:TextBox>
            </div>

            <div class="form-group">
                <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" placeholder="Password" TextMode="Password"></asp:TextBox>
            </div>

            <asp:Button ID="btnLogin" runat="server" Text="Sign In" CssClass="btn-login" OnClick="btnLogin_Click" />

            <asp:Label ID="lblError" runat="server" CssClass="error-msg"></asp:Label>
        </div>
    </form>
</body>
</html>