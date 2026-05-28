<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="hostregistrationform.aspx.cs" Inherits="WebApplication2.hostregistrationform" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Host Registration - Airbnb Style</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    
    <style>
        body {
            background-color: #f7f7f7;
            background-image: linear-gradient(rgba(0,0,0,0.2), rgba(0,0,0,0.2)), url('https://images.unsplash.com/photo-1499678329028-101435549a4e?q=80&w=1920&auto=format&fit=crop');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            background-attachment: fixed;
            margin: 0; padding: 0; height: 100vh;
        }

        .airbnb-container {
            display: flex; justify-content: center; align-items: center;
            min-height: 100vh; background-color: rgba(34, 34, 34, 0.4);
            width: 100%; padding: 40px 0;
        }

        .airbnb-card {
            width: 100%; max-width: 500px; border: none; border-radius: 16px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.3); background-color: #ffffff;
            overflow: hidden;
        }

        .card-header-colored {
            background: linear-gradient(45deg, #FF385C, #E61E4D);
            color: white; padding: 25px; border-bottom: none;
        }

        .form-control {
            border: 1px solid #dddddd; border-radius: 8px; height: 3.5rem;
            background-color: #fcfcfc; transition: all 0.2s ease-in-out;
        }

        .form-control:focus {
            border-color: #FF385C; box-shadow: 0 0 0 2px rgba(255, 56, 92, 0.2);
            background-color: #ffffff;
        }

        .validation-msg {
            color: #FF385C;
            font-size: 0.8rem;
            font-weight: 600;
            display: block;
            margin-top: -12px;
            margin-bottom: 15px;
            margin-left: 5px;
        }

        .file-upload-label {
            display: block; font-size: 0.85rem; font-weight: 700; color: #FF385C;
            margin-bottom: 5px; margin-top: 15px; text-transform: uppercase; letter-spacing: 0.5px;
        }

        .custom-file-input {
            border: 1px solid #eeeeee; border-radius: 8px; padding: 10px;
            width: 100%; background: #f8f9fa; font-size: 0.9rem;
        }

        .btn-airbnb {
            background: linear-gradient(to right, #E61E4D 0%, #E31C5F 50%, #D70466 100%);
            color: white; font-weight: 600; border: none; border-radius: 8px;
            padding: 14px; width: 100%; transition: all 0.3s ease;
            margin-top: 15px; box-shadow: 0 4px 15px rgba(215, 4, 102, 0.3);
        }

        .btn-airbnb:hover {
            background: linear-gradient(to right, #D70466 0%, #E31C5F 50%, #E61E4D 100%);
            color: white; transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(215, 4, 102, 0.4);
        }

        .form-floating > label { color: #717171; }
        .login-link { color: #FF385C !important; text-decoration: none; font-weight: 700; }
        .login-link:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <form id="form1" runat="server" enctype="multipart/form-data">
        <div class="airbnb-container">
            <div class="card airbnb-card">
                <div class="card-header card-header-colored text-center">
                    <h3 class="fw-bold m-0">Finish signing up</h3>
                    <p class="small m-0 opacity-75">Join our community of hosts today</p>
                </div>

                <div class="card-body px-4 py-4">
                    <div class="row g-2">
                        <div class="col-md-6">
                            <div class="form-floating mb-3">
                                <asp:TextBox ID="txtFirstName" runat="server" CssClass="form-control" placeholder="First name"></asp:TextBox>
                                <label for="txtFirstName">First Name</label>
                            </div>
                            <asp:RequiredFieldValidator ID="rfvFirstName" runat="server" ControlToValidate="txtFirstName" ErrorMessage="First name is required." CssClass="validation-msg" Display="Dynamic"></asp:RequiredFieldValidator>
                        </div>
                        <div class="col-md-6">
                            <div class="form-floating mb-3">
                                <asp:TextBox ID="txtLastName" runat="server" CssClass="form-control" placeholder="Last name"></asp:TextBox>
                                <label for="txtLastName">Last Name</label>
                            </div>
                            <asp:RequiredFieldValidator ID="rfvLastName" runat="server" ControlToValidate="txtLastName" ErrorMessage="Last name is required." CssClass="validation-msg" Display="Dynamic"></asp:RequiredFieldValidator>
                        </div>
                    </div>

                    <div class="form-floating mb-3">
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email" placeholder="name@example.com"></asp:TextBox>
                        <label for="txtEmail">Email Address</label>
                    </div>
                    <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail" ErrorMessage="Email address is required." CssClass="validation-msg" Display="Dynamic"></asp:RequiredFieldValidator>

                    <div class="form-floating mb-3">
                        <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" TextMode="Phone" placeholder="Phone Number"></asp:TextBox>
                        <label for="txtPhone">Phone Number</label>
                    </div>
                    <asp:RequiredFieldValidator ID="rfvPhone" runat="server" ControlToValidate="txtPhone" ErrorMessage="Phone number is required." CssClass="validation-msg" Display="Dynamic"></asp:RequiredFieldValidator>

                    <div class="row mb-3">
                        <div class="col-12">
                            <label class="file-upload-label">Your Profile Photo</label>
                            <asp:FileUpload ID="fuHostPhoto" runat="server" CssClass="custom-file-input" />
                            <asp:RequiredFieldValidator ID="rfvHostPhoto" runat="server" ControlToValidate="fuHostPhoto" ErrorMessage="Profile photo is required." CssClass="validation-msg" Display="Dynamic" style="margin-top: 5px;"></asp:RequiredFieldValidator>
                        </div>
                    </div>

                    <div class="row mb-3">
                        <div class="col-12">
                            <label class="file-upload-label">Government ID Proof</label>
                            <asp:FileUpload ID="fuIdProof" runat="server" CssClass="custom-file-input" />
                            <asp:RequiredFieldValidator ID="rfvIdProof" runat="server" ControlToValidate="fuIdProof" ErrorMessage="ID proof is required." CssClass="validation-msg" Display="Dynamic" style="margin-top: 5px;"></asp:RequiredFieldValidator>
                        </div>
                    </div>

                    <div class="form-floating mb-3">
                        <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Password"></asp:TextBox>
                        <label for="txtPassword">Create Password</label>
                    </div>
                    <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtPassword" ErrorMessage="Password is required." CssClass="validation-msg" Display="Dynamic"></asp:RequiredFieldValidator>

                    <div class="form-floating mb-3">
                        <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Confirm Password"></asp:TextBox>
                        <label for="txtConfirmPassword">Confirm Password</label>
                    </div>
                    <asp:RequiredFieldValidator ID="rfvConfirmPassword" runat="server" ControlToValidate="txtConfirmPassword" ErrorMessage="Please confirm your password." CssClass="validation-msg" Display="Dynamic"></asp:RequiredFieldValidator>

                    <asp:CompareValidator 
                        ID="cvPasswordMatch" 
                        runat="server" 
                        ControlToValidate="txtConfirmPassword" 
                        ControlToCompare="txtPassword" 
                        Operator="Equal" 
                        Type="String"
                        ErrorMessage="Passwords do not match!" 
                        CssClass="validation-msg" 
                        Display="Dynamic">
                    </asp:CompareValidator>

                    <div class="d-grid">
                        <asp:Button ID="btnRegister" runat="server" Text="Agree and Continue" CssClass="btn btn-airbnb btn-lg" OnClick="btnRegister_Click" />
                    </div>

                    <div class="text-center mt-4 small text-muted">
                        Already have an account? <a href="hostloginform.aspx" class="login-link">Log in</a>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>