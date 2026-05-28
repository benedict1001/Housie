<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="hostloginform.aspx.cs" Inherits="WebApplication2.hostloginform" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Host Login | Housie</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    
    <style>
        /* 1. BACKGROUND SETUP */
        body {
            background-color: #f7f7f7;
            /* High-quality travel background */
            background-image: url('https://images.unsplash.com/photo-1499678329028-101435549a4e?q=80&w=1920&auto=format&fit=crop');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            background-attachment: fixed;
            height: 100vh;
            margin: 0;
        }

        /* 2. OVERLAY & CONTAINER */
        .airbnb-container {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            background-color: rgba(0, 0, 0, 0.4); /* Dark overlay */
            width: 100%;
        }

        /* Card Styling */
        .airbnb-card {
            width: 100%;
            max-width: 450px;
            border: none;
            border-radius: 12px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.2);
            background-color: rgba(255, 255, 255, 0.95); /* Slight transparency */
        }

        /* Input Styling */
        .form-control {
            border: 1px solid #b0b0b0;
            border-radius: 8px;
            height: 3.5rem;
            background-color: white;
        }

        .form-control:focus {
            border-color: #222222;
            box-shadow: 0 0 0 1px #222222;
        }

        /* NEW: Style for the validation message */
        .validation-msg {
            color: #FF385C;
            font-size: 0.8rem;
            font-weight: 600;
            display: block;
            margin-top: -12px;
            margin-bottom: 15px;
            margin-left: 5px;
        }

        /* Airbnb Brand Button */
        .btn-airbnb {
            background: linear-gradient(to right, #E61E4D 0%, #E31C5F 50%, #D70466 100%);
            color: white;
            font-weight: 600;
            border: none;
            border-radius: 8px;
            padding: 12px;
            width: 100%;
        }

        .btn-airbnb:hover {
            background: linear-gradient(to right, #D70466 0%, #E31C5F 50%, #E61E4D 100%);
            color: white;
        }

        .form-floating > label {
            color: #717171;
        }

        /* Error Label Styling */
        .error-label {
            color: #E61E4D;
            font-size: 0.85rem;
            font-weight: 600;
            display: block;
            margin-bottom: 15px;
            text-align: center;
        }

        /* Link Styling */
        .airbnb-link {
            color: #222;
            text-decoration: underline;
            font-weight: 600;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="airbnb-container">
            <div class="card airbnb-card">
                
                <div class="card-header text-center border-bottom-0 pt-4" style="background: transparent;">
                    <h4 class="fw-bold">Welcome back</h4>
                    <p class="text-muted small mb-0">Login to your host account</p>
                </div>

                <div class="card-body px-4 pb-4">
                    
                    <div class="form-floating mb-3">
                        <asp:TextBox ID="txtLoginEmail" runat="server" CssClass="form-control" TextMode="Email" placeholder="name@example.com"></asp:TextBox>
                        <label for="txtLoginEmail">Email</label>
                    </div>
                    <asp:RequiredFieldValidator ID="rfvLoginEmail" runat="server" ControlToValidate="txtLoginEmail" ErrorMessage="Email address is required." CssClass="validation-msg" Display="Dynamic"></asp:RequiredFieldValidator>

                    <div class="form-floating mb-3">
                        <asp:TextBox ID="txtLoginPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Password"></asp:TextBox>
                        <label for="txtLoginPassword">Password</label>
                    </div>
                    <asp:RequiredFieldValidator ID="rfvLoginPassword" runat="server" ControlToValidate="txtLoginPassword" ErrorMessage="Password is required." CssClass="validation-msg" Display="Dynamic"></asp:RequiredFieldValidator>

                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <div class="form-check">
                            <asp:CheckBox ID="chkRemember" runat="server" CssClass="form-check-input" />
                            <label class="form-check-label small" for="chkRemember">Remember me</label>
                        </div>
                        <a href="hostforgotpassword.aspx" class="small text-decoration-none text-muted">Forgot password?</a>
                    </div>

                    <asp:Label ID="lblError" runat="server" CssClass="error-label"></asp:Label>

                    <div class="d-grid gap-2">
                        <%-- The OnClick name must match your C# method exactly --%>
                        <asp:Button ID="btnLogin" runat="server" Text="Continue" CssClass="btn btn-airbnb btn-lg" OnClick="btnLogin_Click" />
                    </div>

                    <div class="text-center mt-4 border-top pt-3">
                        <span class="small text-muted">Don't have an account? </span>
                        <a href="hostregistrationform.aspx" class="airbnb-link small">Sign up</a>
                    </div>

                </div>
            </div>
        </div>
    </form>
</body>
</html>